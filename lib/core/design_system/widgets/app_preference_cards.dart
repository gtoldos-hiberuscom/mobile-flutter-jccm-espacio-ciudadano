import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

enum AppPreferenceStatus {
  disabled,
  pending,
  enabled,

  /// No se ha podido averiguar el estado.
  ///
  /// Distinto de [disabled] y de [pending]: esos dos **afirman** algo sobre la
  /// configuración del ciudadano, y decirle que algo está desactivado o
  /// pendiente cuando lo que ha fallado es la consulta es mentirle. A
  /// diferencia del resto, su descripción no la pone quien usa la tarjeta:
  /// el motivo es siempre el mismo y no depende de qué se estuviera mirando.
  unavailable,
}

class AppPreferenceList extends StatelessWidget {
  const AppPreferenceList({
    required this.children,
    super.key,
    this.semanticLabel,
  }) : assert(
         semanticLabel == null || semanticLabel != '',
         'semanticLabel must not be empty',
       );

  final List<Widget> children;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: SingleChildScrollView(
        padding: appPagePadding(
          context,
          top: AppDimensions.space24,
          bottom: AppDimensions.space64,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children.indexed
              .map(
                (final entry) => Semantics(
                  sortKey: OrdinalSortKey(entry.$1.toDouble()),
                  child: entry.$2,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class AppConsentPreferenceCard extends StatelessWidget {
  const AppConsentPreferenceCard({
    required this.onEdit,
    super.key,
  });

  final VoidCallback onEdit;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.secondaryLight400),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: AppShadows.medium,
        ),
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              sortKey: const OrdinalSortKey(0),
              header: true,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.consentStep1FullTitle,
                      style: AppTypography.leadingBold.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                  AppPreferenceHeaderAction(onPressed: onEdit),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            AppPreferenceActionButton(
              label: l10n.appPreferenceEditAction,
              icon: AppIcons.edit,
              onPressed: onEdit,
              semanticSortKey: const OrdinalSortKey(1),
            ),
          ],
        ),
      ),
    );
  }
}

class AppPreferenceCard extends StatelessWidget {
  const AppPreferenceCard({
    required this.title,
    required this.icon,
    required this.status,
    required this.inactiveDescription,
    required this.pendingDescription,
    required this.activeDescription,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
    super.key,
    this.showInactiveIcon = false,
    this.filledAction = false,
    this.summaryItems = const [],
    this.activeSummary,
    this.activeFooterText,
    this.showActiveStatus = false,
    this.showActiveHeaderAction = true,
  }) : assert(title != '', 'title must not be empty'),
       assert(inactiveDescription != '', 'inactiveDescription must not be empty'),
       assert(pendingDescription != '', 'pendingDescription must not be empty'),
       assert(activeDescription != '', 'activeDescription must not be empty'),
       assert(actionLabel != '', 'actionLabel must not be empty'),
       assert(activeFooterText == null || activeFooterText != '', 'activeFooterText must not be empty');

  final String title;
  final Widget icon;
  final AppPreferenceStatus status;
  final String inactiveDescription;
  final String pendingDescription;
  final String activeDescription;
  final String actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final bool showInactiveIcon;
  final bool filledAction;
  final List<String> summaryItems;

  /// Contenido estructurado que se muestra cuando la preferencia está activa.
  /// Útil cuando el resumen necesita etiquetas, como los canales de contacto.
  final Widget? activeSummary;
  final String? activeFooterText;
  final bool showActiveStatus;

  /// Whether the active card exposes the redundant action arrow in its header.
  final bool showActiveHeaderAction;

