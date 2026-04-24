// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_contact_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(NotificationContactNotifier)
const notificationContactProvider = NotificationContactNotifierProvider._();

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
final class NotificationContactNotifierProvider
    extends
        $AsyncNotifierProvider<
          NotificationContactNotifier,
          NotificationContact?
        > {
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
  const NotificationContactNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationContactProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationContactNotifierHash();

  @$internal
  @override
  NotificationContactNotifier create() => NotificationContactNotifier();
}

String _$notificationContactNotifierHash() =>
    r'46f26e57986400bf78a49fa0291830cdb9a1b9f3';

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

abstract class _$NotificationContactNotifier
    extends $AsyncNotifier<NotificationContact?> {
  FutureOr<NotificationContact?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<NotificationContact?>, NotificationContact?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationContact?>,
                NotificationContact?
              >,
              AsyncValue<NotificationContact?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
