/// Route path constants used across the application.
///
/// Keep all route strings in one place to prevent typos and enable
/// compile-time refactoring. This file must not import Flutter or Riverpod.
// ignore_for_file: avoid_classes_with_only_static_members
abstract final class RouteRegistry {
  /// Splash / initial route.
  static const String root = '/';

  /// Placeholder home route — replace in STORY-13.
  static const String home = '/home';
}

/// Canonical route path constants for the entire application.
///
/// All navigation targets must be referenced via this class to prevent
/// typos and enable compile-time refactoring. No Flutter or Riverpod imports.
abstract final class Routes {
  // ── Public ────────────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String loginCallback = '/login/callback';
  static const String maintenance = '/maintenance';

  // ── Legal / static (public) ───────────────────────────────────────────────
  static const String terms = '/legal/terms';
  static const String privacy = '/legal/privacy';
  static const String accessibility = '/legal/accessibility';
  static const String legalNotice = '/legal/notice';
  static const String sitemap = '/sitemap';
  static const String help = '/help';
  static const String supportForm = '/help/support';

  // ── Authenticated ─────────────────────────────────────────────────────────
  static const String home = '/home';
  static const String profile = '/profile';
  static const String agenda = '/agenda';
  static const String agendaDetail = '/agenda/:id';
  static const String casework = '/casework';
  static const String caseworkSearch = '/casework/search';
  static const String caseworkItemDetail = '/casework/item/:id';
  static const String notifications = '/notifications';
  static const String cards = '/cards';
  static const String recommendations = '/recommendations';
  static const String support = '/support';

  // ── Authenticated thematic landings ───────────────────────────────────────
  // Real pages will be implemented in STORY-23/24/25/26 — for now the home
  // wires these routes to a [DomainLandingPlaceholder].
  static const String education = '/education';
  static const String employment = '/employment';
  static const String socialWelfare = '/social-welfare';
  static const String stateAffairs = '/state-affairs';

  // ── Deep-link callbacks ───────────────────────────────────────────────────
  static const String claveCallback = '/auth/clave/callback';
  static const String afirmaReturn = '/sign/afirma/return';

  // ── Consent ───────────────────────────────────────────────────────────────
  static const String consent = '/consent';

  // ── Personalization ───────────────────────────────────────────────────────
  /// Mis autorizaciones — citizen data-consent screen (STORY-55).
  static const String preferencesConsent = '/preferences/consent';

  // ── Route sets for guard classification ───────────────────────────────────

  /// Paths that require an active session.
  static const Set<String> _authenticated = {
    home,
    profile,
    agenda,
    casework,
    notifications,
    cards,
    recommendations,
    support,
    education,
    employment,
    socialWelfare,
    stateAffairs,
    preferencesConsent,
  };

  /// Returns true when [path] requires authentication.
  static bool requiresAuth(final String path) =>
      _authenticated.any(path.startsWith);
}
