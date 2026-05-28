import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

/// Authenticated home screen — Figma node 41773:16528 "Inicio".
///
/// Composed of:
/// - [AppNavBar] (type inicio, logged in, with notifications + avatar)
/// - Content area (light blue-lighter background)
/// - [AppBottomTabBar] (5 tabs: Inicio, Gestión, Mi Carpeta, Agenda, Recomendados)
/// - [AppFab] (ID card icon, bottom-right)
/// - Shows an [AppAlertToast] on first load ("Acceso biométrico activado")
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;
  bool _toastShown = false;

  static const List<AppBottomTabBarItem> _tabs = [
    AppBottomTabBarItem(label: 'Inicio', icon: AppIcons.accountBalance),
    AppBottomTabBarItem(label: 'Gestión', icon: AppIcons.docs),
    AppBottomTabBarItem(label: 'Mi Carpeta', icon: AppIcons.apps),
    AppBottomTabBarItem(label: 'Agenda', icon: AppIcons.calendarToday),
    AppBottomTabBarItem(label: 'Recomendados', icon: AppIcons.license),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_toastShown) {
      _toastShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppAlertToast.show(
            context,
            message: 'Acceso biométrico activado',
            severity: AppAlertSeverity.success,
          );
        }
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(
        type: AppNavBarType.inicio,
        isLoggedIn: true,
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.backgroundBlueLighter,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space24,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder content matching Figma design
            _SectionTitle(text: 'Compo 1', style: AppTypography.h2),
            SizedBox(height: AppDimensions.space16),
            _SectionTitle(text: 'Título 3', style: AppTypography.h3),
            SizedBox(height: AppDimensions.space16),
            _SectionTitle(text: 'Título 3', style: AppTypography.leadingMedium),
            SizedBox(height: AppDimensions.space16),
            _SectionTitle(text: 'Título 3', style: AppTypography.bodyRegular),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomTabBar(
        items: _tabs,
        currentIndex: _currentTabIndex,
        onTap: (final int index) => setState(() => _currentTabIndex = index),
      ),
      floatingActionButton: AppFab(
        icon: AppIcons.person,
        onPressed: () {
          // TODO(jccm): Navigate to ID card / digital identity.
        },
        semanticsLabel: 'Identificación digital',
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      style: style.copyWith(color: AppColors.textBase),
    );
  }
}
