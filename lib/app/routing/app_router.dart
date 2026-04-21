import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/observers/app_lifecycle_observer.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';

/// Centralised GoRouter configuration.
///
/// This is a placeholder that exposes a single root route with a
/// "Hello World" body. Expand with feature routes in STORY-13.
final class AppRouter {
  AppRouter() : _observer = AppLifecycleObserver() {
    _router = GoRouter(
      initialLocation: RouteRegistry.root,
      observers: [_observer],
      routes: [
        GoRoute(
          path: RouteRegistry.root,
          builder: (final BuildContext context, final GoRouterState state) =>
              const Scaffold(
            body: Center(child: Text('Espacio Ciudadano')),
          ),
        ),
      ],
    );
  }

  final AppLifecycleObserver _observer;
  late final GoRouter _router;

  /// The configured [GoRouter] instance.
  GoRouter get router => _router;

  /// Disposes the router and its observer.
  void dispose() {
    _router.dispose();
  }
}
