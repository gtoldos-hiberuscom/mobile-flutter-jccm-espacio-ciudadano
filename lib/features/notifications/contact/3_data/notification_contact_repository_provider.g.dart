// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_contact_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [NotificationContactRepository] (STORY-42).
///
/// Kept alive so the in-memory mock survives the lifetime of the
/// session. When the real Dio adapter lands, the keepAlive lifetime
/// will mirror the rest of the notifications data layer.

@ProviderFor(notificationContactRepository)
const notificationContactRepositoryProvider = NotificationContactRepositoryProvider._();

/// DI composition for [NotificationContactRepository] (STORY-42).
///
/// Kept alive so the in-memory mock survives the lifetime of the
/// session. When the real Dio adapter lands, the keepAlive lifetime
/// will mirror the rest of the notifications data layer.

final class NotificationContactRepositoryProvider extends $FunctionalProvider<NotificationContactRepository, NotificationContactRepository, NotificationContactRepository> with $Provider<NotificationContactRepository> {
  /// DI composition for [NotificationContactRepository] (STORY-42).
  ///
  /// Kept alive so the in-memory mock survives the lifetime of the
  /// session. When the real Dio adapter lands, the keepAlive lifetime
  /// will mirror the rest of the notifications data layer.
  const NotificationContactRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationContactRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationContactRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationContactRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationContactRepository create(Ref ref) {
    return notificationContactRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationContactRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationContactRepository>(
        value,
      ),
    );
  }
}

String _$notificationContactRepositoryHash() => r'9ee51b1ecb8de37190462f9658e99967873e3833';
