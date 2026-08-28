import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const AppHeaderBar({
    required this.title,
    required this.onBack,
    super.key,
    this.onInfo,
    this.actions = const [],
    this.backgroundColor = AppColors.backgroundWhite,
    this.leadingIcon = AppIcons.arrowBack,
    this.leadingTooltip,
    this.infoTooltip,
    this.titleSemanticsLabel,
  }) : assert(title != '', 'title must not be empty'),
       assert(
         leadingTooltip == null || leadingTooltip != '',
         'leadingTooltip must not be empty',
       ),
       assert(infoTooltip == null || infoTooltip != '', 'infoTooltip must not be empty'),
       assert(
         titleSemanticsLabel == null || titleSemanticsLabel != '',
         'titleSemanticsLabel must not be empty',
       );

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onInfo;
  final List<Widget> actions;
  final Color backgroundColor;
  final IconData leadingIcon;
  final String? leadingTooltip;
  final String? infoTooltip;
  final String? titleSemanticsLabel;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final semanticTitle = titleSemanticsLabel ?? title;

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
          Semantics(
            header: true,
            headingLevel: 1,
            sortKey: const OrdinalSortKey(0),
            label: semanticTitle,
            child: const SizedBox(width: 1, height: 1),
          ),
          IconButton(
            icon: AppIcon(leadingIcon, size: AppDimensions.iconLarge, color: AppColors.textPrimary),
            onPressed: onBack,
            tooltip: leadingTooltip ?? l10n.a11yBack,
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                title,
                maxLines: 2,
                style: AppTypography.h3.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          ...actions,
          if (onInfo != null)
            IconButton(
              icon: const AppIcon(AppIcons.info, color: AppColors.textPrimary),
              onPressed: onInfo,
              tooltip: infoTooltip ?? l10n.a11yInformation,
            ),
        ],
      ),
    );
  }
}
