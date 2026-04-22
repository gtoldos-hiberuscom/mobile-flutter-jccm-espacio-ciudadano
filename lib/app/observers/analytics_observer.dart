import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';

/// GoRouter / Navigator observer that records screen-view analytics events.
///
/// Sprint 1 stub — real analytics event mapping will be added when the
/// analytics story (STORY-64) is implemented.
final class AnalyticsObserver extends NavigatorObserver {
  AnalyticsObserver({required this.analyticsService});

  final AnalyticsService analyticsService;

  @override
  void didPush(
    final Route<dynamic> route,
    final Route<dynamic>? previousRoute,
  ) {
    super.didPush(route, previousRoute);
    final name = route.settings.name;
    if (name != null) {
      analyticsService.logScreenView(name);
    }
  }

  @override
  void didReplace({
    final Route<dynamic>? newRoute,
    final Route<dynamic>? oldRoute,
  }) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final name = newRoute?.settings.name;
    if (name != null) {
      analyticsService.logScreenView(name);
    }
  }
}
