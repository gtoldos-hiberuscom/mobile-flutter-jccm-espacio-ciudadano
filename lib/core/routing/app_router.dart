import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_observer.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/routing/session_guard.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/pages/consent_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_about_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_help_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_page.dart';

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
          routes: [
            GoRoute(
              path: 'help',
              builder: (final BuildContext context, final GoRouterState state) => const LandingHelpPage(),
            ),
            GoRoute(
              path: 'about',
              builder: (final BuildContext context, final GoRouterState state) => const LandingAboutPage(),
            ),
          ],
        ),

        // ── Consent gate (JCCMEC-11) ─────────────────────────────────────────
        GoRoute(
          path: Routes.consent,
          builder: (final BuildContext context, final GoRouterState state) =>
              const ConsentPage(),
        ),

        // ── Login (JCCMEC-10) ─────────────────────────────────────────────
        GoRoute(
          path: Routes.login,
          builder: (final BuildContext context, final GoRouterState state) =>
              const DomainLandingPlaceholder(title: 'Login'),
        ),

        // ── Personalization — Mis hechos vitales (STORY-54 / JCCMEC-53) ──────
        GoRoute(
          path: Routes.lifeEvents,
          builder: (final BuildContext context, final GoRouterState state) =>
              const LifeEventsPage(),
        ),
      ],
    );

    ref.onDispose(router.dispose);
    return router;
  },
  name: 'goRouterProvider',
);
