import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

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
    this.semanticHint,
    this.onTap,
  }) : assert(semanticLabel == null || semanticLabel.length > 0, 'semanticLabel must not be empty'),
       assert(semanticHint == null || semanticHint.length > 0, 'semanticHint must not be empty'),
       assert(onTap == null || semanticLabel != null, 'interactive cards require a semanticLabel');

  final Widget child;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;
  final String? semanticHint;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);
    final content = ConstrainedBox(
      constraints: onTap == null ? const BoxConstraints() : const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
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
    );
    final card = onTap == null
        ? content
        : Material(
            color: AppColors.surface,
            borderRadius: borderRadius,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              child: content,
            ),
          );

    if (semanticLabel == null) {
      return card;
    }

    return Semantics(
      container: true,
      label: semanticLabel,
      hint: semanticHint,
      button: onTap != null,
      enabled: onTap == null ? null : true,
      onTap: onTap,
      child: ExcludeSemantics(child: card),
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
    this.titleMaxLines,
    this.statusLabel,
    this.statusText,
    this.semanticLabel,
    this.onTap,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(detailLabel.length > 0, 'detailLabel must not be empty'),
       assert(detailText.length > 0, 'detailText must not be empty'),
       assert(statusLabel == null || statusLabel.length > 0, 'statusLabel must not be empty'),
       assert(statusText == null || statusText.length > 0, 'statusText must not be empty'),
       assert(semanticLabel == null || semanticLabel.length > 0, 'semanticLabel must not be empty');

  final String title;
  final int? titleMaxLines;
  final List<String> categoryLabels;
  final String detailLabel;
  final String detailText;
  final String? statusLabel;
  final String? statusText;
  final String? semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final effectiveStatusLabel = statusLabel ?? l10n.recommendationsStatusLabel;
    final effectiveSemanticLabel =
        semanticLabel ??
        [
          ...categoryLabels,
          title,
          '$detailLabel: $detailText',
          if (statusText != null) '$effectiveStatusLabel: $statusText',
        ].join('. ');
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
                    maxLines: titleMaxLines,
                    overflow: titleMaxLines == null ? null : TextOverflow.ellipsis,
                    style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: AppDimensions.space8),
                  const AppIcon(
                    AppIcons.openInNew,
                    color: AppColors.textPrimary,
                  ),
                ],
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
                    effectiveStatusLabel.toUpperCase(),
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
      child: Semantics(
        container: true,
        label: effectiveSemanticLabel,
        hint: l10n.externalLinkA11yHint,
        link: true,
        enabled: true,
        onTap: onTap,
        child: ExcludeSemantics(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: content,
          ),
        ),
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
    this.refNumberLabel,
    this.expiryDateLabel,
    this.extraLabel,
    this.extraText,
    // ── Agenda slots ─────────────────────────────────────────────────────────
    this.date,
    this.time,
    this.description,
    // ── Interaction ───────────────────────────────────────────────────────────
    this.onTap,
    this.semanticLabel,
    this.semanticHint,
    // ── Legacy compat ─────────────────────────────────────────────────────────
    @Deprecated('Use titleIcon') this.leading,
    @Deprecated('Use actionButton') this.trailing,
    @Deprecated('Use date') this.month,
    @Deprecated('Use description') this.subtitle,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(refNumberLabel == null || refNumberLabel.length > 0, 'refNumberLabel must not be empty'),
       assert(expiryDateLabel == null || expiryDateLabel.length > 0, 'expiryDateLabel must not be empty'),
       assert(semanticLabel == null || semanticLabel.length > 0, 'semanticLabel must not be empty'),
       assert(semanticHint == null || semanticHint.length > 0, 'semanticHint must not be empty'),
       assert(state != AppCardState.disabled || onAttachmentTap == null, 'disabled cards cannot have attachment actions'),
       assert(state != AppCardState.disabled || actionButton == null, 'disabled cards cannot have action buttons');

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
  final String? refNumberLabel;

  /// Overrides the "Expir." label in the ref block's second row.
  final String? expiryDateLabel;

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
  final String? semanticLabel;
  final String? semanticHint;

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
    final l10n = AppLocalizations.of(context);
    final effectiveRefNumberLabel = refNumberLabel ?? l10n.appCardReferenceLabel;
    final effectiveExpiryDateLabel = expiryDateLabel ?? l10n.appCardExpiryLabel;
    // WCAG 4.1.2 — unified semantic label for complex cards.
    final semanticSegments = <String>[
      ?categoryLabel,
      title,
      if (refNumber != null) '$effectiveRefNumberLabel: $refNumber',
      if (expiryDate != null) '$effectiveExpiryDateLabel: $expiryDate',
      ?date,
      ?time,
      ?description,
      if (extraText != null) '${extraLabel ?? l10n.recommendationsStatusLabel}: $extraText',
      ?lastUpdateText,
    ];
    final composedLabel = semanticLabel ?? semanticSegments.join('. ');
    final effectiveOnTap = _isDisabled ? null : onTap;
    final content = Container(
      width: double.infinity,
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
        children: cardClass == AppCardClass.agenda ? _agendaSlots() : _basicSlots(effectiveRefNumberLabel, effectiveExpiryDateLabel),
      ),
    );
    final visualCard = effectiveOnTap == null
        ? content
        : Material(
            color: Colors.transparent,
            borderRadius: _borderRadius,
            child: InkWell(
              onTap: effectiveOnTap,
              borderRadius: _borderRadius,
              child: content,
            ),
          );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: composedLabel,
      button: onTap != null,
      enabled: _isDisabled ? false : (onTap != null ? true : null),
      hint: semanticHint,
      onTap: effectiveOnTap,
      child: visualCard,
    );
  }

  // ── Basic slots ───────────────────────────────────────────────────────────

  List<Widget> _basicSlots(final String effectiveRefNumberLabel, final String effectiveExpiryDateLabel) => [
    if (categoryLabel != null || statusTag != null) ExcludeSemantics(child: _headerRow()),
    ExcludeSemantics(child: _titleRow()),
    if (refNumber != null || expiryDate != null) ExcludeSemantics(child: _refBlock(effectiveRefNumberLabel, effectiveExpiryDateLabel)),
    if (extraLabel != null && extraText != null) ExcludeSemantics(child: _extraInfoBlock()),
    if (attachmentLabel != null) _attachmentRow(),
    if (actionButton != null) SizedBox(width: double.infinity, child: actionButton),
    if (lastUpdateText != null) ExcludeSemantics(child: _lastUpdateRow()),
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

  Widget _refBlock(final String effectiveRefNumberLabel, final String effectiveExpiryDateLabel) {
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
              label: effectiveRefNumberLabel,
              value: refNumber!,
              labelColor: labelColor,
              valueColor: valueColor,
            ),
          if (expiryDate != null)
            _refRow(
              label: effectiveExpiryDateLabel,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.captionUppercase.copyWith(color: labelColor),
          ),
          const SizedBox(height: AppDimensions.space4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.smallRegular.copyWith(
                    color: valueColor,
                    fontWeight: valueWeight,
                  ),
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
    final effectiveOnTap = _isDisabled ? null : onAttachmentTap;
    return Semantics(
      label: attachmentLabel,
      button: true,
      enabled: effectiveOnTap != null,
      onTap: effectiveOnTap,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: effectiveOnTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
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
    if (date != null || time != null) ExcludeSemantics(child: _agendaHeaderRow()),
    ExcludeSemantics(child: _agendaTitleRow()),
    if (description != null) ExcludeSemantics(child: _agendaContentBlock()),
    if (actionButton != null) SizedBox(width: double.infinity, child: actionButton),
    if (lastUpdateText != null) ExcludeSemantics(child: _lastUpdateRow()),
  ];

  Widget _agendaHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (date != null)
            _agendaMetadata(
              icon: Icons.calendar_today_outlined,
              value: date!,
            ),
          if (date != null && time != null) const SizedBox(height: AppDimensions.space8),
          if (time != null)
            _agendaMetadata(
              icon: Icons.schedule_outlined,
              value: time!,
            ),
        ],
      ),
    );
  }

  Widget _agendaMetadata({required final IconData icon, required final String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppDimensions.iconMedium,
          color: _textColor(),
        ),
        const SizedBox(width: AppDimensions.space8),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyRegular.copyWith(color: _textColor()),
          ),
        ),
      ],
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
    this.semanticsValue,
    this.announceChanges = false,
    this.height = 16,
    this.borderRadius,
  }) : assert(value == null || (value >= 0 && value <= 1), 'value must be between 0 and 1'),
       assert(height > 0, 'height must be positive'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty'),
       assert(semanticsValue == null || semanticsValue.length > 0, 'semanticsValue must not be empty');

  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final bool announceChanges;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final percentage = value == null ? null : (value! * 100).round();

    return Semantics(
      container: true,
      label: semanticsLabel ?? l10n.appProgressLabel,
      value: semanticsValue ?? (percentage == null ? l10n.appProgressIndeterminateValue : l10n.appProgressPercentage(percentage)),
      liveRegion: announceChanges,
      child: ExcludeSemantics(
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
    this.statusLabel,
  }) : assert(imageUrl == null || imageUrl.length > 0, 'imageUrl must not be empty'),
       assert(initials == null || initials.length > 0, 'initials must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty'),
       assert(statusLabel == null || statusLabel.length > 0, 'statusLabel must not be empty'),
       assert(!hasStatus || statusColor == null || statusLabel != null, 'a custom statusColor requires a statusLabel');

  final String? imageUrl;
  final String? initials;
  final AppAvatarSize size;
  final bool hasStatus;
  final Color? statusColor;
  final String? semanticsLabel;
  final String? statusLabel;

  double get _radius => switch (size) {
    AppAvatarSize.small => 16,
    AppAvatarSize.medium => 24,
    AppAvatarSize.large => 32,
  };

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  textScaler: TextScaler.noScaling,
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

    final visualAvatar = hasStatus
        ? Stack(
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
          )
        : avatarWidget;

    if (semanticsLabel == null && !hasStatus) {
      return ExcludeSemantics(child: visualAvatar);
    }

    return Semantics(
      container: true,
      image: true,
      label: semanticsLabel ?? l10n.appAvatarLabel,
      value: hasStatus ? (statusLabel ?? l10n.appAvatarAvailableStatus) : null,
      child: ExcludeSemantics(child: visualAvatar),
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
    this.semanticsLabel,
    this.semanticsHint,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(subtitle == null || subtitle.length > 0, 'subtitle must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty'),
       assert(semanticsHint == null || semanticsHint.length > 0, 'semanticsHint must not be empty');

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDisabled;
  final String? semanticsLabel;
  final String? semanticsHint;

  @override
  Widget build(final BuildContext context) {
    final effectiveOnTap = isDisabled ? null : onTap;
    // ListTile pinta su fondo y el ripple en el Material más cercano. Dentro
    // de AppList (DecoratedBox con color) ese Material queda por debajo del
    // fondo y el ripple no se ve, y Flutter lo avisa en debug. Un Material
    // transparente propio lo pinta encima del contenedor.
    final tile = Material(
      type: MaterialType.transparency,
      child: ListTile(
        minTileHeight: AppDimensions.minTouchTarget,
        onTap: effectiveOnTap,
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
      ),
    );

    if (onTap == null) {
      return Semantics(
        container: true,
        label: semanticsLabel ?? [title, ?subtitle].join('. '),
        hint: semanticsHint,
        child: ExcludeSemantics(child: tile),
      );
    }

    return Semantics(
      container: true,
      label: semanticsLabel ?? [title, ?subtitle].join('. '),
      hint: semanticsHint,
      button: true,
      enabled: !isDisabled,
      onTap: effectiveOnTap,
      child: ExcludeSemantics(child: tile),
    );
  }
}
