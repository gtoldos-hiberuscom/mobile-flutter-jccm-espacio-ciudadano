import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_screen.dart';

/// Contract for analytics backends.
///
/// Implementations must remain PII-free: they may only persist or forward
/// data that has already been sanitised by the event model itself.
///
/// The interface has no Flutter or BuildContext dependency so it can be used
/// from domain and data layers.
abstract interface class AnalyticsService {
  /// Records a structured [event].
  void logEvent(final AnalyticsEvent event);

  /// Informs the analytics backend of the currently visible [screen].
  ///
  /// The argument is the allow-listed [AnalyticsScreen] enum, **not** a
  /// free-form string — this is a compile-time guarantee that no caller
  /// can leak user content (e.g. `/profile/<NIF>`) into the analytics
  /// pipeline.
  void setCurrentScreen(final AnalyticsScreen screen);
}
