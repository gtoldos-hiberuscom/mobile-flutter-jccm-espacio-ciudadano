import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/observers/analytics_observer.dart';
import 'package:jccm_espacio_ciudadano/core/observers/app_lifecycle_observer.dart';
import 'package:jccm_espacio_ciudadano/core/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/shell/app_scaffold.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';
import 'package:jccm_espacio_ciudadano/core/logging/logger_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/consent_page.dart';
import 'package:jccm_espacio_ciudadano/features/education/2_presentation/education_landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/legal_document_page.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/2_presentation/sitemap_page.dart';

/// Riverpod provider that owns the application [GoRouter].
///
/// Kept alive for the entire app lifetime so the router is never recreated
/// on widget-tree rebuilds. The [SessionGuard] captures `ref` from this
/// factory, keeping all navigation decisions free of [BuildContext].
final goRouterProvider = Provider<GoRouter>(
  (final ref) {
    final lifecycleObserver = AppLifecycleObserver();
    final analyticsObserver = AnalyticsObserver(
      analyticsService: ref.read(analyticsServiceProvider),
      logger: ref.read(appLoggerProvider),
    );

    final router = GoRouter(
      initialLocation: Routes.landing,
      observers: [lifecycleObserver, analyticsObserver],
      // ── Global redirect ──────────────────────────────────────────────────
      //redirect: (final BuildContext context, final GoRouterState state) => guard.redirect(state),

      // ── 404 fallback ──────────────────────────────────────────────────────
      errorBuilder: (final BuildContext context, final GoRouterState state) => const NotFoundScreen(),

      routes: [
        // ── Landing ─────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.landing,
          builder: (final BuildContext context, final GoRouterState state) => const LandingPage(),
        ),

        // ── Maintenance ──────────────────────────────────────────────────────
        GoRoute(
          path: Routes.maintenance,
          builder: (final BuildContext context, final GoRouterState state) => const MaintenanceScreen(),
        ),

        // ── Legal / static pages ─────────────────────────────────────────────
        GoRoute(
          path: Routes.terms,
          builder: (final BuildContext context, final GoRouterState state) => const LegalDocumentPage(documentId: LegalDocumentId.terms),
        ),
        GoRoute(
          path: Routes.privacy,
          builder: (final BuildContext context, final GoRouterState state) => const LegalDocumentPage(documentId: LegalDocumentId.privacy),
        ),
        GoRoute(
          path: Routes.accessibility,
          builder: (final BuildContext context, final GoRouterState state) => const LegalDocumentPage(
            documentId: LegalDocumentId.accessibility,
          ),
        ),
        GoRoute(
          path: Routes.legalNotice,
          builder: (final BuildContext context, final GoRouterState state) => const LegalDocumentPage(documentId: LegalDocumentId.legalNotice),
        ),
        GoRoute(
          path: Routes.sitemap,
          builder: (final BuildContext context, final GoRouterState state) => const SitemapPage(),
        ),

        // ── Consent ──────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.consent,
          builder: (final BuildContext context, final GoRouterState state) => const ConsentPage(),
        ),

        // ── Authenticated shell ──────────────────────────────────────────────
        ShellRoute(
          builder:
              (
                final BuildContext context,
                final GoRouterState state,
                final Widget child,
              ) => AppScaffold(child: child),
          routes: [
            // Sprint 9 / STORY-22 carry-over: Routes.home is referenced by sitemap, consent and the bottom-nav but the home page itself is not implemented (see documentation/qa/STORY-22-home-route-investigation.md). Until a real LoggedHomePage lands, /home redirects to /sitemap to avoid the NotFoundScreen.
            GoRoute(
              path: Routes.home,
              redirect: (final BuildContext context, final GoRouterState state) => Routes.sitemap,
            ),

            // ── Thematic landings (placeholder until STORY-23/24/25/26) ────
            GoRoute(
              path: Routes.education,
              builder: (final BuildContext context, final GoRouterState state) => const EducationLandingPage(),
            ),
          ],
        ),
      ],
    );

    ref.onDispose(router.dispose);
    return router;
  },
  name: 'goRouterProvider',
);
