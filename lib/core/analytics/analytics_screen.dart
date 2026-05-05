import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';

/// Allow-listed enum of telemetry screen identifiers.
///
/// Replaces the previous free-form `String` argument of
/// `AnalyticsService.setCurrentScreen` so that:
///
/// 1. No caller can accidentally feed user content (e.g. `/profile/<NIF>`)
///    into the analytics backend.
/// 2. The set of recognised screens is a closed set defined alongside the
///    canonical [Routes] table; adding a new tracked screen is a deliberate
///    code change.
/// 3. Unknown / parameterised routes collapse to [AnalyticsScreen.unknown],
///    which callers (specifically the `AnalyticsObserver`) treat as a
///    signal to **skip emission** and log a warning.
///
/// Each entry exposes a stable [slug] which is the only string that ever
/// reaches the backend.
enum AnalyticsScreen {
  splash('/'),
  landing(Routes.landing),
  login(Routes.login),
  loginCallback(Routes.loginCallback),
  maintenance(Routes.maintenance),

  // Legal / static (public)
  legalTerms(Routes.terms),
  legalPrivacy(Routes.privacy),
  legalAccessibility(Routes.accessibility),
  legalNotice(Routes.legalNotice),
  sitemap(Routes.sitemap),
  help(Routes.help),
  supportForm(Routes.supportForm),

  // Authenticated
  home(Routes.home),
  profile(Routes.profile),
  agenda(Routes.agenda),
  agendaDetail(Routes.agendaDetail),
  casework(Routes.casework),
  caseworkSearch(Routes.caseworkSearch),
  caseworkAportacion(Routes.caseworkAportacion),
  caseworkItemDetail(Routes.caseworkItemDetail),
  caseworkUpload(Routes.caseworkUpload),
  caseworkRegistroDetail(Routes.caseworkRegistroDetail),
  notifications(Routes.notifications),
  notificationDetail(Routes.notificationDetail),
  notificationContactRegistration(Routes.notificationContactRegistration),
  cards(Routes.cards),
  cardFamiliaNumerosaDetail(Routes.cardFamiliaNumerosaDetail),
  cardJovenDetail(Routes.cardJovenDetail),
  cardDiscapacidadDetail(Routes.cardDiscapacidadDetail),
  recommendations(Routes.recommendations),
  support(Routes.support),
  signatureInbox(Routes.signatureInbox),

  // Authenticated thematic landings
  education(Routes.education),
  employment(Routes.employment),
  socialWelfare(Routes.socialWelfare),
  stateAffairs(Routes.stateAffairs),

  // Deep-link callbacks
  claveCallback(Routes.claveCallback),
  afirmaReturn(Routes.afirmaReturn),

  // Consent + personalization
  consent(Routes.consent),
  preferencesConsent(Routes.preferencesConsent),

  /// Sentinel for routes that are not in the allow-list. Callers must
  /// **never** forward this to the backend; it exists so that
  /// `AnalyticsScreen.fromRoute` is total and so unknown routes can be
  /// surfaced as a warning by the observer.
  unknown('__unknown__')
  ;

  const AnalyticsScreen(this.slug);

  /// Canonical slug forwarded to the analytics backend.
  final String slug;

  /// Resolves [routeName] to a known [AnalyticsScreen] entry.
  ///
  /// Returns [AnalyticsScreen.unknown] when [routeName] is null, empty,
  /// or does not match a registered route slug. Matching is **exact**
  /// against [slug] — no substring or prefix match — so attacker-supplied
  /// strings like `/profile/12345678Z` cannot collide with a real entry.
  static AnalyticsScreen fromRoute(final String? routeName) {
    if (routeName == null || routeName.isEmpty) {
      return AnalyticsScreen.unknown;
    }
    for (final screen in AnalyticsScreen.values) {
      if (screen == AnalyticsScreen.unknown) {
        continue;
      }
      if (screen.slug == routeName) {
        return screen;
      }
    }
    return AnalyticsScreen.unknown;
  }
}
