import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';

class AppConfirmationState extends StatelessWidget {
  const AppConfirmationState({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    super.key,
    this.icon = AppIcons.checkCircle,
    this.iconColor = AppColors.successDark,
    this.semanticsLabel,
    this.announceChanges = true,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(message.length > 0, 'message must not be empty'),
       assert(actionLabel.length > 0, 'actionLabel must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final IconData icon;
  final Color iconColor;
  final String? semanticsLabel;
  final bool announceChanges;

  @override
  Widget build(final BuildContext context) {
    final effectiveSemanticsLabel = semanticsLabel ?? '$title. $message';

    return Center(
      child: SingleChildScrollView(
        padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              container: true,
              header: true,
              headingLevel: 1,
              liveRegion: announceChanges,
              label: effectiveSemanticsLabel,
              child: ExcludeSemantics(
                child: Column(
                  children: [
                    AppIcon(
                      icon,
                      size: AppDimensions.space64,
                      color: iconColor,
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.h2.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            AppButton(
              label: actionLabel,
              onPressed: onAction,
              hierarchy: AppButtonHierarchy.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
