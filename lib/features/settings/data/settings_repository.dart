/// Abstract settings contract.
library;

import 'package:palast/shared/models/user_profile.dart';

abstract interface class SettingsRepository {
  Future<UserProfile?> fetchProfile();
}
