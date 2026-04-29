import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/paginated_list_view.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_item.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notifications_center_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/widgets/notification_filter_bar.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/widgets/notification_item_tile.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/2_presentation/widgets/notification_contact_gate_banner.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Citizen notifications inbox (STORY-41).
///
/// Phase-1 mechanism is **manual consultation**: the citizen pulls to
/// refresh or scrolls to load more. The UI is structured so the future
/// push evolution can plug into the same notifier without redesign —
/// incoming push events would call `refresh()` or insert items at the
/// head of `state.items`.
class NotificationsCenterPage extends ConsumerWidget {
  const NotificationsCenterPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(notificationsCenterProvider);
    final notifier = ref.read(notificationsCenterProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsCenterTitle)),
      body: asyncState.when(
        loading: () => LoadingStateWidget(message: l10n.notificationsLoading),
        error: (final error, final stack) => ErrorStateWidget(
          message: l10n.notificationsErrorMessage,
          onRetry: notifier.refresh,
        ),
        data: (final state) => Column(
          children: <Widget>[
            const NotificationContactGateBanner(),
            NotificationFilterBar(
              activeFilters: state.filters,
              onChanged: notifier.setFilters,
            ),
            Expanded(
              child: PaginatedListView<NotificationItem>(
                items: state.items,
                hasMore: state.hasMore,
                isLoadingMore: state.isLoadingMore,
                onLoadMore: notifier.loadMore,
                onRefresh: notifier.refresh,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.space8,
                ),
                emptyState: EmptyStateWidget(
                  message: l10n.notificationsEmptyTitle,
                  subtitle: l10n.notificationsEmptySubtitle,
                ),
                itemBuilder: (final ctx, final item, final _) => NotificationItemTile(
                  item: item,
                  onTap: () => _openDetail(ctx, item),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space8,
                ),
                child: Text(
                  l10n.notificationsLoadMoreError,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space8,
              ),
              child: Text(
                l10n.notificationsPaginationFooter(
                  state.items.length,
                  state.totalItems,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(final BuildContext context, final NotificationItem item) {
    final path = Routes.notificationDetail.replaceAll(':id', item.id);
    context.go(path);
  }
}
