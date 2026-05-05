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

  /// Third-party aportación documental wizard (STORY-37).
  static const String caseworkAportacion = '/casework/aportacion';
  static const String caseworkItemDetail = '/casework/item/:id';

  /// Upload-evidence screen for a given expediente (STORY-38).
  static const String caseworkUpload = '/casework/item/:id/upload';

  /// Registro de entrada / salida detail screen (STORY-36).
  /// `kind` is one of `entrada|salida`; `numreg` must be URL-encoded.
  static const String caseworkRegistroDetail = '/casework/registro/:kind/:numreg';
  static const String notifications = '/notifications';
  static const String notificationDetail = '/notifications/:id';
  static const String notificationContactRegistration = '/notifications/contact/registration';
  static const String cards = '/cards';

  /// Carnet digital de familia numerosa — per-card detail (STORY-49).
  static const String cardFamiliaNumerosaDetail = '/cards/familia-numerosa';

  /// Carnet digital joven — per-card detail (STORY-50).
  ///
  /// The catalogue surfaces the modal variant of the carnet joven; this
  /// route exists for deep links and for any future home/menu shortcut
  /// that prefers the full-page version.
  static const String cardJovenDetail = '/cards/joven';

  /// Carnet digital de discapacidad — per-card detail (STORY-51).
  ///
  /// Surfaces grado de discapacidad and the PKPass action when the
  /// carnet is vigente; renders explicit no-vigente / sin-datos /
  /// parse-error fallbacks otherwise.
  static const String cardDiscapacidadDetail = '/cards/discapacidad';
  static const String recommendations = '/recommendations';
  static const String support = '/support';
  static const String signatureInbox = '/sign';

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
    notificationContactRegistration,
    cards,
    cardFamiliaNumerosaDetail,
    cardJovenDetail,
    cardDiscapacidadDetail,
    recommendations,
    support,
    signatureInbox,
    education,
    employment,
    socialWelfare,
    stateAffairs,
    preferencesConsent,
  };

  /// Returns true when [path] requires authentication.
  static bool requiresAuth(final String path) => _authenticated.any(path.startsWith);
}
