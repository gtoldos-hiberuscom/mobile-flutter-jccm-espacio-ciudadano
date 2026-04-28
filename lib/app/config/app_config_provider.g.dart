// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [AppConfig] that was resolved at application startup.
///
/// This provider is intentionally left unimplemented here and **must** be
/// overridden at the `ProviderScope` level inside `bootstrap` so that all
/// descendant providers can read the correct configuration without requiring
/// a `BuildContext`.
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     appConfigProvider.overrideWithValue(config),
///   ],
///   child: App(config: config),
/// )
/// ```

@ProviderFor(appConfig)
const appConfigProvider = AppConfigProvider._();

/// Provides the [AppConfig] that was resolved at application startup.
///
/// This provider is intentionally left unimplemented here and **must** be
/// overridden at the `ProviderScope` level inside `bootstrap` so that all
/// descendant providers can read the correct configuration without requiring
/// a `BuildContext`.
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     appConfigProvider.overrideWithValue(config),
///   ],
///   child: App(config: config),
/// )
/// ```

final class AppConfigProvider
    extends $FunctionalProvider<AppConfig, AppConfig, AppConfig>
    with $Provider<AppConfig> {
  /// Provides the [AppConfig] that was resolved at application startup.
  ///
  /// This provider is intentionally left unimplemented here and **must** be
  /// overridden at the `ProviderScope` level inside `bootstrap` so that all
  /// descendant providers can read the correct configuration without requiring
  /// a `BuildContext`.
  ///
  /// ```dart
  /// ProviderScope(
  ///   overrides: [
  ///     appConfigProvider.overrideWithValue(config),
  ///   ],
  ///   child: App(config: config),
  /// )
  /// ```
  const AppConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
        
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigHash();

  @$internal
  @override
  $ProviderElement<AppConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppConfig create(Ref ref) {
    return appConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppConfig>(value),
    );
  }
}

String _$appConfigHash() => r'db21504f98b6b99795c7b00bb0ba648342203336';
