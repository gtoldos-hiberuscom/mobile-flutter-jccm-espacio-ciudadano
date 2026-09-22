import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Digital credential card matching the Carnets Digitales Figma component.
class AppDigitalCard extends StatelessWidget {
  const AppDigitalCard({
    required this.title,
    required this.downloadLabel,
    super.key,
    this.number,
    this.primaryDateLabel,
    this.primaryDate,
    this.secondaryDateLabel,
    this.secondaryDate,
    this.statusLabel,
    this.onDownload,
    this.isDownloading = false,
    this.semanticLabel,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(downloadLabel.length > 0, 'downloadLabel must not be empty'),
       assert(number == null || number.length > 0, 'number must not be empty'),
       assert(primaryDate == null || primaryDateLabel != null, 'primaryDateLabel is required with primaryDate'),
       assert(secondaryDate == null || secondaryDateLabel != null, 'secondaryDateLabel is required with secondaryDate'),
       assert(semanticLabel == null || semanticLabel.length > 0, 'semanticLabel must not be empty');

  final String title;
  final String? number;
  final String? primaryDateLabel;
  final String? primaryDate;
  final String? secondaryDateLabel;
  final String? secondaryDate;
  final String? statusLabel;
  final String downloadLabel;
  final VoidCallback? onDownload;
  final bool isDownloading;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabled = onDownload != null && !isDownloading;
    final downloadSemanticLabel = '$downloadLabel $title';
    final summary =
        semanticLabel ??
        [
          title,
          if (number != null) '${l10n.digitalCardNumberLabel}: $number',
          if (primaryDate != null) '$primaryDateLabel: $primaryDate',
          if (secondaryDate != null) '$secondaryDateLabel: $secondaryDate',
          ?statusLabel,
        ].join('. ');

    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.primary),
        boxShadow: AppShadows.high,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Stack(
          children: [
            const Positioned(
              right: AppDimensions.space8,
              bottom: AppDimensions.space8,
              child: _DigitalCardDots(key: ValueKey('digital-card-map-pattern')),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (statusLabel != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ExcludeSemantics(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(4, 2, 8, 2),
                          decoration: BoxDecoration(
                            color: AppColors.successContainer,
                            border: Border.all(color: AppColors.successDark),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppIcon(AppIcons.check, color: AppColors.successDark, size: 16),
                              const SizedBox(width: AppDimensions.space4),
                              Text(
                                statusLabel!.toUpperCase(),
                                style: AppTypography.captionRegular.copyWith(color: AppColors.successDark),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Semantics(
                    container: true,
                    label: summary,
                    child: ExcludeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.digitalCardTitleLabel,
                            style: _cardCaptionStyle,
                          ),
                          const SizedBox(height: AppDimensions.space2),
                          Text(
                            title,
                            style: AppTypography.h2.copyWith(color: AppColors.textWhite),
                          ),
                          SizedBox(height: statusLabel == null ? AppDimensions.space8 : AppDimensions.space16),
                          if (number != null) ...[
                            Text(l10n.digitalCardNumberLabel, style: _cardCaptionStyle),
                            Text(
                              number!,
                              style: AppTypography.h3.copyWith(color: AppColors.textWhite),
                            ),
                            const SizedBox(height: AppDimensions.space8),
                          ],
                          if (primaryDate != null)
                            Wrap(
                              spacing: AppDimensions.space16,
                              runSpacing: AppDimensions.space8,
                              children: [
                                _CardDate(label: primaryDateLabel!, value: primaryDate!),
                                if (secondaryDate != null) _CardDate(label: secondaryDateLabel!, value: secondaryDate!),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Semantics(
                    button: true,
                    enabled: enabled,
                    label: downloadSemanticLabel,
                    value: isDownloading ? l10n.a11yLoading : null,
                    liveRegion: isDownloading,
                    onTap: enabled ? onDownload : null,
                    child: ExcludeSemantics(
                      child: TextButton.icon(
                        onPressed: enabled ? onDownload : null,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.blue300,
                          disabledForegroundColor: AppColors.blue300.withValues(alpha: 0.55),
                          minimumSize: const Size(0, AppDimensions.minTouchTarget),
                          padding: const EdgeInsets.all(AppDimensions.space8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: isDownloading
                            ? const SizedBox.square(
                                dimension: AppDimensions.iconSmall,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.blue300,
                                ),
                              )
                            : const AppIcon(AppIcons.download),
                        label: Text(
                          downloadLabel,
                          style: AppTypography.bodyBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardDate extends StatelessWidget {
  const _CardDate({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: _cardCaptionStyle),
      Text(value, style: AppTypography.bodyBold.copyWith(color: AppColors.textWhite)),
    ],
  );
}

final TextStyle _cardCaptionStyle = AppTypography.captionRegular.copyWith(
  color: const Color(0xFF98A9BB),
  fontWeight: FontWeight.w400,
);

class _DigitalCardDots extends StatelessWidget {
  const _DigitalCardDots({super.key});

  static const _pattern = <String>[
    '...111.',
    '...111.',
    '000011.',
    '.000011',
    '.00001.',
    '....0..',
  ];

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var row = 0; row < _pattern.length; row++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var col = 0; col < _pattern[row].length; col++)
                SizedBox.square(
                  dimension: 23,
                  child: _pattern[row][col] == '.'
                      ? null
                      : Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: _pattern[row][col] == '1' ? AppColors.secondaryLight400 : AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
            ],
          ),
      ],
    );
  }
}
