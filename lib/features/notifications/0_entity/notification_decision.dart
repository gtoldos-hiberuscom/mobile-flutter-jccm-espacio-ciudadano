import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';

/// Action issued by the citizen on a pending notification (STORY-43).
///
/// Pure Dart — no Flutter / Dio / Riverpod (canon §11).
enum NotificationDecisionAction {
  accept,
  reject,
}

/// Outcome of submitting a [NotificationDecisionAction] against the
/// backend / mock for a notification (STORY-43).
final class NotificationDecisionOutcome {
  const NotificationDecisionOutcome({
    required this.resultStatus,
    this.message,
  });

  /// Resulting lifecycle status reported by the backend after the
  /// decision was applied (typically [NotificationStatus.aceptada] or
  /// [NotificationStatus.rechazada]).
  final NotificationStatus resultStatus;

  /// Optional human-readable message returned by the backend. The
  /// presentation layer is responsible for displaying / localising it.
  final String? message;
}

/// Domain-level error raised when the requested decision cannot be
/// applied because the notification is already decided or its decision
/// window expired.
final class NotificationDecisionConflict implements Exception {
  const NotificationDecisionConflict({
    required this.currentStatus,
    this.message,
  });

  /// Status the backend reports for the notification at the time of
  /// the conflict. The presentation layer can use it to refresh the
  /// header chip without performing a second round-trip.
  final NotificationStatus currentStatus;
  final String? message;

  @override
  String toString() => 'NotificationDecisionConflict(currentStatus: $currentStatus, message: $message)';
}
