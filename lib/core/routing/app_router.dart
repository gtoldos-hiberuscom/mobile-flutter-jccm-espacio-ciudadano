import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/main_sections_shell.dart';
import 'package:jccm_espacio_ciudadano/core/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_observer.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/routing/session_guard.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_page.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/representative_unavailable_page.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/pages/consent_page.dart';
import 'package:jccm_espacio_ciudadano/features/design_system/2_presentation/pages/design_system_catalog_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/digital_cards_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_aportacion_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_aportar_documentacion_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_expediente_detalle_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_expedientes_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_notificacion_detalle_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_notificaciones_alta_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_notificaciones_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_registro_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_registros_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/tercero_identificacion.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/faq_detail_page.dart';
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
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_employment_offers_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_employment_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_health_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_hospital_appointments_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_address_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_real_estate_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_real_estate_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_non_university_titles_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_primary_care_appointments_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_dependency_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_disability_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_family_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_parking_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_thermal_spa_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_university_titles_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_vehicles_page.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_page.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/notification_contact_page.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/preferences_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendation_life_event_filters_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page.dart';

/// Pantalla de detalle de un registro a partir del `extra` de la ruta.
///
/// El registro completo viaja en `extra`, que **no** sobrevive a un deep link,
/// a la restauración de estado ni a un `go()` externo. Sin él no hay nada que
/// mostrar, así que se cae a [NotFoundScreen] en lugar de castear a ciegas
/// (`state.extra! as (Registro, bool)` lanzaba dentro del builder, es decir,
/// pantalla de error de GoRouter). Es el mismo criterio que el resto de rutas
/// con `extra`.
/// Construye la página legal de protección de datos según cómo se llegue a
/// ella.
///
/// `from=home` ([Routes.legalPrivacyInfo]) la abre como información: flecha de
/// volver y sin la barra dicotómica del consentimiento. Sin ese marcador es un
/// paso del flujo legal, con "Salir" y "Continuar".
Widget buildLegalPrivacy(final Uri uri) => PrivacyPage(
  fromHome: uri.queryParameters['from'] == 'home',
  isOnboarding: uri.queryParameters['mode'] == 'onboarding',
);

Widget buildGestionRegistroDetail(final Object? extra) => switch (extra) {
  (final Registro registro, final bool isEntrada) => GestionRegistroDetailPage(registro: registro, isEntrada: isEntrada),
  _ => const NotFoundScreen(),
};

