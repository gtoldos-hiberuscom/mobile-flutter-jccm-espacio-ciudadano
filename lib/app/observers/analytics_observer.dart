import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';

/// [NavigatorObserver] that forwards route transitions to [AnalyticsService].
///
/// Register this observer in GoRouter observers alongside AppLifecycleObserver.
/// It reports [PageViewEvent] on every push/replace so that navigation funnels
/// can be tracked without any PII in the payload.
///
/// The observer delegates to [AnalyticsService] which is itself a no-op in
/// release builds until a real SDK is wired up in a future sprint.
final class AnalyticsObserver extends NavigatorObserver {
  AnalyticsObserver({required final AnalyticsService analyticsService}) : _analytics = analyticsService;

  final AnalyticsService _analytics;

  // ── NavigatorObserver ────────────────────────────────────────────────────────

  @override
  void didPush(
    final Route<dynamic> route,
    final Route<dynamic>? previousRoute,
  ) {
    _trackRoute(route);
  }

  @override
  void didReplace({
    final Route<dynamic>? newRoute,
    final Route<dynamic>? oldRoute,
  }) {
    if (newRoute != null) {
      _trackRoute(newRoute);
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  void _trackRoute(final Route<dynamic> route) {
    final name = route.settings.name;
    if (name == null || name.isEmpty) {
      return;
    }

    _analytics
      ..setCurrentScreen(name)
      ..logEvent(PageViewEvent(name));
  }
}
