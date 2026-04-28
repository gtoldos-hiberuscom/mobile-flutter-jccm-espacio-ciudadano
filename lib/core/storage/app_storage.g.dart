// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider that exposes a singleton [AppStorage] instance.
///
/// Kept alive for the lifetime of the app.
/// The underlying SharedPreferences instance must be obtained
/// asynchronously; this provider must be overridden at bootstrap.

@ProviderFor(appStorage)
const appStorageProvider = AppStorageProvider._();

/// Riverpod provider that exposes a singleton [AppStorage] instance.
///
/// Kept alive for the lifetime of the app.
/// The underlying SharedPreferences instance must be obtained
/// asynchronously; this provider must be overridden at bootstrap.

final class AppStorageProvider
    extends $FunctionalProvider<AppStorage, AppStorage, AppStorage>
    with $Provider<AppStorage> {
  /// Riverpod provider that exposes a singleton [AppStorage] instance.
  ///
  /// Kept alive for the lifetime of the app.
  /// The underlying SharedPreferences instance must be obtained
  /// asynchronously; this provider must be overridden at bootstrap.
  const AppStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStorageHash();

  @$internal
  @override
  $ProviderElement<AppStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppStorage create(Ref ref) {
    return appStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppStorage>(value),
    );
  }
}

String _$appStorageHash() => r'138d4de68c7fe506017549e65925d353f07ca3f6';
