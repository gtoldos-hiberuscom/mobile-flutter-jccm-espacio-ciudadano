import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';

/// Full notification detail value object (STORY-43, extended in STORY-44).
///
/// Pure Dart — no Flutter / Dio / Riverpod (canon §11). Extends the
/// summary item surface (see `NotificationItem`) with the long body,
/// expediente metadata, the decision deadline used by the pending
/// decision flow and — STORY-44 — the list of associated documents
/// plus the moment the citizen marked the notification as read.
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
    this.documents = const <NotificationDocument>[],
    this.readAt,
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

  /// Documents attached to the notification (STORY-44). Empty by
  /// default for the pending flow / when the backend reports none.
  final List<NotificationDocument> documents;

  /// Moment the citizen marked the notification as read (STORY-44).
  /// `null` for the pending flow / when the backend has not flipped
  /// the read flag yet.
  final DateTime? readAt;

  /// Returns a copy with [status] replaced. Used by the notifier after
  /// a successful decision so the header chip reflects the new state
  /// before navigating back. Preserves [documents] and [readAt].
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
    documents: documents,
    readAt: readAt,
  );
}
