import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_detail.dart';

/// Repository abstraction for the notification detail surface and the
/// pending decision flow (STORY-43).
///
/// Implementations live under `3_data/`. The domain layer must depend
/// only on this abstraction (canon §12).
abstract interface class NotificationDetailRepository {
  /// Loads the detail for the notification identified by [id].
  Future<NotificationDetail> loadDetail(final String id);

  /// Submits a pending-state [action] (accept/reject) against
  /// [notificationId].
  ///
  /// Throws [NotificationDecisionConflict] when the notification was
  /// already decided or its decision window expired.
  Future<NotificationDecisionOutcome> submitDecision({
    required final String notificationId,
    required final NotificationDecisionAction action,
  });
}
