import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

enum AppPreferenceStatus {
  disabled,
  pending,
  enabled,
}

class AppPreferenceList extends StatelessWidget {
  const AppPreferenceList({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space24,
        AppDimensions.space16,
        AppDimensions.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
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
    return Container(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: AppDimensions.iconMedium,
                height: AppDimensions.space32,
                child: AppIcon(AppIcons.verified, color: AppColors.textPrimary),
              ),
              const SizedBox(width: AppDimensions.space4),
              Expanded(
                child: Text(
                  'Condiciones de uso y autorizaciones',
                  style: AppTypography.leadingBold.copyWith(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space8),
          AppPreferenceActionButton(
            label: 'Editar',
            icon: AppIcons.edit,
            onPressed: onEdit,
          ),
        ],
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
    this.activeFooterText,
  });

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
  final String? activeFooterText;

  @override
  Widget build(final BuildContext context) {
    final contentColor = status == AppPreferenceStatus.enabled ? AppColors.textPrimary : AppColors.borderBlueMutedBase;
    final hasActiveSummary = status == AppPreferenceStatus.enabled && summaryItems.isNotEmpty;
    final description = switch (status) {
      AppPreferenceStatus.disabled => inactiveDescription,
      AppPreferenceStatus.pending => pendingDescription,
      AppPreferenceStatus.enabled => activeDescription,
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(color: hasActiveSummary ? AppColors.secondaryLight400 : AppColors.backgroundBlueMutedLight),
        borderRadius: BorderRadius.circular(hasActiveSummary ? AppDimensions.radiusMedium : AppDimensions.radiusXs),
        boxShadow: hasActiveSummary ? AppShadows.medium : AppShadows.low,
      ),
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!hasActiveSummary) ...[
            AppPreferenceStatusTag(
              status: status,
              showInactiveIcon: showInactiveIcon,
            ),
            const SizedBox(height: AppDimensions.space8),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppDimensions.iconMedium,
                height: AppDimensions.space32,
                child: icon,
              ),
              const SizedBox(width: AppDimensions.space4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.space4),
                  child: Text(
                    title,
                    style: AppTypography.leadingBold.copyWith(color: contentColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space8),
          if (hasActiveSummary)
            AppPreferenceSummaryList(items: summaryItems)
          else
            Container(
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
          const SizedBox(height: AppDimensions.space12),
          AppPreferenceActionButton(
            label: actionLabel,
            icon: actionIcon,
            onPressed: onAction,
            filled: filledAction,
          ),
          if (hasActiveSummary && activeFooterText != null) ...[
            const SizedBox(height: AppDimensions.space12),
            AppPreferenceFooter(text: activeFooterText!),
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
  });

  final String? phone;
  final String? email;
  final String footerText;
  final VoidCallback onEdit;

  @override
  Widget build(final BuildContext context) {
    return Container(
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
          const AppActiveStatusTag(),
          const SizedBox(height: AppDimensions.space8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: AppDimensions.iconMedium,
                height: AppDimensions.space32,
                child: AppIcon(AppIcons.alternateEmail, color: AppColors.textPrimary),
              ),
              const SizedBox(width: AppDimensions.space4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.space4),
                  child: Text(
                    'Datos de contacto para notificaciones',
                    style: AppTypography.leadingBold.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space8),
          Container(
            width: double.infinity,
            color: AppColors.backgroundBlueLighter,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space8,
              vertical: AppDimensions.space8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (phone case final phoneValue? when phoneValue.isNotEmpty) ...[
                  AppPreferenceDataRow(
                    label: 'TELÉFONO MÓVIL',
                    value: _formatPhoneForDisplay(phoneValue),
                  ),
                  const SizedBox(height: AppDimensions.space12),
                ],
                if (email case final emailValue? when emailValue.isNotEmpty) ...[
                  Text(
                    'CORREO ELECTRÓNICO',
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
          ),
          const SizedBox(height: AppDimensions.space12),
          AppPreferenceActionButton(
            label: 'Editar datos',
            icon: AppIcons.edit,
            onPressed: onEdit,
          ),
          const SizedBox(height: AppDimensions.space12),
          AppPreferenceFooter(text: footerText),
        ],
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
  });

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    return Wrap(
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
    );
  }
}

class AppActiveStatusTag extends StatelessWidget {
  const AppActiveStatusTag({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
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
        'ACTIVO',
        style: AppTypography.captionUppercase.copyWith(color: AppColors.successDark),
      ),
    );
  }
}

class AppPreferenceSummaryList extends StatelessWidget {
  const AppPreferenceSummaryList({
    required this.items,
    super.key,
  });

  final List<String> items;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.secondaryLight100,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            Padding(
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
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                      child: Text(
                        item,
                        style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AppDoubleBullet extends StatelessWidget {
  const AppDoubleBullet({super.key});

  @override
  Widget build(final BuildContext context) {
    return Row(
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
    );
  }
}

class AppPreferenceFooter extends StatelessWidget {
  const AppPreferenceFooter({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        const AppIcon(AppIcons.autorenew, color: AppColors.borderBlueMutedBase),
        const SizedBox(width: AppDimensions.space8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.smallRegular.copyWith(color: AppColors.blueMuted900),
          ),
        ),
      ],
    );
  }
}

class AppPreferenceStatusTag extends StatelessWidget {
  const AppPreferenceStatusTag({
    required this.status,
    required this.showInactiveIcon,
    super.key,
  });

  final AppPreferenceStatus status;
  final bool showInactiveIcon;

  @override
  Widget build(final BuildContext context) {
    final label = switch (status) {
      AppPreferenceStatus.disabled => 'Desactivado',
      AppPreferenceStatus.pending => 'Pendiente',
      AppPreferenceStatus.enabled => 'Activado',
    };
    final background = switch (status) {
      AppPreferenceStatus.disabled => AppColors.background,
      AppPreferenceStatus.pending => AppColors.warningLight,
      AppPreferenceStatus.enabled => AppColors.successLight,
    };
    final border = switch (status) {
      AppPreferenceStatus.disabled => AppColors.primary,
      AppPreferenceStatus.pending => AppColors.warningDark,
      AppPreferenceStatus.enabled => AppColors.successDark,
    };
    final foreground = switch (status) {
      AppPreferenceStatus.disabled => AppColors.primary,
      AppPreferenceStatus.pending => AppColors.warningDark,
      AppPreferenceStatus.enabled => AppColors.successDark,
    };
    final icon = switch (status) {
      AppPreferenceStatus.disabled => AppIcons.hourglass,
      AppPreferenceStatus.pending => AppIcons.warning,
      AppPreferenceStatus.enabled => AppIcons.check,
    };
    final showIcon = showInactiveIcon;

    return Semantics(
      label: label,
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
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;

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
      button: true,
      enabled: enabled,
      label: label,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyRegular.copyWith(color: foreground),
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
