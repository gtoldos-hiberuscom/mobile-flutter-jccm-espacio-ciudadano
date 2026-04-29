import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/observers/analytics_observer.dart';
import 'package:jccm_espacio_ciudadano/app/observers/app_lifecycle_observer.dart';
import 'package:jccm_espacio_ciudadano/app/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/shell/app_scaffold.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';
import 'package:jccm_espacio_ciudadano/core/logging/logger_provider.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_event_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/casework_search_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/casework_workspace_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/aportacion_wizard_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/2_presentation/expediente_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/2_presentation/registro_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/upload_evidence_page.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/consent_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/digital_cards_catalog_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/2_presentation/discapacidad_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/2_presentation/familia_numerosa_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/2_presentation/joven_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/education/2_presentation/education_landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/employment/2_presentation/employment_landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/help_page.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/support_form_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/legal_document_page.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/notification_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/notifications_center_page.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/2_presentation/notification_contact_registration_page.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/data_consent_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page_route.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/afirma_return_page.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/signature_inbox_page.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/2_presentation/sitemap_page.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/2_presentation/social_welfare_landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/2_presentation/state_affairs_landing_page.dart';

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
        GoRoute(
          path: Routes.help,
          builder: (final BuildContext context, final GoRouterState state) => const HelpPage(),
        ),
        GoRoute(
          path: Routes.supportForm,
          builder: (final BuildContext context, final GoRouterState state) => const SupportFormPage(),
        ),

        // ── Deep-link callbacks ──────────────────────────────────────────────
        GoRoute(
          path: Routes.afirmaReturn,
          builder: (final BuildContext context, final GoRouterState state) => AfirmaReturnPage(returnUri: state.uri),
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
            GoRoute(
              path: Routes.employment,
              builder: (final BuildContext context, final GoRouterState state) => const EmploymentLandingPage(),
            ),
            GoRoute(
              path: Routes.socialWelfare,
              builder: (final BuildContext context, final GoRouterState state) => const SocialWelfareLandingPage(),
            ),
            GoRoute(
              path: Routes.stateAffairs,
              builder: (final BuildContext context, final GoRouterState state) => const StateAffairsLandingPage(),
            ),
            GoRoute(
              path: Routes.agenda,
              builder: (final BuildContext context, final GoRouterState state) => const AgendaPage(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (final BuildContext context, final GoRouterState state) => AgendaEventDetailPage(
                    eventId: state.pathParameters['id'] ?? '',
                  ),
                ),
              ],
            ),
            GoRoute(
              path: Routes.casework,
              builder: (final BuildContext context, final GoRouterState state) => const CaseworkWorkspacePage(),
              routes: [
                GoRoute(
                  path: 'search',
                  builder: (final BuildContext context, final GoRouterState state) => const CaseworkSearchPage(),
                ),
                GoRoute(
                  path: 'aportacion',
                  builder: (final BuildContext context, final GoRouterState state) => const AportacionWizardPage(),
                ),
                GoRoute(
                  path: 'item/:id',
                  builder: (final BuildContext context, final GoRouterState state) => ExpedienteDetailPage(
                    expedienteRef: state.pathParameters['id'] ?? '',
                  ),
                  routes: [
                    GoRoute(
                      path: 'upload',
                      builder: (final BuildContext context, final GoRouterState state) => UploadEvidencePage(
                        expedienteRef: state.pathParameters['id'] ?? '',
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'registro/:kind/:numreg',
                  builder: (final BuildContext context, final GoRouterState state) {
                    final kind =
                        RegistroKindToken.fromToken(
                          state.pathParameters['kind'],
                        ) ??
                        RegistroKind.entrada;
                    final encoded = state.pathParameters['numreg'] ?? '';
                    final numreg = Uri.decodeComponent(encoded);
                    return RegistroDetailPage(numreg: numreg, kind: kind);
                  },
                ),
              ],
            ),
            GoRoute(
              path: Routes.notifications,
              builder: (final BuildContext context, final GoRouterState state) => const NotificationsCenterPage(),
              routes: <GoRoute>[
                GoRoute(
                  path: 'contact/registration',
                  builder: (final BuildContext context, final GoRouterState state) => const NotificationContactRegistrationPage(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (final BuildContext context, final GoRouterState state) => NotificationDetailPage(
                    notificationId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: Routes.cards,
              builder: (final BuildContext context, final GoRouterState state) => const DigitalCardsCatalogPage(),
            ),
            GoRoute(
              path: Routes.signatureInbox,
              builder: (final BuildContext context, final GoRouterState state) => const SignatureInboxPage(),
            ),
            GoRoute(
              path: Routes.cardFamiliaNumerosaDetail,
              builder: (final BuildContext context, final GoRouterState state) => const FamiliaNumerosaDetailPage(),
            ),
            GoRoute(
              path: Routes.cardJovenDetail,
              builder: (final BuildContext context, final GoRouterState state) => const JovenDetailPage(),
            ),
            GoRoute(
              path: Routes.cardDiscapacidadDetail,
              builder: (final BuildContext context, final GoRouterState state) => const DiscapacidadDetailPage(),
            ),
            GoRoute(
              path: Routes.profile,
              builder: (final BuildContext context, final GoRouterState state) => const ProfilePlaceholder(),
            ),
            GoRoute(
              path: Routes.recommendations,
              builder: (final BuildContext context, final GoRouterState state) => const RecommendationsPage(),
            ),
            GoRoute(
              path: Routes.support,
              builder: (final BuildContext context, final GoRouterState state) => const SupportPlaceholder(),
            ),
            GoRoute(
              path: Routes.preferencesConsent,
              builder: (final BuildContext context, final GoRouterState state) => const DataConsentPage(),
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
