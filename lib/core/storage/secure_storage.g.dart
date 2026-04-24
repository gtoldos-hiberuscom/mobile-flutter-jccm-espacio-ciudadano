// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider that exposes a singleton [SecureStorage] instance.
///
/// Kept alive for the lifetime of the app — tokens must always be reachable.

@ProviderFor(secureStorage)
const secureStorageProvider = SecureStorageProvider._();

/// Riverpod provider that exposes a singleton [SecureStorage] instance.
///
/// Kept alive for the lifetime of the app — tokens must always be reachable.

final class SecureStorageProvider
    extends $FunctionalProvider<SecureStorage, SecureStorage, SecureStorage>
    with $Provider<SecureStorage> {
  /// Riverpod provider that exposes a singleton [SecureStorage] instance.
  ///
  /// Kept alive for the lifetime of the app — tokens must always be reachable.
  const SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<SecureStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'1bb7df99099ae4c0df083552ad99ecfb67c95371';