/// Detalle de notificación. El id viaja en la ruta y debe ser numérico: un
/// deep link malformado caía antes en `?? 0` y consultaba al backend por la
/// notificación 0 (NC-3) — ahora cae en [NotFoundScreen], como el detalle de
/// registro (H-04).
Widget buildGestionNotificacionDetalle(final String? idParameter, final Object? extra) {
  final id = int.tryParse(idParameter ?? '');
  if (id == null) {
    return const NotFoundScreen();
  }
  // El resumen del listado solo se pasa si se conoce: el repositorio lo usa
  // como respaldo de lo que el detalle no informe (estado, procedimiento,
  // fecha de expiración, sistema de origen). Sin resumen (deep link,
  // restauración) viaja `null`, nunca un dato inventado.
  return GestionNotificacionDetallePage(
    notificacionId: id,
    resumen: extra is Notificacion ? extra : null,
  );
}

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
          path: Routes.faqDetail,
          pageBuilder: (final BuildContext context, final GoRouterState state) {
            final entry = faqEntryById(state.pathParameters['id'] ?? '');
            return noTransitionPage(
              state,
              entry == null ? const NotFoundScreen() : FaqDetailPage(entry: entry),
            );
          },
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
            buildLegalPrivacy(state.uri),
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
              path: Routes.gestion,
              builder: (final BuildContext context, final GoRouterState state) => const GestionPage(),
            ),

            GoRoute(
              path: Routes.gestionAportacion,
              builder: (final BuildContext context, final GoRouterState state) => const GestionAportacionPage(),
            ),

            GoRoute(
              path: Routes.gestionNotificaciones,
              builder: (final BuildContext context, final GoRouterState state) => GestionNotificacionesPage(
                backRoute: state.uri.queryParameters['from'] == 'home' ? Routes.home : Routes.gestion,
              ),
            ),

            GoRoute(
              path: Routes.gestionNotificacionesAlta,
              builder: (final BuildContext context, final GoRouterState state) => const GestionNotificacionesAltaPage(),
            ),

            GoRoute(
              path: Routes.gestionNotificacionDetalle,
              builder: (final BuildContext context, final GoRouterState state) => buildGestionNotificacionDetalle(state.pathParameters['id'], state.extra),
            ),

            GoRoute(
              path: Routes.gestionExpedientes,
              builder: (final BuildContext context, final GoRouterState state) => const GestionExpedientesPage(),
            ),

            GoRoute(
              path: Routes.gestionExpedienteDetalle,
              builder: (final BuildContext context, final GoRouterState state) {
                final extra = state.extra;
                return GestionExpedienteDetallePage(
                  numexp: state.pathParameters['numexp'] ?? '',
                  tercero: extra is TerceroIdentificacion ? extra : null,
                );
              },
            ),

            GoRoute(
              path: Routes.gestionExpedienteAportarDocumentacion,
              builder: (final BuildContext context, final GoRouterState state) {
                final extra = state.extra;
                return GestionAportarDocumentacionPage(
                  numexp: state.pathParameters['numexp'] ?? '',
                  tercero: extra is TerceroIdentificacion ? extra : null,
                );
              },
            ),

            GoRoute(
              path: Routes.gestionRegistros,
              builder: (final BuildContext context, final GoRouterState state) => const GestionRegistrosPage(),
            ),

            GoRoute(
              path: Routes.gestionRegistrosDetail,
              builder: (final BuildContext context, final GoRouterState state) => buildGestionRegistroDetail(state.extra),
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
              builder: (final BuildContext context, final GoRouterState state) => MyDataHealthPage(
                backRoute: state.uri.queryParameters['from'] == 'home' ? Routes.home : Routes.myData,
              ),
            ),

            GoRoute(
              path: Routes.myDataHealthPrimaryCareAppointments,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataPrimaryCareAppointmentsPage(),
            ),

            GoRoute(
              path: Routes.myDataHealthHospitalAppointments,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataHospitalAppointmentsPage(),
            ),

            GoRoute(
              path: Routes.myDataEmployment,
              builder: (final BuildContext context, final GoRouterState state) => MyDataEmploymentPage(
                backRoute: state.uri.queryParameters['from'] == 'home' ? Routes.home : Routes.myData,
              ),
            ),

            GoRoute(
              path: Routes.myDataEmploymentOffers,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataEmploymentOffersPage(),
            ),

            GoRoute(
              path: Routes.myDataSocialWelfare,
              builder: (final BuildContext context, final GoRouterState state) => MyDataSocialWelfarePage(
                backRoute: state.uri.queryParameters['from'] == 'home' ? Routes.home : Routes.myData,
              ),
            ),

            GoRoute(
              path: Routes.myDataSocialWelfareFamily,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataSocialWelfareFamilyPage(),
            ),

            GoRoute(
              path: Routes.myDataSocialWelfareDisability,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataSocialWelfareDisabilityPage(),
            ),

            GoRoute(
              path: Routes.myDataSocialWelfareThermalSpa,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataSocialWelfareThermalSpaPage(),
            ),

            GoRoute(
              path: Routes.myDataSocialWelfareDependency,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataSocialWelfareDependencyPage(),
            ),

            GoRoute(
              path: Routes.myDataSocialWelfareParking,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataSocialWelfareParkingPage(),
            ),

            GoRoute(
              path: Routes.myDataEducation,
              builder: (final BuildContext context, final GoRouterState state) => MyDataEducationPage(
                backRoute: state.uri.queryParameters['from'] == 'home' ? Routes.home : Routes.myData,
              ),
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
              path: Routes.myDataHousing,
              builder: (final BuildContext context, final GoRouterState state) => MyDataHousingPage(
                backRoute: state.uri.queryParameters['from'] == 'home' ? Routes.home : Routes.myData,
              ),
            ),

            GoRoute(
              path: Routes.myDataHousingRealEstate,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataHousingRealEstatePage(),
            ),

            GoRoute(
              path: Routes.myDataHousingRealEstateDetail,
              builder: (final BuildContext context, final GoRouterState state) => MyDataHousingRealEstateDetailPage(
                reference: state.pathParameters['reference'] ?? '',
              ),
            ),

            GoRoute(
              path: Routes.myDataHousingAddress,
              builder: (final BuildContext context, final GoRouterState state) => const MyDataHousingAddressPage(),
            ),

            GoRoute(
              path: Routes.myDataVehicles,
              builder: (final BuildContext context, final GoRouterState state) => MyDataVehiclesPage(
                backRoute: state.uri.queryParameters['from'] == 'home' ? Routes.home : Routes.myData,
              ),
            ),

            GoRoute(
              path: Routes.digitalCards,
              builder: (final BuildContext context, final GoRouterState state) => const DigitalCardsPage(),
            ),

            GoRoute(
              path: Routes.representativeUnavailable,
              builder: (final BuildContext context, final GoRouterState state) => const RepresentativeUnavailablePage(),
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
          builder: (final BuildContext context, final GoRouterState state) => NotificationContactPage(
            returnTo: Routes.isKnownRoute(state.uri.queryParameters['returnTo']) ? state.uri.queryParameters['returnTo']! : Routes.preferences,
          ),
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
        // Catálogo interno de componentes, sólo en debug. NO está en
        // `Routes._authenticated`, así que es ruta pública: registrarla en
        // release la deja alcanzable sin sesión (riesgo nº 8 de
        // documentation/PLAN_DE_PRUEBAS.md).
        if (kDebugMode)
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
