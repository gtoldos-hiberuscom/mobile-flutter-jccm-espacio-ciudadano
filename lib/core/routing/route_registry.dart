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
  static const String supportForm = '/support-form';
  static const String legalPrivacy = '/legal/privacy';
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

  static const String myData = '/my-data';
  static const String myDataHealth = '/my-data/health';
  static const String myDataEducation = '/my-data/education';
  static const String myDataEducationUniversityTitles = '/my-data/education/university-titles';
  static const String myDataEducationNonUniversityTitles = '/my-data/education/non-university-titles';
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
    helpContact,
    supportForm,
    agenda,
    myData,
    myDataEducation,
    myDataEducationUniversityTitles,
    myDataEducationNonUniversityTitles,
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
