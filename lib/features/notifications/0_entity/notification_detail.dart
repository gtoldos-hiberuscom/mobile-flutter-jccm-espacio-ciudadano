import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';

/// Full notification detail value object (STORY-43).
///
/// Pure Dart — no Flutter / Dio / Riverpod (canon §11). Extends the
/// summary item surface (see `NotificationItem`) with the long body,
/// expediente metadata and the decision deadline used by the pending
/// decision flow.
final class NotificationDetail {
  const NotificationDetail({
    required this.id,
    required this.asunto,
    required this.organismoEmisor,
    required this.fechaEmision,
    required this.status,
    required this.descripcion,
    this.expedienteRef,
    this.procedimiento,
    this.decisionDeadline,
  });

  final String id;
  final String asunto;
  final String organismoEmisor;
  final DateTime fechaEmision;
  final NotificationStatus status;

  /// Long-form description / body of the notification.
  final String descripcion;

  /// Optional administrative expediente reference (e.g. `EXP-2025-00451`).
  final String? expedienteRef;

  /// Optional name of the procedure that issued the notification.
  final String? procedimiento;

  /// Optional deadline by which the citizen must accept or reject the
  /// notification. After this date the backend is expected to flip the
  /// status to [NotificationStatus.caducada].
  final DateTime? decisionDeadline;

  /// Returns a copy with [status] replaced. Used by the notifier after
  /// a successful decision so the header chip reflects the new state
  /// before navigating back.
  NotificationDetail copyWithStatus(final NotificationStatus newStatus) => NotificationDetail(
    id: id,
    asunto: asunto,
    organismoEmisor: organismoEmisor,
    fechaEmision: fechaEmision,
    status: newStatus,
    descripcion: descripcion,
    expedienteRef: expedienteRef,
    procedimiento: procedimiento,
    decisionDeadline: decisionDeadline,
  );
}
