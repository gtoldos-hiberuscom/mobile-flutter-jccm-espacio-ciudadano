import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';

/// Page-level query for the notifications listing (STORY-41).
///
/// Pure value type. An empty [statusFilter] means "all statuses" — the
/// repository must not interpret it as "no results".
final class NotificationPageRequest {
  const NotificationPageRequest({
    required this.page,
    required this.pageSize,
    this.statusFilter = const <NotificationStatus>{},
  });

  final int page;
  final int pageSize;
  final Set<NotificationStatus> statusFilter;
}
