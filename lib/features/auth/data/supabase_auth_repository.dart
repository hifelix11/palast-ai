/// Supabase-backed [AuthRepository].
///
/// Performs native Google and Apple sign-in then exchanges the
/// resulting ID token with Supabase via `signInWithIdToken`. This
/// avoids the OAuth web detour and gives us a real native experience.
library;

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/features/auth/data/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  User? getCurrentUser() => _client.auth.currentUser;

  @override
  Stream<AuthState> onAuthStateChange() => _client.auth.onAuthStateChange;

  @override
  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: Uri.base.origin,
      );
      return _client.auth.currentUser;
    }
    // The iOS client ID is read from Info.plist (REVERSED_CLIENT_ID).
    // serverClientId must be the **Web** OAuth client ID — Supabase
    // verifies tokens against this audience on both iOS and Android.
    final google = GoogleSignIn(
      scopes: const ['email', 'profile', 'openid'],
      serverClientId:
          const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID').isEmpty
              ? null
              : const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
    );
    final account = await google.signIn();
    if (account == null) return null;
    final auth = await account.authentication;
    final idToken = auth.idToken;
    final accessToken = auth.accessToken;
    if (idToken == null) {
      throw const AuthException('Google did not return an ID token.');
    }
    final response = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    return response.user;
  }

  @override
  Future<User?> signInWithApple() async {
    if (kIsWeb) {
      await _client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: Uri.base.origin,
      );
      return _client.auth.currentUser;
    }
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('Apple did not return an ID token.');
    }
    final response = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
    );
    return response.user;
  }

  @override
  Future<void> signOut() => _client.auth.signOut();
}
