/// Abstract auth contract for Palast.
///
/// Lets the rest of the app stay agnostic of Supabase / Google / Apple
/// specifics — useful for tests and for swapping the backend.
library;

import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
  Future<void> signOut();
  User? getCurrentUser();
  Stream<AuthState> onAuthStateChange();
}
