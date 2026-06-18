import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════════════════════════════════════

/// Semantic severity used by all alert components.
enum AppAlertSeverity { neutral, success, error, warning }

/// Size variant for [AppAlertContextual].
enum AppAlertContextualSize { medium, small }

// ═══════════════════════════════════════════════════════════════════════════════
// APP ALERT BANNER  (Figma "Alerts/ Banner" 82:3533)
// ═══════════════════════════════════════════════════════════════════════════════

/// Persistent in-page alert placed under the header. Must be dismissed manually.
///
/// Variants: neutral (blue-muted), warning (amber), error (red).
/// Layout: icon + captionUppercase title + close X button / indented body / action.
///
/// Example:
/// ```dart
/// AppAlertBanner(
///   severity: AppAlertSeverity.warning,
///   title: 'Sin conexión',
///   message: 'Comprueba tu conexión a internet.',
///   onDismiss: () {},
///   action: TextButton(onPressed: () {}, child: const Text('Reintentar')),
/// )
/// ```
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
    final (bg, titleColor, borderColor, icon) = _tokens(severity);

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.high,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppIcon(icon, color: titleColor),
                const SizedBox(width: AppDimensions.space8),
                Expanded(
                  child: Text(
                    (title ?? _defaultTitle(severity)).toUpperCase(),
                    style: AppTypography.captionUppercase.copyWith(
                      color: titleColor,
                    ),
                  ),
                ),
                if (onDismiss != null)
                  SizedBox(
                    width: AppDimensions.minTouchTarget,
                    height: AppDimensions.minTouchTarget,
                    child: InkWell(
                      onTap: onDismiss,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      child: Center(
                        child: AppIcon(
                          AppIcons.close,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Body indented by 32 dp (24 icon + 8 gap)
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.space32,
                top: AppDimensions.space4,
              ),
              child: Text(
                message,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textBlack,
                ),
              ),
            ),
            if (action != null) Align(alignment: Alignment.centerRight, child: action),
          ],
        ),
      ),
    );
  }

  static String _defaultTitle(final AppAlertSeverity severity) => switch (severity) {
    AppAlertSeverity.warning => 'Sin conexión a internet',
    AppAlertSeverity.error => 'Error',
    _ => 'Aviso del sistema',
  };

  static (Color bg, Color fg, Color border, IconData icon) _tokens(
    final AppAlertSeverity severity,
  ) => switch (severity) {
    AppAlertSeverity.neutral || AppAlertSeverity.success => (
      AppColors.backgroundBlueMutedLight,
      AppColors.blueMuted900,
      AppColors.borderBlueMutedLight,
      AppIcons.info,
    ),
    AppAlertSeverity.warning => (
      AppColors.warningLight,
      AppColors.warningDark,
      AppColors.borderWarning,
      AppIcons.warning,
    ),
    AppAlertSeverity.error => (
      AppColors.errorLight,
      AppColors.errorDark,
      AppColors.borderError,
      AppIcons.cancel,
    ),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP ALERT CONTEXTUAL HELPER  (Figma "Alerts/ ContextualHelper" 85:2697)
// ═══════════════════════════════════════════════════════════════════════════════

/// Persistent inline contextual hint near a field or section.
///
/// Sizes: [AppAlertContextualSize.medium] (bodyRegular 16 dp) and
/// [AppAlertContextualSize.small] (smallRegular 14 dp).
/// Layout:
/// - `horizontal = true`: icon + text row, action at far right.
/// - `horizontal = false`: icon + text column, action right-aligned below.
///
/// Example:
/// ```dart
/// AppAlertContextual(
///   message: 'Introduce tu NIF sin guiones ni espacios.',
///   size: AppAlertContextualSize.small,
///   horizontal: true,
/// )
/// ```
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
    final textStyle = size == AppAlertContextualSize.medium ? AppTypography.bodyRegular.copyWith(color: AppColors.primaryDark) : AppTypography.smallRegular.copyWith(color: AppColors.primaryDark);

    final textWidget = title == null
        ? Text(message, style: textStyle)
        : Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title ',
                  style: textStyle.copyWith(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: message, style: textStyle),
              ],
            ),
          );

    final contentRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppIcon(
          AppIcons.info,
          color: AppColors.primaryDark,
        ),
        const SizedBox(width: AppDimensions.space8),
        Expanded(child: textWidget),
      ],
    );

    final body = horizontal
        ? Row(
            children: [
              Expanded(child: contentRow),
              if (action != null) ...[
                const SizedBox(width: AppDimensions.space4),
                action!,
              ],
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(alignment: Alignment.centerLeft, child: contentRow),
              if (action != null) ...[
                const SizedBox(height: AppDimensions.space16),
                action!,
              ],
            ],
          );

    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space4,
          vertical: AppDimensions.space8,
        ),
        child: body,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP ALERT TOAST  (Figma "Alerts/ Toast" 83:3210)
