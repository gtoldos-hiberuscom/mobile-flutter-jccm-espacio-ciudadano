import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
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
  });

  final AppNavBarType type;
  final String? title;
  final bool isLoggedIn;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  Color get _backgroundColor => switch (type) {
    AppNavBarType.grey => const Color(0xFFE0E5EB),
    AppNavBarType.detail => const Color(0xFFF1F8F9),
    _ => AppColors.surface,
  };

  Color get _foregroundColor => AppColors.textPrimary;

  Widget? get _leadingWidget {
    if (leading != null) {
      return leading;
    }

    return switch (type) {
      AppNavBarType.level2 || AppNavBarType.detail => IconButton(
        icon: Icon(
          type == AppNavBarType.detail ? Icons.close_rounded : Icons.arrow_back_rounded,
          color: _foregroundColor,
        ),
        onPressed: onBack ?? onClose,
        tooltip: type == AppNavBarType.detail ? 'Cerrar' : 'Volver',
      ),
      _ => null,
    };
  }

  List<Widget>? get _effectiveActions {
    final items = <Widget>[...?actions];

    if (isLoggedIn) {
      items.add(
        const Padding(
          padding: EdgeInsets.only(right: AppDimensions.space16),
          child: Center(
            child: AppAvatar(
              size: AppAvatarSize.small,
              semanticsLabel: 'Perfil',
            ),
          ),
        ),
      );
    }

    return items.isEmpty ? null : items;
  }

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      backgroundColor: _backgroundColor,
      foregroundColor: _foregroundColor,
      automaticallyImplyLeading: false,
      leading: _leadingWidget,
      title: title != null
          ? Text(
              title!,
              style: AppTypography.h3.copyWith(color: _foregroundColor),
            )
          : null,
      actions: _effectiveActions,
      elevation: 0,
      shadowColor: Colors.transparent,
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
      indicatorWeight: 2,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: isNivel1 ? AppTypography.bodyBold : AppTypography.bodyBase.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: isNivel1 ? AppTypography.bodyBase : AppTypography.bodyS,
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
  });

  final AppStickyBarType type;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool isPrimaryLoading;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space12,
        AppDimensions.space16,
        AppDimensions.space12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.high,
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
              hierarchy: AppButtonHierarchy.secondary,
            ),
          ),
          const SizedBox(width: AppDimensions.space12),
        ],
        Expanded(
          flex: secondaryLabel != null ? 2 : 1,
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            hierarchy: AppButtonHierarchy.primary,
            isLoading: isPrimaryLoading,
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
            hierarchy: AppButtonHierarchy.secondary,
          ),
        ),
        const SizedBox(width: AppDimensions.space12),
        Expanded(
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            hierarchy: AppButtonHierarchy.primary,
            isLoading: isPrimaryLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildVertical() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimary,
            hierarchy: AppButtonHierarchy.primary,
            isLoading: isPrimaryLoading,
          ),
        ),
        if (secondaryLabel != null) ...[
          const SizedBox(height: AppDimensions.space8),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: secondaryLabel!,
              onPressed: onSecondary,
              hierarchy: AppButtonHierarchy.tertiary,
            ),
          ),
        ],
      ],
    );
  }
}

enum AppStickyBarType { dicotomy, vertical, flow }

class AppNavCard extends StatelessWidget {
  const AppNavCard({
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
    this.description,
    this.isDisabled = false,
  });

  final String label;
  final IconData icon;
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
      label: label,
      enabled: !isDisabled,
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
                  child: Icon(
                    icon,
                    size: AppDimensions.iconMedium,
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
                      style: AppTypography.bodyL.copyWith(color: titleColor),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        description!,
                        style: AppTypography.bodyS.copyWith(color: descColor),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Icon(
                Icons.arrow_forward_rounded,
                size: AppDimensions.iconLarge,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
