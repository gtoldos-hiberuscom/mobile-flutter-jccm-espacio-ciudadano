import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_screen.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';

/// [NavigatorObserver] that forwards route transitions to [AnalyticsService].
///
/// Register this observer in GoRouter observers alongside AppLifecycleObserver.
/// It reports [PageViewEvent] on every push/replace so that navigation funnels
/// can be tracked without any PII in the payload.
///
/// The observer delegates to [AnalyticsService] which is itself a no-op in
/// release builds until a real SDK is wired up in a future sprint.
final class AnalyticsObserver extends NavigatorObserver {
  AnalyticsObserver({
    required final AnalyticsService analyticsService,
    required final AppLogger logger,
  }) : _analytics = analyticsService,
       _logger = logger;

  final AnalyticsService _analytics;
  final AppLogger _logger;

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

    final screen = AnalyticsScreen.fromRoute(name);
    if (screen == AnalyticsScreen.unknown) {
      // Do NOT forward unrecognised routes to the analytics backend —
      // they may carry path parameters with PII (e.g. `/profile/<NIF>`).
      // Surface a warning instead so the allow-list can be extended.
      _logger.warning(
        '[AnalyticsObserver] dropping unknown route: not in AnalyticsScreen allow-list',
      );
      return;
    }

    _analytics
      ..setCurrentScreen(screen)
      ..logEvent(PageViewEvent(screen.slug));
  }
}
