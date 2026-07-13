import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

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
  });

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

  @override
  Widget build(final BuildContext context) {
    final enabled = onDownload != null && !isDownloading;

    return Semantics(
      button: enabled,
      label: [title, if (number != null) 'Número de carnet $number', if (primaryDate != null) '$primaryDateLabel $primaryDate'].join('. '),
      child: Container(
        height: statusLabel == null ? 234 : 180,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.primary),
          boxShadow: AppShadows.high,
        ),
        child: Stack(
          children: [
            Positioned(
              right: statusLabel == null ? 8 : -4,
              bottom: statusLabel == null ? -23 : -48,
              child: const _DigitalCardDots(),
            ),
            if (statusLabel != null) ...[
              Positioned(
                right: AppDimensions.space8,
                top: AppDimensions.space8,
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
            ],
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: statusLabel == null ? AppDimensions.space16 : 9,
                vertical: AppDimensions.space8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título / Carnet',
                    style: _cardCaptionStyle,
                  ),
                  const SizedBox(height: AppDimensions.space2),
                  Padding(
                    padding: EdgeInsets.only(right: statusLabel == null ? 84 : 116),
                    child: Text(
                      title,
                      style: AppTypography.h2.copyWith(color: AppColors.textWhite),
                    ),
                  ),
                  SizedBox(height: statusLabel == null ? AppDimensions.space8 : AppDimensions.space16),
                  if (number != null) ...[
                    Text('Número de carnet', style: _cardCaptionStyle),
                    Text(
                      number!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.h3.copyWith(color: AppColors.textWhite),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                  ],
                  if (primaryDate != null)
                    Row(
                      children: [
                        Expanded(
                          child: _CardDate(label: primaryDateLabel!, value: primaryDate!),
                        ),
                        if (secondaryDate != null) ...[
                          const SizedBox(width: AppDimensions.space16),
                          Expanded(
                            child: _CardDate(label: secondaryDateLabel!, value: secondaryDate!),
                          ),
                        ],
                      ],
                    ),
                  const Spacer(),
                  TextButton.icon(
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
  const _DigitalCardDots();

  static const _pattern = <String>[
    '111',
    '111',
    '001111',
    '0011111',
    '001111',
    '00010',
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
                Container(
                  width: 17,
                  height: 17,
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: _pattern[row][col] == '1' ? AppColors.secondaryLight400 : AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
