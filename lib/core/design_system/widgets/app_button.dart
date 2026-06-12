import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════════════════════════════════════

/// Hierarchy variants for [AppButton] — mirrors Figma DS node `165:6169`.
enum AppButtonHierarchy {
  primary,
  secondary,
  ghost,
  tertiary,
  disabled,
}

/// Size variants — both enforce a minimum 48 dp touch target height.
enum AppButtonSize {
  medium,
  small,
}

/// Semantic intent — modifies colour palette for special actions.
enum AppButtonIntent {
  none,
  destructive,
  success,
}

// ═══════════════════════════════════════════════════════════════════════════════
// FOCUS RING WRAPPER
// ═══════════════════════════════════════════════════════════════════════════════

/// Renders a 1.5 dp `AppColors.secondary` ring with a 2 dp gap.
/// Mirrors Figma Focus state outer border.
class _FocusRingWrapper extends StatelessWidget {
  const _FocusRingWrapper({required this.child});
  final Widget child;

  @override
  Widget build(final BuildContext context) => Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusXs + 3)),
      border: Border.fromBorderSide(BorderSide(color: AppColors.secondary, width: 1.5)),
    ),
    padding: const EdgeInsets.all(2),
    child: child,
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP BUTTON — LABEL BUTTON  (Figma node `165:6169`)
// ═══════════════════════════════════════════════════════════════════════════════

