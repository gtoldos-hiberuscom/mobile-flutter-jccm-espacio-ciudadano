import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_observer.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/routing/session_guard.dart';
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
    final guard = SessionGuard(ref);

    final router = GoRouter(
      initialLocation: Routes.landing,
      observers: [GoRouterObserver()],
      // ── Global redirect ──────────────────────────────────────────────────
      redirect: (final BuildContext context, final GoRouterState state) async => guard.redirect(state),

      // ── 404 fallback ──────────────────────────────────────────────────────
      errorBuilder: (final BuildContext context, final GoRouterState state) => const NotFoundScreen(),

      routes: [
        // ── Landing ─────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.landing,
          builder: (final BuildContext context, final GoRouterState state) => const LandingPage(),
        ),

        // ── Login (JCCMEC-10) ─────────────────────────────────────────────
        GoRoute(
          path: Routes.login,
          builder: (final BuildContext context, final GoRouterState state) =>
              const DomainLandingPlaceholder(title: 'Login'),
        ),

        // ── Cl@ve SSO callback — deep-link entry point ────────────────────
        GoRoute(
          path: Routes.claveCallback,
          builder: (final BuildContext context, final GoRouterState state) => const ClaveCallbackScreen(),
        ),

        // ── Consent (JCCMEC-11) ───────────────────────────────────────────
        GoRoute(
          path: Routes.consent,
          builder: (final BuildContext context, final GoRouterState state) =>
              const DomainLandingPlaceholder(title: 'Consentimiento'),
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
        GoRoute(
          path: Routes.education,
          builder: (final BuildContext context, final GoRouterState state) => const EducationLandingPage(),
        ),
      ],
    );

    ref.onDispose(router.dispose);
    return router;
  },
  name: 'goRouterProvider',
);
