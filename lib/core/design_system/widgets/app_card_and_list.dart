import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

enum AppCardClass { basic, agenda }

enum AppCardState { defaultState, warning, disabled }

class AppCard extends StatelessWidget {
  const AppCard({
    required this.title,
    super.key,
    this.cardClass = AppCardClass.basic,
    this.state = AppCardState.defaultState,
    this.subtitle,
    this.trailing,
    this.leading,
    this.onTap,
    this.date,
    this.month,
  });

  final AppCardClass cardClass;
  final AppCardState state;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onTap;
  final String? date;
  final String? month;

  @override
  Widget build(final BuildContext context) {
    final isDisabled = state == AppCardState.disabled;
    final bgColor = switch (state) {
      AppCardState.warning => AppColors.warningContainer,
      AppCardState.disabled => AppColors.disabledContainer,
      AppCardState.defaultState => AppColors.surface,
    };
    final borderColor = switch (state) {
      AppCardState.warning => AppColors.warning,
      AppCardState.disabled => AppColors.outline,
      AppCardState.defaultState => AppColors.outlineVariant,
    };

    final Widget cardContent = switch (cardClass) {
      AppCardClass.agenda => _buildAgendaContent(isDisabled),
      AppCardClass.basic => _buildBasicContent(isDisabled),
    };

    return Semantics(
      button: onTap != null,
      enabled: !isDisabled,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(color: borderColor),
            boxShadow: isDisabled ? const <BoxShadow>[] : AppShadows.low,
          ),
          child: cardContent,
        ),
      ),
    );
  }

  Widget _buildBasicContent(final bool isDisabled) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppDimensions.space12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyBold.copyWith(
                    color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.space4),
                  Text(
                    subtitle!,
                    style: AppTypography.bodyBase.copyWith(
                      color: isDisabled ? AppColors.textDisabled : AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppDimensions.space12),
            trailing!,
          ],
        ],
      ),
    );
  }

  Widget _buildAgendaContent(final bool isDisabled) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (date != null && month != null)
            Container(
              width: 48,
              padding: const EdgeInsets.all(AppDimensions.space8),
              decoration: BoxDecoration(
                color: isDisabled ? AppColors.disabledContainer : AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Column(
                children: [
                  Text(
                    date!,
                    style: AppTypography.h5.copyWith(
                      color: isDisabled ? AppColors.textDisabled : AppColors.primary,
                    ),
                  ),
                  Text(
                    month!.toUpperCase(),
                    style: AppTypography.small.copyWith(
                      color: isDisabled ? AppColors.textDisabled : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: AppDimensions.space12),
          Expanded(child: _buildBasicContent(isDisabled)),
        ],
      ),
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.semanticsLabel,
    this.height = 8,
    this.borderRadius,
  });

  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final String? semanticsLabel;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? 'Progreso',
      value: value != null ? '${(value! * 100).round()}%' : null,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusRound),
        child: LinearProgressIndicator(
          value: value,
          minHeight: height,
          backgroundColor: backgroundColor ?? AppColors.neutral300,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? const Color(0xFF156579),
          ),
        ),
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = AppAvatarSize.medium,
    this.hasStatus = false,
    this.statusColor,
    this.semanticsLabel,
  });

  final String? imageUrl;
  final String? initials;
  final AppAvatarSize size;
  final bool hasStatus;
  final Color? statusColor;
  final String? semanticsLabel;

  double get _radius => switch (size) {
    AppAvatarSize.small => 16,
    AppAvatarSize.medium => 24,
    AppAvatarSize.large => 32,
  };

  @override
  Widget build(final BuildContext context) {
    final normalizedInitials = initials?.trim() ?? '';
    final child = imageUrl == null
        ? normalizedInitials.isNotEmpty
              ? Text(
                  normalizedInitials.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    fontSize: _radius * 0.65,
                    color: const Color(0xFF0C0D0D),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.15,
                  ),
                )
              : Icon(
                  Icons.person_rounded,
                  size: _radius * 0.8,
                  color: AppColors.primary,
                )
        : null;

    final avatarWidget = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: CircleAvatar(
        radius: _radius,
        backgroundColor: const Color(0xFFBAE3EE),
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        child: child,
      ),
    );

    if (!hasStatus) {
      return Semantics(label: semanticsLabel, child: avatarWidget);
    }

    return Semantics(
      label: semanticsLabel,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: _radius * 0.5,
              height: _radius * 0.5,
              decoration: BoxDecoration(
                color: statusColor ?? AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AppAvatarSize { small, medium, large }

class AppListItem extends StatelessWidget {
  const AppListItem({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isDisabled = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDisabled;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      onTap: isDisabled ? null : onTap,
      leading: leading,
      trailing:
          trailing ??
          (onTap != null && !isDisabled
              ? const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: AppDimensions.iconMedium,
                )
              : null),
      title: Text(
        title,
        style: AppTypography.bodyBase.copyWith(
          color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodyS.copyWith(
                color: isDisabled ? AppColors.textDisabled : AppColors.textSecondary,
              ),
            )
          : null,
    );
  }
}
