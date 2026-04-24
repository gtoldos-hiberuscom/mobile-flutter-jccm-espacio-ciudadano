import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';

/// Single notification card shown in the citizen inbox (STORY-41).
///
/// Pure value type — no Flutter / Dio / Riverpod (canon §11).
final class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.asunto,
    required this.organismoEmisor,
    required this.fechaEmision,
    required this.status,
    required this.hasDocuments,
    this.fechaCaducidad,
  });

  final String id;
  final String asunto;
  final String organismoEmisor;
  final DateTime fechaEmision;
  final DateTime? fechaCaducidad;
  final NotificationStatus status;
  final bool hasDocuments;
}
