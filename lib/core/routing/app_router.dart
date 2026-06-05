import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_observer.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/routing/session_guard.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/pages/consent_page.dart';
import 'package:jccm_espacio_ciudadano/features/design_system/2_presentation/pages/design_system_catalog_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/help_contact_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/home_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_about_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_help_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/login_callback_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/accessibility_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/legal_notice_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/privacy_page.dart';
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
              builder: (final BuildContext context, final GoRouterState state) => LandingHelpPage(
                fromHome: state.uri.queryParameters['from'] == 'home',
              ),
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
          builder: (final BuildContext context, final GoRouterState state) => ConsentPage(
            isOnboarding: state.uri.queryParameters['mode'] == 'onboarding',
          ),
        ),

        GoRoute(
          path: Routes.helpContact,
          builder: (final BuildContext context, final GoRouterState state) => const HelpContactPage(),
        ),

        // ── Legal ────────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.legalPrivacy,
          builder: (final BuildContext context, final GoRouterState state) => PrivacyPage(
            fromHome: state.uri.queryParameters['from'] == 'home',
          ),
        ),
        GoRoute(
          path: Routes.legalNotice,
          builder: (final BuildContext context, final GoRouterState state) => const LegalNoticePage(),
        ),
        GoRoute(
          path: Routes.legalAccessibility,
          builder: (final BuildContext context, final GoRouterState state) => const AccessibilityPage(),
        ),

        // ── Login (JCCMEC-10) ─────────────────────────────────────────────
        GoRoute(
          path: Routes.login,
          builder: (final BuildContext context, final GoRouterState state) => const DomainLandingPlaceholder(title: 'Login'),
        ),

        // ── Cl@ve SSO callback deep-link ───────────────────────────────────
        GoRoute(
          path: Routes.claveCallback,
          builder: (final BuildContext context, final GoRouterState state) => const LoginCallbackPage(),
        ),

        // ── Authenticated Home (STORY-22) — placeholder until full impl ────
        GoRoute(
          path: Routes.home,
          builder: (final BuildContext context, final GoRouterState state) => const HomePage(),
        ),

        // ── Personalization — Mis hechos vitales (STORY-54 / JCCMEC-53) ──────
        GoRoute(
          path: Routes.lifeEvents,
          builder: (final BuildContext context, final GoRouterState state) => LifeEventsPage(
            isOnboarding: state.uri.queryParameters['mode'] == 'onboarding',
          ),
        ),

        // ── Design System catalog ─────────────────────────────────────────
        GoRoute(
          path: Routes.designSystem,
          builder: (final BuildContext context, final GoRouterState state) => const DesignSystemCatalogPage(),
        ),
      ],
    );

    ref.onDispose(router.dispose);
    return router;
  },
  name: 'goRouterProvider',
);