// ═══════════════════════════════════════════════════════════════════════════════

/// Auto-dismissing dark pill notification (max 2 s). No action button.
///
/// Variants: neutral (info), success (check_circle), error (cancel).
///
/// Use [AppAlertToast.show] to display via [ScaffoldMessenger]:
/// ```dart
/// AppAlertToast.show(context, message: 'Copiado en el portapapeles');
/// ```
class AppAlertToast extends StatelessWidget {
  const AppAlertToast({
    required this.message,
    super.key,
    this.severity = AppAlertSeverity.neutral,
  });

  final AppAlertSeverity severity;
  final String message;

  /// Shows this toast via [ScaffoldMessenger]. Auto-dismisses after [duration].
  static void show(
    final BuildContext context, {
    required final String message,
    final AppAlertSeverity severity = AppAlertSeverity.neutral,
    final Duration duration = const Duration(seconds: 2),
  }) {
    final icon = _icon(severity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        duration: duration,
        content: Row(
          children: [
            AppIcon(icon, color: Colors.white),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyBold.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          side: const BorderSide(color: AppColors.borderBlueMutedBase),
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
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          border: Border.all(color: AppColors.borderBlueMutedBase),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.high,
        ),
        child: Row(
          children: [
            AppIcon(icon, color: Colors.white),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyBold.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _icon(final AppAlertSeverity severity) => switch (severity) {
    AppAlertSeverity.neutral => AppIcons.info,
    AppAlertSeverity.success => AppIcons.checkCircle,
    AppAlertSeverity.error => AppIcons.cancel,
    AppAlertSeverity.warning => AppIcons.warning,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP ALERT SNACKBAR  (Figma "Alerts/ Snackbar" 83:2757)
// ═══════════════════════════════════════════════════════════════════════════════

/// Auto-dismissing dark pill (max 2 s) with one quick reversible action.
///
/// Neutral: no leading icon. Success/Error: status icon on the left.
///
/// Use [AppAlertSnackbar.show] via [ScaffoldMessenger]:
/// ```dart
/// AppAlertSnackbar.show(
///   context,
///   message: 'Cambios guardados',
///   actionLabel: 'Deshacer',
///   onAction: () {},
/// );
/// ```
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

  /// Shows this snackbar via [ScaffoldMessenger].
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    final BuildContext context, {
    required final String message,
    final AppAlertSeverity severity = AppAlertSeverity.neutral,
    final String? actionLabel,
    final VoidCallback? onAction,
    final EdgeInsetsGeometry? margin,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 5),
        elevation: 0,
        padding: EdgeInsets.zero,
        content: AppAlertSnackbar(
          message: message,
          severity: severity,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
        behavior: SnackBarBehavior.floating,
        margin: margin,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final icon = _icon(severity);

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          border: Border.all(color: AppColors.borderBlueMutedBase),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.high,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              AppIcon(icon, color: Colors.white),
              const SizedBox(width: AppDimensions.space8),
            ],
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyBold.copyWith(color: Colors.white),
              ),
            ),
            if (actionLabel != null)
              Padding(
                padding: const EdgeInsets.only(left: AppDimensions.space4),
                child: TextButton(
                  onPressed: onAction ?? () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space8,
                      vertical: AppDimensions.space8,
                    ),
                    minimumSize: const Size(48, 40),
                  ),
                  child: Text(
                    actionLabel!,
                    style: AppTypography.bodyRegular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static IconData? _icon(final AppAlertSeverity severity) => switch (severity) {
    AppAlertSeverity.success => AppIcons.checkCircle,
    AppAlertSeverity.error => AppIcons.cancel,
    _ => null,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP ALERT DIALOG  (Figma "Alerts/ Dialog" 83:3263)
// ═══════════════════════════════════════════════════════════════════════════════

/// Modal dialog with dark scrim. Highest interrupt level — user must respond.
///
/// Always has two buttons: [cancelLabel] (secondary) and [confirmLabel] (primary).
/// Optional slots: icon avatar, H3 [title], bodyRegular [description],
/// checkbox row, full-width tertiary [infoLabel] button.
///
/// Example via [AppAlertDialog.show]:
/// ```dart
/// final confirmed = await AppAlertDialog.show(
///   context,
///   title: 'Cerrar sesión',
///   description: 'Vas a cerrar la sesión en este dispositivo.',
///   confirmLabel: 'Aceptar',
///   cancelLabel: 'Cancelar',
/// );
/// if (confirmed == true) logout();
/// ```
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
    super.key,
    this.title,
    this.description,
    this.icon,
    this.showIconContainer = true,
    this.infoLabel,
    this.onInfo,
    this.checkboxLabel,
    this.isChecked = false,
    this.onCheckboxChanged,
  });

  /// Icon inside the circular avatar. Defaults to [AppIcons.info].
  final IconData? icon;

  /// Show the blue-muted avatar circle above the title. Defaults to `true`.
  final bool showIconContainer;

  /// H3 title (centered).
  final String? title;

  /// bodyRegular description text.
  final String? description;

  /// Optional full-width tertiary button label (e.g. 'Más información').
  final String? infoLabel;
  final VoidCallback? onInfo;

  /// Checkbox row label (leadingMedium). Shown only when non-null.
  final String? checkboxLabel;
  final bool isChecked;
  final ValueChanged<bool>? onCheckboxChanged;

  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  /// Displays this dialog and returns `true` on confirm, `false` on cancel.
  static Future<bool?> show(
    final BuildContext context, {
    required final String confirmLabel,
    required final String cancelLabel,
    final String? title,
    final String? description,
    final IconData? icon,
    final bool showIconContainer = true,
    final String? infoLabel,
    final VoidCallback? onInfo,
    final String? checkboxLabel,
    final bool isChecked = false,
    final ValueChanged<bool>? onCheckboxChanged,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final ctx) => AppAlertDialog(
        title: title,
        description: description,
        icon: icon,
        showIconContainer: showIconContainer,
        infoLabel: infoLabel,
        onInfo: onInfo,
        checkboxLabel: checkboxLabel,
        isChecked: isChecked,
        onCheckboxChanged: onCheckboxChanged,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space64,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderBlueMutedLight),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.overAll,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showIconContainer) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.space8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundBlueMutedLight,
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: AppIcon(
                    icon ?? AppIcons.info,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space8),
            ],
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: AppTypography.h3.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppDimensions.space8),
            ],
            if (description != null) ...[
              Text(
                description!,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.space8),
            ],
            if (checkboxLabel != null) ...[
              _DialogCheckboxRow(
                label: checkboxLabel!,
                isChecked: isChecked,
                onChanged: onCheckboxChanged,
              ),
              const SizedBox(height: AppDimensions.space8),
            ],
            _DialogActions(
              infoLabel: infoLabel,
              onInfo: onInfo,
              confirmLabel: confirmLabel,
              cancelLabel: cancelLabel,
              onConfirm: onConfirm,
              onCancel: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}

/// Destructive confirmation dialog matching the Figma `Alerts/Dialog` danger
/// variant.
///
/// Use this for irreversible or session-impacting actions. The dialog is
/// blocking and always presents a cancel action plus a destructive primary
/// action.
class AppDestructiveConfirmDialog extends StatelessWidget {
  const AppDestructiveConfirmDialog({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
    super.key,
    this.icon = AppIcons.info,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final IconData icon;

  /// Displays this dialog and returns `true` on confirm, `false` on cancel.
  static Future<bool?> show(
    final BuildContext context, {
    required final String title,
    required final String description,
    required final String confirmLabel,
    required final String cancelLabel,
    final IconData icon = AppIcons.info,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final ctx) => AppDestructiveConfirmDialog(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        icon: icon,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space64,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.borderBlueMutedLight),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.overAll,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.space8),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(64),
                ),
                child: AppIcon(
                  icon,
                  color: AppColors.errorDark,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.h3.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.space24),
            Text(
              description,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.space16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: cancelLabel,
                    hierarchy: AppButtonHierarchy.tertiary,
                    isExpanded: true,
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(width: AppDimensions.space16),
                Expanded(
                  child: AppButton(
                    label: confirmLabel,
                    intent: AppButtonIntent.destructive,
                    isExpanded: true,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Biometric quick-access opt-in dialog.
///
/// Built from existing design-system pieces: [AppAlertDialog], [AppButton],
/// [AppIcon], and [AppIcons.fingerprint].
class AppBiometricAccessDialog {
  const AppBiometricAccessDialog._();

  static const title = '¿Quieres activar el acceso rápido con huella/reconocimiento facial?';
  static const description = 'Esto te permitirá entrar en la aplicación sin la necesidad de autenticarte. Cada cierto tiempo se te pedirá autenticación para mantener siempre tus datos a salvo.';
  static const cancelLabel = 'Cancelar';
  static const confirmLabel = 'Activar';

  static Future<bool?> show(final BuildContext context) {
    return AppAlertDialog.show(
      context,
      icon: AppIcons.fingerprint,
      title: title,
      description: description,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    );
  }
}

// ─── Dialog internals ─────────────────────────────────────────────────────────

class _DialogCheckboxRow extends StatelessWidget {
  const _DialogCheckboxRow({
    required this.label,
    required this.isChecked,
    this.onChanged,
  });

  final String label;
  final bool isChecked;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space16),
      child: InkWell(
        onTap: () => onChanged?.call(!isChecked),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isChecked ? Icons.check_box_outlined : Icons.check_box_outline_blank,
              size: AppDimensions.iconMedium,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                label,
                style: AppTypography.leadingMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  const _DialogActions({
    required this.confirmLabel,
    required this.cancelLabel,
    this.infoLabel,
    this.onInfo,
    this.onConfirm,
    this.onCancel,
  });

  final String? infoLabel;
  final VoidCallback? onInfo;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (infoLabel != null) ...[
          AppButton(
            label: infoLabel!,
            onPressed: onInfo,
            hierarchy: AppButtonHierarchy.tertiary,
            leadingIcon: AppIcons.help,
          ),
          const SizedBox(height: AppDimensions.space16),
        ],
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppDimensions.minTouchTarget,
                child: AppButton(
                  label: cancelLabel,
                  onPressed: onCancel,
                  hierarchy: AppButtonHierarchy.tertiary,
                  leadingIcon: AppIcons.cancel,
                  isExpanded: true,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space16),
            Expanded(
              child: SizedBox(
                height: AppDimensions.minTouchTarget,
                child: AppButton(
                  label: confirmLabel,
                  onPressed: onConfirm,
                  leadingIcon: AppIcons.check,
                  isExpanded: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
