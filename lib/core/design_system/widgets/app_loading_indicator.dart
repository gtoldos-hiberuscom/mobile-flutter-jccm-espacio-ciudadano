import 'dart:ui' show FlutterView;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart' show AppColors;
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Centered [CircularProgressIndicator] with a [Semantics] node for screen
/// readers.
///
/// Used as the canonical loading indicator across the design system. Wrap in
/// a [Scaffold] / [SizedBox] / [Expanded] as needed to fill available space.
///
/// Example:
/// ```dart
/// state.when(
///   loading: () => const AppLoadingIndicator(),
///   data: (data) => MyWidget(data),
///   error: (e, _) => ErrorView(error: e),
/// );
/// ```
class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({
    super.key,
    this.semanticsLabel,
    this.color,
    this.strokeWidth = 4.0,
    this.decorative = false,
    this.announceCompletion = true,
  }) : assert(decorative || semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty'),
       assert(strokeWidth > 0, 'strokeWidth must be greater than zero');

  /// Screen-reader label. Override with a localised string when possible.
  final String? semanticsLabel;

  /// Indicator colour. Defaults to [AppColors.primary] when not provided.
  final Color? color;

  /// Stroke width passed to [CircularProgressIndicator]. Defaults to `4.0`.
  final double strokeWidth;

  /// When true, the indicator is hidden from assistive technologies.
  final bool decorative;

  /// Announces the localised completion message when the indicator disappears.
  final bool announceCompletion;

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator> {
  FlutterView? _view;
  TextDirection _textDirection = TextDirection.ltr;
  String? _completionLabel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _view = View.of(context);
    _textDirection = Directionality.of(context);
    _completionLabel = AppLocalizations.of(context).a11yContentLoaded;
  }

  @override
  void dispose() {
    if (!widget.decorative && widget.announceCompletion && _view != null && _completionLabel != null) {
      SemanticsService.sendAnnouncement(
        _view!,
        _completionLabel!,
        _textDirection,
      ).ignore();
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final indicator = Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.color ?? AppColors.primary,
        ),
        strokeWidth: widget.strokeWidth,
      ),
    );

    if (widget.decorative) {
      return ExcludeSemantics(child: indicator);
    }

    final label = widget.semanticsLabel ?? AppLocalizations.of(context).a11yLoading;
    return Semantics(
      container: true,
      label: label,
      liveRegion: true,
      child: ExcludeSemantics(child: indicator),
    );
  }
}
