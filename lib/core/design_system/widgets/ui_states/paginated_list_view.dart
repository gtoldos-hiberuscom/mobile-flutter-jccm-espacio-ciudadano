import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A generic paginated list with optional pull-to-refresh and a load-more footer.
///
/// Type parameter [T] is the list item type.
class PaginatedListView<T> extends StatelessWidget {
  const PaginatedListView({
    required this.items,
    required this.itemBuilder,
    required this.hasMore,
    required this.onLoadMore,
    super.key,
    this.isLoadingMore = false,
    this.onRefresh,
    this.emptyState,
    this.padding,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Whether more pages are available.
  final bool hasMore;

  /// Called when the user scrolls to the bottom and [hasMore] is true.
  final VoidCallback onLoadMore;

  /// When true a small progress indicator is shown at the bottom.
  final bool isLoadingMore;

  /// If provided, wraps the list in a [RefreshIndicator].
  final Future<void> Function()? onRefresh;

  /// Widget shown when [items] is empty.
  final Widget? emptyState;

  final EdgeInsets? padding;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (items.isEmpty && emptyState != null) {
      return emptyState!;
    }

    // Extra item count: 1 footer when hasMore or isLoadingMore.
    final footerCount = (hasMore || isLoadingMore) ? 1 : 0;
    final itemCount = items.length + footerCount;

    Widget listView = ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (final context, final index) {
        if (index < items.length) {
          return itemBuilder(context, items[index], index);
        }
        // Footer
        if (isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return Semantics(
          button: true,
          label: l10n.loadMoreItems,
          child: GestureDetector(
            onTap: onLoadMore,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
        );
      },
    );

    if (onRefresh != null) {
      listView = Semantics(
        label: l10n.pullToRefresh,
        child: RefreshIndicator.adaptive(
          onRefresh: onRefresh!,
          child: listView,
        ),
      );
    }

    return listView;
  }
}
