import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_detail.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notification_detail_repository.dart';

/// Mock implementation of [NotificationDetailRepository] for STORY-43.
///
/// Returns deterministic data so widget / notifier tests can exercise
/// the pending decision flow without monkey-patching anything. A real
/// Dio-backed adapter against `/notifications/*` is deferred — see
/// `documentation/discovery/TASK-47-notifications-contract-strategy.md`.
// TODO(future-sprint): replace mock with Dio-backed datasource bound
// to the confirmed contract once TASK-47 is finalised.
final class NotificationDetailRepositoryImpl implements NotificationDetailRepository {
  NotificationDetailRepositoryImpl({
    this.simulatedNetworkDelay = const Duration(milliseconds: 200),
    this.conflictOnDecision = false,
    this.conflictCurrentStatus = NotificationStatus.aceptada,
    this.failOnLoad = false,
  });

  /// Simulates a tiny network round-trip for [submitDecision]. Tests
  /// can lower it to [Duration.zero] to keep widget pumps cheap.
  final Duration simulatedNetworkDelay;

  /// When `true`, [submitDecision] throws [NotificationDecisionConflict]
  /// instead of returning an outcome. Used by widget tests to exercise
  /// the conflict snackbar surface.
  final bool conflictOnDecision;
  final NotificationStatus conflictCurrentStatus;

  /// When `true`, [loadDetail] throws so the page can render its error
  /// state.
  final bool failOnLoad;

  @override
  Future<NotificationDetail> loadDetail(final String id) async {
    if (failOnLoad) {
      throw StateError('mock: forced loadDetail failure for $id');
    }
    final reference = DateTime(2026, 5, 4, 10);
    return NotificationDetail(
      id: id,
      asunto: 'Notificación administrativa $id',
      organismoEmisor: 'Consejería de Educación',
      fechaEmision: reference,
      status: NotificationStatus.pendiente,
      descripcion: _dummyDescription,
      expedienteRef: 'EXP-2025-00451',
      procedimiento: 'Subvenciones — convocatoria 2025',
      decisionDeadline: reference.add(const Duration(days: 14)),
    );
  }

  @override
  Future<NotificationDecisionOutcome> submitDecision({
    required final String notificationId,
    required final NotificationDecisionAction action,
  }) async {
    if (simulatedNetworkDelay > Duration.zero) {
      await Future<void>.delayed(simulatedNetworkDelay);
    }
    if (conflictOnDecision) {
      throw NotificationDecisionConflict(
        currentStatus: conflictCurrentStatus,
        message: 'mock: notification $notificationId already decided',
      );
    }
    final resultStatus = switch (action) {
      NotificationDecisionAction.accept => NotificationStatus.aceptada,
      NotificationDecisionAction.reject => NotificationStatus.rechazada,
    };
    return NotificationDecisionOutcome(
      resultStatus: resultStatus,
      message: 'mock: decision applied to $notificationId',
    );
  }

  // Roughly ~600 chars of dummy lorem-style copy in Spanish, deterministic.
  static const String _dummyDescription =
      'Le comunicamos que se ha emitido una notificación administrativa relativa al expediente '
      'identificado en esta misma pantalla. Dispone de un plazo legal para aceptar o rechazar la '
      'notificación a través de los canales electrónicos habilitados. Si acepta la notificación '
      'podrá consultar el contenido íntegro y los documentos anexos asociados al expediente. Si '
      'la rechaza, la administración tendrá constancia formal de su rechazo y se considerará '
      'efectuada la práctica de la notificación a todos los efectos legales. Esta acción es '
      'irreversible. Para cualquier duda puede contactar con el organismo emisor a través de los '
      'canales habituales de atención al ciudadano.';
}
