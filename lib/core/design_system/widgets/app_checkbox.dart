import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Size variant for [AppCheckbox].
enum AppCheckboxSize {
  /// Standard 24 dp checkbox.
  medium,

  /// Large 32 dp checkbox.
  large,
}

/// Three-state checkbox — mirrors Figma "CheckBox" node (`106:3249`).
///
/// Supports `false`, `true`, `null` (indeterminate / mixed), disabled and
/// error states.  Wraps [Checkbox] with WCAG-compliant touch target and
/// [Semantics].
///
/// Example:
/// ```dart
/// AppCheckbox(
///   label: 'Acepto los términos',
///   value: _accepted,
///   onChanged: (v) => setState(() => _accepted = v ?? false),
/// )
/// ```
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.size = AppCheckboxSize.medium,
    this.isError = false,
    this.errorText,
    this.tristate = false,
    this.labelStyle,
    this.contentPadding = const EdgeInsets.fromLTRB(
      AppDimensions.space4,
      AppDimensions.space4,
      AppDimensions.space4,
      AppDimensions.space8,
    ),
  });

  /// `null` triggers the indeterminate (Mixed) state; requires [tristate].
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final AppCheckboxSize size;
  final bool isError;
  final String? errorText;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry contentPadding;

  /// When `true`, cycles through `false → true → null` on tap.
  final bool tristate;

  bool get _isDisabled => onChanged == null;

  double get _iconSize => switch (size) {
    AppCheckboxSize.medium => AppDimensions.iconMedium,
    AppCheckboxSize.large => AppDimensions.iconLarge,
  };

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: [
            label,
            if (isError && errorText != null) 'Error: $errorText',
          ].join(', '),
          checked: value ?? false,
          enabled: !_isDisabled,
          child: ExcludeSemantics(
            child: InkWell(
              onTap: _isDisabled
                  ? null
                  : () {
                      if (tristate) {
                        onChanged?.call(
                          switch (value) {
                            false => true,
                            true => null,
                            null => false,
                          },
                        );
                      } else {
                        onChanged?.call(!(value ?? false));
                      }
                    },
              borderRadius: BorderRadius.circular(AppDimensions.space4),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
                child: Padding(
                  padding: contentPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        switch (value) {
                          true => Icons.check_box_outlined,
                          false => Icons.check_box_outline_blank,
                          null => Icons.indeterminate_check_box_outlined,
                        },
                        size: _iconSize,
                        color: _iconColor,
                      ),
                      const SizedBox(width: AppDimensions.space8),
                      Flexible(
                        child: Text(
                          label,
                          style: (labelStyle ?? AppTypography.leadingMedium).copyWith(
                            color: _isDisabled ? AppColors.textDisabled : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isError && errorText != null) ...[
          const SizedBox(height: AppDimensions.space4),
          Text(
            errorText!,
            style: AppTypography.captionRegular.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Color get _iconColor {
    if (_isDisabled) {
      return AppColors.disabled;
    }
    if (isError) {
      return AppColors.error;
    }
    return AppColors.successDark;
  }
}
