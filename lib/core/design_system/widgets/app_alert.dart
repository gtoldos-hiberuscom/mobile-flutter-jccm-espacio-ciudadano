import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_modal_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

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
    this.semanticsLabel,
    this.announce = true,
    this.dismissSemanticsLabel,
  }) : assert(message.length > 0, 'message must not be empty'),
       assert(title == null || title.length > 0, 'title must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty'),
       assert(
         dismissSemanticsLabel == null || dismissSemanticsLabel.length > 0,
         'dismissSemanticsLabel must not be empty',
       );

  final AppAlertSeverity severity;
  final String? title;
  final String message;
  final VoidCallback? onDismiss;
  final Widget? action;
  final String? semanticsLabel;
  final bool announce;
  final String? dismissSemanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final (bg, titleColor, borderColor, icon) = _tokens(severity);
    final l10n = AppLocalizations.of(context);
    final effectiveTitle = title ?? _defaultTitle(l10n, severity);
    final alertLabel = semanticsLabel ?? l10n.a11yAlert(effectiveTitle, message);
    final dismissLabel = dismissSemanticsLabel ?? MaterialLocalizations.of(context).closeButtonTooltip;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.high,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                container: true,
                label: alertLabel,
                liveRegion: announce,
                child: const SizedBox(width: 1, height: 1),
              ),
              Row(
                children: [
                  ExcludeSemantics(child: AppIcon(icon, color: titleColor)),
                  const SizedBox(width: AppDimensions.space8),
                  Expanded(
                    child: Semantics(
                      header: true,
                      headingLevel: 2,
                      child: Text(
                        effectiveTitle.toUpperCase(),
                        style: AppTypography.captionUppercase.copyWith(
                          color: titleColor,
                        ),
                      ),
                    ),
                  ),
                  if (onDismiss != null)
                    Semantics(
                      label: dismissLabel,
                      button: true,
                      onTap: onDismiss,
                      child: ExcludeSemantics(
                        child: SizedBox(
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
                child: ExcludeSemantics(
                  child: Text(
                    message,
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
              ),
              if (action != null) Align(alignment: Alignment.centerRight, child: action),
            ],
          ),
        ),
      ),
    );
  }

  static String _defaultTitle(final AppLocalizations l10n, final AppAlertSeverity severity) => switch (severity) {
    AppAlertSeverity.neutral => l10n.a11yAlertNeutral,
    AppAlertSeverity.success => l10n.a11yAlertSuccess,
    AppAlertSeverity.warning => l10n.a11yAlertWarning,
    AppAlertSeverity.error => l10n.a11yAlertError,
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
    this.actionSpacing = AppDimensions.space16,
    this.semanticsLabel,
    this.announce = false,
  }) : assert(message.length > 0, 'message must not be empty'),
       assert(title == null || title.length > 0, 'title must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty'),
       assert(actionSpacing >= 0, 'actionSpacing must not be negative');

  final AppAlertSeverity severity;
  final String? title;
  final String message;
  final AppAlertContextualSize size;
  final bool horizontal;
  final Widget? action;
  final double actionSpacing;
  final String? semanticsLabel;

  /// Contextual help is persistent by default; enable for dynamic insertion.
  final bool announce;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (_, severityColor, _, severityIcon) = AppAlertBanner._tokens(severity);
    final severityTitle = AppAlertBanner._defaultTitle(l10n, severity);
    final effectiveTitle = title ?? severityTitle;
    final alertLabel = semanticsLabel ?? l10n.a11yAlert(effectiveTitle, message);
    final useHorizontalLayout = horizontal && MediaQuery.textScalerOf(context).scale(1) <= 1.5;
    final textStyle = size == AppAlertContextualSize.medium ? AppTypography.bodyRegular.copyWith(color: severityColor) : AppTypography.smallRegular.copyWith(color: severityColor);

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

    final contentRow = ExcludeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(severityIcon, color: severityColor),
          const SizedBox(width: AppDimensions.space8),
          Expanded(child: textWidget),
        ],
      ),
    );

    final body = useHorizontalLayout
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
                SizedBox(height: actionSpacing),
                action!,
              ],
            ],
          );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space4,
          vertical: AppDimensions.space8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                container: true,
                label: alertLabel,
                liveRegion: announce,
                child: const SizedBox(width: 1, height: 1),
              ),
              body,
            ],
          ),
        ),
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
    this.semanticsLabel,
    this.announce = true,
  }) : assert(message.length > 0, 'message must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final AppAlertSeverity severity;
  final String message;
  final String? semanticsLabel;
  final bool announce;

  /// Shows this toast via [ScaffoldMessenger]. Auto-dismisses after [duration].
  static void show(
    final BuildContext context, {
    required final String message,
    final AppAlertSeverity severity = AppAlertSeverity.neutral,
    final Duration duration = const Duration(seconds: 4),
    final String? semanticsLabel,
  }) {
    assert(message.isNotEmpty, 'message must not be empty');
    assert(semanticsLabel == null || semanticsLabel.isNotEmpty, 'semanticsLabel must not be empty');
    assert(duration >= const Duration(seconds: 4), 'duration must be at least four seconds');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        duration: duration,
        content: AppAlertToast(
          message: message,
          severity: severity,
          semanticsLabel: semanticsLabel,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final icon = _icon(severity);
    final title = AppAlertBanner._defaultTitle(AppLocalizations.of(context), severity);
    final alertLabel = semanticsLabel ?? AppLocalizations.of(context).a11yAlert(title, message);

    return Semantics(
      container: true,
      label: alertLabel,
      liveRegion: announce,
      child: ExcludeSemantics(
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
    this.semanticsLabel,
    this.announce = true,
  }) : assert(message.length > 0, 'message must not be empty'),
       assert(actionLabel == null || actionLabel.length > 0, 'actionLabel must not be empty'),
       assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel and onAction must be provided together',
       ),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final AppAlertSeverity severity;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? semanticsLabel;
  final bool announce;

  /// Shows this snackbar via [ScaffoldMessenger].
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    final BuildContext context, {
    required final String message,
    final AppAlertSeverity severity = AppAlertSeverity.neutral,
    final String? actionLabel,
    final VoidCallback? onAction,
    final EdgeInsetsGeometry? margin,
    final Duration duration = const Duration(seconds: 5),
    final String? semanticsLabel,
    final bool announce = true,
  }) {
    assert(duration >= const Duration(seconds: 4), 'duration must be at least four seconds');

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        duration: duration,
        elevation: 0,
        padding: EdgeInsets.zero,
        content: AppAlertSnackbar(
          message: message,
          severity: severity,
          actionLabel: actionLabel,
          onAction: onAction,
          semanticsLabel: semanticsLabel,
          announce: announce,
        ),
        behavior: SnackBarBehavior.floating,
        margin: margin,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final icon = _icon(severity);
    final l10n = AppLocalizations.of(context);
    final alertLabel = semanticsLabel ?? l10n.a11yAlert(AppAlertBanner._defaultTitle(l10n, severity), message);
    final useVerticalLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;

    final messageContent = Expanded(
      child: ExcludeSemantics(
        child: Text(
          message,
          style: AppTypography.bodyBold.copyWith(color: Colors.white),
        ),
      ),
    );
    final action = actionLabel == null
        ? null
        : TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space8,
                vertical: AppDimensions.space8,
              ),
              minimumSize: const Size(48, AppDimensions.minTouchTarget),
            ),
            child: Text(
              actionLabel!,
              style: AppTypography.bodyRegular.copyWith(color: Colors.white),
            ),
          );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          border: Border.all(color: AppColors.borderBlueMutedBase),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.high,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              container: true,
              label: alertLabel,
              liveRegion: announce,
              child: const SizedBox(width: 1, height: 1),
            ),
            if (useVerticalLayout) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null) ...[
                    ExcludeSemantics(child: AppIcon(icon, color: Colors.white)),
                    const SizedBox(width: AppDimensions.space8),
                  ],
                  messageContent,
                ],
              ),
              if (action != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: action,
                ),
            ] else
              Row(
                children: [
                  if (icon != null) ...[
                    ExcludeSemantics(child: AppIcon(icon, color: Colors.white)),
                    const SizedBox(width: AppDimensions.space8),
                  ],
                  messageContent,
                  if (action != null) ...[
                    const SizedBox(width: AppDimensions.space4),
                    action,
                  ],
                ],
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
    this.semanticsLabel,
  }) : assert(confirmLabel.length > 0, 'confirmLabel must not be empty'),
       assert(cancelLabel.length > 0, 'cancelLabel must not be empty'),
       assert(title == null || title.length > 0, 'title must not be empty'),
       assert(description == null || description.length > 0, 'description must not be empty'),
       assert(infoLabel == null || infoLabel.length > 0, 'infoLabel must not be empty'),
       assert(checkboxLabel == null || checkboxLabel.length > 0, 'checkboxLabel must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

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

  /// Accessible route name. Falls back to [title] or the localized dialog
  /// label when no visible title is provided.
  final String? semanticsLabel;

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
    final String? semanticsLabel,
  }) {
    return showDialog<bool>(
      context: context,
      requestFocus: true,
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
        semanticsLabel: semanticsLabel,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final dialogLabel = semanticsLabel ?? title ?? MaterialLocalizations.of(context).alertDialogLabel;

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: dialogLabel,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Dialog(
          constraints: appModalDialogConstraints(context),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showIconContainer) ...[
                    Center(
                      child: ExcludeSemantics(
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
                    ),
                    const SizedBox(height: AppDimensions.space8),
                  ],
                  if (title != null) ...[
                    Semantics(
                      header: true,
                      headingLevel: 1,
                      sortKey: const OrdinalSortKey(1),
                      child: Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: AppTypography.h3.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                  ],
                  if (description != null) ...[
                    Semantics(
                      sortKey: const OrdinalSortKey(2),
                      child: Text(
                        description!,
                        style: AppTypography.bodyRegular.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                  ],
                  if (checkboxLabel != null) ...[
                    Semantics(
                      sortKey: const OrdinalSortKey(3),
                      child: _DialogCheckboxRow(
                        label: checkboxLabel!,
                        isChecked: isChecked,
                        onChanged: onCheckboxChanged,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                  ],
                  Semantics(
                    sortKey: const OrdinalSortKey(4),
                    child: _DialogActions(
                      infoLabel: infoLabel,
                      onInfo: onInfo,
                      confirmLabel: confirmLabel,
                      cancelLabel: cancelLabel,
                      onConfirm: onConfirm,
                      onCancel: onCancel,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    this.semanticsLabel,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(description.length > 0, 'description must not be empty'),
       assert(confirmLabel.length > 0, 'confirmLabel must not be empty'),
       assert(cancelLabel.length > 0, 'cancelLabel must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final IconData icon;
  final String? semanticsLabel;

  /// Displays this dialog and returns `true` on confirm, `false` on cancel.
  static Future<bool?> show(
    final BuildContext context, {
    required final String title,
    required final String description,
    required final String confirmLabel,
    required final String cancelLabel,
    final IconData icon = AppIcons.info,
    final String? semanticsLabel,
  }) {
    return showDialog<bool>(
      context: context,
      requestFocus: true,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final ctx) => AppDestructiveConfirmDialog(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        icon: icon,
        semanticsLabel: semanticsLabel,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final useVerticalLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final cancelButton = AppButton(
      label: cancelLabel,
      hierarchy: AppButtonHierarchy.tertiary,
      isExpanded: true,
      onPressed: onCancel,
    );
    final confirmButton = AppButton(
      label: confirmLabel,
      intent: AppButtonIntent.destructive,
      isExpanded: true,
      onPressed: onConfirm,
    );

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticsLabel ?? title,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Dialog(
          constraints: appModalDialogConstraints(context),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ExcludeSemantics(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.space8),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: AppIcon(icon, color: AppColors.errorDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  Semantics(
                    header: true,
                    headingLevel: 1,
                    sortKey: const OrdinalSortKey(1),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.h3.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space24),
                  Semantics(
                    sortKey: const OrdinalSortKey(2),
                    child: Text(
                      description,
                      style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  Semantics(
                    sortKey: const OrdinalSortKey(3),
                    child: useVerticalLayout
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              cancelButton,
                              const SizedBox(height: AppDimensions.space8),
                              confirmButton,
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: cancelButton),
                              const SizedBox(width: AppDimensions.space16),
                              Expanded(child: confirmButton),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Success confirmation dialog matching the Figma `Alerts/Dialog` success
/// variant (node `44242:24055`).
///
/// Unlike [AppAlertDialog], its two actions are stacked full-width instead
/// of side by side, and the secondary action has no leading icon — the same
/// reason [AppDestructiveConfirmDialog] is its own class rather than an
/// [AppAlertDialog] variant.
class AppSuccessDialog extends StatelessWidget {
  const AppSuccessDialog({
    required this.title,
    required this.description,
    required this.secondaryLabel,
    required this.primaryLabel,
    required this.onSecondary,
    required this.onPrimary,
    super.key,
    this.semanticsLabel,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(description.length > 0, 'description must not be empty'),
       assert(secondaryLabel.length > 0, 'secondaryLabel must not be empty'),
       assert(primaryLabel.length > 0, 'primaryLabel must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String title;
  final String description;
  final String secondaryLabel;
  final String primaryLabel;
  final VoidCallback onSecondary;
  final VoidCallback onPrimary;
  final String? semanticsLabel;

  /// Displays this dialog. Dismissal is only via [onSecondary]/[onPrimary],
  /// each of which pops this dialog (using its own route context, not the
  /// caller's) before invoking the provided callback — same pattern as
  /// [AppAlertDialog.show]/[AppDestructiveConfirmDialog.show].
  static Future<void> show(
    final BuildContext context, {
    required final String title,
    required final String description,
    required final String secondaryLabel,
    required final String primaryLabel,
    required final VoidCallback onSecondary,
    required final VoidCallback onPrimary,
    final String? semanticsLabel,
  }) {
    return showDialog<void>(
      context: context,
      requestFocus: true,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final ctx) => AppSuccessDialog(
        title: title,
        description: description,
        secondaryLabel: secondaryLabel,
        primaryLabel: primaryLabel,
        semanticsLabel: semanticsLabel,
        onSecondary: () {
          Navigator.of(ctx).pop();
          onSecondary();
        },
        onPrimary: () {
          Navigator.of(ctx).pop();
          onPrimary();
        },
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dialogLabel = semanticsLabel ?? l10n.a11yAlert(l10n.a11yAlertSuccess, title);

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: dialogLabel,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Dialog(
          constraints: appModalDialogConstraints(context),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ExcludeSemantics(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.space8),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: const AppIcon(
                          AppIcons.checkCircle,
                          color: AppColors.successDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  Semantics(
                    header: true,
                    headingLevel: 1,
                    sortKey: const OrdinalSortKey(1),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.h3.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  Semantics(
                    sortKey: const OrdinalSortKey(2),
                    child: Text(
                      description,
                      style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  Semantics(
                    sortKey: const OrdinalSortKey(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppButton(
                          label: secondaryLabel,
                          hierarchy: AppButtonHierarchy.tertiary,
                          isExpanded: true,
                          onPressed: onSecondary,
                        ),
                        const SizedBox(height: AppDimensions.space16),
                        AppButton(
                          label: primaryLabel,
                          leadingIcon: AppIcons.check,
                          isExpanded: true,
                          onPressed: onPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
    return Semantics(
      container: true,
      label: label,
      checked: isChecked,
      enabled: onChanged == null ? false : null,
      onTap: onChanged == null ? null : () => onChanged?.call(!isChecked),
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
          child: InkWell(
            onTap: onChanged == null ? null : () => onChanged?.call(!isChecked),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            child: Row(
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
    final useVerticalLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final cancelButton = AppButton(
      label: cancelLabel,
      onPressed: onCancel,
      hierarchy: AppButtonHierarchy.tertiary,
      leadingIcon: AppIcons.cancel,
      isExpanded: true,
    );
    final confirmButton = AppButton(
      label: confirmLabel,
      onPressed: onConfirm,
      leadingIcon: AppIcons.check,
      isExpanded: true,
    );

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
        if (useVerticalLayout) ...[
          cancelButton,
          const SizedBox(height: AppDimensions.space8),
          confirmButton,
        ] else
          Row(
            children: [
              Expanded(child: cancelButton),
              const SizedBox(width: AppDimensions.space16),
              Expanded(child: confirmButton),
            ],
          ),
      ],
    );
  }
}

/// Biometric quick-access opt-in dialog — Figma node `44744:15094`.
class AppBiometricAccessDialog extends StatelessWidget {
  const AppBiometricAccessDialog({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  static Future<bool?> show(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return showDialog<bool>(
      context: context,
      requestFocus: true,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final dialogContext) => AppBiometricAccessDialog(
        title: l10n.biometricAccessDialogTitle,
        description: l10n.biometricAccessDialogDescription,
        confirmLabel: l10n.biometricAccessDialogConfirm,
        cancelLabel: l10n.biometricAccessDialogCancel,
        onConfirm: () => Navigator.of(dialogContext).pop(true),
        onCancel: () => Navigator.of(dialogContext).pop(false),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Dialog(
          constraints: appModalDialogConstraints(context),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ExcludeSemantics(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.space8),
                        decoration: const BoxDecoration(
                          color: AppColors.borderBlueMutedLighter,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/fingerprint.svg',
                          width: AppDimensions.iconMedium,
                          height: AppDimensions.iconMedium,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF678099),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  Semantics(
                    header: true,
                    headingLevel: 1,
                    sortKey: const OrdinalSortKey(1),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.h3.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),
                  Semantics(
                    sortKey: const OrdinalSortKey(2),
                    child: Text(
                      description,
                      style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Semantics(
                    sortKey: const OrdinalSortKey(3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppButton(
                            label: cancelLabel,
                            hierarchy: AppButtonHierarchy.tertiary,
                            isExpanded: true,
                            onPressed: onCancel,
                          ),
                          const SizedBox(height: AppDimensions.space16),
                          AppButton(
                            label: confirmLabel,
                            isExpanded: true,
                            onPressed: onConfirm,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
