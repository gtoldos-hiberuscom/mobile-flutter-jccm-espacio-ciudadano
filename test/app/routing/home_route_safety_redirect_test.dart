import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';

/// Sprint 9 / STORY-22 carry-over safety net.
///
/// The real `LoggedHomePage` is not implemented on this integration line
/// (see `documentation/qa/STORY-22-home-route-investigation.md`). Until it
/// lands, `Routes.home` must transparently redirect to `Routes.sitemap` so
/// that existing call-sites (bottom-nav, sitemap, consent, profile drawer)
/// do NOT fall through to `NotFoundScreen`.
///
/// This test mirrors the production `app_router.dart` wiring at the level
/// that matters for the safety contract:
///
/// * `Routes.home`     → `redirect:` to `Routes.sitemap`
/// * `Routes.sitemap`  → real page (here, a marker widget)
/// * `errorBuilder`    → a marker widget for `NotFoundScreen` so we can
///   assert it is NOT the one rendered.
void main() {
  testWidgets(
    'Routes.home redirects to Routes.sitemap and never hits NotFoundScreen',
    (final tester) async {
      final router = GoRouter(
        initialLocation: '/seed',
        errorBuilder: (final c, final s) => const Scaffold(body: Text('NOT_FOUND_MARKER')),
        routes: [
          GoRoute(
            path: '/seed',
            builder: (final c, final s) => const Scaffold(body: Text('SEED_MARKER')),
          ),
          GoRoute(
            path: Routes.home,
            redirect: (final c, final s) => Routes.sitemap,
          ),
          GoRoute(
            path: Routes.sitemap,
            builder: (final c, final s) => const Scaffold(body: Text('SITEMAP_MARKER')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      // Sanity: we start on the seed route, not on the redirect path.
      expect(find.text('SEED_MARKER'), findsOneWidget);

      // Navigate to /home — the safety net must transparently land us on /sitemap.
      router.go(Routes.home);
      await tester.pumpAndSettle();

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        Routes.sitemap,
        reason: 'Routes.home must redirect to Routes.sitemap until LoggedHomePage lands.',
      );
      expect(find.text('SITEMAP_MARKER'), findsOneWidget);
      expect(
        find.text('NOT_FOUND_MARKER'),
        findsNothing,
        reason: '/home must NOT fall through to NotFoundScreen.',
      );
    },
  );
}
