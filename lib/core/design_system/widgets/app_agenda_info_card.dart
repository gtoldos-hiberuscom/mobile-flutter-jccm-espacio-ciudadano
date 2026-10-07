import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

enum AppAgendaInfoCardType {
  notification,
  health,
  credential,
}

/// Compact agenda card used for notifications, health appointments and
/// credential expiry events.
class AppAgendaInfoCard extends StatelessWidget {
  const AppAgendaInfoCard({
    required this.type,
    required this.day,
    required this.weekday,
    required this.title,
    super.key,
    this.time,
    this.channel,
    this.primaryText,
    this.secondaryText,
    this.showTypeIcon = true,
    this.channelBeforeTitle = false,
    this.titleIsRegular = false,
    this.semanticsLabel,
  }) : assert(day.length > 0, 'day must not be empty'),
       assert(weekday.length > 0, 'weekday must not be empty'),
       assert(title.length > 0, 'title must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final AppAgendaInfoCardType type;
  final String day;
  final String weekday;
  final String title;
  final String? time;
  final String? channel;
  final String? primaryText;
  final String? secondaryText;

  /// Whether to render the trailing icon that identifies the agenda item type.
  final bool showTypeIcon;

  /// Places the channel label above the title when it is the appointment
  /// heading, instead of showing it as supporting information.
  final bool channelBeforeTitle;

  /// Uses the body-regular token for the title (the health appointment card
  /// variant), instead of the default emphasized title.
  final bool titleIsRegular;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final typeLabel = switch (type) {
      AppAgendaInfoCardType.notification => l10n.a11yAgendaTypeNotification,
      AppAgendaInfoCardType.health => l10n.a11yAgendaTypeHealth,
      AppAgendaInfoCardType.credential => l10n.a11yAgendaTypeCredential,
    };
    final semanticParts = [
      day,
      weekday,
      ?time,
      _displayCase(title),
      if (channel case final value? when value.isNotEmpty) _displayCase(value),
      if (primaryText case final value? when value.isNotEmpty) _displayCase(value),
      if (secondaryText case final value? when value.isNotEmpty) _displayCase(value),
    ].where((final part) => part.isNotEmpty);
    final effectiveLabel = semanticsLabel ?? l10n.a11yAgendaCard(typeLabel, semanticParts.join(', '));
    final useVerticalLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final dateBlock = _DateBlock(
      day: day,
      weekday: weekday,
      time: time,
      showVerticalDivider: !useVerticalLayout,
    );
    final contentBlock = _ContentBlock(
      title: title,
      channel: channel,
      primaryText: primaryText,
      secondaryText: secondaryText,
      channelBeforeTitle: channelBeforeTitle,
      titleIsRegular: titleIsRegular,
    );
    final typeIcon = showTypeIcon ? _TypeIcon(type: type, semanticsLabel: typeLabel) : null;

    return Semantics(
      container: true,
      label: effectiveLabel,
      child: ExcludeSemantics(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.space8).copyWith(
            top: AppDimensions.space16,
            bottom: AppDimensions.space16,
          ),
          decoration: _decoration,
          child: useVerticalLayout
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: dateBlock),
                        const SizedBox(width: AppDimensions.space8),
                        ?typeIcon,
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    contentBlock,
                  ],
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      dateBlock,
                      const SizedBox(width: AppDimensions.space8),
                      Expanded(child: contentBlock),
                      if (typeIcon != null) ...[
                        const SizedBox(width: AppDimensions.space4),
                        Align(alignment: Alignment.topCenter, child: typeIcon),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  BoxDecoration get _decoration => const BoxDecoration(
    color: AppColors.surface,
    border: Border(
      left: BorderSide(color: AppColors.borderBlueMutedLight, width: 4),
      top: BorderSide(color: AppColors.borderBlueMutedLight),
      right: BorderSide(color: AppColors.borderBlueMutedLight),
      bottom: BorderSide(color: AppColors.borderBlueMutedLight),
    ),
    borderRadius: BorderRadius.all(Radius.circular(1)),
  );
}

class _DateBlock extends StatelessWidget {
  const _DateBlock({
    required this.day,
    required this.weekday,
    required this.time,
    required this.showVerticalDivider,
  });

  final String day;
  final String weekday;
  final String? time;
  final bool showVerticalDivider;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
      decoration: showVerticalDivider
          ? const BoxDecoration(
              border: Border(
                right: BorderSide(color: AppColors.backgroundBlueMutedLight),
              ),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: time == null ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(
            day,
            style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
            maxLines: 1,
            softWrap: false,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              weekday.toLowerCase(),
              style: AppTypography.captionRegular.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
            ),
          ),
          if (time != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.neutral100,
              ),
            ),
            Text(
              time!,
              style: AppTypography.smallRegular.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              softWrap: false,
            ),
          ],
        ],
      ),
    );
  }
}

class _ContentBlock extends StatelessWidget {
  const _ContentBlock({
    required this.title,
    required this.channel,
    required this.primaryText,
    required this.secondaryText,
    required this.channelBeforeTitle,
    required this.titleIsRegular,
  });

  final String title;
  final String? channel;
  final String? primaryText;
  final String? secondaryText;
  final bool channelBeforeTitle;
  final bool titleIsRegular;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (channelBeforeTitle && channel != null && channel!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space4),
            child: Text(
              channel!.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(
                color: AppColors.textBlueMutedDark,
              ),
            ),
          ),
        Text(
          _displayCase(title),
          style: (titleIsRegular ? AppTypography.bodyRegular : AppTypography.bodyBold).copyWith(color: AppColors.textPrimary),
        ),
        if (!channelBeforeTitle && channel != null && channel!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
            child: Text(
              channel!.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(
                color: AppColors.blueMuted900,
              ),
            ),
          ),
        if (primaryText != null && primaryText!.isNotEmpty)
          Text(
            _displayCase(primaryText!),
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        if (secondaryText != null && secondaryText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.space4),
            child: Text(
              _displayCase(secondaryText!),
              style: AppTypography.captionRegular.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

String _displayCase(final String value) {
  final trimmed = value.trim();
  final hasLetters = RegExp('[A-Za-zÁÉÍÓÚÜÑ]').hasMatch(trimmed);
  if (!hasLetters || trimmed != trimmed.toUpperCase()) {
    return trimmed;
  }

  final lowerCase = trimmed.toLowerCase();
  return '${lowerCase[0].toUpperCase()}${lowerCase.substring(1)}';
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type, required this.semanticsLabel});

  final AppAgendaInfoCardType type;
  final String semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final assetPath = switch (type) {
      AppAgendaInfoCardType.notification => AppIconAssets.mail,
      AppAgendaInfoCardType.health => AppIconAssets.health,
      AppAgendaInfoCardType.credential => AppIconAssets.idCard,
    };

    return SizedBox.square(
      dimension: AppDimensions.iconMedium,
      child: Center(
        child: AppSvgIcon(
          assetPath,
          color: AppColors.borderBlueMutedBase,
          semanticsLabel: semanticsLabel,
        ),
      ),
    );
  }
}
