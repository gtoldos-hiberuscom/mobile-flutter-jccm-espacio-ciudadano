import 'package:meta/meta.dart';

/// Stable identifier for one of the bundled legal documents.
///
/// Pure Dart enum (canon §11). The presentation layer maps each id to the
/// corresponding route; the data layer maps it to the bundled body.
enum LegalDocumentId { terms, privacy, accessibility, legalNotice }

/// Immutable value object for a bundled legal/static document.
///
/// - [id] / [titleKey] are locale-safe; the title is rendered via ARB.
/// - [bodyMarkdown] holds the document body as plain text with a tiny
///   subset of conventions:
///     * paragraphs are separated by blank lines (`\n\n`),
///     * lines starting with `- ` are bullet items.
///   The presentation layer renders these into typography without any
///   third-party Markdown dependency.
@immutable
final class LegalDocument {
  const LegalDocument({
    required this.id,
    required this.titleKey,
    required this.bodyMarkdown,
  });

  final LegalDocumentId id;
  final String titleKey;
  final String bodyMarkdown;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is LegalDocument &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          titleKey == other.titleKey &&
          bodyMarkdown == other.bodyMarkdown;

  @override
  int get hashCode => Object.hash(id, titleKey, bodyMarkdown);

  @override
  String toString() => 'LegalDocument(id: $id)';
}
