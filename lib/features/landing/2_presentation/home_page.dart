import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

/// Authenticated home screen — Figma node 43716:13302 "Inicio".
///
/// Composed of:
/// - [AppNavBar] (type inicio, logged in, with notifications + avatar)
/// - Content area (light blue-lighter background)
/// - [AppBottomTabBar] (5 tabs: Inicio, Gestión, Mi Carpeta, Agenda, Recomendados)
/// - [AppFab] (ID card icon, bottom-right)
/// - Shows the biometric quick-access dialog on first load.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;
  bool _biometricDialogShown = false;

  static const List<AppBottomTabBarItem> _tabs = [
    AppBottomTabBarItem(label: 'Inicio', iconAsset: AppIconAssets.accountBalance),
    AppBottomTabBarItem(label: 'Gestión', iconAsset: AppIconAssets.docs),
    AppBottomTabBarItem(label: 'Mi Carpeta', iconAsset: AppIconAssets.apps),
    AppBottomTabBarItem(label: 'Agenda', iconAsset: AppIconAssets.calendarToday),
    AppBottomTabBarItem(label: 'Recomendados', iconAsset: AppIconAssets.license),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_biometricDialogShown) {
      _biometricDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_showBiometricDialog());
        }
      });
    }
  }

  Future<void> _showBiometricDialog() async {
    final accepted = await AppBiometricAccessDialog.show(context);

    if (!mounted || accepted != true) {
      return;
    }

    AppAlertToast.show(
      context,
      message: 'Acceso biométrico activado',
      severity: AppAlertSeverity.success,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(
        type: AppNavBarType.inicio,
        isLoggedIn: true,
      ),
      body: const _HomeDashboard(),
      bottomNavigationBar: AppBottomTabBar(
        items: _tabs,
        currentIndex: _currentTabIndex,
        onTap: (final int index) => setState(() => _currentTabIndex = index),
      ),
      floatingActionButton: AppFab(
        iconAsset: AppIconAssets.license,
        onPressed: () {
          // TODO(jccm): Navigate to ID card / digital identity.
        },
        semanticsLabel: 'Identificación digital',
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundBlueLighter,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space24,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: 'Compo 1', style: AppTypography.h2),
          SizedBox(height: AppDimensions.space16),
          _SectionTitle(text: 'Título 3', style: AppTypography.h3),
          SizedBox(height: AppDimensions.space16),
          _SectionTitle(text: 'Título 3', style: AppTypography.leadingMedium),
          SizedBox(height: AppDimensions.space16),
          _SectionTitle(text: 'Título 3', style: AppTypography.bodyRegular),
        ],
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
