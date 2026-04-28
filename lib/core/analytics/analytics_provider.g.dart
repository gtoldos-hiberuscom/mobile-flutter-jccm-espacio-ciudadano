// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the application-level [AnalyticsService] singleton.
///
/// Currently returns a [ConsoleAnalyticsService] in all environments:
/// - **Debug**: logs events to the development console via [appLoggerProvider].
/// - **Release**: all calls are no-ops (see [ConsoleAnalyticsService]).
///
/// Future sprint: replace the release implementation with a real analytics
/// SDK provider (e.g. Firebase Analytics) without changing any call-sites.

@ProviderFor(analyticsService)
const analyticsServiceProvider = AnalyticsServiceProvider._();

/// Provides the application-level [AnalyticsService] singleton.
///
/// Currently returns a [ConsoleAnalyticsService] in all environments:
/// - **Debug**: logs events to the development console via [appLoggerProvider].
/// - **Release**: all calls are no-ops (see [ConsoleAnalyticsService]).
///
/// Future sprint: replace the release implementation with a real analytics
/// SDK provider (e.g. Firebase Analytics) without changing any call-sites.

final class AnalyticsServiceProvider extends $FunctionalProvider<AnalyticsService, AnalyticsService, AnalyticsService> with $Provider<AnalyticsService> {
  /// Provides the application-level [AnalyticsService] singleton.
  ///
  /// Currently returns a [ConsoleAnalyticsService] in all environments:
  /// - **Debug**: logs events to the development console via [appLoggerProvider].
  /// - **Release**: all calls are no-ops (see [ConsoleAnalyticsService]).
  ///
  /// Future sprint: replace the release implementation with a real analytics
  /// SDK provider (e.g. Firebase Analytics) without changing any call-sites.
  const AnalyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsServiceHash();

  @$internal
  @override
  $ProviderElement<AnalyticsService> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AnalyticsService create(Ref ref) {
    return analyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsService>(value),
    );
  }
}

String _$analyticsServiceHash() => r'2daac0d875683ce71a44f8684c1f78955cf3119f';