  @override
  Widget build(final BuildContext context) {
    assert(
      summaryItems.every((final item) => item.isNotEmpty),
      'summary items must not be empty',
    );
    final l10n = AppLocalizations.of(context);
    final contentColor = status == AppPreferenceStatus.enabled ? AppColors.textPrimary : AppColors.borderBlueMutedBase;
    final hasActiveSummary = status == AppPreferenceStatus.enabled && (summaryItems.isNotEmpty || activeSummary != null);
    final isActive = status == AppPreferenceStatus.enabled;
    final showsStatusTag = !hasActiveSummary || (isActive && showActiveStatus);
    final description = switch (status) {
      AppPreferenceStatus.disabled => inactiveDescription,
      AppPreferenceStatus.pending => pendingDescription,
      AppPreferenceStatus.enabled => activeDescription,
      AppPreferenceStatus.unavailable => l10n.appPreferenceStatusUnavailableDescription,
    };
    final statusLabel = switch (status) {
      AppPreferenceStatus.disabled => l10n.appPreferenceStatusDisabled,
      AppPreferenceStatus.pending => l10n.appPreferenceStatusPending,
      AppPreferenceStatus.enabled => l10n.appPreferenceStatusEnabled,
      AppPreferenceStatus.unavailable => l10n.appPreferenceStatusUnavailable,
    };

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(
            color: hasActiveSummary ? AppColors.secondaryLight400 : AppColors.backgroundBlueMutedLight,
          ),
          borderRadius: BorderRadius.circular(
            hasActiveSummary ? AppDimensions.radiusMedium : AppDimensions.radiusXs,
          ),
          boxShadow: hasActiveSummary ? AppShadows.medium : AppShadows.low,
        ),
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Semantics(
              sortKey: const OrdinalSortKey(0),
              label: statusLabel,
              child: ExcludeSemantics(
                child: !showsStatusTag
                    ? const SizedBox.square(dimension: 1)
                    : AppPreferenceStatusTag(
                        status: status,
                        showInactiveIcon: showInactiveIcon,
                      ),
              ),
            ),
            if (showsStatusTag) const SizedBox(height: AppDimensions.space8),
            Semantics(
              sortKey: const OrdinalSortKey(1),
              header: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isActive) ...[
                    ExcludeSemantics(
                      child: SizedBox(
                        width: AppDimensions.iconMedium,
                        height: AppDimensions.space32,
                        child: icon,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space4),
                  ],
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: isActive ? 0 : AppDimensions.space4),
                      child: Text(
                        title,
                        style: AppTypography.leadingBold.copyWith(color: contentColor),
                      ),
                    ),
                  ),
                  if (isActive && showActiveHeaderAction && onAction != null)
                    AppPreferenceHeaderAction(
                      onPressed: onAction!,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Semantics(
              sortKey: const OrdinalSortKey(2),
              child: hasActiveSummary
                  ? activeSummary ?? AppPreferenceSummaryList(items: summaryItems)
                  : Container(
                      width: double.infinity,
                      color: status == AppPreferenceStatus.enabled ? AppColors.backgroundBlueLighter : AppColors.backgroundBlueMutedLight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space8,
                        vertical: AppDimensions.space8,
                      ),
                      child: Text(
                        description,
                        style: AppTypography.smallRegular.copyWith(color: contentColor),
                      ),
                    ),
            ),
            const SizedBox(height: AppDimensions.space12),
            AppPreferenceActionButton(
              label: actionLabel,
              icon: actionIcon,
              onPressed: onAction,
              filled: filledAction,
              semanticSortKey: const OrdinalSortKey(3),
            ),
            if (hasActiveSummary && activeFooterText != null) ...[
              const SizedBox(height: AppDimensions.space12),
              Semantics(
                sortKey: const OrdinalSortKey(4),
                child: AppPreferenceFooter(text: activeFooterText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Botón de acceso rápido mostrado por las tarjetas de preferencias.
///
/// La flecha no es decorativa: lleva a la misma acción que el botón situado
/// al final de la tarjeta. Mantener ambos accesos evita que el indicador de
/// navegación parezca interactivo sin serlo.
class AppPreferenceHeaderAction extends StatelessWidget {
  const AppPreferenceHeaderAction({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      excludeFromSemantics: true,
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: const AppIcon(AppIcons.arrowForward, color: AppColors.textPrimary),
    );
  }
}

/// Resumen de los canales registrados para las notificaciones electrónicas.
class AppNotificationContactSummary extends StatelessWidget {
  const AppNotificationContactSummary({
    required this.phone,
    required this.email,
    super.key,
  });

  final String? phone;
  final String? email;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phoneValue = phone?.trim();
    final emailValue = email?.trim();

    return Container(
      width: double.infinity,
      color: AppColors.backgroundBlueLighter,
      padding: const EdgeInsets.all(AppDimensions.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (phoneValue != null && phoneValue.isNotEmpty)
            AppPreferenceDataRow(
              label: l10n.gestionNotificacionesAltaPhoneLabel.toUpperCase(),
              value: phoneValue,
            ),
          if (phoneValue != null && phoneValue.isNotEmpty && emailValue != null && emailValue.isNotEmpty) const SizedBox(height: AppDimensions.space12),
          if (emailValue != null && emailValue.isNotEmpty) ...[
            Text(
              l10n.gestionNotificacionesAltaEmailLabel.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.space4),
            Text(
              emailValue,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
          ],
        ],
      ),
    );
  }
}

class AppNotificationContactPreferenceCard extends StatelessWidget {
  const AppNotificationContactPreferenceCard({
    required this.onEdit,
    super.key,
    this.phone,
    this.email,
    this.footerText = 'Actualizado el 21 abr 2026 a las 23:00h',
  }) : assert(
         (phone != null && phone != '') || (email != null && email != ''),
         'Provide at least one contact method',
       ),
       assert(footerText != '', 'footerText must not be empty');

  final String? phone;
  final String? email;
  final String footerText;
  final VoidCallback onEdit;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phoneValue = phone?.trim();
    final emailValue = email?.trim();

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.secondaryLight400),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: AppShadows.medium,
        ),
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Semantics(
              sortKey: const OrdinalSortKey(0),
              label: l10n.appPreferenceStatusActive,
              child: const ExcludeSemantics(child: AppActiveStatusTag()),
            ),
            const SizedBox(height: AppDimensions.space8),
            Semantics(
              sortKey: const OrdinalSortKey(1),
              header: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExcludeSemantics(
                    child: SizedBox(
                      width: AppDimensions.iconMedium,
                      height: AppDimensions.space32,
                      child: AppIcon(
                        AppIcons.alternateEmail,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space4),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppDimensions.space4),
                      child: Text(
                        l10n.appNotificationContactCardTitle,
                        style: AppTypography.leadingBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Semantics(
              sortKey: const OrdinalSortKey(2),
              container: true,
              explicitChildNodes: true,
              child: Container(
                width: double.infinity,
                color: AppColors.backgroundBlueLighter,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space8,
                  vertical: AppDimensions.space8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (phoneValue != null && phoneValue.isNotEmpty) ...[
                      Semantics(
                        sortKey: const OrdinalSortKey(0),
                        label: '${l10n.gestionNotificacionesAltaPhoneLabel}. ${_formatPhoneForDisplay(phoneValue)}',
                        child: ExcludeSemantics(
                          child: AppPreferenceDataRow(
                            label: l10n.gestionNotificacionesAltaPhoneLabel.toUpperCase(),
                            value: _formatPhoneForDisplay(phoneValue),
                          ),
                        ),
                      ),
                      if (emailValue != null && emailValue.isNotEmpty) const SizedBox(height: AppDimensions.space12),
                    ],
                    if (emailValue != null && emailValue.isNotEmpty)
                      Semantics(
                        sortKey: const OrdinalSortKey(1),
                        label: '${l10n.gestionNotificacionesAltaEmailLabel}. $emailValue',
                        child: ExcludeSemantics(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.gestionNotificacionesAltaEmailLabel.toUpperCase(),
                                style: AppTypography.captionUppercase.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space4),
                              Text(
                                emailValue,
                                style: AppTypography.bodyRegular.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            AppPreferenceActionButton(
              label: l10n.appNotificationContactCardEditAction,
              icon: AppIcons.edit,
              onPressed: onEdit,
              semanticSortKey: const OrdinalSortKey(3),
            ),
            const SizedBox(height: AppDimensions.space12),
            Semantics(
              sortKey: const OrdinalSortKey(4),
              label: footerText,
              child: ExcludeSemantics(
                child: AppPreferenceFooter(text: footerText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPhoneForDisplay(final String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 9) {
      return '0034 ${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }
    return phone;
  }
}

class AppPreferenceDataRow extends StatelessWidget {
  const AppPreferenceDataRow({
    required this.label,
    required this.value,
    super.key,
    this.semanticLabel,
  }) : assert(label != '', 'label must not be empty'),
       assert(value != '', 'value must not be empty'),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final String label;
  final String value;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel ?? '$label. $value',
      child: ExcludeSemantics(
        child: Wrap(
          spacing: AppDimensions.space16,
          runSpacing: AppDimensions.space4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              label,
              style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
            ),
            Text(
              value,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class AppActiveStatusTag extends StatelessWidget {
  const AppActiveStatusTag({super.key, this.semanticLabel}) : assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      container: true,
      label: semanticLabel ?? l10n.appPreferenceStatusActive,
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space8,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.successLight,
            border: Border.all(color: AppColors.successDark),
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          ),
          child: Text(
            l10n.appPreferenceStatusActive.toUpperCase(),
            style: AppTypography.captionUppercase.copyWith(color: AppColors.successDark),
          ),
        ),
      ),
    );
  }
}

class AppPreferenceSummaryList extends StatelessWidget {
  const AppPreferenceSummaryList({
    required this.items,
    super.key,
    this.semanticLabel,
  }) : assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final List<String> items;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    assert(items.isNotEmpty, 'items must not be empty');
    assert(items.every((final item) => item.isNotEmpty), 'items must not contain empty values');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: Container(
        width: double.infinity,
        color: AppColors.secondaryLight100,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space8,
          vertical: AppDimensions.space4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items.indexed
              .map(
                (final entry) => Semantics(
                  container: true,
                  sortKey: OrdinalSortKey(entry.$1.toDouble()),
                  label: entry.$2,
                  child: ExcludeSemantics(
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppDimensions.space16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: AppDimensions.space8),
                            child: AppDoubleBullet(),
                          ),
                          const SizedBox(width: AppDimensions.space8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.space4,
                              ),
                              child: Text(
                                entry.$2,
                                style: AppTypography.bodyRegular.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class AppDoubleBullet extends StatelessWidget {
  const AppDoubleBullet({super.key});

  @override
  Widget build(final BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.space4),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.secondaryLight400,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class AppPreferenceFooter extends StatelessWidget {
  const AppPreferenceFooter({
    required this.text,
    super.key,
    this.semanticLabel,
  }) : assert(text != '', 'text must not be empty'),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final String text;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel ?? text,
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppIcon(AppIcons.autorenew, color: AppColors.borderBlueMutedBase),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                text,
                style: AppTypography.smallRegular.copyWith(color: AppColors.blueMuted900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppPreferenceStatusTag extends StatelessWidget {
  const AppPreferenceStatusTag({
    required this.status,
    required this.showInactiveIcon,
    super.key,
    this.semanticLabel,
  }) : assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final AppPreferenceStatus status;
  final bool showInactiveIcon;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = switch (status) {
      AppPreferenceStatus.disabled => l10n.appPreferenceStatusDisabled,
      AppPreferenceStatus.pending => l10n.appPreferenceStatusPending,
      AppPreferenceStatus.enabled => l10n.appPreferenceStatusEnabled,
      AppPreferenceStatus.unavailable => l10n.appPreferenceStatusUnavailable,
    };
    final background = switch (status) {
      AppPreferenceStatus.disabled => AppColors.background,
      AppPreferenceStatus.pending => AppColors.warningLight,
      AppPreferenceStatus.enabled => AppColors.successLight,
      // Neutro a propósito: ni verde ni ámbar, que dirían algo del ciudadano.
      AppPreferenceStatus.unavailable => AppColors.background,
    };
    final border = switch (status) {
      AppPreferenceStatus.disabled => AppColors.primary,
      AppPreferenceStatus.pending => AppColors.warningDark,
      AppPreferenceStatus.enabled => AppColors.successDark,
      AppPreferenceStatus.unavailable => AppColors.primary,
    };
    final foreground = switch (status) {
      AppPreferenceStatus.disabled => AppColors.primary,
      AppPreferenceStatus.pending => AppColors.warningDark,
      AppPreferenceStatus.enabled => AppColors.successDark,
      AppPreferenceStatus.unavailable => AppColors.primary,
    };
    final icon = switch (status) {
      AppPreferenceStatus.disabled => AppIcons.hourglass,
      AppPreferenceStatus.pending => AppIcons.warning,
      AppPreferenceStatus.enabled => AppIcons.check,
      AppPreferenceStatus.unavailable => AppIcons.info,
    };
    final showIcon = showInactiveIcon;

    return Semantics(
      container: true,
      label: semanticLabel ?? label,
      child: ExcludeSemantics(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            showIcon ? AppDimensions.space4 : AppDimensions.space8,
            2,
            AppDimensions.space8,
            2,
          ),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon) ...[
                AppIcon(icon, size: AppDimensions.iconSmall, color: foreground),
                const SizedBox(width: AppDimensions.space4),
              ],
              Text(
                label.toUpperCase(),
                style: AppTypography.captionUppercase.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppPreferenceActionButton extends StatelessWidget {
  const AppPreferenceActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
    this.filled = false,
    this.semanticLabel,
    this.semanticSortKey,
  }) : assert(label != '', 'label must not be empty'),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;
  final String? semanticLabel;
  final SemanticsSortKey? semanticSortKey;

  @override
  Widget build(final BuildContext context) {
    final enabled = onPressed != null;
    final background = enabled
        ? filled
              ? AppColors.primary
              : AppColors.backgroundWhite
        : AppColors.backgroundBlueMutedLight;
    final border = enabled ? AppColors.primary : AppColors.borderBlueMutedLight;
    final foreground = enabled
        ? filled
              ? AppColors.textWhite
              : AppColors.textBlack
        : AppColors.borderBlueMutedLight;

    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      onTap: onPressed,
      sortKey: semanticSortKey,
      child: ExcludeSemantics(
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            child: Container(
              constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.space8),
              decoration: BoxDecoration(
                color: background,
                border: Border.all(color: border, width: enabled ? 2 : 1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                boxShadow: enabled ? AppShadows.low : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    AppIcon(icon!, color: foreground),
                    const SizedBox(width: AppDimensions.space8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      style: AppTypography.bodyRegular.copyWith(color: foreground),
                      textAlign: TextAlign.center,
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
