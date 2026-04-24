import 'package:meta/meta.dart';

/// A node in the application sitemap tree (canon §11, pure Dart).
///
/// A node represents one of:
///  - an internal route ([route] non-null),
///  - an external destination ([externalLinkId] referring to the
///    `ExternalLinkCatalog`),
///  - or a pure grouping container with [children] only.
///
/// [titleKey] is always an ARB key — entities never carry localised text.
@immutable
final class SitemapNode {
  const SitemapNode({
    required this.id,
    required this.titleKey,
    this.route,
    this.externalLinkId,
    this.children = const <SitemapNode>[],
  }) : assert(
         !(route != null && externalLinkId != null),
         'A node cannot point to both an internal route and an external link.',
       );

  /// Stable identifier — used by tests, analytics and tree diffs.
  final String id;

  /// ARB key for the displayed label.
  final String titleKey;

  /// Internal `Routes.*` value when the node opens an in-app screen.
  final String? route;

  /// `ExternalLink.id` from the catalog when the node opens an external
  /// destination through the hardened launcher.
  final String? externalLinkId;

  /// Child nodes (depth ≥ 1). Defaults to an empty list for leaves.
  final List<SitemapNode> children;

  bool get isLeaf => children.isEmpty;
  bool get isExternal => externalLinkId != null;
  bool get isInternal => route != null;

  @override
  String toString() => 'SitemapNode(id: $id, route: $route, ext: $externalLinkId, children: ${children.length})';
}
