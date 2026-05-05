import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';

/// Observer for GoRouter that logs navigation events with emoji formatting.
final class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    logger.d('🔀 Route pushed: ${route.settings.name}');
  }

  @override
  void didPop(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    logger.d('⬅️ Route popped: ${route.settings.name}');
  }

  @override
  void didRemove(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    logger.d('❌ Route removed: ${route.settings.name}');
  }

  @override
  void didReplace({
    final Route<dynamic>? newRoute,
    final Route<dynamic>? oldRoute,
  }) {
    logger.d('🔄 Route replaced: ${oldRoute?.settings.name} → ${newRoute?.settings.name}');
  }
}
