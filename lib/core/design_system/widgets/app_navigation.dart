import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';

enum AppNavBarType { inicio, main, level2, detail, grey }

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavBar({
    super.key,
    this.type = AppNavBarType.main,
    this.title,
    this.isLoggedIn = false,
    this.onBack,
    this.onClose,
    this.actions,
    this.leading,
    this.titleWidget,
    this.showLeading = true,
    this.onAvatarTap,
  });

  final AppNavBarType type;
  final String? title;
  final bool isLoggedIn;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? titleWidget;
  final bool showLeading;

  /// Called when the user avatar is tapped (opens the profile drawer).
  final VoidCallback? onAvatarTap;

  @override
  Size get preferredSize => Size.fromHeight(
    switch (type) {
      AppNavBarType.inicio || AppNavBarType.detail => AppDimensions.appBarHeightInicio,
      AppNavBarType.main => AppDimensions.appBarHeight + 2,
      _ => AppDimensions.appBarHeight,
    },
  );

  Color get _backgroundColor => switch (type) {
    AppNavBarType.grey => AppColors.backgroundBlueMutedLight,
    AppNavBarType.detail => AppColors.backgroundBlueLighter,
    AppNavBarType.level2 => AppColors.statusNeutralLight,
    _ => AppColors.surface,
  };

  Color get _foregroundColor => switch (type) {
    AppNavBarType.level2 => AppColors.primary,
    _ => AppColors.textPrimary,
  };

  Color get _iconColor => switch (type) {
    AppNavBarType.level2 => AppColors.primaryDark,
    _ => AppColors.textPrimary,
  };

  Widget? get _leadingWidget {
    if (!showLeading) {
      return null;
    }

    if (leading != null) {
      return leading;
    }

    return switch (type) {
      AppNavBarType.level2 || AppNavBarType.detail => IconButton(
        icon: Icon(
          type == AppNavBarType.detail ? Icons.close_rounded : Icons.arrow_back_rounded,
          color: _iconColor,
          size: type == AppNavBarType.level2 ? AppDimensions.iconLarge : null,
        ),
        onPressed: onBack ?? onClose,
        tooltip: type == AppNavBarType.detail ? 'Cerrar' : 'Volver',
      ),
      _ => null,
    };
  }

  List<Widget>? get _effectiveActions {
    final items = <Widget>[...?actions];

    if (isLoggedIn && type != AppNavBarType.inicio) {
      items.add(
        IconButton(
          constraints: const BoxConstraints.tightFor(
            width: AppDimensions.minTouchTarget,
            height: AppDimensions.minTouchTarget,
          ),
          icon: const AppSvgIcon(AppIconAssets.notifications, color: AppColors.textPrimary),
          onPressed: () {},
          tooltip: 'Notificaciones',
        ),
      );
    }

    if (isLoggedIn) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(right: AppDimensions.space8),
          child: IconButton(
            onPressed: onAvatarTap,
            tooltip: 'Perfil',
            icon: const AppAvatar(
              initials: 'AM',
              size: AppAvatarSize.small,
              semanticsLabel: 'Perfil',
            ),
          ),
        ),
      );
    }

    return items.isEmpty ? null : items;
  }

  Widget? get _titleWidget {
    if (type == AppNavBarType.inicio) {
      return const AppBrandLogo();
    }
    if (titleWidget != null) {
      return titleWidget;
    }
    if (title != null) {
      return Text(
        title!,
        style: AppTypography.h3.copyWith(color: _foregroundColor),
      );
    }
    return null;
  }

  @override
  Widget build(final BuildContext context) {
    if (type == AppNavBarType.inicio) {
      return _InicioNavBar(
        isLoggedIn: isLoggedIn,
        actions: actions,
        onAvatarTap: onAvatarTap,
      );
    }

    final appBar = AppBar(
      backgroundColor: _backgroundColor,
      foregroundColor: _foregroundColor,
      automaticallyImplyLeading: false,
      toolbarHeight: switch (type) {
        AppNavBarType.detail => AppDimensions.appBarHeightInicio,
        AppNavBarType.main => AppDimensions.appBarHeight + 2,
        _ => AppDimensions.appBarHeight,
      },
      titleSpacing: showLeading ? null : AppDimensions.space16,
      leading: _leadingWidget,
      title: _titleWidget,
      actions: _effectiveActions,
      elevation: 0,
      shadowColor: Colors.transparent,
      bottom: type == AppNavBarType.level2
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.dividerColor,
              ),
            )
          : null,
    );

    if (type == AppNavBarType.level2) {
      return appBar;
    }

    if (type == AppNavBarType.main) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.backgroundBlueMutedLight),
          boxShadow: AppShadows.low,
        ),
        child: appBar,
      );
    }

    if (type != AppNavBarType.detail) {
      return appBar;
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.backgroundBlueMutedLight),
        ),
        boxShadow: AppShadows.low,
      ),
      child: appBar,
    );
  }
}

