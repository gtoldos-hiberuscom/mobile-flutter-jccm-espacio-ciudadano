import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';

enum AppAlertSeverity { neutral, success, error, warning }

class AppAlertBanner extends StatelessWidget {
  const AppAlertBanner({
    required this.message,
    super.key,
    this.severity = AppAlertSeverity.neutral,
    this.title,
    this.onDismiss,
    this.action,
  });

  final AppAlertSeverity severity;
  final String? title;
  final String message;
  final VoidCallback? onDismiss;
  final Widget? action;

  @override
  Widget build(final BuildContext context) {
    final (bg, fg, icon) = _tokens(severity);

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: fg, width: 1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.high,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: fg, size: AppDimensions.iconMedium),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!.toUpperCase(),
                      style: AppTypography.caption.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.15,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space4),
                  ],
                  Text(
                    message,
                    style: AppTypography.bodyBase.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  if (action != null) ...[
                    const SizedBox(height: AppDimensions.space8),
                    action!,
                  ],
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded),
                color: fg,
                tooltip: 'Cerrar',
              ),
          ],
        ),
      ),
    );
  }

  static (Color bg, Color fg, IconData icon) _tokens(
    final AppAlertSeverity severity,
  ) => switch (severity) {
    AppAlertSeverity.neutral || AppAlertSeverity.success => (
      const Color(0xFFE0E5EB),
      const Color(0xFF678098),
      Icons.info_outline_rounded,
    ),
    AppAlertSeverity.warning => (
      const Color(0xFFFCE4BF),
      const Color(0xFF8E5806),
      Icons.warning_amber_rounded,
    ),
    AppAlertSeverity.error => (
      const Color(0xFFF9E1E1),
      const Color(0xFFA31F1F),
      Icons.cancel_outlined,
    ),
  };
}

enum AppAlertContextualSize { medium, small }

class AppAlertContextual extends StatelessWidget {
  const AppAlertContextual({
    required this.message,
    super.key,
    this.severity = AppAlertSeverity.neutral,
    this.size = AppAlertContextualSize.medium,
    this.horizontal = false,
    this.title,
    this.action,
  });

  final AppAlertSeverity severity;
  final String? title;
  final String message;
  final AppAlertContextualSize size;
  final bool horizontal;
  final Widget? action;

  @override
  Widget build(final BuildContext context) {
    final (color, icon) = _contextualTokens(severity);
    final textStyle = size == AppAlertContextualSize.medium ? AppTypography.bodyBase : AppTypography.bodyS;

    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: size == AppAlertContextualSize.medium ? AppDimensions.iconMedium : AppDimensions.iconSmall,
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: title == null
                ? Text(
                    message,
                    style: textStyle.copyWith(color: AppColors.primary),
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${title!} ',
                          style: textStyle.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: message,
                          style: textStyle.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppDimensions.space8),
            action!,
          ],
        ],
      ),
    );
  }

  static (Color color, IconData icon) _contextualTokens(
    final AppAlertSeverity severity,
  ) => switch (severity) {
    AppAlertSeverity.neutral => (
      AppColors.neutralDark,
      Icons.info_outline_rounded,
    ),
    AppAlertSeverity.success => (
      const Color(0xFF297047),
      Icons.check_circle_outline_rounded,
    ),
    AppAlertSeverity.warning => (
      const Color(0xFF8E5806),
      Icons.warning_amber_rounded,
    ),
    AppAlertSeverity.error => (
      const Color(0xFFA31F1F),
      Icons.cancel_outlined,
    ),
  };
}

class AppAlertToast extends StatelessWidget {
  const AppAlertToast({
    required this.message,
    super.key,
    this.severity = AppAlertSeverity.neutral,
  });

  final AppAlertSeverity severity;
  final String message;

  static void show(
    final BuildContext context, {
    required final String message,
    final AppAlertSeverity severity = AppAlertSeverity.neutral,
    final Duration duration = const Duration(seconds: 2),
  }) {
    final (_, icon) = _tokens(severity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        duration: duration,
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: AppDimensions.iconMedium),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyBase.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          side: const BorderSide(color: AppColors.neutralDark),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final (_, icon) = _tokens(severity);

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          border: Border.all(color: AppColors.neutralDark),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.high,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: AppDimensions.iconMedium),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyBase.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static (Color bg, IconData icon) _tokens(final AppAlertSeverity severity) => switch (severity) {
    AppAlertSeverity.neutral => (
      AppColors.primaryDark,
      Icons.info_outline_rounded,
    ),
    AppAlertSeverity.success => (
      AppColors.primaryDark,
      Icons.check_circle_outline_rounded,
    ),
    AppAlertSeverity.error => (
      AppColors.primaryDark,
      Icons.cancel_outlined,
    ),
    AppAlertSeverity.warning => (
      AppColors.primaryDark,
      Icons.warning_amber_rounded,
    ),
  };
}

class AppAlertSnackbar extends StatelessWidget {
  const AppAlertSnackbar({
    required this.message,
    super.key,
    this.severity = AppAlertSeverity.neutral,
    this.actionLabel,
    this.onAction,
  });

  final AppAlertSeverity severity;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    final BuildContext context, {
    required final String message,
    final AppAlertSeverity severity = AppAlertSeverity.neutral,
    final String? actionLabel,
    final VoidCallback? onAction,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        duration: const Duration(seconds: 5),
        content: Text(
          message,
          style: AppTypography.bodyBase.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          side: const BorderSide(color: AppColors.neutralDark),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final icon = _icon(severity);

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          border: Border.all(color: AppColors.neutralDark),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.high,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: AppDimensions.iconMedium),
              const SizedBox(width: AppDimensions.space8),
            ],
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyBase.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (actionLabel != null)
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                hierarchy: AppButtonHierarchy.tertiary,
                size: AppButtonSize.small,
              ),
          ],
        ),
      ),
    );
  }

  static IconData? _icon(final AppAlertSeverity severity) => switch (severity) {
    AppAlertSeverity.success => Icons.check_circle_outline_rounded,
    AppAlertSeverity.error => Icons.cancel_outlined,
    _ => null,
  };
}
