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

// ── Errors ────────────────────────────────────────────────────────────────────

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
