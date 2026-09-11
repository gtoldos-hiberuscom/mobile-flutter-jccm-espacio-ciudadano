import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/providers/notification_contact_providers.dart';

/// Locks the contract that a load failure becomes [AsyncError] — never a null
/// contact. A null used to render a blank editable form whose save wiped the
/// registered e-notification contact.
void main() {
  ProviderContainer buildContainer(final NotificationContactRepository repository) {
    final container = ProviderContainer(
      overrides: [
        notificationContactRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('a load failure surfaces as AsyncError, not as a null contact', () async {
    final container = buildContainer(_FakeNotificationContactRepository(error: Exception('backend down')));

    await expectLater(
      container.read(notificationContactProvider('PER1').future),
      throwsA(isA<StateError>()),
    );
  });

  test('a loaded contact is exposed as data', () async {
    final container = buildContainer(
      _FakeNotificationContactRepository(contact: const NotificationContact(phone: '600000000', email: 'a@b.es')),
    );

    final contact = await container.read(notificationContactProvider('PER1').future);

    expect(contact?.phone, '600000000');
    expect(contact?.email, 'a@b.es');
  });

  test('a genuine missing contact stays null', () async {
    final container = buildContainer(_FakeNotificationContactRepository());

    expect(await container.read(notificationContactProvider('PER1').future), isNull);
  });
}

final class _FakeNotificationContactRepository implements NotificationContactRepository {
  _FakeNotificationContactRepository({this.contact, this.error});

  final NotificationContact? contact;
  final Exception? error;

  @override
  Future<NotificationContact?> loadContact({required final String citizenId}) async {
    final pendingError = error;
    if (pendingError != null) {
      throw pendingError;
    }
    return contact;
  }

  @override
  Future<NotificationContact> saveContact({
    required final String citizenId,
    required final String dni,
    required final NotificationContact contact,
  }) => throw UnimplementedError();
}