/// Design-system button — enforces WCAG 2.1 minimum touch target.
///
/// Hierarchies: Primary, Secondary, Ghost, Tertiary.
/// Sizes: Medium (48 dp, padding 8 dp all sides), Small (48 dp, padding 0 dp vertical / 8 dp horizontal).
/// States: Default, Focus (keyboard ring), Pressed (bg change), Disabled, Loading.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.hierarchy = AppButtonHierarchy.primary,
    this.size = AppButtonSize.medium,
    this.intent = AppButtonIntent.none,
    this.semanticsLabel,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isExpanded = false,
    // ignore: deprecated_member_use_from_same_package
    @Deprecated('Use hierarchy instead') final AppButtonVariant? variant,
  }) : _legacyVariant = variant;

  final AppButtonHierarchy hierarchy;
  final AppButtonSize size;
  final AppButtonIntent intent;
  final String label;
  final VoidCallback? onPressed;
  final String? semanticsLabel;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Widget? icon;
  final bool isLoading;
  final bool isExpanded;
  // ignore: deprecated_member_use_from_same_package
  final AppButtonVariant? _legacyVariant;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  AppButtonHierarchy get _effectiveHierarchy {
    // ignore: deprecated_member_use_from_same_package
    final legacy = widget._legacyVariant;
    if (legacy != null) {
      // ignore: deprecated_member_use_from_same_package
      return switch (legacy) {
        AppButtonVariant.primary => AppButtonHierarchy.primary,
        AppButtonVariant.outlined => AppButtonHierarchy.secondary,
        AppButtonVariant.text => AppButtonHierarchy.tertiary,
      };
    }
    return widget.hierarchy;
  }

  /// Both Medium and Small enforce the minimum 48 dp touch target height.
  double get _height => AppDimensions.minTouchTarget;

  /// Figma: icon 24 dp (medium), 16 dp (small).
  double get _iconSize => widget.size == AppButtonSize.medium ? AppDimensions.iconMedium : AppDimensions.iconSmall;

  /// Figma: px = 8 dp both sizes; py = 8 dp (medium) / 0 dp (small).
  EdgeInsetsGeometry get _contentPadding => EdgeInsets.symmetric(
    horizontal: AppDimensions.space8,
    vertical: widget.size == AppButtonSize.medium ? AppDimensions.space8 : 0,
  );

  TextStyle _labelStyle(final Color fg) {
    final base = widget.size == AppButtonSize.medium ? AppTypography.bodyRegular : AppTypography.smallRegular;
    return base.copyWith(color: fg);
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hierarchy = _effectiveHierarchy;
    final isDisabled = widget.onPressed == null || hierarchy == AppButtonHierarchy.disabled;

    Widget button = _buildCoreButton(hierarchy, isDisabled, l10n);

    // Focus ring — keyboard focus.
    if (_isFocused && !isDisabled) {
      button = _FocusRingWrapper(child: button);
    }

    if (widget.isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return Semantics(
      label: widget.semanticsLabel ?? widget.label,
      button: true,
      enabled: !isDisabled && !widget.isLoading,
      child: ExcludeSemantics(child: button),
    );
  }

  Widget _buildCoreButton(
    final AppButtonHierarchy hierarchy,
    final bool isDisabled,
    final AppLocalizations l10n,
  ) {
    final onPressed = isDisabled || widget.isLoading ? null : widget.onPressed;
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusXs)),
    );
    final minSize = Size(AppDimensions.minTouchTarget, _height);

    Widget spinner(final Color fg) => Semantics(
      liveRegion: true,
      label: l10n.a11yLoading,
      focusable: false,
      child: ExcludeSemantics(
        child: SizedBox(
          width: AppDimensions.iconSmall,
          height: AppDimensions.iconSmall,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(fg),
          ),
        ),
      ),
    );

    Widget content(final Color fg, {final bool underline = false}) => widget.isLoading ? spinner(fg) : _buildContentRow(fg, underline: underline);

    final baseStyle = ButtonStyle(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      minimumSize: WidgetStateProperty.all(minSize),
      padding: WidgetStateProperty.all(_contentPadding),
      shape: WidgetStateProperty.all<OutlinedBorder>(shape),
    );

    // ── Disabled ──────────────────────────────────────────────────────────────
    if (isDisabled) {
      return ElevatedButton(
        onPressed: null,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(AppColors.blueMuted100),
          foregroundColor: WidgetStateProperty.all(AppColors.blueMuted500),
          side: WidgetStateProperty.all(BorderSide.none),
        ),
        child: content(AppColors.blueMuted500),
      );
    }

    // ── Primary ───────────────────────────────────────────────────────────────
    if (hierarchy == AppButtonHierarchy.primary) {
      final (bg, fg) = switch (widget.intent) {
        AppButtonIntent.none => (AppColors.primary, AppColors.textOnPrimary),
        AppButtonIntent.destructive => (AppColors.error, AppColors.onError),
        AppButtonIntent.success => (AppColors.success, AppColors.onSuccess),
      };
      final pressedBg = widget.intent == AppButtonIntent.none ? AppColors.primaryLight : bg.withValues(alpha: 0.85);

      return ElevatedButton(
        focusNode: _focusNode,
        onPressed: onPressed,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith(
            (final s) => s.contains(WidgetState.pressed) ? pressedBg : bg,
          ),
          foregroundColor: WidgetStateProperty.all(fg),
        ),
        child: content(fg),
      );
    }

    // ── Secondary ─────────────────────────────────────────────────────────────
    if (hierarchy == AppButtonHierarchy.secondary) {
      final borderColor = switch (widget.intent) {
        AppButtonIntent.none => AppColors.primary,
        AppButtonIntent.destructive => AppColors.error,
        AppButtonIntent.success => AppColors.success,
      };
      return OutlinedButton(
        focusNode: _focusNode,
        onPressed: onPressed,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith(
            (final s) => s.contains(WidgetState.pressed) ? AppColors.blueMuted100 : AppColors.backgroundWhite,
          ),
          foregroundColor: WidgetStateProperty.all(AppColors.textBlack),
          side: WidgetStateProperty.all(BorderSide(color: borderColor, width: 2)),
        ),
        child: content(AppColors.textBlack),
      );
    }

    // ── Ghost ─────────────────────────────────────────────────────────────────
    if (hierarchy == AppButtonHierarchy.ghost) {
      return TextButton(
        focusNode: _focusNode,
        onPressed: onPressed,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith(
            (final s) => s.contains(WidgetState.pressed) ? AppColors.blueMuted100 : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.all(AppColors.textBlack),
        ),
        child: content(AppColors.textBlack, underline: true),
      );
    }

    // ── Tertiary ──────────────────────────────────────────────────────────────
    final tertiaryBg = switch (widget.intent) {
      AppButtonIntent.none => AppColors.secondaryLight100, // #e4f3f6
      AppButtonIntent.destructive => AppColors.errorLight,
      AppButtonIntent.success => AppColors.successLight,
    };

    return TextButton(
      focusNode: _focusNode,
      onPressed: onPressed,
      style: baseStyle.copyWith(
        backgroundColor: WidgetStateProperty.resolveWith(
          (final s) => s.contains(WidgetState.pressed) ? AppColors.blueMuted500 : tertiaryBg,
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.textBlack),
      ),
      child: content(AppColors.textBlack),
    );
  }

  Widget _buildContentRow(final Color fg, {final bool underline = false}) {
    final hasLeading = widget.leadingIcon != null || widget.icon != null;
    final hasTrailing = widget.trailingIcon != null;

    final textStyle = underline
        ? _labelStyle(fg).copyWith(
            decoration: TextDecoration.underline,
            decorationColor: fg,
          )
        : _labelStyle(fg);

    final textWidget = Text(
      widget.label,
      style: textStyle,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (!hasLeading && !hasTrailing) {
      return textWidget;
    }

    return Row(
      mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasLeading) ...[
          widget.icon ?? AppIcon(widget.leadingIcon!, size: _iconSize, color: fg),
          const SizedBox(width: AppDimensions.space4), // Figma gap = 4 dp
        ],
        Flexible(child: textWidget),
        if (hasTrailing) ...[
          const SizedBox(width: AppDimensions.space4),
          AppIcon(widget.trailingIcon!, size: _iconSize, color: fg),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP ICON BUTTON — ICON-ONLY  (Figma node `177:3992`)
// ═══════════════════════════════════════════════════════════════════════════════

/// Icon-only button — square with no label text.
/// Medium = 48 dp, Small = 48 dp (minimum touch target height).
class AppIconButton extends StatefulWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
    super.key,
    this.hierarchy = AppButtonHierarchy.primary,
    this.size = AppButtonSize.medium,
    this.intent = AppButtonIntent.none,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticsLabel;
  final AppButtonHierarchy hierarchy;
  final AppButtonSize size;
  final AppButtonIntent intent;
  final bool isLoading;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.hierarchy == AppButtonHierarchy.disabled;
    const double dimension = AppDimensions.minTouchTarget;
    final double iconSize = widget.size == AppButtonSize.medium ? AppDimensions.iconMedium : AppDimensions.iconSmall;

    final colors = _ButtonColors.resolve(widget.hierarchy, widget.intent, isDisabled);

    final Widget iconChild = widget.isLoading
        ? SizedBox(
            width: AppDimensions.iconSmall,
            height: AppDimensions.iconSmall,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
            ),
          )
        : Icon(widget.icon, size: iconSize, color: colors.foreground);

    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusXs)),
    );
    const minSize = Size(dimension, dimension);
    final effectiveOnPressed = widget.isLoading || isDisabled ? null : widget.onPressed;

    final baseStyle = ButtonStyle(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      minimumSize: WidgetStateProperty.all(minSize),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      shape: WidgetStateProperty.all<OutlinedBorder>(shape),
    );

    Widget button = switch (widget.hierarchy) {
      AppButtonHierarchy.primary || AppButtonHierarchy.disabled => ElevatedButton(
        focusNode: _focusNode,
        onPressed: effectiveOnPressed,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((final s) {
            if (isDisabled) {
              return AppColors.blueMuted100;
            }
            if (s.contains(WidgetState.pressed)) {
              return AppColors.primaryLight;
            }
            return colors.background;
          }),
          foregroundColor: WidgetStateProperty.all(colors.foreground),
          side: isDisabled
              ? WidgetStateProperty.all(
                  const BorderSide(color: AppColors.blueMuted500),
                )
              : null,
        ),
        child: iconChild,
      ),
      AppButtonHierarchy.secondary => OutlinedButton(
        focusNode: _focusNode,
        onPressed: effectiveOnPressed,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((final s) => s.contains(WidgetState.pressed) ? AppColors.blueMuted100 : AppColors.backgroundWhite),
          foregroundColor: WidgetStateProperty.all(colors.foreground),
          side: WidgetStateProperty.all(BorderSide(color: colors.border, width: 2)),
        ),
        child: iconChild,
      ),
      AppButtonHierarchy.ghost => TextButton(
        focusNode: _focusNode,
        onPressed: effectiveOnPressed,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((final s) => s.contains(WidgetState.pressed) ? AppColors.blueMuted100 : Colors.transparent),
          foregroundColor: WidgetStateProperty.all(colors.foreground),
        ),
        child: iconChild,
      ),
      AppButtonHierarchy.tertiary => TextButton(
        focusNode: _focusNode,
        onPressed: effectiveOnPressed,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((final s) => s.contains(WidgetState.pressed) ? AppColors.blueMuted500 : colors.background),
          foregroundColor: WidgetStateProperty.all(colors.foreground),
        ),
        child: iconChild,
      ),
    };

    if (!isDisabled && widget.hierarchy != AppButtonHierarchy.ghost) {
      button = DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusXs)),
          boxShadow: AppShadows.low,
        ),
        child: button,
      );
    }

    if (_isFocused && !isDisabled) {
      button = _FocusRingWrapper(child: button);
    }

    return Semantics(
      label: widget.semanticsLabel,
      button: true,
      enabled: !isDisabled && !widget.isLoading,
      child: ExcludeSemantics(
        child: SizedBox(width: dimension, height: dimension, child: button),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// INTERNAL — COLOUR RESOLUTION
// ═══════════════════════════════════════════════════════════════════════════════

class _ButtonColorSet {
  const _ButtonColorSet({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

// ignore: avoid_classes_with_only_static_members
abstract final class _ButtonColors {
  static _ButtonColorSet resolve(
    final AppButtonHierarchy hierarchy,
    final AppButtonIntent intent,
    final bool isDisabled,
  ) {
    if (isDisabled) {
      return const _ButtonColorSet(
        background: AppColors.blueMuted100,
        foreground: AppColors.blueMuted500,
        border: AppColors.blueMuted500,
      );
    }

    final (Color fill, Color fg, Color border) = switch (intent) {
      AppButtonIntent.none => (AppColors.primary, AppColors.textOnPrimary, AppColors.primary),
      AppButtonIntent.destructive => (AppColors.error, AppColors.onError, AppColors.error),
      AppButtonIntent.success => (AppColors.success, AppColors.onSuccess, AppColors.success),
    };

    return switch (hierarchy) {
      AppButtonHierarchy.primary => _ButtonColorSet(
        background: fill,
        foreground: fg,
        border: fill,
      ),
      AppButtonHierarchy.secondary => _ButtonColorSet(
        background: AppColors.backgroundWhite,
        foreground: AppColors.textBlack,
        border: border,
      ),
      AppButtonHierarchy.ghost => _ButtonColorSet(
        background: Colors.transparent,
        foreground: intent == AppButtonIntent.none ? AppColors.textBlack : fill,
        border: Colors.transparent,
      ),
      AppButtonHierarchy.tertiary => _ButtonColorSet(
        background: intent == AppButtonIntent.none ? AppColors.secondaryLight100 : fill.withValues(alpha: 0.08),
        foreground: intent == AppButtonIntent.none ? AppColors.primary : fill,
        border: Colors.transparent,
      ),
      AppButtonHierarchy.disabled => const _ButtonColorSet(
        background: AppColors.blueMuted100,
        foreground: AppColors.blueMuted500,
        border: AppColors.blueMuted500,
      ),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DEPRECATED — BACKWARDS COMPATIBILITY
// ═══════════════════════════════════════════════════════════════════════════════

@Deprecated('Use AppButtonHierarchy')
enum AppButtonVariant {
  primary,
  outlined,
  text,
}
