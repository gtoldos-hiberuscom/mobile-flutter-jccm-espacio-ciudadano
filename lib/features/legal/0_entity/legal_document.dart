/// Legal document types available in the application.
///
/// Each variant corresponds to a static page served from bundled content.
/// No Flutter, Riverpod, or infrastructure imports are allowed in this layer.
enum LegalDocumentType {
  termsOfUse,
  privacyPolicy,
  accessibility,
  legalNotice,
}

/// Immutable value object representing a legal / static document.
///
/// Content is plain text or light Markdown that can be rendered with
/// `SelectableText`. The [lastUpdated] field is optional — supply it only
/// when an authoritative revision date is available.
final class LegalDocument {
  const LegalDocument({
    required this.type,
    required this.title,
    required this.content,
    this.lastUpdated,
  });

  /// Which legal document this instance represents.
  final LegalDocumentType type;

  /// Localised display title shown in the AppBar.
  final String title;

  /// Full document text (plain text or light Markdown).
  final String content;

  /// Optional revision date shown at the bottom of the page.
  final DateTime? lastUpdated;

  @override
  String toString() =>
      'LegalDocument(type: $type, title: $title, lastUpdated: $lastUpdated)';
}
