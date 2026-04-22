// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logger_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the application-level [AppLogger] singleton.
///
/// - **Debug builds**: returns a [ConsoleLogger] at [LogLevel.debug] so all
///   messages are visible during development.
/// - **Release builds**: returns a [ConsoleLogger] at [LogLevel.error] so
///   only errors reach the console — verbose diagnostics are suppressed.
///
/// Future sprint: swap the release-mode implementation for a remote
/// crash-reporting adapter (e.g. Firebase Crashlytics) without changing
/// call-sites.

@ProviderFor(appLogger)
const appLoggerProvider = AppLoggerProvider._();

/// Provides the application-level [AppLogger] singleton.
///
/// - **Debug builds**: returns a [ConsoleLogger] at [LogLevel.debug] so all
///   messages are visible during development.
/// - **Release builds**: returns a [ConsoleLogger] at [LogLevel.error] so
///   only errors reach the console — verbose diagnostics are suppressed.
///
/// Future sprint: swap the release-mode implementation for a remote
/// crash-reporting adapter (e.g. Firebase Crashlytics) without changing
/// call-sites.

final class AppLoggerProvider
    extends $FunctionalProvider<AppLogger, AppLogger, AppLogger>
    with $Provider<AppLogger> {
  /// Provides the application-level [AppLogger] singleton.
  ///
  /// - **Debug builds**: returns a [ConsoleLogger] at [LogLevel.debug] so all
  ///   messages are visible during development.
  /// - **Release builds**: returns a [ConsoleLogger] at [LogLevel.error] so
  ///   only errors reach the console — verbose diagnostics are suppressed.
  ///
  /// Future sprint: swap the release-mode implementation for a remote
  /// crash-reporting adapter (e.g. Firebase Crashlytics) without changing
  /// call-sites.
  const AppLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLoggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLoggerHash();

  @$internal
  @override
  $ProviderElement<AppLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLogger create(Ref ref) {
    return appLogger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLogger>(value),
    );
  }
}

String _$appLoggerHash() => r'41a6fd44470c1e96941c3715fba54ea3f864d533';
