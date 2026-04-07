/// Typed routes for Palast, used by `go_router_builder`.
///
/// Run `make gen` after editing this file to regenerate the
/// `routes.g.dart` companion.
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:palast/features/auth/presentation/pages/sign_in_page.dart';
import 'package:palast/features/capture/presentation/pages/capture_page.dart';
import 'package:palast/features/inbox/presentation/pages/inbox_page.dart';
import 'package:palast/features/item_detail/presentation/pages/item_detail_page.dart';
import 'package:palast/features/library/presentation/pages/library_page.dart';
import 'package:palast/features/search/presentation/pages/search_page.dart';
import 'package:palast/features/settings/presentation/pages/settings_page.dart';

part 'routes.g.dart';

@TypedGoRoute<SignInRoute>(path: '/sign-in')
class SignInRoute extends GoRouteData {
  const SignInRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignInPage();
}

@TypedGoRoute<InboxRoute>(path: '/')
class InboxRoute extends GoRouteData {
  const InboxRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const InboxPage();
}

@TypedGoRoute<CaptureRoute>(path: '/capture')
class CaptureRoute extends GoRouteData {
  const CaptureRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CapturePage();
}

@TypedGoRoute<LibraryRoute>(path: '/library')
class LibraryRoute extends GoRouteData {
  const LibraryRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LibraryPage();
}

@TypedGoRoute<SearchRoute>(path: '/search')
class SearchRoute extends GoRouteData {
  const SearchRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SearchPage();
}

@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData {
  const SettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

@TypedGoRoute<ItemDetailRoute>(path: '/item/:itemId')
class ItemDetailRoute extends GoRouteData {
  const ItemDetailRoute({required this.itemId});
  final String itemId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ItemDetailPage(itemId: itemId);
}
