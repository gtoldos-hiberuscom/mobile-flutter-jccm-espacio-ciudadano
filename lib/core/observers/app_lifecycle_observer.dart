import 'package:flutter/material.dart';

/// Navigation observer for the application lifecycle.
///
/// Extend with analytics or logging calls in later stories.
/// Registered as a GoRouter observer so route transitions are centralised.
final class AppLifecycleObserver extends NavigatorObserver {
  @override
  void didPush(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    // TODO(STORY-13): emit analytics event on push.
  }

  @override
  void didPop(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    // TODO(STORY-13): emit analytics event on pop.
  }

  @override
  void didReplace({final Route<dynamic>? newRoute, final Route<dynamic>? oldRoute}) {
    // TODO(STORY-13): emit analytics event on replace.
  }
}
