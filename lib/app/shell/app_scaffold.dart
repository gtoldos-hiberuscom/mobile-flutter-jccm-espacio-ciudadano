import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';

/// Authenticated shell scaffold.
///
/// Wraps all protected screens with a persistent [NavigationBar] that
/// drives the [ShellRoute] child. Navigation items correspond to the five
/// primary sections of the authenticated experience.
///
/// The shell intentionally carries no business logic — it only dispatches
/// `context.go()` calls on item tap and derives the active index from the
/// current route location.
class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.child, super.key});

  /// The current page rendered inside the shell by GoRouter.
  final Widget child;

  static const _destinations = <(String path, IconData icon, String label)>[
    (Routes.home, Icons.home_outlined, 'Inicio'),
    (Routes.agenda, Icons.calendar_today_outlined, 'Agenda'),
    (Routes.casework, Icons.folder_outlined, 'Expedientes'),
    (Routes.notifications, Icons.notifications_outlined, 'Notificaciones'),
    (Routes.cards, Icons.credit_card_outlined, 'Tarjetas'),
  ];

  int _selectedIndex(final BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _destinations.indexWhere(
      (final d) => location == d.$1 || location.startsWith('${d.$1}/'),
    );
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex(context),
          onDestinationSelected: (final int index) =>
              context.go(_destinations[index].$1),
          destinations: _destinations
              .map(
                (final d) => NavigationDestination(
                  icon: Icon(d.$2),
                  label: d.$3,
                ),
              )
              .toList(growable: false),
        ),
      );
}
