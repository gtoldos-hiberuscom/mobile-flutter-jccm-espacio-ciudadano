import 'package:jccm_espacio_ciudadano/features/sitemap/0_entity/sitemap_node.dart';

/// Domain contract for retrieving the application sitemap tree.
///
/// Synchronous: the tree is derived from local route registries and
/// (for external nodes) from the `ExternalLinkCatalog` allow-list, so
/// no network call is involved (canon §13).
abstract interface class SitemapRepository {
  /// Returns the navigation tree as a list of top-level nodes.
  List<SitemapNode> loadTree();
}
