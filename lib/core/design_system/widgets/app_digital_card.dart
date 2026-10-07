import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Compact credential card matching the current Carnets Digitales component.
/// Its detail fields stay available to screen readers, but are no longer shown.
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
    this.cardArtAsset = AppDigitalCardAssets.disability,
    this.onDownload,
    this.isDownloading = false,
    this.semanticLabel,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(downloadLabel.length > 0, 'downloadLabel must not be empty'),
       assert(primaryDate == null || primaryDateLabel != null, 'primaryDateLabel is required with primaryDate'),
       assert(secondaryDate == null || secondaryDateLabel != null, 'secondaryDateLabel is required with secondaryDate');

  final String title;
  final String? number;
  final String? primaryDateLabel;
  final String? primaryDate;
  final String? secondaryDateLabel;
  final String? secondaryDate;
  final String? statusLabel;
  final String cardArtAsset;
  final String downloadLabel;
  final VoidCallback? onDownload;
  final bool isDownloading;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabled = onDownload != null && !isDownloading;
    final summary =
        semanticLabel ??
        [
          title,
          if (number != null) '${l10n.digitalCardNumberLabel}: $number',
          if (primaryDate != null) '$primaryDateLabel: $primaryDate',
          if (secondaryDate != null) '$secondaryDateLabel: $secondaryDate',
          ?statusLabel,
        ].join('. ');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: summary,
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          final scale = constraints.maxWidth / 274;
          final textScale = MediaQuery.textScalerOf(context).scale(1);
          return AspectRatio(
            aspectRatio: 274 / (180 * textScale),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium * scale),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondaryLight300],
                ),
                boxShadow: [BoxShadow(color: const Color(0x47000000), blurRadius: 8 * scale, offset: Offset(0, 3 * scale))],
              ),
              child: Padding(
                padding: EdgeInsets.all(2 * scale),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6 * scale),
                  child: ColoredBox(
                    color: AppColors.primaryLight,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -22 * scale,
                          top: -62 * scale,
                          child: ExcludeSemantics(
                            child: _CardCornerCircle(scale: scale, key: const ValueKey('digital-card-corner-circle')),
                          ),
                        ),
                        Positioned(
                          right: AppDimensions.space8 * scale,
                          bottom: AppDimensions.space8 * scale,
                          child: ExcludeSemantics(
                            child: _DigitalCardBranding(scale: scale, key: const ValueKey('digital-card-branding')),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppDimensions.space8 * scale),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppDimensions.space8 * scale),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: ExcludeSemantics(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: SvgPicture.asset(
                                              'assets/images/castilla_logo.svg',
                                              width: 45.4 * scale,
                                              height: 28 * scale,
                                              colorFilter: const ColorFilter.mode(AppColors.textWhite, BlendMode.srcIn),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: ExcludeSemantics(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerRight,
                                            child: _CardArt(asset: cardArtAsset, scale: scale),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppDimensions.space32 * scale),
                              ExcludeSemantics(
                                child: Padding(
                                  padding: EdgeInsets.only(left: AppDimensions.space4 * scale),
                                  child: Text(
                                    title,
                                    style: AppTypography.bodyBold.copyWith(color: AppColors.textWhite, fontSize: 16 * scale),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Semantics(
                                button: true,
                                enabled: enabled,
                                label: '$downloadLabel $title',
                                value: isDownloading ? l10n.a11yLoading : null,
                                liveRegion: isDownloading,
                                onTap: enabled ? onDownload : null,
                                child: ExcludeSemantics(
                                  child: AppFocusRing(
                                    enabled: enabled,
                                    child: TextButton.icon(
                                      onPressed: enabled ? onDownload : null,
                                      style: TextButton.styleFrom(
                                        foregroundColor: downloadColor,
                                        disabledForegroundColor: downloadColor.withValues(alpha: 0.55),
                                        overlayColor: Colors.transparent,
                                        minimumSize: Size(48 * scale, AppDimensions.minTouchTarget * scale),
                                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.space4 * scale),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      icon: isDownloading
                                          ? SizedBox.square(
                                              dimension: AppDimensions.iconMedium * scale,
                                              child: CircularProgressIndicator(strokeWidth: 2 * scale, color: AppColors.secondaryLight300),
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/carnets/download.svg',
                                              width: AppDimensions.iconMedium * scale,
                                              height: AppDimensions.iconMedium * scale,
                                            ),
                                      label: Text(downloadLabel, style: AppTypography.smallBold.copyWith(fontSize: 14 * scale)),
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

abstract final class AppDigitalCardAssets {
  // Estos dos artes contienen una imagen raster embebida en el SVG original,
  // una construcción que `flutter_svg` no renderiza. Se usan sus PNG
  // equivalentes para que siempre se vean en Android e iOS.
  static const String disability = 'assets/icons/carnets/discapacidad.png';
  static const String largeFamily = 'assets/icons/carnets/familia.png';
  static const String youth = 'assets/icons/carnets/joven.svg';
}

@visibleForTesting
const Color downloadColor = AppColors.secondaryLight300;

class _CardArt extends StatelessWidget {
  const _CardArt({required this.asset, required this.scale});
  final String asset;
  final double scale;

  @override
  Widget build(final BuildContext context) => asset.endsWith('.svg') ? SvgPicture.asset(asset, width: 53 * scale, height: 24 * scale) : Image.asset(asset, width: 53 * scale, height: 24 * scale, fit: BoxFit.contain);
}

class _CardCornerCircle extends StatelessWidget {
  const _CardCornerCircle({required this.scale, super.key});
  final double scale;

  @override
  Widget build(final BuildContext context) => Container(
    width: 134 * scale,
    height: 134 * scale,
    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
  );
}

class _DigitalCardBranding extends StatelessWidget {
  const _DigitalCardBranding({required this.scale, super.key});
  final double scale;

  @override
  Widget build(final BuildContext context) => Opacity(
    opacity: 0.3,
    child: SvgPicture.asset(
      'assets/icons/carnets/logo_fondo.svg',
      width: 77 * scale,
      height: 64 * scale,
    ),
  );
}
