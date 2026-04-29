// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider that exposes the singleton [Dio] HTTP client.
///
/// The [Dio] instance is kept alive for the lifetime of the app and is
/// configured via [appConfigProvider] and [secureStorageProvider].
///
/// Consumers in the `3_data/` layer inject this provider to perform HTTP
/// requests without depending on Dio construction details.
///
/// ```dart
/// final dio = ref.watch(dioProvider);
/// final response = await dio.get('/citizen/notifications');
/// ```

@ProviderFor(dio)
const dioProvider = DioProvider._();

/// Riverpod provider that exposes the singleton [Dio] HTTP client.
///
/// The [Dio] instance is kept alive for the lifetime of the app and is
/// configured via [appConfigProvider] and [secureStorageProvider].
///
/// Consumers in the `3_data/` layer inject this provider to perform HTTP
/// requests without depending on Dio construction details.
///
/// ```dart
/// final dio = ref.watch(dioProvider);
/// final response = await dio.get('/citizen/notifications');
/// ```

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio> with $Provider<Dio> {
  /// Riverpod provider that exposes the singleton [Dio] HTTP client.
  ///
  /// The [Dio] instance is kept alive for the lifetime of the app and is
  /// configured via [appConfigProvider] and [secureStorageProvider].
  ///
  /// Consumers in the `3_data/` layer inject this provider to perform HTTP
  /// requests without depending on Dio construction details.
  ///
  /// ```dart
  /// final dio = ref.watch(dioProvider);
  /// final response = await dio.get('/citizen/notifications');
  /// ```
  const DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'6002b92f86ec5ae5215eb972dc6331abe988f906';
