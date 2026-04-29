import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_item.dart';

/// Page-level response for the notifications listing (STORY-41).
final class NotificationPageResult {
  const NotificationPageResult({
    required this.items,
    required this.totalItems,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  final List<NotificationItem> items;
  final int totalItems;
  final int page;
  final int pageSize;
  final bool hasMore;
}
