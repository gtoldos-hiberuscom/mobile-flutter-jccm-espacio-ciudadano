import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

class AppExternalLinkSection extends StatelessWidget {
  const AppExternalLinkSection({
    required this.title,
    required this.links,
    super.key,
  });

  final String title;
  final List<AppExternalLinkItem> links;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
          child: Text(
            title,
            style: AppTypography.h2.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: AppDimensions.space16),
        for (var i = 0; i < links.length; i++) ...[
          links[i],
          if (i < links.length - 1) const SizedBox(height: AppDimensions.space16),
        ],
      ],
    );
  }
}

class AppExternalLinkItem extends StatelessWidget {
  const AppExternalLinkItem({
    required this.label,
    required this.onTap,
    super.key,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: AppDimensions.space16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AppDoubleBullet(),
                  const SizedBox(width: AppDimensions.space8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                      child: Text(
                        label,
                        style: AppTypography.bodyLink.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimensions.space4),
                    child: AppIcon(
                      AppIcons.openInNew,
                      color: AppColors.textBase,
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

class _AppDoubleBullet extends StatelessWidget {
  const _AppDoubleBullet();

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: AppDimensions.space32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.space8,
            height: AppDimensions.space8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.space4),
          Container(
            width: AppDimensions.space8,
            height: AppDimensions.space8,
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
