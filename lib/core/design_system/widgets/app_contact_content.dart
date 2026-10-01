import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class AppSectionHeading extends StatelessWidget {
  const AppSectionHeading(
    this.text, {
    super.key,
    this.headingLevel = 2,
  }) : assert(text.length > 0, 'text must not be empty'),
       assert(headingLevel >= 1 && headingLevel <= 6, 'headingLevel must be between 1 and 6');

  final String text;
  final int headingLevel;

  @override
  Widget build(final BuildContext context) => Semantics(
    header: true,
    headingLevel: headingLevel,
    child: Text(
      text,
      style: AppTypography.h2.copyWith(color: AppColors.primary),
    ),
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
    this.semanticsLabel,
  }) : assert(text.length > 0, 'text must not be empty'),
       assert(icon == null || iconAsset == null, 'provide either icon or iconAsset, not both'),
       assert(iconAsset == null || iconAsset.length > 0, 'iconAsset must not be empty'),
       assert(iconSize > 0, 'iconSize must be positive'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final IconData? icon;
  final String? iconAsset;
  final String text;
  final List<String> boldParts;
  final Color iconColor;
  final double iconSize;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.primary);
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: _ContactLeadingIcon(
            icon: icon,
            iconAsset: iconAsset,
            color: iconColor,
            size: iconSize,
          ),
        ),
        const SizedBox(width: AppDimensions.space16),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: style,
              children: _spansWithBoldParts(text, style, boldParts),
            ),
            textScaler: MediaQuery.textScalerOf(context),
          ),
        ),
      ],
    );

    if (semanticsLabel == null) {
      return content;
    }

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: ExcludeSemantics(child: content),
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
    this.semanticHint,
    this.isExternalLink = true,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(subtitle.length > 0, 'subtitle must not be empty'),
       assert(iconSize > 0, 'iconSize must be positive'),
       assert(semanticLabel == null || semanticLabel.length > 0, 'semanticLabel must not be empty'),
       assert(semanticHint == null || semanticHint.length > 0, 'semanticHint must not be empty');

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData icon;
  final double iconSize;
  final String? semanticLabel;
  final String? semanticHint;
  final bool isExternalLink;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      container: true,
      button: !isExternalLink,
      link: isExternalLink,
      enabled: true,
      label: semanticLabel ?? '$title. $subtitle',
      hint: semanticHint ?? (isExternalLink ? l10n.externalLinkA11yHint : null),
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          // Foco de teclado visible y con contraste (WCAG 1.4.11 / 2.4.7): el
          // InkWell sólo aporta un sombreado que no llega a 3:1.
          child: AppFocusRing(
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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
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
        ),
      ),
    );
  }
}

class AppPhoneActionCard extends StatelessWidget {
  const AppPhoneActionCard({
    required this.number,
    required this.subtitle,
    required this.onTap,
    super.key,
    this.semanticLabel,
    this.semanticHint,
  }) : assert(number.length > 0, 'number must not be empty'),
       assert(subtitle.length > 0, 'subtitle must not be empty'),
       assert(semanticLabel == null || semanticLabel.length > 0, 'semanticLabel must not be empty'),
       assert(semanticHint == null || semanticHint.length > 0, 'semanticHint must not be empty');

  final String number;
  final String subtitle;
  final VoidCallback onTap;
  final String? semanticLabel;
  final String? semanticHint;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppContactActionCard(
      title: number,
      subtitle: subtitle,
      icon: AppIcons.call,
      semanticLabel: semanticLabel ?? l10n.appPhoneCallLabel(number, subtitle),
      semanticHint: semanticHint ?? l10n.appPhoneCallHint,
      isExternalLink: false,
      onTap: onTap,
    );
  }
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
