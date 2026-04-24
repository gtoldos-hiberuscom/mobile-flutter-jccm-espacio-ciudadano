import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_page_request.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_page_result.dart';

/// Repository abstraction for the notifications inbox (STORY-41).
///
/// Implementations live under `3_data/`. The domain layer must depend
/// only on this abstraction (canon §12).
abstract interface class NotificationsRepository {
  /// Fetches a single page of notifications matching [request].
  Future<NotificationPageResult> fetchPage(final NotificationPageRequest request);
}
