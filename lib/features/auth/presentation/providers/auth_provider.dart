/// Auth state and actions for Palast.
///
/// Exposes an [AsyncNotifier] over the current Supabase [User] and a
/// few imperative methods for sign-in / sign-out.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/core/analytics/analytics_provider.dart';
import 'package:palast/core/network/supabase_client_provider.dart';
import 'package:palast/features/auth/data/auth_repository.dart';
import 'package:palast/features/auth/data/supabase_auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return SupabaseAuthRepository(ref.watch(supabaseClientProvider));
}

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    // Reflect auth state changes from Supabase.
    final sub = repo.onAuthStateChange().listen((event) {
      state = AsyncData(event.session?.user);
    });
    ref.onDispose(sub.cancel);
    return repo.getCurrentUser();
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      if (user != null) {
        await ref.read(analyticsProvider).signedIn(provider: 'google');
      }
      return user;
    });
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).signInWithApple();
      if (user != null) {
        await ref.read(analyticsProvider).signedIn(provider: 'apple');
      }
      return user;
    });
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(analyticsProvider).signedOut();
    state = const AsyncData(null);
  }
}
