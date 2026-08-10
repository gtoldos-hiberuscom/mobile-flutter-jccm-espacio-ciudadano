import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';

class AppCaptchaPlaceholder extends StatelessWidget {
  const AppCaptchaPlaceholder({
    required this.label,
    super.key,
    this.errorText,
    this.isVerified = false,
    this.verifiedLabel = 'Captcha verificado',
  });

  final String label;
  final String? errorText;
  final bool isVerified;
  final String verifiedLabel;

  @override
  Widget build(final BuildContext context) {
    final isError = errorText != null && errorText!.isNotEmpty;
    final borderColor = switch ((isError, isVerified)) {
      (true, _) => AppColors.error,
      (_, true) => AppColors.borderSuccess,
      _ => AppColors.borderBlueMutedBase,
    };
    final borderWidth = isError || isVerified ? 2.0 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: switch ((isError, isVerified)) {
            (true, _) => '$label. Error: $errorText',
            (_, true) => verifiedLabel,
            _ => label,
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isVerified ? AppColors.backgroundSuccess : AppColors.backgroundBlueMutedDark,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 104,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isVerified
                      ? Row(
                          key: const ValueKey('verified'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              AppIcons.checkCircle,
                              color: AppColors.successDark,
                              size: AppDimensions.iconLarge,
                            ),
                            const SizedBox(width: AppDimensions.space8),
                            Text(
                              verifiedLabel,
                              style: AppTypography.leadingMedium.copyWith(color: AppColors.successDark),
                            ),
                          ],
                        )
                      : Text(
                          label,
                          key: const ValueKey('pending'),
                          style: AppTypography.leadingMedium.copyWith(color: AppColors.textLight),
                        ),
                ),
              ),
            ),
          ),
        ),
        if (isError) ...[
          const SizedBox(height: AppDimensions.space8),
          AppDescriptionText(
            text: errorText!,
            state: AppDescriptionTextState.error,
          ),
        ],
      ],
    );
  }
}

class AppPrivacyInfoText extends StatelessWidget {
  const AppPrivacyInfoText({
    required this.description,
    required this.linkText,
    this.onTap,
    super.key,
  });

  final String description;
  final String linkText;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Semantics(
        label: '$description $linkText',
        hint: 'Enlace externo. Se abrirá fuera de la aplicación.',
        link: true,
        button: true,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: AppTypography.leadingMedium.copyWith(
                      color: AppColors.textBase,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: '$description '),
                      TextSpan(
                        text: linkText,
                        style: AppTypography.leadingMedium.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                          decorationThickness: 1.5,
                        ),
                      ),
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.only(left: AppDimensions.space4),
                          child: Icon(
                            Icons.open_in_new,
                            size: AppDimensions.iconSmall,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.space4),
                Text(
                  'Enlace externo · Se abrirá fuera de la aplicación',
                  style: AppTypography.smallRegular.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
