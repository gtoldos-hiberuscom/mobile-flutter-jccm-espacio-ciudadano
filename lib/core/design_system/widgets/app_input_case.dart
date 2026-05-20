import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_label.dart';

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
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.focusNode,
    this.isRequired = false,
  });

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
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  AppInputState get _effectiveState {
    if (!widget.enabled) return AppInputState.disabled;
    if (widget.state == AppInputState.error) return AppInputState.error;
    if (widget.state == AppInputState.success) return AppInputState.success;
    if (_hasFocus) return AppInputState.focus;
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
        AppColors.textSecondary,
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
        AppColors.outline,
        AppColors.surface,
        AppColors.textSecondary,
      ),
    };
  }

  Widget? get _trailIcon {
    if (widget.suffixIcon != null) return widget.suffixIcon;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLabel(
          text: widget.label,
          color: labelColor,
          required: widget.isRequired,
        ),
        const SizedBox(height: AppDimensions.space4),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          enabled: !isDisabled && !widget.readOnly,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          style: AppTypography.bodyBase.copyWith(
            color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.bodyBase.copyWith(
              color: AppColors.textDisabled,
            ),
            filled: true,
            fillColor: fillColor,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _trailIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: BorderSide(
                color: AppColors.outline.withValues(alpha: 0.5),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            errorText: widget.errorText,
            helperText: widget.helperText,
          ),
        ),
      ],
    );
  }
}
