import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const AppHeaderBar({
    required this.title,
    required this.onBack,
    super.key,
    this.onInfo,
    this.backgroundColor = AppColors.backgroundWhite,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onInfo;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 64,
      titleSpacing: 0,
      shape: const Border(
        bottom: BorderSide(color: AppColors.backgroundBlueMutedLight),
      ),
      title: Row(
        children: [
          IconButton(
            icon: const AppIcon(AppIcons.arrowBack, size: AppDimensions.iconLarge, color: AppColors.textPrimary),
            onPressed: onBack,
            tooltip: 'Volver',
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.h3.copyWith(color: AppColors.primary),
            ),
          ),
          if (onInfo != null)
            IconButton(
              icon: const AppIcon(AppIcons.info, color: AppColors.textPrimary),
              onPressed: onInfo,
              tooltip: 'Información',
            ),
        ],
      ),
    );
  }
}
