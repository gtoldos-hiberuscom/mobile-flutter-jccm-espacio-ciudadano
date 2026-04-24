// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_contact_gate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Aggregates the contact-loading state into a [NotificationContactStatus]
/// usable as a guard surface (STORY-42).
///
/// Future tickets can read this provider to drive missing-contact
/// banners or hard guards before allowing the citizen to operate
/// notifications.

@ProviderFor(notificationContactGate)
const notificationContactGateProvider = NotificationContactGateProvider._();

/// Aggregates the contact-loading state into a [NotificationContactStatus]
/// usable as a guard surface (STORY-42).
///
/// Future tickets can read this provider to drive missing-contact
/// banners or hard guards before allowing the citizen to operate
/// notifications.

final class NotificationContactGateProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationContactStatus>,
          NotificationContactStatus,
          FutureOr<NotificationContactStatus>
        >
    with
        $FutureModifier<NotificationContactStatus>,
        $FutureProvider<NotificationContactStatus> {
  /// Aggregates the contact-loading state into a [NotificationContactStatus]
  /// usable as a guard surface (STORY-42).
  ///
  /// Future tickets can read this provider to drive missing-contact
  /// banners or hard guards before allowing the citizen to operate
  /// notifications.
  const NotificationContactGateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationContactGateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationContactGateHash();

  @$internal
  @override
  $FutureProviderElement<NotificationContactStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotificationContactStatus> create(Ref ref) {
    return notificationContactGate(ref);
  }
}

String _$notificationContactGateHash() =>
    r'46a536094f0b6957883624ef86a73d2e9d21b2cf';
