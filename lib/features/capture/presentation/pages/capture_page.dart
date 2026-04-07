/// The Capture page: write a thought, paste a URL, or hit the mic.
library;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:palast/core/theme/design_tokens.dart';
import 'package:palast/features/capture/domain/models/capture_input.dart';
import 'package:palast/features/capture/presentation/providers/capture_provider.dart';
import 'package:palast/features/capture/presentation/providers/voice_memo_provider.dart';
import 'package:palast/features/capture/presentation/widgets/share_intent_handler.dart';
import 'package:palast/shared/models/item.dart';
import 'package:palast/shared/widgets/app_button.dart';
import 'package:palast/shared/widgets/app_text_field.dart';

class CapturePage extends ConsumerStatefulWidget {
  const CapturePage({super.key});

  @override
  ConsumerState<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends ConsumerState<CapturePage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) return;
    await ref.read(captureControllerProvider.notifier).capture(
          CaptureInput.bytes(
            bytes: bytes,
            filename: file.name,
            sourceType: ItemSourceType.pdf,
            mimeType: 'application/pdf',
          ),
          method: 'file_picker',
        );
    if (mounted) context.pop();
  }

  Future<void> _save() async {
    final raw = _controller.text.trim();
    if (raw.isEmpty) return;
    final isUrl = raw.startsWith('http://') || raw.startsWith('https://');
    final input = isUrl
        ? CaptureInput.url(url: raw, sourceType: detectSourceType(raw))
        : CaptureInput.thought(text: raw);
    await ref
        .read(captureControllerProvider.notifier)
        .capture(input, method: isUrl ? 'paste' : 'thought');
    if (mounted) {
      _controller.clear();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(captureControllerProvider);
    final voice = ref.watch(voiceMemoControllerProvider);
    final voiceCtl = ref.read(voiceMemoControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Capture')),
      body: Padding(
        padding: const EdgeInsets.all(PalastSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _controller,
              hint: 'Write a thought, or paste a link...',
              minLines: 4,
              maxLines: 10,
              autofocus: true,
            ),
            const SizedBox(height: PalastSpacing.md),
            AppButton(
              label: 'Save',
              loading: state.isLoading,
              onPressed: _save,
            ),
            const SizedBox(height: PalastSpacing.md),
            AppButton(
              label: 'Upload a PDF',
              icon: Icons.picture_as_pdf_outlined,
              variant: AppButtonVariant.outlined,
              onPressed: _pickPdf,
            ),
            const SizedBox(height: PalastSpacing.xl),
            const Divider(),
            const SizedBox(height: PalastSpacing.md),
            AppButton(
              label: voice.isRecording
                  ? 'Stop and save voice memo'
                  : 'Record a voice memo',
              icon: voice.isRecording ? Icons.stop : Icons.mic,
              variant: AppButtonVariant.outlined,
              onPressed: () async {
                if (voice.isRecording) {
                  await voiceCtl.stopAndSave();
                  if (mounted) context.pop();
                } else {
                  await voiceCtl.start();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
