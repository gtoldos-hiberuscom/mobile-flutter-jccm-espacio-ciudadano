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
    required this.number,
    required this.expiryDate,
    required this.downloadLabel,
    super.key,
    this.onDownload,
    this.isDownloading = false,
  });

  final String title;
  final String number;
  final String expiryDate;
  final String downloadLabel;
  final VoidCallback? onDownload;
  final bool isDownloading;

  @override
  Widget build(final BuildContext context) {
    final enabled = onDownload != null && !isDownloading;

    return Semantics(
      button: enabled,
      label: '$title. Numero de carnet $number. Fecha de caducidad $expiryDate.',
      child: Container(
        constraints: const BoxConstraints(minHeight: 234),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: AppShadows.high,
        ),
        child: Stack(
          children: [
            const Positioned(
              right: 14,
              top: 82,
              child: _DigitalCardDots(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space8,
                AppDimensions.space8,
                AppDimensions.space8,
                AppDimensions.space16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Título / Carnet',
                    style: AppTypography.smallRegular.copyWith(color: AppColors.blue300),
                  ),
                  const SizedBox(height: AppDimensions.space2),
                  Padding(
                    padding: const EdgeInsets.only(right: 84),
                    child: Text(
                      title,
                      style: AppTypography.h2.copyWith(color: AppColors.textWhite),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    'Número de carnet',
                    style: AppTypography.smallRegular.copyWith(color: AppColors.blue300),
                  ),
                  Text(
                    number,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.h3.copyWith(color: AppColors.textWhite),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    'Fecha de caducidad',
                    style: AppTypography.smallRegular.copyWith(color: AppColors.blue300),
                  ),
                  Text(
                    expiryDate,
                    style: AppTypography.bodyBold.copyWith(color: AppColors.textWhite),
                  ),
                  const SizedBox(height: AppDimensions.space20),
                  TextButton.icon(
                    onPressed: enabled ? onDownload : null,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.blue300,
                      disabledForegroundColor: AppColors.blue300.withValues(alpha: 0.55),
                      minimumSize: const Size(0, AppDimensions.minTouchTarget),
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
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
