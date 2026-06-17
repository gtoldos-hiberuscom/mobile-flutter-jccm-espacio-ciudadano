import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/main_sections_shell.dart';
import 'package:jccm_espacio_ciudadano/core/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_observer.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/routing/session_guard.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_page.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/pages/consent_page.dart';
import 'package:jccm_espacio_ciudadano/features/design_system/2_presentation/pages/design_system_catalog_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/help_contact_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/home_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_about_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_help_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/login_callback_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/support_form_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/accessibility_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/legal_notice_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/privacy_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_education_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_health_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_non_university_titles_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_university_titles_page.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_page.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/notification_contact_page.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/preferences_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendation_life_event_filters_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page.dart';

/// Riverpod provider that owns the application [GoRouter].
///
/// Kept alive for the entire app lifetime so the router is never recreated
/// on widget-tree rebuilds. The [SessionGuard] captures `ref` from this
/// factory, keeping all navigation decisions free of [BuildContext].
final goRouterProvider = Provider<GoRouter>(
  (final ref) {
    final guard = SessionGuard(ref);

    NoTransitionPage<void> noTransitionPage(final GoRouterState state, final Widget child) => NoTransitionPage<void>(
      key: state.pageKey,
      child: child,
    );

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
            isPreferencesEditing: state.uri.queryParameters['mode'] == 'preferences',
            returnTo: Routes.isKnownRoute(state.uri.queryParameters['returnTo']) ? state.uri.queryParameters['returnTo']! : Routes.home,
          ),
        ),

        GoRoute(
          path: Routes.helpContact,
          pageBuilder: (final BuildContext context, final GoRouterState state) => noTransitionPage(
            state,
            const HelpContactPage(),
          ),
        ),

        GoRoute(
          path: Routes.supportForm,
          pageBuilder: (final BuildContext context, final GoRouterState state) => noTransitionPage(
            state,
            const SupportFormPage(),
          ),
        ),

        // ── Legal ────────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.legalPrivacy,
          pageBuilder: (final BuildContext context, final GoRouterState state) => noTransitionPage(
            state,
            PrivacyPage(
              fromHome: state.uri.queryParameters['from'] == 'home',
            ),
          ),
        ),
        GoRoute(
          path: Routes.legalNotice,
          pageBuilder: (final BuildContext context, final GoRouterState state) => noTransitionPage(
            state,
            const LegalNoticePage(),
          ),
        ),
        GoRoute(
          path: Routes.legalAccessibility,
          pageBuilder: (final BuildContext context, final GoRouterState state) => noTransitionPage(
            state,
            const AccessibilityPage(),
          ),
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

        ShellRoute(
          builder: (final BuildContext context, final GoRouterState state, final Widget child) => MainSectionsShell(
            location: state.uri.path,
            child: child,
          ),
          routes: [
            // ── Authenticated Home (STORY-22) ────────────────────────────────
            GoRoute(
              path: Routes.home,
              pageBuilder: (final BuildContext context, final GoRouterState state) {
                const page = HomePage();
                if (state.uri.queryParameters['from'] == 'drawer') {
                  return noTransitionPage(state, page);
                }
                return MaterialPage<void>(
                  key: state.pageKey,
                  child: page,
                );
              },
            ),

            GoRoute(
              path: Routes.agenda,
              builder: (final BuildContext context, final GoRouterState state) => const AgendaPage(),
            ),

            GoRoute(
              path: Routes.myData,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataPage(),
            ),

            GoRoute(
              path: Routes.myDataHealth,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataHealthPage(),
            ),

            GoRoute(
              path: Routes.myDataEducation,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataEducationPage(),
            ),

            GoRoute(
              path: Routes.myDataEducationUniversityTitles,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataUniversityTitlesPage(),
            ),

            GoRoute(
              path: Routes.myDataEducationNonUniversityTitles,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataNonUniversityTitlesPage(),
            ),

            GoRoute(
              path: Routes.recommendations,
              builder: (final BuildContext context, final GoRouterState state) => const RecommendationsPage(),
            ),
          ],
        ),

        GoRoute(
          path: Routes.recommendationLifeEventFilters,
          builder: (final BuildContext context, final GoRouterState state) {
            final extra = state.extra;
            if (extra is RecommendationLifeEventFiltersArgs) {
              return RecommendationLifeEventFiltersPage(args: extra);
            }
            return const RecommendationsPage();
          },
        ),

        GoRoute(
          path: Routes.preferences,
          pageBuilder: (final BuildContext context, final GoRouterState state) => noTransitionPage(
            state,
            const PreferencesPage(),
          ),
        ),

        GoRoute(
          path: Routes.notificationContact,
          builder: (final BuildContext context, final GoRouterState state) => const NotificationContactPage(),
        ),

        // ── Personalization — Mis hechos vitales (STORY-54 / JCCMEC-53) ──────
        GoRoute(
          path: Routes.lifeEvents,
          builder: (final BuildContext context, final GoRouterState state) => LifeEventsPage(
            isOnboarding: state.uri.queryParameters['mode'] == 'onboarding',
            returnTo: Routes.isKnownRoute(state.uri.queryParameters['returnTo']) ? state.uri.queryParameters['returnTo']! : Routes.home,
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
