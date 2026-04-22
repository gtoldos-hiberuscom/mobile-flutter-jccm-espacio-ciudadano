import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/observers/analytics_observer.dart';
import 'package:jccm_espacio_ciudadano/app/observers/app_lifecycle_observer.dart';
import 'package:jccm_espacio_ciudadano/app/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_guards.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/shell/app_scaffold.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/login_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';

/// Riverpod provider that owns the application [GoRouter].
///
/// Kept alive for the entire app lifetime so the router is never recreated
/// on widget-tree rebuilds. The [SessionGuard] captures `ref` from this
/// factory, keeping all navigation decisions free of [BuildContext].
final goRouterProvider = Provider<GoRouter>(
  (final ref) {
    final guard = SessionGuard(ref);
    final lifecycleObserver = AppLifecycleObserver();
    final analyticsObserver = AnalyticsObserver(
      analyticsService: ref.read(analyticsServiceProvider),
    );

    final router = GoRouter(
      initialLocation: Routes.splash,
      observers: [lifecycleObserver, analyticsObserver],
      // ── Global redirect ──────────────────────────────────────────────────
      redirect: (final BuildContext context, final GoRouterState state) =>
          guard.redirect(state),

      // ── 404 fallback ──────────────────────────────────────────────────────
      errorBuilder: (final BuildContext context, final GoRouterState state) =>
          const NotFoundScreen(),

      routes: [
        // ── Splash ──────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.splash,
          builder: (final BuildContext context, final GoRouterState state) =>
              const SplashScreen(),
        ),

        // ── Landing ─────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.landing,
          builder: (final BuildContext context, final GoRouterState state) =>
              const LandingPage(),
        ),

        // ── Login flow ───────────────────────────────────────────────────────
        GoRoute(
          path: Routes.login,
          builder: (final BuildContext context, final GoRouterState state) =>
              const LoginPage(),
          routes: [
            GoRoute(
              path: 'callback',
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const LoginCallbackPlaceholder(),
            ),
          ],
        ),

        // ── Maintenance ──────────────────────────────────────────────────────
        GoRoute(
          path: Routes.maintenance,
          builder: (final BuildContext context, final GoRouterState state) =>
              const MaintenanceScreen(),
        ),

        // ── Legal / static pages ─────────────────────────────────────────────
        GoRoute(
          path: Routes.terms,
          builder: (final BuildContext context, final GoRouterState state) =>
              const LegalPlaceholder(title: 'Condiciones de uso'),
        ),
        GoRoute(
          path: Routes.privacy,
          builder: (final BuildContext context, final GoRouterState state) =>
              const LegalPlaceholder(title: 'Política de privacidad'),
        ),
        GoRoute(
          path: Routes.accessibility,
          builder: (final BuildContext context, final GoRouterState state) =>
              const LegalPlaceholder(title: 'Accesibilidad'),
        ),
        GoRoute(
          path: Routes.legalNotice,
          builder: (final BuildContext context, final GoRouterState state) =>
              const LegalPlaceholder(title: 'Aviso legal'),
        ),
        GoRoute(
          path: Routes.sitemap,
          builder: (final BuildContext context, final GoRouterState state) =>
              const SitemapPlaceholder(),
        ),
        GoRoute(
          path: Routes.help,
          builder: (final BuildContext context, final GoRouterState state) =>
              const HelpPlaceholder(),
        ),

        // ── Deep-link callbacks ──────────────────────────────────────────────
        // Custom URL scheme: jccmapp://auth/clave/callback?code=<authorization_code>
        // GoRouter matches the path portion: /auth/clave/callback
        // The `code` query parameter is extracted and passed to [SessionNotifier].
        GoRoute(
          path: Routes.claveCallback,
          builder: (final BuildContext context, final GoRouterState routerState) {
            final callbackUri = routerState.uri;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final container = ProviderScope.containerOf(context);
              unawaited(
                container
                    .read<SessionNotifier>(sessionProvider.notifier)
                    .handleCallback(callbackUri),
              );
            });
            return const LoginCallbackPlaceholder();
          },
        ),
        GoRoute(
          path: Routes.afirmaReturn,
          builder: (final BuildContext context, final GoRouterState state) =>
              const LoginCallbackPlaceholder(),
        ),

        // ── Authenticated shell ──────────────────────────────────────────────
        ShellRoute(
          builder: (
            final BuildContext context,
            final GoRouterState state,
            final Widget child,
          ) =>
              AppScaffold(child: child),
          routes: [
            GoRoute(
              path: Routes.home,
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const HomePlaceholder(),
            ),
            GoRoute(
              path: Routes.agenda,
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const AgendaPlaceholder(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder:
                      (final BuildContext context, final GoRouterState state) =>
                          const AgendaPlaceholder(),
                ),
              ],
            ),
            GoRoute(
              path: Routes.casework,
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const CaseworkPlaceholder(),
            ),
            GoRoute(
              path: Routes.notifications,
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const NotificationsPlaceholder(),
            ),
            GoRoute(
              path: Routes.cards,
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const CardsPlaceholder(),
            ),
            GoRoute(
              path: Routes.profile,
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const ProfilePlaceholder(),
            ),
            GoRoute(
              path: Routes.recommendations,
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const RecommendationsPlaceholder(),
            ),
            GoRoute(
              path: Routes.support,
              builder:
                  (final BuildContext context, final GoRouterState state) =>
                      const SupportPlaceholder(),
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
