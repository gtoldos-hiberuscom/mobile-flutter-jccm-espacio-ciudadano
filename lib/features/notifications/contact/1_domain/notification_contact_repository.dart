import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact.dart';

/// Repository abstraction for citizen contact data used by the
/// electronic-notifications platform (STORY-42).
///
/// Implementations live under `3_data/`. The domain layer must depend
/// only on this abstraction (canon §12). Real backend wiring is
/// deferred — see
/// `documentation/discovery/TASK-47-notifications-contract-strategy.md`.
abstract interface class NotificationContactRepository {
  /// Returns the currently registered contact, or `null` when none
  /// exists yet (initial onboarding state).
  Future<NotificationContact?> loadCurrent();

  /// Persists [contact] as the new citizen contact.
  Future<void> register(final NotificationContact contact);
}
