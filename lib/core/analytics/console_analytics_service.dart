import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_screen.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';

/// Development-console implementation of [AnalyticsService].
///
/// - **Debug builds**: prints each event to the console via [AppLogger].
/// - **Release builds**: all calls are complete no-ops.
///   A real analytics SDK (e.g. Firebase Analytics) will replace or wrap
///   this class in a future sprint without requiring call-site changes.
///
/// No PII may be logged here — [AnalyticsEvent] subclasses are themselves
/// responsible for stripping identifying information from their payloads,
/// and screen identifiers are constrained to the [AnalyticsScreen] enum.
final class ConsoleAnalyticsService implements AnalyticsService {
  /// Creates a console analytics service.
  ///
  /// [releaseMode] is injectable so the release-mode no-op contract can
  /// be exercised by tests; it defaults to [kReleaseMode] so production
  /// behaviour is unchanged.
  const ConsoleAnalyticsService({
    final bool releaseMode = kReleaseMode,
  }) : _releaseMode = releaseMode;

  final bool _releaseMode;

  @override
  void logEvent(final AnalyticsEvent event) {
    if (_releaseMode) {
      return;
    }
    // ignore: avoid_print
    print('[Analytics] event: ${event.runtimeType} | $event');
  }

  @override
  void setCurrentScreen(final AnalyticsScreen screen) {
    if (_releaseMode) {
      return;
    }
    // ignore: avoid_print
    print('[Analytics] screen: ${screen.slug}');
  }
}
