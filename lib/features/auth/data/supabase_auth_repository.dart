/// Supabase-backed [AuthRepository].
///
/// Performs native Google and Apple sign-in then exchanges the
/// resulting ID token with Supabase via `signInWithIdToken`. This
/// avoids the OAuth web detour and gives us a real native experience.
library;

import 'dart:io' show Platform;

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
    // TODO(setup): provide the Google OAuth client IDs in
    // ios/Runner/Info.plist (REVERSED_CLIENT_ID) and android/app/google-services.json.
    final google = GoogleSignIn(
      scopes: const ['email', 'profile', 'openid'],
      // serverClientId is the Web OAuth client id from Google Cloud,
      // required to obtain an idToken on Android.
      // serverClientId: 'YOUR-WEB-CLIENT-ID.apps.googleusercontent.com',
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
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw const AuthException('Apple Sign-In is only available on iOS.');
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
