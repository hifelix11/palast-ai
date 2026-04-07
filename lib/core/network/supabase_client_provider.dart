/// Riverpod providers exposing the [SupabaseClient] and the current
/// authenticated [User], if any.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_client_provider.g.dart';

@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@Riverpod(keepAlive: true)
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
}

@riverpod
User? currentUser(CurrentUserRef ref) {
  final auth = ref.watch(authStateChangesProvider);
  return auth.maybeWhen(
    data: (state) => state.session?.user,
    orElse: () => ref.read(supabaseClientProvider).auth.currentUser,
  );
}
