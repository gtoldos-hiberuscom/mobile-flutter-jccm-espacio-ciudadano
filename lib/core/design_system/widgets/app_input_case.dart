import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_label.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Interaction state for [AppInputCase].
///
/// Mirrors the Figma "InputCase" node (`58:5718`) state property.
enum AppInputState {
  defaultState,
  focus,
  active,
  filled,
  error,
  success,
  disabled,
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.semanticsLabel,
    this.enabled = true,
    this.readOnly = false,
    this.autofillHints,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Hint shown inside the field. Defaults to the localized search hint.
  final String? hintText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? semanticsLabel;
  final bool enabled;
  final bool readOnly;
  final Iterable<String>? autofillHints;

  @override
  Widget build(final BuildContext context) {
    final label = semanticsLabel ?? MaterialLocalizations.of(context).searchFieldLabel;
    assert(label.isNotEmpty, 'semanticsLabel must not be empty');
    final effectiveHintText = hintText ?? AppLocalizations.of(context).appSearchFieldHint;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
      child: MergeSemantics(
        child: Semantics(
          label: label,
          onDidGainAccessibilityFocus: () {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ).ignore();
          },
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            enabled: enabled,
            readOnly: readOnly,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            autofillHints: autofillHints,
            decoration: InputDecoration(
              hintText: effectiveHintText,
              hintStyle: AppTypography.bodyRegular.copyWith(color: AppColors.textPlaceholder),
              filled: true,
              fillColor: AppColors.backgroundWhite,
              isDense: true,
              constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space12,
                vertical: AppDimensions.space12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                borderSide: const BorderSide(color: AppColors.borderBlueMutedBase),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
            ),
            style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

/// Atomic text-input field — the foundational form control.
///
/// Manages its own focus decoration transitions to match Figma states.
/// Use [AppInputCase] inside a [Column] with [AppDescriptionText] below it
/// to build full input rows matching the "Inputs" component (`60:6366`).
///
/// Example:
/// ```dart
/// AppInputCase(
///   label: 'Correo electrónico',
///   hint: 'nombre@ejemplo.es',
///   controller: _emailController,
///   state: _emailError ? AppInputState.error : AppInputState.defaultState,
///   errorText: _emailError ? 'Email no válido' : null,
/// )
/// ```
class AppInputCase extends StatefulWidget {
  const AppInputCase({
    required this.label,
    super.key,
    this.hint,
    this.controller,
    this.state = AppInputState.defaultState,
    this.errorText,
    this.helperText,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.focusNode,
    this.isRequired = false,
  }) : assert(label.length > 0, 'label must not be empty');

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final AppInputState state;
  final String? errorText;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final bool isRequired;
  final FocusNode? focusNode;

  @override
  State<AppInputCase> createState() => _AppInputCaseState();
}

class _AppInputCaseState extends State<AppInputCase> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  @override
  void didUpdateWidget(covariant final AppInputCase oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newError = widget.errorText;
    if (newError != null && newError.isNotEmpty && oldWidget.errorText != newError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          SemanticsService.sendAnnouncement(
            View.of(context),
            l10n.a11yFieldError(widget.label, newError),
            Directionality.of(context),
          ).ignore();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  AppInputState get _effectiveState {
    if (!widget.enabled) {
      return AppInputState.disabled;
    }
    if (widget.state == AppInputState.error) {
      return AppInputState.error;
    }
    if (widget.state == AppInputState.success) {
      return AppInputState.success;
    }
    if (_hasFocus) {
      return AppInputState.focus;
    }
    return widget.state;
  }

  (Color border, Color fill, Color label) get _stateColors {
    return switch (_effectiveState) {
      AppInputState.focus => (
        AppColors.primary,
        AppColors.surface,
        AppColors.primary,
      ),
      AppInputState.active || AppInputState.filled => (
        AppColors.primary,
        AppColors.surface,
        AppColors.primary,
      ),
      AppInputState.error => (
        AppColors.error,
        AppColors.errorContainer,
        AppColors.error,
      ),
      AppInputState.success => (
        AppColors.success,
        AppColors.successContainer,
        AppColors.success,
      ),
      AppInputState.disabled => (
        AppColors.outline,
        AppColors.disabledContainer,
        AppColors.textDisabled,
      ),
      AppInputState.defaultState => (
        AppColors.borderBlueMutedBase,
        AppColors.surface,
        AppColors.primary,
      ),
    };
  }

  Widget? get _trailIcon {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    return switch (_effectiveState) {
      AppInputState.error => const Icon(
        Icons.error_outline_rounded,
        color: AppColors.error,
        size: AppDimensions.iconSmall,
      ),
      AppInputState.success => const Icon(
        Icons.check_circle_outline_rounded,
        color: AppColors.success,
        size: AppDimensions.iconSmall,
      ),
      _ => null,
    };
  }

  @override
  Widget build(final BuildContext context) {
    final (borderColor, fillColor, labelColor) = _stateColors;
    final isDisabled = _effectiveState == AppInputState.disabled;

    // WCAG 4.1.2 — compose semantic label: field name + current value + error.
    final hasError = widget.errorText?.isNotEmpty ?? false;
    final semanticSegments = <String>[widget.label];
    if (hasError) {
      semanticSegments.add(widget.errorText!);
    }
    final composedLabel = semanticSegments.join(', ');

    return MergeSemantics(
      child: Semantics(
        label: composedLabel,
        isRequired: widget.isRequired,
        validationResult: hasError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
        onDidGainAccessibilityFocus: () {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ).ignore();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: AppLabel(
                text: widget.label,
                color: labelColor,
                required: widget.isRequired,
              ),
            ),
            const SizedBox(height: AppDimensions.space4),
            AppFocusRing(
              enabled: !isDisabled,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  boxShadow: isDisabled ? const <BoxShadow>[] : AppShadows.low,
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  autocorrect: widget.autocorrect,
                  enableSuggestions: widget.enableSuggestions,
                  enabled: !isDisabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  style: AppTypography.leadingMedium.copyWith(
                    color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: AppTypography.leadingMedium.copyWith(
                      color: AppColors.textPlaceholder,
                    ),
                    filled: true,
                    fillColor: fillColor,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: _trailIcon,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space8,
                      vertical: AppDimensions.space12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      borderSide: BorderSide(color: borderColor, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      borderSide: BorderSide(
                        color: AppColors.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      borderSide: const BorderSide(color: AppColors.error, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.space4),
              ExcludeSemantics(
                child: AppDescriptionText(text: widget.errorText!, state: AppDescriptionTextState.error),
              ),
            ] else if (widget.helperText != null) ...[
              const SizedBox(height: AppDimensions.space4),
              ExcludeSemantics(child: AppDescriptionText(text: widget.helperText!)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── AppInputArea ──────────────────────────────────────────────────────────────

/// Collapsible multiline textarea — mirrors the Figma "Inputs/Area" node
/// (`58:6183`).
///
/// Renders a captionUppercase-labelled textarea constrained to
/// [collapsedHeight] (default 140 dp). An expand/collapse toggle in the
/// top-right corner lets the user switch to an unconstrained height so all
/// entered text is visible at once.
///
/// An optional [description] string is displayed below the field using
/// [AppDescriptionText].
///
/// Example:
/// ```dart
/// AppInputArea(
///   label: 'Observaciones',
///   hint: 'Escribe aquí...',
///   controller: _obsController,
///   description: 'Máximo 500 caracteres.',
/// )
/// ```
class AppInputArea extends StatefulWidget {
  const AppInputArea({
    required this.label,
    super.key,
    this.hint,
    this.controller,
    this.state = AppInputState.defaultState,
    this.onChanged,
    this.description,
    this.descriptionState = AppDescriptionTextState.helper,
    this.enabled = true,
    this.focusNode,
    this.isRequired = false,
    this.collapsedHeight = 140.0,
    this.textInputAction = TextInputAction.newline,
    this.autofillHints,
    this.autocorrect = true,
    this.enableSuggestions = true,
  }) : assert(label.length > 0, 'label must not be empty'),
       assert(collapsedHeight >= AppDimensions.minTouchTarget, 'collapsedHeight must be at least 48 dp');

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final AppInputState state;
  final ValueChanged<String>? onChanged;

  /// Optional helper / error message shown below the field.
  final String? description;
  final AppDescriptionTextState descriptionState;

  final bool enabled;
  final FocusNode? focusNode;
  final bool isRequired;

  /// Height of the field when collapsed. Defaults to `140.0`.
  final double collapsedHeight;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;

  @override
  State<AppInputArea> createState() => _AppInputAreaState();
}

class _AppInputAreaState extends State<AppInputArea> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  void _toggleExpanded() => setState(() => _isExpanded = !_isExpanded);

  @override
  void didUpdateWidget(covariant final AppInputArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newError = widget.descriptionState == AppDescriptionTextState.error ? widget.description : null;
    final oldError = oldWidget.descriptionState == AppDescriptionTextState.error ? oldWidget.description : null;
    if (newError == null || newError.isEmpty || newError == oldError) {
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

  AppInputState get _effectiveState {
    if (!widget.enabled) {
      return AppInputState.disabled;
    }
    if (widget.state == AppInputState.error) {
      return AppInputState.error;
    }
    if (widget.state == AppInputState.success) {
      return AppInputState.success;
    }
    if (_hasFocus) {
      return AppInputState.focus;
    }
    return widget.state;
  }

  (Color border, Color fill, Color label) get _stateColors => switch (_effectiveState) {
    AppInputState.focus => (AppColors.primary, AppColors.surface, AppColors.primary),
    AppInputState.active || AppInputState.filled => (AppColors.primary, AppColors.surface, AppColors.textSecondary),
    AppInputState.error => (AppColors.error, AppColors.errorContainer, AppColors.error),
    AppInputState.success => (AppColors.success, AppColors.successContainer, AppColors.success),
    AppInputState.disabled => (AppColors.outline, AppColors.disabledContainer, AppColors.textDisabled),
    AppInputState.defaultState => (AppColors.outlineNeutralBase, AppColors.surface, AppColors.textSecondary),
  };

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (borderColor, fillColor, labelColor) = _stateColors;
    final isDisabled = _effectiveState == AppInputState.disabled;
    final borderWidth = _effectiveState == AppInputState.focus ? 2.0 : 1.0;
    final hasError = widget.descriptionState == AppDescriptionTextState.error && (widget.description?.isNotEmpty ?? false);
    final semanticLabel = hasError ? '${widget.label}, ${widget.description}' : widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: AppLabel(
            text: widget.label,
            color: labelColor,
            required: widget.isRequired,
          ),
        ),
        const SizedBox(height: AppDimensions.space8),
        // ── Textarea container ───────────────────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: _isExpanded ? widget.collapsedHeight * 2 : widget.collapsedHeight,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: isDisabled ? const <BoxShadow>[] : AppShadows.low,
          ),
          child: Stack(
            children: [
              // ── Text field ─────────────────────────────────────────────────
              Positioned.fill(
                child: MergeSemantics(
                  child: Semantics(
                    label: semanticLabel,
                    isRequired: widget.isRequired,
                    validationResult: hasError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
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
                      onChanged: widget.onChanged,
                      enabled: !isDisabled,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.multiline,
                      textInputAction: widget.textInputAction,
                      autofillHints: widget.autofillHints,
                      autocorrect: widget.autocorrect,
                      enableSuggestions: widget.enableSuggestions,
                      style: AppTypography.bodyRegular.copyWith(
                        color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: AppTypography.bodyRegular.copyWith(
                          color: AppColors.textPlaceholder,
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(
                          AppDimensions.space8,
                          AppDimensions.space4,
                          AppDimensions.space40,
                          AppDimensions.space4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ── Expand / collapse toggle ────────────────────────────────────
              Positioned(
                top: AppDimensions.space4,
                right: AppDimensions.space4,
                child: Semantics(
                  label: _isExpanded ? l10n.a11yCollapseTextArea(widget.label) : l10n.a11yExpandTextArea(widget.label),
                  button: true,
                  enabled: !isDisabled,
                  expanded: _isExpanded,
                  onTap: isDisabled ? null : _toggleExpanded,
                  child: ExcludeSemantics(
                    child: IconButton(
                      onPressed: isDisabled ? null : _toggleExpanded,
                      constraints: const BoxConstraints.tightFor(
                        width: AppDimensions.minTouchTarget,
                        height: AppDimensions.minTouchTarget,
                      ),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        size: AppDimensions.iconMedium,
                        color: isDisabled ? AppColors.textDisabled : AppColors.neutralDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // ── Description text ────────────────────────────────────────────────
        if (widget.description != null) ...[
          const SizedBox(height: AppDimensions.space8),
          ExcludeSemantics(
            child: AppDescriptionText(
              text: widget.description!,
              state: widget.descriptionState,
            ),
          ),
        ],
      ],
    );
  }
}
