/// Riverpod surface for capturing items into Palast.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:palast/core/analytics/analytics_provider.dart';
import 'package:palast/core/network/supabase_client_provider.dart';
import 'package:palast/features/capture/data/capture_repository.dart';
import 'package:palast/features/capture/data/supabase_capture_repository.dart';
import 'package:palast/features/capture/domain/models/capture_input.dart';
import 'package:palast/shared/models/item.dart';

part 'capture_provider.g.dart';

@Riverpod(keepAlive: true)
CaptureRepository captureRepository(CaptureRepositoryRef ref) {
  return SupabaseCaptureRepository(ref.watch(supabaseClientProvider));
}

@riverpod
class CaptureController extends _$CaptureController {
  @override
  AsyncValue<Item?> build() => const AsyncData(null);

  Future<Item?> capture(CaptureInput input, {required String method}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final item =
          await ref.read(captureRepositoryProvider).capture(input);
      await ref.read(analyticsProvider).itemCaptured(
            sourceType: item.sourceType.name,
            captureMethod: method,
          );
      if (input is CaptureInputThought) {
        await ref
            .read(analyticsProvider)
            .thoughtAdded(isVoiceMemo: false);
      } else if (input is CaptureInputVoiceMemo) {
        await ref
            .read(analyticsProvider)
            .thoughtAdded(isVoiceMemo: true);
        await ref.read(analyticsProvider).voiceMemoRecorded(
              durationSeconds: input.durationSeconds,
            );
      }
      return item;
    });
    state = result;
    return result.value;
  }
}