class _InicioNavBar extends StatelessWidget {
  const _InicioNavBar({
    required this.isLoggedIn,
    this.actions,
    this.onAvatarTap,
  });

  final bool isLoggedIn;
  final List<Widget>? actions;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(final BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.backgroundBlueMutedLight),
        boxShadow: AppShadows.low,
      ),
      child: SizedBox(
        height: AppDimensions.appBarHeightInicio + topPadding,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.space8,
            topPadding + AppDimensions.space8,
            AppDimensions.space8,
            AppDimensions.space8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 48,
                child: AppBrandLogo(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...?actions,
                  if (isLoggedIn) ...[
                    IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: AppDimensions.iconLarge,
                        height: AppDimensions.iconLarge,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const AppSvgIcon(
                        AppIconAssets.notifications,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {},
                      tooltip: 'Notificaciones',
                    ),
                    const SizedBox(width: AppDimensions.space16),
                    IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: AppDimensions.minTouchTarget,
                        height: AppDimensions.minTouchTarget,
                      ),
                      padding: const EdgeInsets.all(AppDimensions.space8),
                      onPressed: onAvatarTap,
                      tooltip: 'Perfil',
                      icon: const AppAvatar(
                        initials: 'AM',
                        size: AppAvatarSize.small,
                        semanticsLabel: 'Perfil',
                      ),
                    ),
                  ] else
                    IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: AppDimensions.iconLarge,
                        height: AppDimensions.iconLarge,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const AppSvgIcon(
                        AppIconAssets.help,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {},
                      tooltip: 'Ayuda',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── AppBrandLogo ──────────────────────────────────────────────────────────────

/// The JCCM "Espacio Ciudadano" brand logo used in the `inicio` NavBar.
///
/// Figma node 42095:13027 — "Logo" group composed of the castle emblem
/// and the "Espacio ciudadano" wordmark.
///
/// Uses `assets/images/logo.svg`.
class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({super.key, this.height = 40});

  /// Overall height constraint for the logo.
  final double height;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          width: height,
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            height: height,
            semanticsLabel: 'Escudo de Castilla-La Mancha',
          ),
        ),
        const SizedBox(width: AppDimensions.space4),
        SizedBox(
          height: 32,
          width: 128,
          child: SvgPicture.asset(
            'assets/images/espacioCiudadano_logo.svg',
            height: 32,
            semanticsLabel: 'Espacio Ciudadano',
          ),
        ),
      ],
    );
  }
}

class AppTabItem {
  const AppTabItem({required this.label, this.icon});

  final String label;
  final IconData? icon;
}

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBar({
    required this.tabs,
    super.key,
    this.level = AppTabBarLevel.nivel1,
    this.controller,
  });

  final List<AppTabItem> tabs;
  final AppTabBarLevel level;
  final TabController? controller;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(final BuildContext context) {
    final isNivel1 = level == AppTabBarLevel.nivel1;

    return TabBar(
      controller: controller,
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: isNivel1 ? AppTypography.bodyBold : AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: isNivel1 ? AppTypography.bodyRegular : AppTypography.smallRegular,
      tabs: tabs
          .map(
            (final AppTabItem tab) => Tab(
              text: tab.label,
              icon: tab.icon != null ? Icon(tab.icon, size: 20) : null,
            ),
          )
          .toList(),
    );
  }
}

