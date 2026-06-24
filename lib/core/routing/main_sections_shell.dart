import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';

class MainSectionsShell extends StatelessWidget {
  const MainSectionsShell({
    required this.child,
    required this.location,
    super.key,
  });

  final Widget child;
  final String location;

  static const List<AppBottomTabBarItem> _tabs = [
    AppBottomTabBarItem(label: 'Inicio', iconAsset: AppIconAssets.accountBalance),
    AppBottomTabBarItem(label: 'Gestión', iconAsset: AppIconAssets.docs),
    AppBottomTabBarItem(label: 'Mis datos', iconAsset: AppIconAssets.apps),
    AppBottomTabBarItem(label: 'Agenda', iconAsset: AppIconAssets.calendarToday),
    AppBottomTabBarItem(label: 'Recomendados', iconAsset: AppIconAssets.license),
  ];

  int get _currentIndex {
    if (location.startsWith(Routes.gestion)) {
      return 1;
    }
    if (location.startsWith(Routes.myData)) {
      return 2;
    }
    if (location.startsWith(Routes.agenda)) {
      return 3;
    }
    if (location.startsWith(Routes.recommendations)) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomTabBar(
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (final index) => _handleTabTap(context, index),
      ),
    );
  }

  void _handleTabTap(final BuildContext context, final int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
      case 1:
        context.go(Routes.gestion);
      case 2:
        context.go(Routes.myData);
      case 3:
        context.go(Routes.agenda);
      case 4:
        context.go(Routes.recommendations);
    }
  }
}
