import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_screen.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';

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
  const ConsoleAnalyticsService({required final AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  @override
  void logEvent(final AnalyticsEvent event) {
    if (kReleaseMode) {
      return;
    }
    _logger.debug('[Analytics] event: ${event.runtimeType} | $event');
  }

  @override
  void setCurrentScreen(final AnalyticsScreen screen) {
    if (kReleaseMode) {
      return;
    }
    _logger.debug('[Analytics] screen: ${screen.slug}');
  }
}
