import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/console_analytics_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_provider.g.dart';

/// Provides the application-level [AnalyticsService] singleton.
///
/// Currently returns a [ConsoleAnalyticsService] in all environments:
/// - **Debug**: logs events to the development console.
/// - **Release**: all calls are no-ops (see [ConsoleAnalyticsService]).
///
/// Future sprint: replace the release implementation with a real analytics
/// SDK provider (e.g. Firebase Analytics) without changing any call-sites.
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(final Ref ref) {
  return const ConsoleAnalyticsService();
}
