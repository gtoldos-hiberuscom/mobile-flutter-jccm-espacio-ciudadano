import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A centred loading indicator with an optional message.
///
/// Used as the standard loading placeholder across all feature screens.
class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
    this.message,
    this.semanticsLabel,
  });

  /// Optional text shown below the spinner.
  final String? message;

  /// Override for the semantics live-region label.
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = semanticsLabel ?? l10n.loadingStateDefault;

    return Semantics(
      liveRegion: true,
      label: label,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator.adaptive(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
