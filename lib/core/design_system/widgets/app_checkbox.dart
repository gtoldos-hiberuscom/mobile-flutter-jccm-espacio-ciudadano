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
/// Supports [false], [true], [null] (indeterminate / mixed), disabled and
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
  });

  /// `null` triggers the indeterminate (Mixed) state; requires [tristate].
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final AppCheckboxSize size;
  final bool isError;
  final String? errorText;

  /// When `true`, cycles through `false → true → null` on tap.
  final bool tristate;

  bool get _isDisabled => onChanged == null;

  double get _iconSize => switch (size) {
    AppCheckboxSize.medium => AppDimensions.iconMedium,
    AppCheckboxSize.large => AppDimensions.iconLarge,
  };

  @override
  Widget build(final BuildContext context) {
    final activeColor = isError ? AppColors.error : AppColors.primary;
    final checkColor = isError ? AppColors.onError : AppColors.onPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: label,
          checked: value ?? false,
          enabled: !_isDisabled,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: _iconSize,
                  height: _iconSize,
                  child: Checkbox(
                    value: value,
                    tristate: tristate,
                    onChanged: onChanged,
                    activeColor: activeColor,
                    checkColor: checkColor,
                    side: BorderSide(
                      color: _isDisabled
                          ? AppColors.disabled
                          : isError
                          ? AppColors.error
                          : AppColors.outline,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                Flexible(
                  child: Text(
                    label,
                    style: (size == AppCheckboxSize.large
                            ? AppTypography.bodyL
                            : AppTypography.bodyBase)
                        .copyWith(
                      color: _isDisabled
                          ? AppColors.textDisabled
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isError && errorText != null) ...[
          const SizedBox(height: AppDimensions.space4),
          Text(
            errorText!,
            style: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
