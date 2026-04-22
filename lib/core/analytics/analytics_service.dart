import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';

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

  /// Informs the analytics backend of the currently visible screen.
  ///
  /// [screenName] must be a route slug or a stable screen identifier —
  /// never a user-facing label derived from user content.
  void setCurrentScreen(final String screenName);
}
