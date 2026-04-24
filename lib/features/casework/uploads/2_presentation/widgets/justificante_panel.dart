import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/justificante_state.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Renders the post-upload justificante panel with three states.
class JustificantePanel extends StatelessWidget {
  const JustificantePanel({
    required this.state,
    required this.onDownload,
    super.key,
  });

  final JustificanteState state;
  final ValueChanged<String> onDownload;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: switch (state) {
          JustificantePending() => Row(
            children: <Widget>[
              const Icon(Icons.hourglass_empty),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Text(l10n.caseworkUploadJustificantePending),
              ),
            ],
          ),
          JustificanteUnavailable(:final reason) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.info_outline, color: theme.colorScheme.tertiary),
                  const SizedBox(width: AppDimensions.space8),
                  Expanded(
                    child: Text(l10n.caseworkUploadJustificanteUnavailable),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space4),
              Text(
                l10n.caseworkUploadJustificanteUnavailableReason(reason),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          JustificanteAvailable(:final downloadRef) => Row(
            children: <Widget>[
              const Icon(Icons.download_outlined),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Text(l10n.caseworkUploadJustificanteAvailable),
              ),
              FilledButton.icon(
                onPressed: () => onDownload(downloadRef),
                icon: const Icon(Icons.download),
                label: Text(l10n.caseworkUploadJustificanteDownloadCta),
              ),
            ],
          ),
        },
      ),
    );
  }
}