enum AppTabBarLevel { nivel1, nivel2 }

class AppStickyBar extends StatelessWidget {
  const AppStickyBar({
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
    this.type = AppStickyBarType.flow,
    this.secondaryLabel,
    this.onSecondary,
    this.isPrimaryLoading = false,
    this.secondaryHierarchy = AppButtonHierarchy.secondary,
    this.primaryLeadingIcon,
    this.secondaryLeadingIcon,
  });

  final AppStickyBarType type;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool isPrimaryLoading;

  /// Hierarchy for the secondary/left button in [AppStickyBarType.dicotomy]
  /// and [AppStickyBarType.flow]. Defaults to [AppButtonHierarchy.secondary].
  ///
  /// Use [AppButtonHierarchy.tertiary] to match the Figma Stickybar variant
  /// where the cancel button has a light-blue (`secondaryLight100`) background.
  final AppButtonHierarchy secondaryHierarchy;

  /// Optional leading icon for the primary (right/main) button.
  /// Figma node `41717:12172` — check icon on "Guarda cambios".
  final IconData? primaryLeadingIcon;

  /// Optional leading icon for the secondary (left/cancel) button.
  /// Figma node `41717:12172` — cancel icon on "Cancelar".
  final IconData? secondaryLeadingIcon;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        // Figma node 41779:23195 — Shadow/Low + border neutral-lighter
        border: Border(
          top: BorderSide(color: Color(0xFFE5E2E1)), // Color/Border/neutral-lighter
        ),
        boxShadow: AppShadows.low,
      ),
      child: switch (type) {
        AppStickyBarType.flow => _buildFlow(),
        AppStickyBarType.dicotomy => _buildDicotomy(),
        AppStickyBarType.vertical => _buildVertical(),
      },
    );
  }

  Widget _buildFlow() {
    return Row(
      children: [
        if (secondaryLabel != null) ...[
          Expanded(
            child: AppButton(
              label: secondaryLabel!,
              onPressed: onSecondary,
              hierarchy: secondaryHierarchy,
              leadingIcon: secondaryLeadingIcon,
            ),
          ),
          const SizedBox(width: AppDimensions.space12),
        ],
        Expanded(
          flex: secondaryLabel != null ? 2 : 1,
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            isLoading: isPrimaryLoading,
            leadingIcon: primaryLeadingIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildDicotomy() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: secondaryLabel ?? 'Cancelar',
            onPressed: onSecondary,
            hierarchy: secondaryHierarchy,
            leadingIcon: secondaryLeadingIcon,
          ),
        ),
        const SizedBox(width: AppDimensions.space12),
        Expanded(
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            isLoading: isPrimaryLoading,
            leadingIcon: primaryLeadingIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildVertical() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (secondaryLabel != null) ...[
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: secondaryLabel!,
              onPressed: onSecondary,
              hierarchy: secondaryHierarchy,
              leadingIcon: secondaryLeadingIcon,
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
        ],
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            isLoading: isPrimaryLoading,
            leadingIcon: primaryLeadingIcon,
          ),
        ),
      ],
    );
  }
}

enum AppStickyBarType { dicotomy, vertical, flow }

class AppNavCard extends StatelessWidget {
  const AppNavCard({
    required this.label,
    required this.onTap,
    super.key,
    this.icon,
    this.iconAsset,
    this.description,
    this.isDisabled = false,
  }) : assert(icon != null || iconAsset != null, 'Provide either icon or iconAsset');

  final String label;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback? onTap;
  final String? description;
  final bool isDisabled;

