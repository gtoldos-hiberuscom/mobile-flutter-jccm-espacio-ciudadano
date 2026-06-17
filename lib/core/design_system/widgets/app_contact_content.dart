import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

class AppSectionHeading extends StatelessWidget {
  const AppSectionHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(final BuildContext context) => Text(
    text,
    style: AppTypography.h2.copyWith(color: AppColors.primary),
  );
}

class AppIconTextBlock extends StatelessWidget {
  const AppIconTextBlock({
    required this.text,
    super.key,
    this.icon,
    this.iconAsset,
    this.boldParts = const [],
    this.iconColor = AppColors.secondary,
    this.iconSize = AppDimensions.iconLarge,
  });

  final IconData? icon;
  final String? iconAsset;
  final String text;
  final List<String> boldParts;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(final BuildContext context) {
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.primary);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactLeadingIcon(
          icon: icon,
          iconAsset: iconAsset,
          color: iconColor,
          size: iconSize,
        ),
        const SizedBox(width: AppDimensions.space16),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: style,
              children: _spansWithBoldParts(text, style, boldParts),
            ),
          ),
        ),
      ],
    );
  }

  List<TextSpan> _spansWithBoldParts(
    final String value,
    final TextStyle style,
    final List<String> boldParts,
  ) {
    if (boldParts.isEmpty) {
      return [TextSpan(text: value)];
    }
    final spans = <TextSpan>[];
    var cursor = 0;
    while (cursor < value.length) {
      final next = boldParts
          .map((final part) => (part: part, index: value.indexOf(part, cursor)))
          .where((final match) => match.index >= 0)
          .fold<({String part, int index})?>(
            null,
            (final current, final match) => current == null || match.index < current.index ? match : current,
          );
      if (next == null) {
        spans.add(TextSpan(text: value.substring(cursor)));
        break;
      }
      if (cursor < next.index) {
        spans.add(TextSpan(text: value.substring(cursor, next.index)));
      }
      spans.add(
        TextSpan(
          text: next.part,
          style: style.copyWith(fontWeight: FontWeight.w700),
        ),
      );
      cursor = next.index + next.part.length;
    }
    return spans;
  }
}

class AppContactActionCard extends StatelessWidget {
  const AppContactActionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
    this.icon = AppIcons.openInNew,
    this.iconSize = AppDimensions.iconLarge,
    this.semanticLabel,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData icon;
  final double iconSize;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) => Semantics(
    button: true,
    label: semanticLabel,
    child: ExcludeSemantics(
      excluding: semanticLabel != null,
      child: Material(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              border: Border.all(color: AppColors.borderBlueMutedLight),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              boxShadow: AppShadows.low,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.leadingMedium.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          subtitle,
                          style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space16),
                  AppIcon(icon, color: AppColors.textBase, size: iconSize),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class AppPhoneActionCard extends StatelessWidget {
  const AppPhoneActionCard({
    required this.number,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final String number;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => AppContactActionCard(
    title: number,
    subtitle: subtitle,
    icon: AppIcons.call,
    semanticLabel: 'Llamar al $number',
    onTap: onTap,
  );
}

class _ContactLeadingIcon extends StatelessWidget {
  const _ContactLeadingIcon({
    required this.icon,
    required this.iconAsset,
    required this.color,
    required this.size,
  });

  final IconData? icon;
  final String? iconAsset;
  final Color color;
  final double size;

  @override
  Widget build(final BuildContext context) {
    if (iconAsset != null) {
      return AppSvgIcon(iconAsset!, size: size);
    }
    return AppIcon(icon ?? AppIcons.info, color: color, size: size);
  }
}
