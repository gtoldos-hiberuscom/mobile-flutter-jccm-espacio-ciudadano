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
    this.titleSemanticsLabel,
    this.leadingTooltip,
    this.infoTooltip,
    this.activeViewSemanticLabel,
  }) : assert(title != '', 'title must not be empty'),
       assert(tabs.length > 0, 'tabs must not be empty'),
       assert(tabs.length == tabViews.length, 'tabs and tabViews must have the same length'),
       assert(selectedIndex >= 0 && selectedIndex < tabs.length, 'selectedIndex is out of range'),
       assert(titleSemanticsLabel == null || titleSemanticsLabel != '', 'titleSemanticsLabel must not be empty'),
       assert(leadingTooltip == null || leadingTooltip != '', 'leadingTooltip must not be empty'),
       assert(infoTooltip == null || infoTooltip != '', 'infoTooltip must not be empty'),
       assert(activeViewSemanticLabel == null || activeViewSemanticLabel != '', 'activeViewSemanticLabel must not be empty');

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
  final String? titleSemanticsLabel;
  final String? leadingTooltip;
  final String? infoTooltip;
  final String? activeViewSemanticLabel;

  @override
  Widget build(final BuildContext context) {
    assert(tabs.every((final tab) => tab.isNotEmpty), 'tab labels must not be empty');
    final tabBar = AppTopTabBar(
      tabs: tabs,
      selectedIndex: selectedIndex,
      onTabSelected: onTabSelected,
    );
    final activeView = Semantics(
      container: true,
      explicitChildNodes: true,
      label: activeViewSemanticLabel,
      child: tabViews[selectedIndex],
    );
    final header = AppHeaderBar(
      title: title,
      titleSemanticsLabel: titleSemanticsLabel,
      leadingTooltip: leadingTooltip,
      infoTooltip: infoTooltip,
      onBack: onBack,
      onInfo: onInfo,
      actions: actions,
      backgroundColor: appBarBackgroundColor,
    );
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    return Scaffold(
      // Con el texto ampliado la cabecera va dentro del desplazamiento.
      appBar: usesLargeText ? null : header,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor,
        child: SafeArea(
          top: usesLargeText,
          child: usesLargeText
              // Con el texto ampliado la cabecera y las pestañas se desplazan
              // con el contenido: fijas ocupaban gran parte de la pantalla y
              // dejaban muy poco espacio para leer (WCAG 1.4.4). La cabecera
              // reaparece en cuanto se desplaza hacia arriba, con el botón de
              // volver.
              ? NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (final context, final _) => [
                    SliverPersistentHeader(
                      floating: true,
                      delegate: _FloatingHeaderDelegate(
                        header: header,
                        height: header.toolbarHeightOf(context),
                      ),
                    ),
                    SliverToBoxAdapter(child: tabBar),
                  ],
                  body: activeView,
                )
              : Column(
                  children: [
                    tabBar,
                    Expanded(child: activeView),
                  ],
                ),
        ),
      ),
    );
  }
}

class _FloatingHeaderDelegate extends SliverPersistentHeaderDelegate {
  _FloatingHeaderDelegate({required this.header, required this.height});

  final AppHeaderBar header;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(final BuildContext context, final double shrinkOffset, final bool overlapsContent) => SizedBox(height: height, child: header);

  @override
  bool shouldRebuild(final _FloatingHeaderDelegate oldDelegate) => oldDelegate.header != header || oldDelegate.height != height;
}
