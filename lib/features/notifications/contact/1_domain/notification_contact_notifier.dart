import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/1_domain/notification_contact_validator.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/3_data/notification_contact_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_contact_notifier.g.dart';

/// Owns the notification-contact registration screen state (STORY-42).
///
/// `build()` resolves the current contact from the repository (the
/// initial value is `null` for a citizen who has not yet onboarded).
/// `register()` runs domain validation; on success it persists the new
/// contact via the repository and reloads the state, so the UI can
/// transition to the success branch.
///
/// Backend wiring is deferred — see
/// `documentation/discovery/TASK-47-notifications-contract-strategy.md`
/// and `kNotificationContactLiveBackendEnabled`.
@riverpod
class NotificationContactNotifier extends _$NotificationContactNotifier {
  @override
  Future<NotificationContact?> build() {
    final repo = ref.watch(notificationContactRepositoryProvider);
    return repo.loadCurrent();
  }

  /// Validates the input pair, persists the new contact and reloads
  /// the state.
  ///
  /// Throws [NotificationContactValidationException] when the input is
  /// rejected by the domain validator. The presentation layer catches
  /// this and surfaces a localised SnackBar without flipping the state
  /// into an error branch — registration failures must not blank the
  /// screen.
  Future<void> register({final String? phone, final String? email}) async {
    final failure = NotificationContactValidator.validateContact(
      phone: phone,
      email: email,
    );
    if (failure != null) {
      throw NotificationContactValidationException(failure);
    }
    final repo = ref.read(notificationContactRepositoryProvider);
    final phoneTrimmed = (phone ?? '').trim();
    final emailTrimmed = (email ?? '').trim();
    final contact = NotificationContact(
      phoneE164: phoneTrimmed.isEmpty ? null : phoneTrimmed,
      email: emailTrimmed.isEmpty ? null : emailTrimmed,
    );
    state = const AsyncValue<NotificationContact?>.loading();
    state = await AsyncValue.guard<NotificationContact?>(() async {
      await repo.register(contact);
      return repo.loadCurrent();
    });
  }
}

/// Thrown by [NotificationContactNotifier.register] when the supplied
/// values fail domain validation. The carried [failure] drives the
/// localised SnackBar shown by the presentation layer.
final class NotificationContactValidationException implements Exception {
  const NotificationContactValidationException(this.failure);

  final NotificationContactValidationFailure failure;

  @override
  String toString() => 'NotificationContactValidationException(${failure.name})';
}
