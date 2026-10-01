import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Split phone input used when a country prefix selector is part of the field.
class AppPhoneInputCase extends StatefulWidget {
  const AppPhoneInputCase({
    required this.label,
    required this.controller,
    super.key,
    this.countryLabel = '(ES)',
    this.hint = '600 000 000',
    this.errorText,
    this.onChanged,
    this.helperText,
    this.onSelectorTap,
    this.inputFormatters,
    this.keyboardType,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.isRequired = false,
    this.textInputAction = TextInputAction.next,
    this.autofillHints = const [AutofillHints.telephoneNumber],
    this.selectorSemanticsLabel,
  }) : assert(label.length > 0, 'label must not be empty'),
       assert(countryLabel.length > 0, 'countryLabel must not be empty');

  final String label;
  final TextEditingController controller;
  final String countryLabel;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? helperText;
  final VoidCallback? onSelectorTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final bool isRequired;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? selectorSemanticsLabel;

  @override
  State<AppPhoneInputCase> createState() => _AppPhoneInputCaseState();
}

class _AppPhoneInputCaseState extends State<AppPhoneInputCase> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant final AppPhoneInputCase oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newError = widget.errorText;
    if (newError == null || newError.isEmpty || newError == oldWidget.errorText) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final l10n = AppLocalizations.of(context);
      SemanticsService.sendAnnouncement(
        View.of(context),
        l10n.a11yFieldError(widget.label, newError),
        Directionality.of(context),
      ).ignore();
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final color = isError ? AppColors.error : AppColors.primary;
    final borderColor = isError ? AppColors.error : AppColors.borderBlueMutedBase;
    final fillColor = isError ? AppColors.errorContainer : AppColors.backgroundWhite;

    final selectorContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
      child: Row(
        children: [
          const AppIcon(AppIcons.globeLocationPin, color: AppColors.textPrimary),
          const SizedBox(width: AppDimensions.space4),
          Text(
            widget.countryLabel,
            style: AppTypography.bodyRegular.copyWith(color: AppColors.textPlaceholder),
          ),
          const AppIcon(AppIcons.keyboardArrowDown, color: AppColors.textPrimary),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            widget.label.toUpperCase(),
            style: AppTypography.captionUppercase.copyWith(color: color),
          ),
        ),
        const SizedBox(height: AppDimensions.space8),
        AppFocusRing(
          enabled: widget.enabled,
          child: Container(
            constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
            decoration: BoxDecoration(
              color: fillColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              boxShadow: AppShadows.low,
            ),
            child: Row(
              children: [
                if (widget.onSelectorTap != null)
                  Semantics(
                    label: widget.selectorSemanticsLabel ?? l10n.a11ySelectPhoneCountryCode(widget.countryLabel),
                    button: true,
                    enabled: widget.enabled,
                    onTap: widget.enabled ? widget.onSelectorTap : null,
                    child: ExcludeSemantics(
                      child: InkWell(
                        onTap: widget.enabled ? widget.onSelectorTap : null,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
                          child: selectorContent,
                        ),
                      ),
                    ),
                  )
                else
                  ExcludeSemantics(child: selectorContent),
                ExcludeSemantics(
                  child: Container(
                    width: 1,
                    height: 30,
                    color: AppColors.borderBlueMutedLight,
                  ),
                ),
                Expanded(
                  child: MergeSemantics(
                    child: Semantics(
                      label: isError ? '${widget.label}, ${widget.errorText}' : widget.label,
                      isRequired: widget.isRequired,
                      validationResult: isError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
                      onDidGainAccessibilityFocus: () {
                        Scrollable.ensureVisible(
                          context,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ).ignore();
                      },
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        keyboardType: widget.keyboardType ?? TextInputType.phone,
                        textInputAction: widget.textInputAction,
                        autofillHints: widget.autofillHints,
                        inputFormatters:
                            widget.inputFormatters ??
                            [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                            ],
                        onChanged: widget.onChanged,
                        enabled: widget.enabled,
                        readOnly: widget.readOnly,
                        style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          hintStyle: AppTypography.bodyRegular.copyWith(
                            color: AppColors.textPlaceholder,
                          ),
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.space16,
                            vertical: AppDimensions.space12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isError) ...[
                  const SizedBox(width: AppDimensions.space8),
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: AppDimensions.iconSmall,
                  ),
                  const SizedBox(width: AppDimensions.space8),
                ],
              ],
            ),
          ),
        ),
        if (isError) ...[
          const SizedBox(height: AppDimensions.space8),
          ExcludeSemantics(
            child: AppDescriptionText(
              text: widget.errorText!,
              state: AppDescriptionTextState.error,
            ),
          ),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: AppDimensions.space8),
          ExcludeSemantics(child: AppDescriptionText(text: widget.helperText!)),
        ],
      ],
    );
  }
}
