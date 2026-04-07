/// Supabase-backed [CaptureRepository].
///
/// 1. Inserts an `items` row in `pending` state.
/// 2. Uploads any binary payload to the `items` storage bucket at
///    `items/{user_id}/{item_id}/{filename}`.
/// 3. For thoughts and voice memos, also inserts a `thoughts` row.
/// 4. Invokes the `process-item` edge function (fire and forget).
library;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:palast/core/ai/ai_constants.dart';
import 'package:palast/core/constants/app_constants.dart';
import 'package:palast/features/capture/data/capture_repository.dart';
import 'package:palast/features/capture/domain/models/capture_input.dart';
import 'package:palast/shared/models/item.dart';

class SupabaseCaptureRepository implements CaptureRepository {
  SupabaseCaptureRepository(this._client);

  final SupabaseClient _client;
  static const _uuid = Uuid();

  @override
  Future<Item> capture(CaptureInput input) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('You are signed out.');
    }
    final itemId = _uuid.v4();
    final now = DateTime.now().toUtc();

    final (sourceType, title, originalUrl, rawInput) = _baseFields(input);

    String? storagePath;
    if (input is CaptureInputFile) {
      storagePath = await _uploadFile(
        userId: user.id,
        itemId: itemId,
        file: File(input.localPath),
        filename: input.filename,
      );
    } else if (input is CaptureInputVoiceMemo) {
      storagePath = await _uploadFile(
        userId: user.id,
        itemId: itemId,
        file: File(input.localPath),
        filename: 'voice-memo.m4a',
      );
    } else if (input is CaptureInputBytes) {
      storagePath = await _uploadBytes(
        userId: user.id,
        itemId: itemId,
        bytes: input.bytes,
        filename: input.filename,
        mimeType: input.mimeType,
      );
    }

    await _client.from('items').insert({
      'id': itemId,
      'user_id': user.id,
      'source_type': sourceType.toJsonValue(),
      'status': 'pending',
      'title': title,
      'original_url': originalUrl,
      'storage_path': storagePath,
      'raw_input': rawInput,
      'created_at': now.toIso8601String(),
    });

    if (input is CaptureInputThought) {
      await _client.from('thoughts').insert({
        'item_id': itemId,
        'user_id': user.id,
        'raw_text': input.text,
        'is_voice_memo': false,
      });
    } else if (input is CaptureInputVoiceMemo) {
      await _client.from('thoughts').insert({
        'item_id': itemId,
        'user_id': user.id,
        'raw_text': null,
        'is_voice_memo': true,
        'audio_storage_path': storagePath,
        'duration_seconds': input.durationSeconds,
      });
    }

    // Fire and forget — the inbox subscribes to status updates.
    unawaited(
      _client.functions.invoke(
        AiConstants.processItemFunction,
        body: {'item_id': itemId},
      ),
    );

    return Item(
      id: itemId,
      userId: user.id,
      sourceType: sourceType,
      status: ItemStatus.pending,
      title: title,
      originalUrl: originalUrl,
      storagePath: storagePath,
      rawInput: rawInput,
      createdAt: now,
    );
  }

  Future<String> _uploadBytes({
    required String userId,
    required String itemId,
    required Uint8List bytes,
    required String filename,
    String? mimeType,
  }) async {
    final path = p.posix.join('items', userId, itemId, filename);
    await _client.storage.from(AppConstants.itemsBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: mimeType,
          ),
        );
    return path;
  }

  Future<String> _uploadFile({
    required String userId,
    required String itemId,
    required File file,
    required String filename,
  }) async {
    final path = p.posix.join('items', userId, itemId, filename);
    await _client.storage.from(AppConstants.itemsBucket).upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    return path;
  }

  (ItemSourceType, String?, String?, Map<String, dynamic>?) _baseFields(
    CaptureInput input,
  ) {
    return switch (input) {
      CaptureInputUrl(:final url, :final sourceType, :final title) => (
          sourceType,
          title,
          url,
          {'url': url},
        ),
      CaptureInputThought(:final text) => (
          ItemSourceType.text,
          _firstLine(text),
          null,
          {'text': text},
        ),
      CaptureInputFile(:final filename, :final sourceType, :final mimeType) =>
        (
          sourceType,
          filename,
          null,
          {'filename': filename, 'mime_type': mimeType},
        ),
      CaptureInputVoiceMemo(:final durationSeconds) => (
          ItemSourceType.voiceMemo,
          'Voice memo',
          null,
          {'duration_seconds': durationSeconds},
        ),
      CaptureInputBytes(:final filename, :final sourceType, :final mimeType) =>
        (
          sourceType,
          filename,
          null,
          {'filename': filename, 'mime_type': mimeType},
        ),
      _ => throw ArgumentError.value(input, 'input', 'Unknown CaptureInput'),
    };
  }

  String _firstLine(String text) {
    final line = text.trim().split('\n').first;
    return line.length > 80 ? '${line.substring(0, 80)}...' : line;
  }
}

extension on ItemSourceType {
  String toJsonValue() => switch (this) {
        ItemSourceType.url => 'url',
        ItemSourceType.article => 'article',
        ItemSourceType.youtube => 'youtube',
        ItemSourceType.tiktok => 'tiktok',
        ItemSourceType.instagram => 'instagram',
        ItemSourceType.tweet => 'tweet',
        ItemSourceType.image => 'image',
        ItemSourceType.pdf => 'pdf',
        ItemSourceType.text => 'text',
        ItemSourceType.voiceMemo => 'voice_memo',
      };
}