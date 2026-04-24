import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_item.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_page_request.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notifications_center_state.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notifications_repository.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notifications_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_center_notifier.g.dart';

/// Owns the notifications center screen state (STORY-41).
///
/// On `build()` it requests page 0 with no status filter (all statuses).
/// `setFilters` resets paging to the first page; `loadMore` appends the
/// next page; `refresh` reloads the first page preserving the active
/// filter set. Errors do not blank the previously loaded items — they
/// surface through `hasError` so the user can keep browsing what is
/// already on screen and retry the failing page.
@riverpod
class NotificationsCenterNotifier extends _$NotificationsCenterNotifier {
  static const int _defaultPageSize = 6;

  @override
  Future<NotificationsCenterState> build() async {
    final repo = ref.watch(notificationsRepositoryProvider);
    return _loadFirstPage(
      repo,
      filters: const <NotificationStatus>{},
    );
  }

  /// Replaces the active status filter set and reloads from page 0.
  Future<void> setFilters(final Set<NotificationStatus> filters) async {
    state = const AsyncValue<NotificationsCenterState>.loading();
    state = await AsyncValue.guard<NotificationsCenterState>(
      () => _loadFirstPage(
        ref.read(notificationsRepositoryProvider),
        filters: filters,
      ),
    );
  }

  /// Reloads the first page preserving the current filter set.
  Future<void> refresh() async {
    final current = state.value;
    final filters = current?.filters ?? const <NotificationStatus>{};
    state = const AsyncValue<NotificationsCenterState>.loading();
    state = await AsyncValue.guard<NotificationsCenterState>(
      () => _loadFirstPage(
        ref.read(notificationsRepositoryProvider),
        filters: filters,
      ),
    );
  }

  /// Loads the next page and appends its items. No-ops when there is
  /// no current state, no more pages, or another load is in flight.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) {
      return;
    }
    state = AsyncValue<NotificationsCenterState>.data(
      current.copyWith(isLoadingMore: true, hasError: false),
    );
    try {
      final repo = ref.read(notificationsRepositoryProvider);
      final nextPage = current.currentPage + 1;
      final result = await repo.fetchPage(
        NotificationPageRequest(
          page: nextPage,
          pageSize: current.pageSize,
          statusFilter: current.filters,
        ),
      );
      final latest = state.value ?? current;
      state = AsyncValue<NotificationsCenterState>.data(
        latest.copyWith(
          items: List<NotificationItem>.unmodifiable(<NotificationItem>[
            ...latest.items,
            ...result.items,
          ]),
          currentPage: result.page,
          totalItems: result.totalItems,
          hasMore: result.hasMore,
          isLoadingMore: false,
          hasError: false,
        ),
      );
    } on Object {
      final latest = state.value ?? current;
      state = AsyncValue<NotificationsCenterState>.data(
        latest.copyWith(isLoadingMore: false, hasError: true),
      );
    }
  }

  Future<NotificationsCenterState> _loadFirstPage(
    final NotificationsRepository repo, {
    required final Set<NotificationStatus> filters,
  }) async {
    final result = await repo.fetchPage(
      NotificationPageRequest(
        page: 0,
        pageSize: _defaultPageSize,
        statusFilter: filters,
      ),
    );
    return NotificationsCenterState(
      items: List<NotificationItem>.unmodifiable(result.items),
      filters: Set<NotificationStatus>.unmodifiable(filters),
      currentPage: result.page,
      pageSize: result.pageSize,
      totalItems: result.totalItems,
      hasMore: result.hasMore,
      isLoadingMore: false,
      hasError: false,
    );
  }
}
