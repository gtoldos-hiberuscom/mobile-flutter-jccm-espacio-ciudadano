// ignore_for_file: avoid_classes_with_only_static_members

/// Route path constants used across the application.
///
/// Keep all route strings in one place to prevent typos and enable
/// compile-time refactoring. This file must not import Flutter or Riverpod.
library;

/// Canonical route path constants for the entire application.
///
/// All navigation targets must be referenced via this class to prevent
/// typos and enable compile-time refactoring. No Flutter or Riverpod imports.
abstract final class Routes {
  // ── Public ────────────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String landing = '/landing';
  static const String landingHelp = '/landing/help';
  static const String landingAbout = '/landing/about';
  static const String helpContact = '/help-contact';
  static const String faqDetail = '/help-contact/faq/:id';
  static String faqDetailPath(final String id) => '/help-contact/faq/$id';
  static const String supportForm = '/support-form';
  static const String legalPrivacy = '/legal/privacy';

  /// [legalPrivacy] en su **vista informativa**: con flecha de volver y sin la
  /// barra de "Salir"/"Continuar" del consentimiento.
  ///
  /// La usan el menú de perfil y la (i) de "Condiciones de uso y
  /// autorizaciones", que abren la página para leerla y no para aceptar nada.
  /// Sin este marcador la página se pinta como paso del consentimiento y
  /// arrastra sus botones.
  static const String legalPrivacyInfo = '$legalPrivacy?from=home';
  static const String legalNotice = '/legal/notice';
  static const String legalAccessibility = '/legal/accessibility';
  static const String login = '/login';
  static const String loginCallback = '/login/callback';
  static const String maintenance = '/maintenance';

  // ── Deep-link callbacks ───────────────────────────────────────────────────
  // The configured URI is `es.jccm.espaciociudadano://auth/callback`;
  // Flutter/GoRouter matches its path component, `/callback`.
  static const String claveCallback = '/callback';
  static const String afirmaReturn = '/sign/afirma/return';

  // ── Authenticated ───────────────────────────────────────────────────────

  /// Mandatory legal-consent gate shown after first login.
  static const String consent = '/consent';
  static const String consentOnboarding = '$consent?mode=onboarding';

  /// Authenticated home — main screen with bottom navigation.
  static const String home = '/home';
  static const String homeFromDrawer = '$home?from=drawer';

  static const String gestion = '/gestion';
  static const String gestionAportacion = '/gestion/aportacion';
  static const String gestionExpedientes = '/gestion/expedientes';
  static const String gestionExpedienteDetalle = '/gestion/expedientes/:numexp';
  static const String gestionExpedienteAportarDocumentacion = '/gestion/expedientes/:numexp/aportar-documentacion';
  static const String gestionNotificaciones = '/gestion/notificaciones';
  static const String gestionNotificacionDetalle = '/gestion/notificaciones/:id';
  static String gestionNotificacionDetallePath(final int id) => '/gestion/notificaciones/$id';
  static const String gestionNotificacionesAlta = '/gestion/notificaciones/alta';
  static const String gestionRegistros = '/gestion/registros';
  static const String gestionRegistrosDetail = '/gestion/registros/detail';
  static const String myData = '/my-data';
  static const String myDataHealth = '/my-data/health';
  static const String myDataHealthPrimaryCareAppointments = '/my-data/health/primary-care';
  static const String myDataHealthHospitalAppointments = '/my-data/health/hospital-appointments';
  static const String myDataEmployment = '/my-data/employment';
  static const String myDataEmploymentOffers = '/my-data/employment/offers';
  static const String myDataSocialWelfare = '/my-data/social-welfare';
  static const String myDataSocialWelfareFamily = '/my-data/social-welfare/family';
  static const String myDataSocialWelfareDisability = '/my-data/social-welfare/disability';
  static const String myDataSocialWelfareThermalSpa = '/my-data/social-welfare/thermal-spa';
  static const String myDataSocialWelfareDependency = '/my-data/social-welfare/dependency';
  static const String myDataSocialWelfareParking = '/my-data/social-welfare/parking';
  static const String myDataEducation = '/my-data/education';
  static const String myDataEducationUniversityTitles = '/my-data/education/university-titles';
  static const String myDataEducationNonUniversityTitles = '/my-data/education/non-university-titles';
  static const String myDataHousing = '/my-data/housing';
  static const String myDataHousingRealEstate = '/my-data/housing/real-estate';
  static const String myDataHousingRealEstateDetail = '/my-data/housing/real-estate/:reference';
  static const String myDataHousingAddress = '/my-data/housing/address';
  static const String myDataVehicles = '/my-data/vehicles';
  static const String digitalCards = '/digital-cards';
  static const String representativeUnavailable = '/representative-unavailable';
  static const String agenda = '/agenda';
  static const String recommendations = '/recommendations';
  static const String recommendationLifeEventFilters = '/recommendations/life-events-filter';

  static const String preferences = '/preferences';
  static const String notificationContact = '/preferences/notification-contact';
  static const String lifeEvents = '/preferences/life-events';
  static const String lifeEventsOnboarding = '$lifeEvents?mode=onboarding';

  /// Design system catalog — developer/designer reference screen.
  static const String designSystem = '/design-system';

  static const Set<String> _authenticated = {
    consent,
    agenda,
    gestion,
    gestionAportacion,
    gestionExpedientes,
    gestionNotificaciones,
    gestionNotificacionesAlta,
    gestionRegistros,
    gestionRegistrosDetail,
    myData,
    // `requiresAuth` ya las cubría por `startsWith(myData)`, pero este conjunto
    // alimenta además `isKnownRoute`, que exige coincidencia exacta y es quien
    // valida el `returnTo` al volver de Preferencias. Sin estar aquí, aceptar
    // el clausulado desde Salud devolvía a `/home` en vez de a la consulta.
    myDataHealth,
    myDataHealthPrimaryCareAppointments,
    myDataHealthHospitalAppointments,
    myDataEmployment,
    myDataEmploymentOffers,
    myDataEducation,
    myDataEducationUniversityTitles,
    myDataEducationNonUniversityTitles,
    myDataHousing,
    myDataHousingRealEstate,
    myDataHousingAddress,
    myDataSocialWelfare,
    myDataSocialWelfareFamily,
    myDataSocialWelfareDisability,
    myDataSocialWelfareThermalSpa,
    myDataSocialWelfareDependency,
    myDataSocialWelfareParking,
    myDataVehicles,
    digitalCards,
    representativeUnavailable,
    recommendations,
    recommendationLifeEventFilters,
    home,
    legalAccessibility,
    legalNotice,
    legalPrivacy,
    preferences,
    notificationContact,
    lifeEvents,
  };

  /// Returns true when [path] requires authentication.
  static bool requiresAuth(final String path) => _authenticated.any(path.startsWith);

  /// Las páginas con datos no disponibles para representación se encargan de
  /// mostrar su aviso dentro de la propia vista, para conservar sus enlaces e
  /// información de ayuda.
  static bool isUnavailableForRepresentative(final String path) {
    return false;
  }

  static bool isKnownRoute(final String? path) {
    if (path == null || path.isEmpty) {
      return false;
    }
    return _authenticated.any((final route) => path == route || path.startsWith('$route?')) ||
        {
          landing,
          landingHelp,
          landingAbout,
          login,
          claveCallback,
        }.contains(path);
  }
}
