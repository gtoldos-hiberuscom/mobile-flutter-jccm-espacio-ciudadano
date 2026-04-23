/// Typed, PII-free analytics event hierarchy.
///
/// All subclasses must contain only generic type labels — never actual
/// user-identifying content such as names, IDs, document numbers, or
/// health-related identifiers.
///
/// Follows the canon §26 PII rules: RED / AMBER data must not appear in
/// any event payload.
sealed class AnalyticsEvent {
  const AnalyticsEvent();
}

// ── Navigation ────────────────────────────────────────────────────────────────

/// Fired when the user navigates to a named page.
///
/// [pageName] must be the route slug (e.g. `/home`, `/profile`), not a
/// user-facing label or any value derived from user content.
/// [parameters] must contain only structural metadata (e.g. query keys),
/// never values that could carry PII.
class PageViewEvent extends AnalyticsEvent {
  const PageViewEvent(this.pageName, {this.parameters});

  /// Route slug or screen identifier — never user content.
  final String pageName;

  /// Optional structural parameters (key names only, no PII values).
  final Map<String, String>? parameters;
}

// ── Actions ───────────────────────────────────────────────────────────────────

/// Fired when the user downloads a document.
///
/// [documentType] is a generic category label such as `'certificado'` or
/// `'notificacion'` — never the actual file name or document content.
class DownloadEvent extends AnalyticsEvent {
  const DownloadEvent(this.documentType, {this.mimeType});

  /// Generic category label for the downloaded item (e.g. `'certificado'`).
  final String documentType;

  /// Optional MIME type of the downloaded file (e.g. `'application/pdf'`).
  final String? mimeType;
}

/// Fired when the user taps a block on the authenticated home dashboard.
///
/// [blockId] is the stable string id of the block (e.g. `'education'`,
/// `'notifications'`) — never a localised label or any value derived from
/// user content.
class HomeBlockNavigateEvent extends AnalyticsEvent {
  const HomeBlockNavigateEvent(this.blockId, {this.target});

  /// Stable identifier of the block that was tapped.
  final String blockId;

  /// Optional target route slug (e.g. `'/education'`).
  final String? target;
}

/// Fired when the user follows an external link.
///
/// Only the [domain] is recorded — the full URL is never stored because
/// query parameters may carry session tokens or user identifiers.
class ExternalLinkEvent extends AnalyticsEvent {
  const ExternalLinkEvent(this.domain);

  /// Registered domain of the external destination (e.g. `'sede.jccm.es'`).
  final String domain;
}

/// Fired when the application attempts to open an external link from the
/// outbound-navigation infrastructure (STORY-28).
///
/// [linkId] is the stable, locale-independent identifier of the link in
/// the [ExternalLinkCatalog] (e.g. `'educamos_clm'`) — never the
/// localised label, never the full URL.
/// [success] is `true` when the platform accepted the launch and `false`
/// when the launcher returned a failure (validation rejected, platform
/// rejected, or unknown error).
class ExternalLinkOpenedEvent extends AnalyticsEvent {
  const ExternalLinkOpenedEvent({
    required this.linkId,
    required this.success,
  });

  /// Stable identifier of the catalog entry.
  final String linkId;

  /// Whether the platform accepted the launch.
  final bool success;
}

/// Fired when an external-link launch attempt fails.
///
/// Carries the same [linkId] as [ExternalLinkOpenedEvent] plus a
/// coarse-grained [reason] code. The reason is intentionally a short
/// stable label (e.g. `'invalidScheme'`, `'hostMismatch'`) — never the
/// underlying error message — to guarantee no PII or session token can
/// leak through analytics (canon §26).
class ExternalLinkOpenFailedEvent extends AnalyticsEvent {
  const ExternalLinkOpenFailedEvent({
    required this.linkId,
    required this.reason,
  });

  /// Stable identifier of the catalog entry.
  final String linkId;

  /// Coarse-grained failure reason as a short stable label.
  final String reason;
}

// ── Errors ────────────────────────────────────────────────────────────────────

/// Fired the first time a thematic dashboard landing
/// (STORY-23/24/25/26) is opened by the user during a session.
///
/// [domain] is the stable, locale-independent identifier of the landing
/// (e.g. `'state_affairs'`, `'education'`, `'employment'`,
/// `'social_welfare'`) — never a localized title or any value derived
/// from user content.
class DomainLandingViewedEvent extends AnalyticsEvent {
  const DomainLandingViewedEvent({required this.domain});

  /// Stable identifier of the landing.
  final String domain;
}

/// Fired when the user changes the agenda temporal filter (STORY-29).
///
/// [periodId] is the stable enum name of the [AgendaPeriodFilter]
/// (e.g. `'all'`, `'next7Days'`) — never a localised label.
class AgendaPeriodChangedEvent extends AnalyticsEvent {
  const AgendaPeriodChangedEvent({required this.periodId});

  /// Stable identifier of the selected period filter.
  final String periodId;
}

/// Fired when the user opens the detail view of an agenda event (STORY-29).
///
/// [eventId] is the stable identifier from the agenda repository — must
/// not embed PII. [category] is the stable enum name of the
/// `AgendaCategory` (e.g. `'salud'`, `'administrativo'`).
class AgendaEventOpenedEvent extends AnalyticsEvent {
  const AgendaEventOpenedEvent({
    required this.eventId,
    required this.category,
  });

  /// Stable identifier of the opened event.
  final String eventId;

  /// Stable enum name of the event category.
  final String category;
}

/// Fired when a user-visible or operationally relevant error occurs.
///
/// [errorType] is the runtime type name of the `AppError` subclass —
/// never the error message, which may contain user data.
class AppErrorEvent extends AnalyticsEvent {
  const AppErrorEvent(this.errorType, {this.context});

  /// Runtime type name of the `AppError` (e.g. `'NetworkFailure'`).
  final String errorType;

  /// Optional screen or feature slug where the error occurred.
  final String? context;
}
