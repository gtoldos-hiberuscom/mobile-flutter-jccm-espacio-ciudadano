import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Variant for [AppCard] — mirrors the Figma `propClass` property.
enum AppCardClass {
  /// Standard content card with category tag, title, ref block, attachment, and action.
  basic,

  /// Calendar/appointment card with date, time, title, and description block.
  agenda,
}

/// Status for [AppCard] — mirrors the Figma `status` property.
enum AppCardState {
  /// Active, default appearance.
  defaultState,

  /// Expiry/attention — warning colours on the ref block.
  warning,

  /// Card is expired/inactive; all content uses muted colours.
  disabled,
}

class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppDimensions.space16),
    this.semanticLabel,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);
    final card = Material(
      color: AppColors.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.backgroundBlueMutedLight),
            boxShadow: AppShadows.low,
            color: AppColors.surface,
          ),
          child: child,
        ),
      ),
    );

    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: semanticLabel == null ? card : ExcludeSemantics(child: card),
    );
  }
}

class AppRecommendationCard extends StatelessWidget {
  const AppRecommendationCard({
    required this.title,
    required this.categoryLabels,
    required this.detailLabel,
    required this.detailText,
    super.key,
    this.statusLabel,
    this.statusText,
    this.onTap,
  });

  final String title;
  final List<String> categoryLabels;
  final String detailLabel;
  final String detailText;
  final String? statusLabel;
  final String? statusText;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderBlueMutedLight),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (categoryLabels.isNotEmpty) ...[
            Wrap(
              spacing: AppDimensions.space16,
              children: [
                for (final label in categoryLabels)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.space4,
                      bottom: AppDimensions.space8,
                    ),
                    child: Text(
                      '#${label.toUpperCase()}',
                      style: AppTypography.captionUppercase.copyWith(
                        color: AppColors.textBlueMutedDark,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.space8),
          ],
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimensions.space4,
              bottom: AppDimensions.space8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                const AppIcon(
                  AppIcons.openInNew,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space8,
              vertical: AppDimensions.space4,
            ),
            color: AppColors.backgroundLightBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.space4),
                Text(
                  detailLabel.toUpperCase(),
                  style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  detailText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.smallRegular.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: AppDimensions.space4),
              ],
            ),
          ),
          if (statusText != null) ...[
            const SizedBox(height: AppDimensions.space8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (statusLabel ?? 'Estado').toUpperCase(),
                    style: AppTypography.captionUppercase.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    statusText!,
                    style: AppTypography.smallRegular.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: content,
      ),
    );
  }
}

