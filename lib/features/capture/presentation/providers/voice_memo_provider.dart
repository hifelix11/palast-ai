/// Voice memo recorder, backed by the `record` package.
///
/// Holds the recorder instance for the lifetime of the provider so the
/// user can start and stop without losing state.
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:palast/features/capture/domain/models/capture_input.dart';
import 'package:palast/features/capture/presentation/providers/capture_provider.dart';

part 'voice_memo_provider.g.dart';

class VoiceMemoState {
  const VoiceMemoState({
    this.isRecording = false,
    this.startedAt,
    this.lastPath,
  });

  final bool isRecording;
  final DateTime? startedAt;
  final String? lastPath;

  VoiceMemoState copyWith({
    bool? isRecording,
    DateTime? startedAt,
    String? lastPath,
  }) =>
      VoiceMemoState(
        isRecording: isRecording ?? this.isRecording,
        startedAt: startedAt ?? this.startedAt,
        lastPath: lastPath ?? this.lastPath,
      );
}

@riverpod
class VoiceMemoController extends _$VoiceMemoController {
  final AudioRecorder _recorder = AudioRecorder();
  static const _uuid = Uuid();

  @override
  VoiceMemoState build() {
    ref.onDispose(_recorder.dispose);
    return const VoiceMemoState();
  }

  Future<void> start() async {
    if (!await _recorder.hasPermission()) {
      throw StateError('Microphone permission denied.');
    }
    final dir = await getTemporaryDirectory();
    final path = p.join(dir.path, 'voice-${_uuid.v4()}.m4a');
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );
    state = state.copyWith(
      isRecording: true,
      startedAt: DateTime.now(),
      lastPath: path,
    );
  }

  Future<void> stopAndSave() async {
    final path = await _recorder.stop();
    final started = state.startedAt;
    state = state.copyWith(isRecording: false);
    if (path == null || started == null) return;
    final duration = DateTime.now().difference(started).inSeconds;
    if (!File(path).existsSync()) return;
    await ref.read(captureControllerProvider.notifier).capture(
          CaptureInput.voiceMemo(
            localPath: path,
            durationSeconds: duration,
          ),
          method: 'voice',
        );
  }

  Future<void> cancel() async {
    await _recorder.stop();
    state = const VoiceMemoState();
  }
}
