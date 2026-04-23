import 'package:meta/meta.dart';

/// Immutable value object describing a help guide (article or external
/// resource) listed on the help center page.
///
/// Pure Dart — no Flutter or infrastructure imports (canon §11).
@immutable
final class HelpGuide {
  const HelpGuide({
    required this.id,
    required this.titleKey,
    required this.bodyKey,
    this.externalLinkId,
  });

  /// Stable identifier (snake_case).
  final String id;

  /// ARB key for the guide title.
  final String titleKey;

  /// ARB key for the guide body / summary.
  final String bodyKey;

  /// Optional reference to a catalog `ExternalLink.id`. When non-null,
  /// the presentation layer renders an external-link affordance that
  /// resolves the link via the catalog provider.
  final String? externalLinkId;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is HelpGuide &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          titleKey == other.titleKey &&
          bodyKey == other.bodyKey &&
          externalLinkId == other.externalLinkId;

  @override
  int get hashCode => Object.hash(id, titleKey, bodyKey, externalLinkId);

  @override
  String toString() => 'HelpGuide(id: $id)';
}
