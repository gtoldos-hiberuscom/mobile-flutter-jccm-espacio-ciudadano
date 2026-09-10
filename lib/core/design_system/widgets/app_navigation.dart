import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

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
    this.showNotifications = true,
    this.onAvatarTap,
    this.onNotificationsTap,
    this.onHelpTap,
    this.profileInitials,
  }) : assert(title == null || title != '', 'title must not be empty'),
       assert(
         profileInitials == null || profileInitials != '',
         'profileInitials must not be empty',
       );

  final AppNavBarType type;
  final String? title;
  final bool isLoggedIn;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? titleWidget;
  final bool showLeading;
  final bool showNotifications;

  /// Called when the user avatar is tapped (opens the profile drawer).
  final VoidCallback? onAvatarTap;

  /// Initials of the authenticated person shown in the profile avatar.
  final String? profileInitials;

  /// Called when the notifications icon is tapped.
  final VoidCallback? onNotificationsTap;

  /// Called from the help action shown to unauthenticated users on Inicio.
  final VoidCallback? onHelpTap;

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

  Widget? _leadingWidget(final AppLocalizations l10n) {
    if (!showLeading) {
      return null;
    }

    if (leading != null) {
      return leading;
    }

    final button = switch (type) {
      AppNavBarType.level2 || AppNavBarType.detail => IconButton(
        icon: Icon(
          type == AppNavBarType.detail ? Icons.close_rounded : Icons.arrow_back_rounded,
          color: _iconColor,
          size: type == AppNavBarType.level2 ? AppDimensions.iconLarge : null,
        ),
        onPressed: onBack ?? onClose,
        tooltip: type == AppNavBarType.detail ? l10n.a11yClose : l10n.a11yBack,
      ),
      _ => null,
    };
    return button == null ? null : Semantics(sortKey: const OrdinalSortKey(1), child: button);
  }

  List<Widget>? _effectiveActions(final AppLocalizations l10n) {
    final items = <Widget>[...?actions];

    if (isLoggedIn && showNotifications && type != AppNavBarType.inicio) {
      items.add(
        IconButton(
          constraints: const BoxConstraints.tightFor(
            width: AppDimensions.minTouchTarget,
            height: AppDimensions.minTouchTarget,
          ),
          icon: const AppSvgIcon(AppIconAssets.notifications, color: AppColors.textPrimary),
          onPressed: onNotificationsTap,
          tooltip: l10n.userMenuNotifications,
        ),
      );
    }

    if (isLoggedIn) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(right: AppDimensions.space8),
          child: IconButton(
            onPressed: onAvatarTap,
            tooltip: l10n.userMenuProfile,
            icon: AppAvatar(
              initials: profileInitials,
              size: AppAvatarSize.small,
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
    final l10n = AppLocalizations.of(context);
    if (type == AppNavBarType.inicio) {
      return _InicioNavBar(
        isLoggedIn: isLoggedIn,
        showNotifications: showNotifications,
        actions: actions,
        onAvatarTap: onAvatarTap,
        onNotificationsTap: onNotificationsTap,
        onHelpTap: onHelpTap,
        profileInitials: profileInitials,
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
      leading: _leadingWidget(l10n),
      title: title == null
          ? _titleWidget
          : Semantics(
              header: true,
              headingLevel: 1,
              sortKey: const OrdinalSortKey(0),
              child: Text(
                title!,
                maxLines: 2,
                style: AppTypography.h3.copyWith(color: _foregroundColor),
              ),
            ),
      actions: _effectiveActions(l10n),
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
          bottom: BorderSide(color: AppColors.borderBlueMutedLighter),
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
    required this.showNotifications,
    this.actions,
    this.onAvatarTap,
    this.onNotificationsTap,
    this.onHelpTap,
    this.profileInitials,
  });

  final bool isLoggedIn;
  final bool showNotifications;
  final List<Widget>? actions;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onHelpTap;
  final String? profileInitials;

  @override
  Widget build(final BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final l10n = AppLocalizations.of(context);

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
              Semantics(
                header: true,
                headingLevel: 1,
                sortKey: const OrdinalSortKey(0),
                label: l10n.a11yAppName,
                child: const ExcludeSemantics(
                  child: SizedBox(
                    height: 48,
                    child: AppBrandLogo(),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...?actions,
                  if (isLoggedIn) ...[
                    if (showNotifications) ...[
                      IconButton(
                        constraints: const BoxConstraints.tightFor(
                          width: AppDimensions.minTouchTarget,
                          height: AppDimensions.minTouchTarget,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const AppSvgIcon(
                          AppIconAssets.notifications,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: onNotificationsTap,
                        tooltip: l10n.userMenuNotifications,
                      ),
                      const SizedBox(width: AppDimensions.space16),
                    ],
                    IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: AppDimensions.minTouchTarget,
                        height: AppDimensions.minTouchTarget,
                      ),
                      padding: const EdgeInsets.all(AppDimensions.space8),
                      onPressed: onAvatarTap,
                      tooltip: l10n.userMenuProfile,
                      icon: AppAvatar(
                        initials: profileInitials,
                        size: AppAvatarSize.small,
                      ),
                    ),
                  ] else
                    IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: AppDimensions.minTouchTarget,
                        height: AppDimensions.minTouchTarget,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const AppSvgIcon(
                        AppIconAssets.help,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: onHelpTap,
                      tooltip: l10n.a11yHelp,
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
  const AppBrandLogo({
    super.key,
    this.height = 40,
    this.semanticsLabel,
    this.decorative = false,
  }) : assert(height > 0, 'height must be greater than zero'),
       assert(
         semanticsLabel == null || semanticsLabel != '',
         'semanticsLabel must not be empty',
       );

  /// Overall height constraint for the logo.
  final double height;

  /// Optional accessible brand name. Defaults to the localized application name.
  final String? semanticsLabel;

  /// Excludes the logo when the surrounding component already announces it.
  final bool decorative;

  @override
  Widget build(final BuildContext context) {
    final logo = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          width: height,
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            height: height,
            excludeFromSemantics: true,
          ),
        ),
        const SizedBox(width: AppDimensions.space4),
        SizedBox(
          height: height * 0.8,
          width: height * 3.2,
          child: SvgPicture.asset(
            'assets/images/espacioCiudadano_logo.svg',
            height: height * 0.8,
            excludeFromSemantics: true,
          ),
        ),
      ],
    );

    if (decorative) {
      return ExcludeSemantics(child: logo);
    }
    return Semantics(
      container: true,
      image: true,
      label: semanticsLabel ?? AppLocalizations.of(context).a11yAppName,
      child: ExcludeSemantics(child: logo),
    );
  }
}

class AppTabItem {
  const AppTabItem({required this.label, this.icon, this.semanticsLabel})
    : assert(label != '', 'label must not be empty'),
      assert(
        semanticsLabel == null || semanticsLabel != '',
        'semanticsLabel must not be empty',
      );

  final String label;
  final IconData? icon;
  final String? semanticsLabel;
}

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBar({
    required this.tabs,
    super.key,
    this.level = AppTabBarLevel.nivel1,
    this.controller,
    this.isScrollable = false,
  });

  final List<AppTabItem> tabs;
  final AppTabBarLevel level;
  final TabController? controller;
  final bool isScrollable;

  @override
  Size get preferredSize => Size.fromHeight(
    tabs.any((final tab) => tab.icon != null) ? 72 : kTextTabBarHeight,
  );

  @override
  Widget build(final BuildContext context) {
    assert(tabs.length >= 2, 'tabs must contain at least two items');
    final isNivel1 = level == AppTabBarLevel.nivel1;
    final scrollable = isScrollable || MediaQuery.textScalerOf(context).scale(1) > 1.5;

    final labelStyle = isNivel1 ? AppTypography.bodyBold : AppTypography.bodyRegular.copyWith(fontWeight: FontWeight.w600);
    final unselectedLabelStyle = isNivel1 ? AppTypography.bodyRegular : AppTypography.smallRegular;

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final widths = tabs.map((final tab) {
          var width = 48.0;
          for (final style in [labelStyle, unselectedLabelStyle]) {
            final painter = TextPainter(
              text: TextSpan(text: tab.label, style: style),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
              maxLines: 1,
            )..layout();
            final paddedWidth = painter.width.ceilToDouble() + 32;
            if (paddedWidth > width) width = paddedWidth;
            painter.dispose();
          }
          return width;
        }).toList();
        final totalWidth = widths.fold(0.0, (final sum, final width) => sum + width);
        final extraWidth = constraints.hasBoundedWidth && constraints.maxWidth > totalWidth ? (constraints.maxWidth - totalWidth) / tabs.length : 0.0;

        return TabBar(
          controller: controller,
          isScrollable: scrollable,
          tabAlignment: scrollable ? TabAlignment.start : TabAlignment.fill,
          labelPadding: isScrollable ? EdgeInsets.zero : null,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: labelStyle,
          unselectedLabelStyle: unselectedLabelStyle,
          tabs: tabs.asMap().entries.map((final entry) {
            final tab = entry.value;
            final text = Text(tab.label, textAlign: TextAlign.center);
            final child = Tab(
              icon: tab.icon != null ? ExcludeSemantics(child: Icon(tab.icon, size: 20)) : null,
              child: tab.semanticsLabel == null
                  ? text
                  : Semantics(
                      label: tab.semanticsLabel,
                      child: ExcludeSemantics(child: text),
                    ),
            );
            return isScrollable ? SizedBox(width: widths[entry.key] + extraWidth, child: child) : child;
          }).toList(),
        );
      },
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
  }) : assert(primaryLabel != '', 'primaryLabel must not be empty'),
       assert(
         secondaryLabel == null || secondaryLabel != '',
         'secondaryLabel must not be empty',
       ),
       assert(
         onSecondary == null || secondaryLabel != null || type == AppStickyBarType.dicotomy,
         'secondaryLabel is required when onSecondary is provided',
       );

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
    final l10n = AppLocalizations.of(context);
    final effectiveSecondaryLabel = type == AppStickyBarType.dicotomy ? secondaryLabel ?? l10n.a11yCancel : secondaryLabel;
    final useVerticalLayout = type == AppStickyBarType.vertical || MediaQuery.textScalerOf(context).scale(1) > 1.5;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: l10n.a11yStickybarLabel,
      child: Container(
        padding: appPagePadding(
          context,
          top: AppDimensions.space16,
          bottom: AppDimensions.space16 + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E2E1)),
          ),
          boxShadow: AppShadows.low,
        ),
        child: useVerticalLayout ? _buildVertical(effectiveSecondaryLabel) : _buildHorizontal(effectiveSecondaryLabel),
      ),
    );
  }

  Widget _buildHorizontal(final String? effectiveSecondaryLabel) {
    return Row(
      children: [
        if (effectiveSecondaryLabel != null) ...[
          Expanded(
            child: Semantics(
              sortKey: const OrdinalSortKey(1),
              child: AppButton(
                label: effectiveSecondaryLabel,
                onPressed: onSecondary,
                hierarchy: secondaryHierarchy,
                leadingIcon: secondaryLeadingIcon,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space12),
        ],
        Expanded(
          flex: type == AppStickyBarType.flow && effectiveSecondaryLabel != null ? 2 : 1,
          child: Semantics(
            sortKey: const OrdinalSortKey(2),
            child: AppButton(
              label: primaryLabel,
              onPressed: onPrimary,
              isLoading: isPrimaryLoading,
              leadingIcon: primaryLeadingIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVertical(final String? effectiveSecondaryLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (effectiveSecondaryLabel != null) ...[
          Semantics(
            sortKey: const OrdinalSortKey(1),
            child: AppButton(
              label: effectiveSecondaryLabel,
              onPressed: onSecondary,
              hierarchy: secondaryHierarchy,
              leadingIcon: secondaryLeadingIcon,
              isExpanded: true,
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
        ],
        Semantics(
          sortKey: const OrdinalSortKey(2),
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            isLoading: isPrimaryLoading,
            leadingIcon: primaryLeadingIcon,
            isExpanded: true,
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
    this.semanticLabel,
    this.isDisabled = false,
  }) : assert(label != '', 'label must not be empty'),
       assert(description == null || description != '', 'description must not be empty'),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty'),
       assert(
         (icon == null) != (iconAsset == null),
         'Provide exactly one of icon or iconAsset',
       );

  final String label;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback? onTap;
  final String? description;
  final String? semanticLabel;
  final bool isDisabled;

  @override
  Widget build(final BuildContext context) {
    final isEnabled = !isDisabled && onTap != null;
    final bgColor = isEnabled ? AppColors.surface : const Color(0xFFE5E2E1);
    final titleColor = isEnabled ? AppColors.primary : AppColors.textDisabled;
    final descColor = isEnabled ? AppColors.primary : AppColors.textDisabled;
    final leadingBg = isEnabled ? const Color(0xFFF1F8F9) : Colors.black.withValues(alpha: 0.05);
    final iconColor = isEnabled ? AppColors.primary : AppColors.textDisabled;

    return Semantics(
      button: true,
      label: semanticLabel ?? [label, if (description != null) description].join('. '),
      enabled: isEnabled,
      onTap: isEnabled ? onTap : null,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: isEnabled ? onTap : null,
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
                color: isEnabled ? const Color(0xFFA0B2C5) : Colors.black.withValues(alpha: 0.08),
              ),
              boxShadow: isEnabled ? AppShadows.medium : const <BoxShadow>[],
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
    this.semanticLabel,
  }) : assert(label != '', 'label must not be empty'),
       assert(description != '', 'description must not be empty'),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final String label;
  final String description;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? '$label. $description',
      enabled: onTap != null,
      onTap: onTap,
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
                        style: AppTypography.leadingMedium.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        description,
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
    required this.onTap,
    super.key,
    this.icon,
    this.iconAsset,
    this.semanticLabel,
  }) : assert(label != '', 'label must not be empty'),
       assert(
         (icon == null) != (iconAsset == null),
         'Provide exactly one of icon or iconAsset',
       ),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final String label;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      enabled: onTap != null,
      onTap: onTap,
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
                      child: iconAsset == null
                          ? AppIcon(
                              icon!,
                              size: 40,
                              color: AppColors.primary,
                            )
                          : AppSvgIcon(
                              iconAsset!,
                              size: 32,
                              color: AppColors.primary,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Center(
                    child: Text(
                      label,
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
    this.scrollable = false,
    this.padding = const EdgeInsets.all(AppDimensions.space8),
    this.tabHorizontalPadding = AppDimensions.space8,
    this.spacing = AppDimensions.space8,
    this.compact = false,
    this.tabMinHeight = AppDimensions.minTouchTarget,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<bool>? enabledTabs;
  final List<double>? minTabWidths;
  final Widget? leading;
  final Widget? trailing;
  final bool scrollable;
  final EdgeInsetsGeometry padding;
  final double tabHorizontalPadding;
  final double spacing;
  final bool compact;
  final double tabMinHeight;

  @override
  Widget build(final BuildContext context) {
    assert(tabs.isNotEmpty, 'tabs must not be empty');
    assert(tabs.every((final tab) => tab.isNotEmpty), 'tab labels must not be empty');
    assert(
      selectedIndex == -1 || (selectedIndex >= 0 && selectedIndex < tabs.length),
      'selectedIndex is out of range',
    );
    assert(
      enabledTabs == null || enabledTabs!.length == tabs.length,
      'enabledTabs must match tabs length',
    );
    assert(
      minTabWidths == null || minTabWidths!.length == tabs.length,
      'minTabWidths must match tabs length',
    );

    final tabsContent = List.generate(tabs.length, (final int index) {
      final bool isSelected = index == selectedIndex;
      final bool isEnabled = enabledTabs?[index] ?? true;
      return _FloatingNavTab(
        label: tabs[index],
        isSelected: isSelected,
        isEnabled: isEnabled,
        minWidth: minTabWidths?[index] ?? AppDimensions.minTouchTarget,
        horizontalPadding: tabHorizontalPadding,
        compact: compact,
        minHeight: tabMinHeight,
        onTap: () => onTabSelected(index),
      );
    });
    final usesScrollableLayout = scrollable || MediaQuery.textScalerOf(context).scale(1) > 1.5;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderNeutralLight),
      ),
      child: usesScrollableLayout
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: spacing,
                children: [?leading, ...tabsContent, ?trailing],
              ),
            )
          : Row(
              spacing: spacing,
              children: [
                ?leading,
                ...tabsContent.indexed.map(
                  (final entry) => entry.$1 == selectedIndex ? entry.$2 : Expanded(child: entry.$2),
                ),
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
    this.semanticLabel,
  }) : assert(label != '', 'label must not be empty'),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty'),
       assert(
         (icon == null) != (iconAsset == null),
         'Provide exactly one of icon or iconAsset',
       );

  final String label;

  /// Icon token — use a constant from [AppIcons].
  final IconData? icon;

  /// SVG icon asset — use a constant from [AppIconAssets].
  final String? iconAsset;

  /// Alternative pronunciation for abbreviations or ambiguous labels.
  final String? semanticLabel;
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
    assert(items.isNotEmpty, 'items must not be empty');
    assert(
      currentIndex >= 0 && currentIndex < items.length,
      'currentIndex is out of range',
    );
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final usesScrollableLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final tabs = List.generate(items.length, (final int index) {
      final item = items[index];
      final isSelected = index == currentIndex;
      final icon = item.iconAsset == null ? AppIcon(item.icon!, color: AppColors.textWhite) : AppSvgIcon(item.iconAsset!, color: AppColors.textWhite);
      final tab = Semantics(
        container: true,
        sortKey: OrdinalSortKey(index.toDouble()),
        button: true,
        label: item.semanticLabel ?? item.label,
        selected: isSelected,
        onTap: () => onTap(index),
        child: ExcludeSemantics(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(index),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
                child: SizedBox(
                  height: usesScrollableLayout
                      ? null
                      : isLandscape
                      ? 56
                      : AppDimensions.bottomNavHeight,
                  child: usesScrollableLayout || isLandscape
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.space8,
                                vertical: AppDimensions.space8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  icon,
                                  const SizedBox(width: AppDimensions.space8),
                                  Flexible(
                                    child: Text(
                                      item.label,
                                      style: AppTypography.smallRegular.copyWith(
                                        color: AppColors.textWhite,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: _BottomTabIndicator(isSelected: isSelected),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            icon,
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
                            _BottomTabIndicator(isSelected: isSelected),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      );
      return usesScrollableLayout ? SizedBox(width: 160, child: tab) : tab;
    });

    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.space4,
        right: AppDimensions.space4,
        top: AppDimensions.space4,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      color: AppColors.primary,
      child: usesScrollableLayout
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: tabs),
            )
          : Row(children: tabs.map((final tab) => Expanded(child: tab)).toList()),
    );
  }
}

// ── AppFab ────────────────────────────────────────────────────────────────────

class _BottomTabIndicator extends StatelessWidget {
  const _BottomTabIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(final BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    height: 4,
    width: 24,
    decoration: BoxDecoration(
      color: isSelected ? AppColors.secondaryLight300 : Colors.transparent,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXs)),
    ),
  );
}

/// A dark FAB matching the compact and extended Figma variants.
///
/// The extended variant uses a 48 dp-high pill with a 24 dp icon and label.
class AppFab extends StatelessWidget {
  const AppFab({
    required this.onPressed,
    super.key,
    this.icon,
    this.iconAsset,
    this.iconSize = 20,
    this.label,
    this.semanticsLabel,
  }) : assert(
         (icon == null) != (iconAsset == null),
         'Provide exactly one of icon or iconAsset',
       ),
       assert(iconSize > 0, 'iconSize must be greater than zero'),
       assert(label == null || label != '', 'label must not be empty'),
       assert(semanticsLabel == null || semanticsLabel != '', 'semanticsLabel must not be empty'),
       assert(label != null || semanticsLabel != null, 'Compact FABs require a semanticsLabel');

  final IconData? icon;
  final String? iconAsset;
  final double iconSize;
  final String? label;
  final VoidCallback? onPressed;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final isExtended = label != null;
    final borderRadius = BorderRadius.circular(AppDimensions.radiusRound);
    final isEnabled = onPressed != null;

    return Semantics(
      container: true,
      button: true,
      label: semanticsLabel ?? label,
      enabled: isEnabled,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: isExtended ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: isExtended ? borderRadius : null,
            boxShadow: isEnabled ? AppShadows.high : const <BoxShadow>[],
          ),
          child: Material(
            color: isEnabled ? AppColors.primary : AppColors.textDisabled,
            shape: isExtended ? const StadiumBorder() : const CircleBorder(),
            child: InkWell(
              onTap: onPressed,
              customBorder: isExtended ? null : const CircleBorder(),
              borderRadius: isExtended ? borderRadius : null,
              child: isExtended
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space16,
                          vertical: AppDimensions.space8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _AppFabIcon(
                              icon: icon,
                              iconAsset: iconAsset,
                              size: iconSize,
                            ),
                            const SizedBox(width: AppDimensions.space4),
                            Flexible(
                              child: Text(
                                label!,
                                style: AppTypography.bodyRegular.copyWith(
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 56,
                      height: 56,
                      child: Center(
                        child: _AppFabIcon(
                          icon: icon,
                          iconAsset: iconAsset,
                          size: iconSize,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppFabIcon extends StatelessWidget {
  const _AppFabIcon({
    required this.icon,
    required this.iconAsset,
    required this.size,
  });

  final IconData? icon;
  final String? iconAsset;
  final double size;

  @override
  Widget build(final BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Center(
        child: iconAsset == null
            ? AppIcon(icon!, color: AppColors.textWhite, size: size)
            : AppSvgIcon(
                iconAsset!,
                color: AppColors.textWhite,
                size: size,
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
    required this.horizontalPadding,
    required this.compact,
    required this.minHeight,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isEnabled;
  final double minWidth;
  final double horizontalPadding;
  final bool compact;
  final double minHeight;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.backgroundBlueLighter
        : isEnabled
        ? AppColors.surface
        : AppColors.background;
    final borderColor = isSelected
        ? AppColors.primaryDark
        : isEnabled
        ? AppColors.neutral500
        : Colors.transparent;
    final textStyle = isSelected
        ? (compact ? AppTypography.smallBold : AppTypography.bodyBold).copyWith(color: AppColors.textBlack)
        : isEnabled
        ? (compact ? AppTypography.smallRegular : AppTypography.bodyRegular).copyWith(color: AppColors.textBlack)
        : (compact ? AppTypography.smallRegular : AppTypography.bodyRegular).copyWith(color: AppColors.textDisabled);

    return Semantics(
      container: true,
      button: true,
      label: label,
      selected: isSelected,
      enabled: isEnabled,
      onTap: isEnabled ? onTap : null,
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: minHeight,
          ),
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
              onTap: isEnabled ? onTap : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.space8,
                ).copyWith(left: horizontalPadding, right: horizontalPadding),
                child: Center(
                  child: Text(
                    label,
                    style: textStyle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
