import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/1_domain/notification_contact_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/3_data/notification_contact_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/3_data/notification_contact_repository_provider.dart';

void main() {
  ProviderContainer makeContainer({final NotificationContact? seed}) => ProviderContainer(
    overrides: [
      notificationContactRepositoryProvider.overrideWith(
        (final ref) => NotificationContactRepositoryImpl(seed: seed),
      ),
    ],
  );

  group('NotificationContactNotifier', () {
    test('initial build returns null when nothing is registered yet', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = await container.read(
        notificationContactProvider.future,
      );
      expect(state, isNull);
    });

    test('initial build returns the seeded contact', () async {
      final container = makeContainer(
        seed: const NotificationContact(email: 'seed@example.com'),
      );
      addTearDown(container.dispose);

      final state = await container.read(
        notificationContactProvider.future,
      );
      expect(state, isNotNull);
      expect(state!.email, 'seed@example.com');
    });

    test('register persists the new contact and reloads the state', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final sub = container.listen(
        notificationContactProvider,
        (final _, final next) {},
      );
      addTearDown(sub.close);
      await container.read(notificationContactProvider.future);
      await container.read(notificationContactProvider.notifier).register(phone: '600123456', email: 'user@example.com');

      final state = container.read(notificationContactProvider).requireValue;
      expect(state, isNotNull);
      expect(state!.phoneE164, '600123456');
      expect(state.email, 'user@example.com');
    });

    test('register throws NotificationContactValidationException when both empty', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final sub = container.listen(
        notificationContactProvider,
        (final _, final next) {},
      );
      addTearDown(sub.close);
      await container.read(notificationContactProvider.future);

      await expectLater(
        () => container.read(notificationContactProvider.notifier).register(),
        throwsA(isA<NotificationContactValidationException>()),
      );

      // State remains the previous value (null) — the failure does not
      // blank the screen.
      final state = container.read(notificationContactProvider);
      expect(state.requireValue, isNull);
    });
  });
}
