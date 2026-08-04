import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_header_bar.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_top_tab_bar.dart';

/// Standard detail scaffold with a header bar and a top tab bar.
///
/// Use it for authenticated level-2/detail flows that share the JCCM pattern:
/// title bar, optional info action, two or more top tabs, and one active tab body.
class AppTabbedDetailScaffold extends StatelessWidget {
  const AppTabbedDetailScaffold({
    required this.title,
    required this.onBack,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabViews,
    super.key,
    this.onInfo,
    this.actions = const [],
    this.backgroundColor = AppColors.backgroundBlueLighter,
    this.appBarBackgroundColor = AppColors.backgroundWhite,
  }) : assert(tabs.length == tabViews.length, 'tabs and tabViews must have the same length');

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onInfo;
  final List<Widget> actions;
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<Widget> tabViews;
  final Color backgroundColor;
  final Color appBarBackgroundColor;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppHeaderBar(
        title: title,
        onBack: onBack,
        onInfo: onInfo,
        actions: actions,
        backgroundColor: appBarBackgroundColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              AppTopTabBar(
                tabs: tabs,
                selectedIndex: selectedIndex,
                onTabSelected: onTabSelected,
              ),
              Expanded(child: tabViews[selectedIndex]),
            ],
          ),
        ),
      ),
    );
  }
}
