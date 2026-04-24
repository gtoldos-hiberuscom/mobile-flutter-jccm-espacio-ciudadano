import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_item.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';

/// View-model state for the notifications center (STORY-41).
///
/// Pure value type. The notifier accumulates loaded pages into [items];
/// `hasMore` drives the load-more affordance and `isLoadingMore` /
/// `hasError` drive transient UI states without losing the already
/// loaded content.
final class NotificationsCenterState {
  const NotificationsCenterState({
    required this.items,
    required this.filters,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.hasMore,
    required this.isLoadingMore,
    required this.hasError,
  });

  factory NotificationsCenterState.initial({final int pageSize = 6}) =>
      NotificationsCenterState(
        items: const <NotificationItem>[],
        filters: const <NotificationStatus>{},
        currentPage: 0,
        pageSize: pageSize,
        totalItems: 0,
        hasMore: false,
        isLoadingMore: false,
        hasError: false,
      );

  final List<NotificationItem> items;
  final Set<NotificationStatus> filters;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final bool hasMore;
  final bool isLoadingMore;
  final bool hasError;

  bool get isEmpty => items.isEmpty;

  NotificationsCenterState copyWith({
    final List<NotificationItem>? items,
    final Set<NotificationStatus>? filters,
    final int? currentPage,
    final int? pageSize,
    final int? totalItems,
    final bool? hasMore,
    final bool? isLoadingMore,
    final bool? hasError,
  }) => NotificationsCenterState(
    items: items ?? this.items,
    filters: filters ?? this.filters,
    currentPage: currentPage ?? this.currentPage,
    pageSize: pageSize ?? this.pageSize,
    totalItems: totalItems ?? this.totalItems,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    hasError: hasError ?? this.hasError,
  );
}