  @override
  Widget build(final BuildContext context) {
    final bgColor = isDisabled ? const Color(0xFFE5E2E1) : AppColors.surface;
    final titleColor = isDisabled ? AppColors.textDisabled : AppColors.primary;
    final descColor = isDisabled ? AppColors.textDisabled : AppColors.primary;
    final leadingBg = isDisabled ? Colors.black.withValues(alpha: 0.05) : const Color(0xFFF1F8F9);
    final iconColor = isDisabled ? AppColors.textDisabled : AppColors.primary;

    return Semantics(
      button: true,
      label: [label, if (description != null) description].join(', '),
      enabled: !isDisabled,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            padding: const EdgeInsets.only(
              left: AppDimensions.space8,
              right: AppDimensions.space16,
              top: AppDimensions.space8,
              bottom: AppDimensions.space8,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: isDisabled ? Colors.black.withValues(alpha: 0.08) : const Color(0xFFA0B2C5),
              ),
              boxShadow: isDisabled ? const <BoxShadow>[] : AppShadows.medium,
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(AppDimensions.space4),
                  decoration: BoxDecoration(
                    color: leadingBg,
                    borderRadius: BorderRadius.circular(AppDimensions.space4),
                  ),
                  child: Center(
                    child: iconAsset == null
                        ? Icon(
                            icon,
                            size: AppDimensions.iconMedium,
                            color: iconColor,
                          )
                        : AppSvgIcon(
                            iconAsset!,
                            color: iconColor,
                          ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: AppTypography.leadingMedium.copyWith(color: titleColor),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          description!,
                          style: AppTypography.smallRegular.copyWith(color: descColor),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                AppSvgIcon(
                  AppIconAssets.chevronRight,
                  size: AppDimensions.iconLarge,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppSimpleNavCard extends StatelessWidget {
  const AppSimpleNavCard({
    required this.label,
    required this.description,
    required this.onTap,
    super.key,
  });

  final String label;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: '$label, $description',
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space24,
              AppDimensions.space12,
              AppDimensions.space16,
              AppDimensions.space12,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: AppColors.borderBlueMutedLight),
              boxShadow: AppShadows.medium,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.leadingMedium.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.smallRegular.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                const AppIcon(
                  AppIcons.arrowForward,
                  size: AppDimensions.iconLarge,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppQuickAccessCard extends StatelessWidget {
  const AppQuickAccessCard({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.space8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: AppColors.borderBlueMutedLight),
              boxShadow: AppShadows.medium,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundBlueLighter,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                    child: Center(
                      child: AppIcon(
                        icon,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                SizedBox(
                  height: 44,
                  child: Center(
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── FloatingNavigation ────────────────────────────────────────────────────────

/// A pill-shaped horizontal tab selector that floats above content.
///
/// Figma node 43716:12912 — "FloatingNavigation" component.
/// - Container: bluemuted-light bg, bluemuted border, `radiusLarge`, `space8` padding/gap.
/// - Selected tab: blue-lighter bg, primary border, low shadow, round pill.
/// - Unselected tab: white bg, bluemuted border, medium shadow, round pill.
class AppFloatingNavigation extends StatelessWidget {
  const AppFloatingNavigation({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    super.key,
    this.enabledTabs,
    this.minTabWidths,
    this.leading,
    this.trailing,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<bool>? enabledTabs;
  final List<double>? minTabWidths;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(final BuildContext context) {
    assert(
      enabledTabs == null || enabledTabs!.length == tabs.length,
      'enabledTabs must match tabs length',
    );
    assert(
      minTabWidths == null || minTabWidths!.length == tabs.length,
      'minTabWidths must match tabs length',
    );

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderNeutralLight),
      ),
      child: Row(
        spacing: AppDimensions.space8,
        children: [
          ?leading,
          ...List.generate(tabs.length, (final int index) {
            final bool isSelected = index == selectedIndex;
            final bool isEnabled = enabledTabs?[index] ?? true;
            final tab = _FloatingNavTab(
              label: tabs[index],
              isSelected: isSelected,
              isEnabled: isEnabled,
              minWidth: minTabWidths?[index] ?? AppDimensions.minTouchTarget,
              onTap: () => onTabSelected(index),
            );
            if (isSelected) {
              return tab;
            }
            return Expanded(child: tab);
          }),
          ?trailing,
        ],
      ),
    );
  }
}

// ── AppBottomTabBar ──────────────────────────────────────────────────────────

/// Bottom tab bar item definition.
class AppBottomTabBarItem {
  const AppBottomTabBarItem({
    required this.label,
    this.icon,
    this.iconAsset,
  }) : assert(icon != null || iconAsset != null, 'Provide either icon or iconAsset');

  final String label;

  /// Icon token — use a constant from [AppIcons].
  final IconData? icon;

  /// SVG icon asset — use a constant from [AppIconAssets].
  final String? iconAsset;
}

/// A dark-themed bottom navigation bar matching Figma "Tabs/ BottomTabBar".
///
/// - 5 tabs: Inicio, Gestión, Mi Carpeta, Agenda, Recomendados
/// - Dark blue background (`AppColors.primary`)
/// - Active tab has a cyan indicator bar below it
/// - White icons and labels
class AppBottomTabBar extends StatelessWidget {
  const AppBottomTabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<AppBottomTabBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.space4,
        right: AppDimensions.space4,
        top: AppDimensions.space4,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      color: AppColors.primary,
      child: Row(
        children: List.generate(items.length, (final int index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                height: AppDimensions.bottomNavHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (item.iconAsset == null)
                      AppIcon(
                        item.icon!,
                        color: AppColors.textWhite,
                      )
                    else
                      AppSvgIcon(
                        item.iconAsset!,
                        color: AppColors.textWhite,
                      ),
                    const SizedBox(height: AppDimensions.space8),
                    Text(
                      item.label,
                      style: AppTypography.smallRegular.copyWith(
                        color: AppColors.textWhite,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.space4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 4,
                      width: 24,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondaryLight300 : Colors.transparent,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppDimensions.radiusXs),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── AppFab ────────────────────────────────────────────────────────────────────

/// A dark round FAB matching Figma "FAB" (node 41773:16536).
///
/// Size: 56×56, dark primary background, white icon, high shadow.
class AppFab extends StatelessWidget {
  const AppFab({
    required this.onPressed,
    super.key,
    this.icon,
    this.iconAsset,
    this.semanticsLabel,
  }) : assert(icon != null || iconAsset != null, 'Provide either icon or iconAsset');

  final IconData? icon;
  final String? iconAsset;
  final VoidCallback? onPressed;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 56,
            height: 56,
            child: iconAsset == null
                ? AppIcon(icon!, color: AppColors.textWhite, size: 20)
                : AppSvgIcon(
                    iconAsset!,
                    color: AppColors.textWhite,
                    size: 20,
                  ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavTab extends StatelessWidget {
  const _FloatingNavTab({
    required this.label,
    required this.isSelected,
    required this.isEnabled,
    required this.minWidth,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isEnabled;
  final double minWidth;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final isInteractive = isSelected || isEnabled;
    final backgroundColor = isSelected
        ? AppColors.backgroundBlueLighter
        : isEnabled
        ? AppColors.surface
        : AppColors.background;
    final borderColor = isSelected
        ? AppColors.primaryDark
        : isEnabled
        ? AppColors.borderNeutralLight
        : Colors.transparent;
    final textStyle = isSelected
        ? AppTypography.bodyBold.copyWith(color: AppColors.textBlack)
        : isEnabled
        ? AppTypography.bodyRegular.copyWith(color: AppColors.textBlack)
        : AppTypography.bodyRegular.copyWith(color: AppColors.textDisabled);

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: isInteractive,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 40,
        constraints: BoxConstraints(minWidth: minWidth),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          border: Border.all(color: borderColor),
          boxShadow: AppShadows.low,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          child: InkWell(
            onTap: isInteractive ? onTap : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
