import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notification_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notification_detail_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notification_detail_repository_provider.dart';

void main() {
  group('NotificationDetailNotifier', () {
    ProviderContainer makeContainer({
      final bool conflictOnDecision = false,
      final NotificationStatus conflictCurrentStatus = NotificationStatus.aceptada,
    }) => ProviderContainer(
      overrides: [
        notificationDetailRepositoryProvider.overrideWith(
          (final ref) => NotificationDetailRepositoryImpl(
            simulatedNetworkDelay: Duration.zero,
            conflictOnDecision: conflictOnDecision,
            conflictCurrentStatus: conflictCurrentStatus,
          ),
        ),
      ],
    );

    test('build() loads the detail in pendiente state', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final detail = await container.read(
        notificationDetailProvider('NOT-0001').future,
      );

      expect(detail.id, 'NOT-0001');
      expect(detail.status, NotificationStatus.pendiente);
    });

    test('submitDecision(accept) updates state to aceptada and returns outcome', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(notificationDetailProvider('NOT-0001').future);

      final outcome = await container
          .read(notificationDetailProvider('NOT-0001').notifier)
          .submitDecision(NotificationDecisionAction.accept);

      expect(outcome.resultStatus, NotificationStatus.aceptada);
      final updated = container
          .read(notificationDetailProvider('NOT-0001'))
          .requireValue;
      expect(updated.status, NotificationStatus.aceptada);
    });

    test('submitDecision(reject) updates state to rechazada', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(notificationDetailProvider('NOT-0001').future);

      final outcome = await container
          .read(notificationDetailProvider('NOT-0001').notifier)
          .submitDecision(NotificationDecisionAction.reject);

      expect(outcome.resultStatus, NotificationStatus.rechazada);
      final updated = container
          .read(notificationDetailProvider('NOT-0001'))
          .requireValue;
      expect(updated.status, NotificationStatus.rechazada);
    });

    test('conflict updates header status with currentStatus and rethrows', () async {
      final container = makeContainer(
        conflictOnDecision: true,
        conflictCurrentStatus: NotificationStatus.caducada,
      );
      addTearDown(container.dispose);
      await container.read(notificationDetailProvider('NOT-0001').future);

      await expectLater(
        () => container
            .read(notificationDetailProvider('NOT-0001').notifier)
            .submitDecision(NotificationDecisionAction.accept),
        throwsA(isA<NotificationDecisionConflict>()),
      );
      final updated = container
          .read(notificationDetailProvider('NOT-0001'))
          .requireValue;
      expect(updated.status, NotificationStatus.caducada);
    });
  });
}
