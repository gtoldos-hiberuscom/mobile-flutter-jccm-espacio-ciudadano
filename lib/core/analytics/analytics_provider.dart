import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Minimal analytics service contract.
///
/// Sprint 1 stub — real analytics integration is tracked in STORY-64.
/// This file exists so the router can compile while the analytics story
/// is in progress.
abstract interface class AnalyticsService {
  /// Records a named screen view event.
  void logScreenView(final String screenName);
}

/// No-op analytics service for Sprint 1.
final class NoOpAnalyticsService implements AnalyticsService {
  const NoOpAnalyticsService();

  @override
  void logScreenView(final String screenName) {
    // No-op: real implementation tracked by STORY-64.
  }
}

/// Provides the singleton [AnalyticsService].
///
/// Kept alive for the app lifetime. Override in tests or when wiring real
/// analytics in a future story.
final analyticsServiceProvider = Provider<AnalyticsService>(
  (_) => const NoOpAnalyticsService(),
  name: 'analyticsServiceProvider',
);
