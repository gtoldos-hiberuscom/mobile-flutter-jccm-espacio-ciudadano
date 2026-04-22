/// A single navigable entry in the application sitemap.
class SitemapEntry {
  const SitemapEntry({
    required this.label,
    required this.route,
    this.isExternal = false,
    this.children = const [],
  });

  /// Display label for the entry.
  final String label;

  /// GoRouter internal path (e.g. `/home`) or full URL for external links.
  final String route;

  /// Whether [route] points to an external URL that should be opened in a browser.
  final bool isExternal;

  /// Optional sub-entries rendered as an indented subsection.
  final List<SitemapEntry> children;
}