/// A flexible content card — mirrors the Figma **"Cards/Cards"** component
/// (node `56:3449`) from the DS canvas section `165:6403`.
///
/// **Design rule (Figma):** "Una card con sombra implica que será interactiva
/// y viceversa."  When [isInteractive] is `true` the card uses
/// [AppShadows.medium] and an `8 dp` radius; non-interactive cards use
/// [AppShadows.low] and a `4 dp` radius.
///
/// ## Variants
/// - [AppCardClass.basic] — service/document card with optional category label,
///   status tag, title icon, ref/expiry block, attachment link, action button,
///   and last-update footer.
/// - [AppCardClass.agenda] — appointment card with date, time, title,
///   description block, optional action button, and last-update footer.
///
/// ## Example — Basic (interactive, default)
/// ```dart
/// AppCard(
///   title: 'Familia numerosa',
///   categoryLabel: 'Tag | Categoría',
///   statusTag: AppTag(status: AppTagStatus.infoActive, label: 'Actualizado'),
///   titleIcon: Icon(Icons.badge_outlined, size: 32, color: AppColors.primary),
///   refNumber: '0000000000000000',
///   expiryDate: '30 Dic 2029',
///   attachmentLabel: 'Archivos adjuntos al expediente',
///   lastUpdateText: 'Actualizado el 21 abr 2026 a las 23:00h',
///   onTap: () {},
/// )
/// ```
///
/// ## Example — Agenda (non-interactive)
/// ```dart
/// AppCard(
///   cardClass: AppCardClass.agenda,
///   title: 'Cita en Atención Primaria',
///   isInteractive: false,
///   date: '21 dic 2026',
///   time: '10:30h',
///   description: 'Texto de la descripción del evento.',
///   lastUpdateText: 'Actualizado el 21 abr 2026 a las 23:00h',
/// )
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    required this.title,
    super.key,
    this.cardClass = AppCardClass.basic,
    this.state = AppCardState.defaultState,
    this.isInteractive = true,
    // ── Basic slots ──────────────────────────────────────────────────────────
    this.categoryLabel,
    this.statusTag,
    this.titleIcon,
    this.refNumber,
    this.expiryDate,
    this.expiryWarning = false,
    this.attachmentLabel,
    this.onAttachmentTap,
    this.actionButton,
    this.lastUpdateText,
    this.showArrow = false,
    this.refNumberLabel = 'Nº ref.',
    this.expiryDateLabel = 'Expir.',
    this.extraLabel,
    this.extraText,
    // ── Agenda slots ─────────────────────────────────────────────────────────
    this.date,
    this.time,
    this.description,
    // ── Interaction ───────────────────────────────────────────────────────────
    this.onTap,
    // ── Legacy compat ─────────────────────────────────────────────────────────
    @Deprecated('Use titleIcon') this.leading,
    @Deprecated('Use actionButton') this.trailing,
    @Deprecated('Use date') this.month,
    @Deprecated('Use description') this.subtitle,
  });

  final AppCardClass cardClass;
  final AppCardState state;

  /// When `true` (default) the card has [AppShadows.medium] + `8 dp` radius.
  /// When `false` the card uses [AppShadows.low] + `4 dp` radius.
  /// Disabled cards are always non-interactive visually.
  final bool isInteractive;

  /// Main title — Inter Bold 18/28 (`leadingBold`).
  final String title;

  // ── Basic ─────────────────────────────────────────────────────────────────

  /// Uppercase caption label at the top-left of the header row.
  final String? categoryLabel;

  /// Status tag widget — typically `AppTag(status: ..., label: ...)`.
  final Widget? statusTag;

  /// 32 dp icon displayed to the left of the title.
  final Widget? titleIcon;

  /// Reference number shown in the description block.
  final String? refNumber;

  /// Expiry date shown in the description block.
  final String? expiryDate;

  /// When `true`, displays [expiryDate] in warning colour with a warning icon.
  final bool expiryWarning;

  /// Attachment row label text.
  final String? attachmentLabel;

  /// Tap callback for the attachment row.
  final VoidCallback? onAttachmentTap;

  /// Optional action button widget — typically `AppButton(...)`.
  final Widget? actionButton;

  /// Last-update footer text, prefixed with an `autorenew` icon.
  final String? lastUpdateText;

  /// When `true`, shows a trailing `arrow_forward` icon next to the title
  /// (navigation affordance) — independent from [titleIcon].
  final bool showArrow;

  /// Overrides the "Nº ref." label in the ref block's first row.
  final String refNumberLabel;

  /// Overrides the "Expir." label in the ref block's second row.
  final String expiryDateLabel;

  /// Uppercase caption label for the optional info block rendered below the
  /// ref block (e.g. "Estado").
  final String? extraLabel;

  /// Value text for the optional info block rendered below the ref block.
  final String? extraText;

  // ── Agenda ────────────────────────────────────────────────────────────────

  /// Date string — e.g. `'21 dic 2026'`.
  final String? date;

  /// Time string — e.g. `'10:30h'`.
  final String? time;

  /// Description text shown in the content block.
  final String? description;

  // ── Interaction ───────────────────────────────────────────────────────────

  final VoidCallback? onTap;

  // ── Legacy compat (unused internally) ────────────────────────────────────
  @Deprecated('Use titleIcon')
  // ignore: deprecated_member_use_from_same_package
  final Widget? leading;
  @Deprecated('Use actionButton')
  // ignore: deprecated_member_use_from_same_package
  final Widget? trailing;
  @Deprecated('Use date')
  // ignore: deprecated_member_use_from_same_package
  final String? month;
  @Deprecated('Use description')
  // ignore: deprecated_member_use_from_same_package
  final String? subtitle;

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool get _isDisabled => state == AppCardState.disabled;

  BorderRadius get _borderRadius => BorderRadius.circular(
    isInteractive && !_isDisabled ? AppDimensions.radiusMedium : AppDimensions.radiusXs,
  );

  List<BoxShadow> get _shadow => isInteractive && !_isDisabled ? AppShadows.medium : AppShadows.low;

  Color _textColor([final Color? active]) => _isDisabled ? AppColors.neutralDark : (active ?? AppColors.textPrimary);

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(final BuildContext context) {
    // WCAG 4.1.2 — unified semantic label for complex cards.
    final semanticSegments = <String>[
      ?categoryLabel,
      title,
      ?refNumber,
      ?expiryDate,
      ?date,
      ?time,
      ?description,
      ?extraText,
    ];
    final composedLabel = semanticSegments.join(', ');

    return Semantics(
      label: composedLabel,
      button: onTap != null,
      enabled: !_isDisabled,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: _isDisabled ? null : onTap,
          borderRadius: _borderRadius,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: _borderRadius,
              border: Border.all(color: AppColors.borderBlueMutedLight),
              boxShadow: _shadow,
            ),
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: cardClass == AppCardClass.agenda ? _agendaSlots() : _basicSlots(),
            ),
          ),
        ),
      ),
    );
  }

  // ── Basic slots ───────────────────────────────────────────────────────────

  List<Widget> _basicSlots() => [
    if (categoryLabel != null || statusTag != null) _headerRow(),
    _titleRow(),
    if (refNumber != null || expiryDate != null) _refBlock(),
    if (extraLabel != null && extraText != null) _extraInfoBlock(),
    if (attachmentLabel != null) _attachmentRow(),
    if (actionButton != null) SizedBox(width: double.infinity, child: actionButton),
    if (lastUpdateText != null) _lastUpdateRow(),
  ];

  Widget _headerRow() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          if (categoryLabel != null)
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 215,
                maxWidth: 290,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppDimensions.space4,
                  bottom: AppDimensions.space8,
                ),
                child: Text(
                  categoryLabel!,
                  textAlign: TextAlign.right,
                  style: AppTypography.captionUppercase.copyWith(
                    color: _isDisabled ? AppColors.neutralDark : AppColors.textBlueMutedDark,
                  ),
                ),
              ),
            ),
          ?statusTag,
        ],
      ),
    );
  }

  Widget _titleRow() {
    final effectiveTitleIcon = titleIcon;
    final titleColor = _isDisabled ? AppColors.neutralDark : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.space4,
        bottom: AppDimensions.space8,
      ),
      child: Row(
        children: [
          if (effectiveTitleIcon != null) ...[
            SizedBox(width: 32, height: 32, child: effectiveTitleIcon),
            const SizedBox(width: AppDimensions.space4),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTypography.leadingBold.copyWith(color: titleColor),
            ),
          ),
          if (showArrow) ...[
            const SizedBox(width: AppDimensions.space8),
            AppIcon(
              AppIcons.arrowForward,
              color: _isDisabled ? AppColors.neutralDark : AppColors.primaryDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _refBlock() {
    final bgColor = _isDisabled ? AppColors.backgroundBlueMutedLight : AppColors.backgroundLightBlue;

    final labelColor = _isDisabled ? AppColors.neutralDark : AppColors.primary;
    final valueColor = _isDisabled ? AppColors.neutralDark : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (refNumber != null)
            _refRow(
              label: refNumberLabel,
              value: refNumber!,
              labelColor: labelColor,
              valueColor: valueColor,
            ),
          if (expiryDate != null)
            _refRow(
              label: expiryDateLabel,
              value: expiryDate!,
              labelColor: labelColor,
              valueColor: expiryWarning ? AppColors.warningDark : valueColor,
              valueWeight: expiryWarning ? FontWeight.w700 : FontWeight.w400,
              trailingIcon: expiryWarning
                  ? const Icon(
                      Icons.warning_amber_rounded,
                      size: AppDimensions.iconMedium,
                      color: AppColors.warningDark,
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  Widget _refRow({
    required final String label,
    required final String value,
    required final Color labelColor,
    required final Color valueColor,
    final FontWeight valueWeight = FontWeight.w400,
    final Widget? trailingIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Wrap(
        spacing: AppDimensions.space8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 124),
            child: Text(
              label.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(color: labelColor),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTypography.smallRegular.copyWith(
                  color: valueColor,
                  fontWeight: valueWeight,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppDimensions.space4),
                trailingIcon,
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _extraInfoBlock() {
    final color = _isDisabled ? AppColors.neutralDark : AppColors.primary;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.space8, bottom: AppDimensions.space4),
            child: Text(
              extraLabel!,
              style: AppTypography.captionUppercase.copyWith(color: color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space4),
            child: Text(
              extraText!,
              style: AppTypography.smallRegular.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentRow() {
    return InkWell(
      onTap: _isDisabled ? null : onAttachmentTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
        child: Row(
          children: [
            AppIcon(
              AppIcons.attachment,
              color: _textColor(),
            ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                attachmentLabel!,
                style: AppTypography.bodyRegular.copyWith(color: _textColor()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lastUpdateRow() {
    final color = _isDisabled ? AppColors.neutralDark : AppColors.blueMuted900;
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          AppIcon(AppIcons.autorenew, color: color),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Text(
              lastUpdateText!,
              style: AppTypography.smallRegular.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  // ── Agenda slots ──────────────────────────────────────────────────────────

  List<Widget> _agendaSlots() => [
    if (date != null || time != null) _agendaHeaderRow(),
    _agendaTitleRow(),
    if (description != null) _agendaContentBlock(),
    if (actionButton != null) SizedBox(width: double.infinity, child: actionButton),
    if (lastUpdateText != null) _lastUpdateRow(),
  ];

  Widget _agendaHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (date != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconMedium,
                  color: _textColor(),
                ),
                const SizedBox(width: AppDimensions.space8),
                Text(
                  date!,
                  style: AppTypography.bodyRegular.copyWith(color: _textColor()),
                ),
              ],
            ),
          if (time != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: AppDimensions.iconMedium,
                  color: _textColor(),
                ),
                const SizedBox(width: AppDimensions.space8),
                Text(
                  time!,
                  style: AppTypography.bodyRegular.copyWith(color: _textColor()),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _agendaTitleRow() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.space4,
        bottom: AppDimensions.space8,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          title,
          style: AppTypography.leadingBold.copyWith(color: _textColor()),
        ),
      ),
    );
  }

  Widget _agendaContentBlock() {
    final bgColor = _isDisabled ? AppColors.backgroundBlueMutedLight : AppColors.backgroundBlueLighter;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      color: bgColor,
      child: Text(
        description!,
        style: AppTypography.smallRegular.copyWith(color: _textColor()),
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
    this.height = 16,
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
          backgroundColor: backgroundColor ?? const Color(0xFFE0E5EB),
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.secondary,
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
        border: Border.all(color: AppColors.primary),
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
