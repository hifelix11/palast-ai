/// The Palast [GoRouter] instance, exposed via Riverpod.
///
/// Redirects unauthenticated users to /sign-in and signed-in users away
/// from /sign-in. Listens to Supabase auth state via
/// [authStateChangesProvider] so navigation reacts to sign-in/out events.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:palast/core/network/supabase_client_provider.dart';
import 'package:palast/features/auth/presentation/pages/sign_in_page.dart';
import 'package:palast/features/capture/presentation/pages/capture_page.dart';
import 'package:palast/features/inbox/presentation/pages/inbox_page.dart';
import 'package:palast/features/item_detail/presentation/pages/item_detail_page.dart';
import 'package:palast/features/library/presentation/pages/library_page.dart';
import 'package:palast/features/search/presentation/pages/search_page.dart';
import 'package:palast/features/settings/presentation/pages/settings_page.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final user = ref.read(currentUserProvider);
      final isSignIn = state.matchedLocation == '/sign-in';
      if (user == null && !isSignIn) return '/sign-in';
      if (user != null && isSignIn) return '/';
      return null;
    },
    refreshListenable: _AuthRefresh(ref),
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (_, __) => const SignInPage(),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const InboxPage(),
        routes: [
          GoRoute(
            path: 'capture',
            builder: (_, __) => const CapturePage(),
          ),
          GoRoute(
            path: 'library',
            builder: (_, __) => const LibraryPage(),
          ),
          GoRoute(
            path: 'search',
            builder: (_, __) => const SearchPage(),
          ),
          GoRoute(
            path: 'settings',
            builder: (_, __) => const SettingsPage(),
          ),
          GoRoute(
            path: 'item/:itemId',
            builder: (context, state) => ItemDetailPage(
              itemId: state.pathParameters['itemId']!,
            ),
          ),
        ],
      ),
    ],
  );
}

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(this._ref) {
    _ref.listen(authStateChangesProvider, (_, __) => notifyListeners());
  }
  // ignore: unused_field
  final Ref _ref;
}
