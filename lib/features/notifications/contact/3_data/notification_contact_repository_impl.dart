import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/1_domain/notification_contact_repository.dart';

/// In-memory mock implementation of [NotificationContactRepository]
/// for STORY-42.
///
/// No backend endpoint exists yet for citizen-contact registration —
/// see `documentation/discovery/TASK-47-notifications-contract-strategy.md`.
/// The mock starts with no registered contact (`null` ⇒ "missing"
/// status in the gate) and stores whatever the citizen submits in a
/// private field with a small simulated network delay so the success
/// transition is observable in the UI.
///
// TODO(future-sprint): replace this mock with a Dio-backed datasource
// once the backend contract for citizen-contact registration is
// confirmed (deferred per TASK-47, controlled by
// `kNotificationContactLiveBackendEnabled`). The real adapter will
// likely live behind a new `ContactoApi` operation and reuse the
// existing Dio composition root.
final class NotificationContactRepositoryImpl implements NotificationContactRepository {
  NotificationContactRepositoryImpl({final NotificationContact? seed}) : _current = seed;

  NotificationContact? _current;

  @override
  Future<NotificationContact?> loadCurrent() async => _current;

  @override
  Future<void> register(final NotificationContact contact) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _current = contact;
  }
}
