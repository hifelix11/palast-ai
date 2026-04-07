/// Riverpod surface for Settings.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:palast/core/network/supabase_client_provider.dart';
import 'package:palast/features/settings/data/settings_repository.dart';
import 'package:palast/features/settings/data/supabase_settings_repository.dart';
import 'package:palast/shared/models/user_profile.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SupabaseSettingsRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Future<UserProfile?> currentProfile(CurrentProfileRef ref) {
  return ref.watch(settingsRepositoryProvider).fetchProfile();
}
