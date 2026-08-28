import 'dart:ui' show FlutterView;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A centred loading indicator with an optional message.
///
/// Used as the standard loading placeholder across all feature screens.
class LoadingStateWidget extends StatefulWidget {
  const LoadingStateWidget({
    super.key,
    this.message,
    this.semanticsLabel,
    this.announceCompletion = true,
  }) : assert(message == null || message.length > 0, 'message must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  /// Optional text shown below the spinner.
  final String? message;

  /// Override for the semantics live-region label.
  final String? semanticsLabel;

  final bool announceCompletion;

  @override
  State<LoadingStateWidget> createState() => _LoadingStateWidgetState();
}

class _LoadingStateWidgetState extends State<LoadingStateWidget> {
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
    if (widget.announceCompletion && _view != null && _completionLabel != null) {
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
    final l10n = AppLocalizations.of(context);
    final label = widget.semanticsLabel ?? widget.message ?? l10n.loadingStateDefault;

    return Semantics(
      container: true,
      liveRegion: true,
      label: label,
      child: ExcludeSemantics(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoadingIndicator(
                  decorative: true,
                  announceCompletion: false,
                ),
                if (widget.message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    widget.message!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
