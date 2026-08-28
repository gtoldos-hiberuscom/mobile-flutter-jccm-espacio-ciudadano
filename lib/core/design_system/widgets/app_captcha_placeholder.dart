import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class AppCaptchaPlaceholder extends StatelessWidget {
  const AppCaptchaPlaceholder({
    required this.label,
    super.key,
    this.errorText,
    this.isVerified = false,
    this.verifiedLabel,
    this.semanticsLabel,
    this.announceChanges = true,
  }) : assert(label.length > 0, 'label must not be empty'),
       assert(errorText == null || errorText.length > 0, 'errorText must not be empty'),
       assert(verifiedLabel == null || verifiedLabel.length > 0, 'verifiedLabel must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String label;
  final String? errorText;
  final bool isVerified;
  final String? verifiedLabel;
  final String? semanticsLabel;
  final bool announceChanges;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isError = errorText != null && errorText!.isNotEmpty;
    final effectiveVerifiedLabel = verifiedLabel ?? l10n.a11yCaptchaVerified;
    final effectiveSemanticsLabel =
        semanticsLabel ??
        switch ((isError, isVerified)) {
          (true, _) => l10n.a11yFieldError(label, errorText!),
          (_, true) => effectiveVerifiedLabel,
          _ => label,
        };
    final borderColor = switch ((isError, isVerified)) {
      (true, _) => AppColors.error,
      (_, true) => AppColors.borderSuccess,
      _ => AppColors.borderBlueMutedBase,
    };
    final borderWidth = isError || isVerified ? 2.0 : 1.0;
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final verifiedContent = usesLargeText
        ? Column(
            key: const ValueKey('verified'),
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                AppIcons.checkCircle,
                color: AppColors.successDark,
                size: AppDimensions.iconLarge,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                effectiveVerifiedLabel,
                textAlign: TextAlign.center,
                style: AppTypography.leadingMedium.copyWith(
                  color: AppColors.successDark,
                ),
              ),
            ],
          )
        : Row(
            key: const ValueKey('verified'),
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                AppIcons.checkCircle,
                color: AppColors.successDark,
                size: AppDimensions.iconLarge,
              ),
              const SizedBox(width: AppDimensions.space8),
              Flexible(
                child: Text(
                  effectiveVerifiedLabel,
                  style: AppTypography.leadingMedium.copyWith(
                    color: AppColors.successDark,
                  ),
                ),
              ),
            ],
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          container: true,
          label: effectiveSemanticsLabel,
          liveRegion: announceChanges && (isError || isVerified),
          child: ExcludeSemantics(
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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 104),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: isVerified
                            ? verifiedContent
                            : Text(
                                label,
                                key: const ValueKey('pending'),
                                textAlign: TextAlign.center,
                                style: AppTypography.leadingMedium.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isError) ...[
          const SizedBox(height: AppDimensions.space8),
          ExcludeSemantics(
            child: AppDescriptionText(
              text: errorText!,
              state: AppDescriptionTextState.error,
            ),
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
    this.semanticsLabel,
    super.key,
  }) : assert(description.length > 0, 'description must not be empty'),
       assert(linkText.length > 0, 'linkText must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String description;
  final String linkText;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Semantics(
        label: semanticsLabel ?? '$description $linkText',
        hint: l10n.externalLinkA11yHint,
        link: true,
        enabled: onTap != null,
        onTap: onTap,
        child: ExcludeSemantics(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        textScaler: MediaQuery.textScalerOf(context),
                      ),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        l10n.externalLinkVisibleNotice,
                        style: AppTypography.smallRegular.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
