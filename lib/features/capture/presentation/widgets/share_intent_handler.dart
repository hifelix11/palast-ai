/// Listens to the OS share sheet via `receive_sharing_intent` and turns
/// each incoming payload into a [CaptureInput] handed to the
/// [CaptureController]. Mount once near the root of the widget tree.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:palast/features/capture/domain/models/capture_input.dart';
import 'package:palast/features/capture/presentation/providers/capture_provider.dart';
import 'package:palast/shared/models/item.dart';

class ShareIntentHandler extends ConsumerStatefulWidget {
  const ShareIntentHandler({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ShareIntentHandler> createState() => _ShareIntentHandlerState();
}

class _ShareIntentHandlerState extends ConsumerState<ShareIntentHandler> {
  StreamSubscription<List<SharedMediaFile>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = ReceiveSharingIntent.instance.getMediaStream().listen(_onMedia);
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) _onMedia(files);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _onMedia(List<SharedMediaFile> files) async {
    final controller = ref.read(captureControllerProvider.notifier);
    for (final file in files) {
      final input = _toInput(file);
      if (input != null) {
        await controller.capture(input, method: 'share_sheet');
      }
    }
    await ReceiveSharingIntent.instance.reset();
  }

  CaptureInput? _toInput(SharedMediaFile file) {
    switch (file.type) {
      case SharedMediaType.text:
      case SharedMediaType.url:
        final url = file.path;
        return CaptureInput.url(
          url: url,
          sourceType: detectSourceType(url),
        );
      case SharedMediaType.image:
        return CaptureInput.file(
          localPath: file.path,
          filename: file.path.split('/').last,
          sourceType: ItemSourceType.image,
          mimeType: file.mimeType,
        );
      case SharedMediaType.video:
      case SharedMediaType.file:
        final lower = file.path.toLowerCase();
        final type =
            lower.endsWith('.pdf') ? ItemSourceType.pdf : ItemSourceType.image;
        return CaptureInput.file(
          localPath: file.path,
          filename: file.path.split('/').last,
          sourceType: type,
          mimeType: file.mimeType,
        );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Detects the [ItemSourceType] of a freshly shared URL by looking at
/// the host. Defaults to [ItemSourceType.url].
ItemSourceType detectSourceType(String url) {
  final lower = url.toLowerCase();
  if (lower.contains('youtube.com') || lower.contains('youtu.be')) {
    return ItemSourceType.youtube;
  }
  if (lower.contains('instagram.com')) return ItemSourceType.instagram;
  if (lower.contains('tiktok.com')) return ItemSourceType.tiktok;
  if (lower.contains('twitter.com') || lower.contains('x.com')) {
    return ItemSourceType.tweet;
  }
  return ItemSourceType.url;
}

