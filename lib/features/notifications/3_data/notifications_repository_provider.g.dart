// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI composition for [NotificationsRepository].
///
/// Kept alive so the catalog is built once per session — the mock
/// implementation is stateless but the real Dio adapter (deferred)
/// will benefit from this lifetime when wired against
/// `ServicioApi.miDetalleOperation`.

@ProviderFor(notificationsRepository)
const notificationsRepositoryProvider = NotificationsRepositoryProvider._();

/// DI composition for [NotificationsRepository].
///
/// Kept alive so the catalog is built once per session — the mock
/// implementation is stateless but the real Dio adapter (deferred)
/// will benefit from this lifetime when wired against
/// `ServicioApi.miDetalleOperation`.

final class NotificationsRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationsRepository,
          NotificationsRepository,
          NotificationsRepository
        >
    with $Provider<NotificationsRepository> {
  /// DI composition for [NotificationsRepository].
  ///
  /// Kept alive so the catalog is built once per session — the mock
  /// implementation is stateless but the real Dio adapter (deferred)
  /// will benefit from this lifetime when wired against
  /// `ServicioApi.miDetalleOperation`.
  const NotificationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationsRepository create(Ref ref) {
    return notificationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsRepository>(value),
    );
  }
}

String _$notificationsRepositoryHash() =>
    r'887bacc45e6cdc617d5a31c1bac7bcb4ad4622d9';
