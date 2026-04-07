/// Supabase-backed [SettingsRepository].
library;

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/features/settings/data/settings_repository.dart';
import 'package:palast/shared/models/user_profile.dart';

class SupabaseSettingsRepository implements SettingsRepository {
  SupabaseSettingsRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<UserProfile?> fetchProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    if (row == null) return null;
    return UserProfile.fromJson(row);
  }
}
