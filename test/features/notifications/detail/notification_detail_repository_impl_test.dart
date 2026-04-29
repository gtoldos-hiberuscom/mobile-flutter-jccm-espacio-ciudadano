import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notification_detail_repository_impl.dart';

void main() {
  group('NotificationDetailRepositoryImpl', () {
    test('loadDetail returns a deterministic pending detail', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final detail = await repo.loadDetail('NOT-0001');

      expect(detail.id, 'NOT-0001');
      expect(detail.status, NotificationStatus.pendiente);
      expect(detail.expedienteRef, 'EXP-2025-00451');
      expect(detail.procedimiento, 'Subvenciones — convocatoria 2025');
      expect(detail.decisionDeadline, isNotNull);
      expect(detail.descripcion.length, greaterThan(400));
      // Deadline = emisión + 14 días.
      expect(
        detail.decisionDeadline!.difference(detail.fechaEmision).inDays,
        14,
      );
    });

    test('submitDecision(accept) returns aceptada outcome', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final outcome = await repo.submitDecision(
        notificationId: 'NOT-0001',
        action: NotificationDecisionAction.accept,
      );

      expect(outcome.resultStatus, NotificationStatus.aceptada);
    });

    test('submitDecision(reject) returns rechazada outcome', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
      );

      final outcome = await repo.submitDecision(
        notificationId: 'NOT-0001',
        action: NotificationDecisionAction.reject,
      );

      expect(outcome.resultStatus, NotificationStatus.rechazada);
    });

    test('conflictOnDecision throws NotificationDecisionConflict', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
        conflictOnDecision: true,
        conflictCurrentStatus: NotificationStatus.caducada,
      );

      await expectLater(
        () => repo.submitDecision(
          notificationId: 'NOT-0001',
          action: NotificationDecisionAction.accept,
        ),
        throwsA(
          isA<NotificationDecisionConflict>().having(
            (final e) => e.currentStatus,
            'currentStatus',
            NotificationStatus.caducada,
          ),
        ),
      );
    });

    test('failOnLoad throws on loadDetail', () async {
      final repo = NotificationDetailRepositoryImpl(
        simulatedNetworkDelay: Duration.zero,
        failOnLoad: true,
      );

      expect(
        () => repo.loadDetail('NOT-0001'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
