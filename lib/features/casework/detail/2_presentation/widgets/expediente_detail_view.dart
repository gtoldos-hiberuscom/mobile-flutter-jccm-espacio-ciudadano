import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/2_presentation/widgets/expediente_fichero_tile.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/2_presentation/widgets/expediente_metadata_block.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/upload_evidence_section.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Public, scaffold-free composition of an [ExpedienteDetail] (STORY-35).
///
/// Mirrors the visual layout of `expediente_detail_page.dart`'s loaded
/// state so it can be embedded by other flows — currently the
/// third-party aportación wizard (STORY-37) — without forcing the
/// existing detail page to be refactored.
///
/// The widget stays additive: the original `ExpedienteDetailPage`
/// continues to render its own private layout and is unaffected by this
/// file.
class ExpedienteDetailView extends StatelessWidget {
  const ExpedienteDetailView({
    required this.detail,
    this.uploadSection,
    super.key,
  });

  final ExpedienteDetail detail;

  /// Optional override for the operations area. When `null`, the view
  /// renders a default [UploadEvidenceSection] (when
  /// `detail.estado.permiteAportacion`) or a closed-state banner.
  /// Wizards that need to listen to the upload session can inject their
  /// own pre-configured [UploadEvidenceSection].
  final Widget? uploadSection;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpedienteMetadataBlock(detail: detail),
          const SizedBox(height: AppDimensions.space24),
          Text(
            l10n.caseworkExpedienteDetailFilesTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.space8),
          if (detail.ficheros.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.space12,
              ),
              child: Text(
                l10n.caseworkExpedienteDetailFilesEmpty,
                style: theme.textTheme.bodyMedium,
              ),
            )
          else
            Column(
              children: <Widget>[
                for (final fichero in detail.ficheros) ExpedienteFicheroTile(fichero: fichero),
              ],
            ),
          const SizedBox(height: AppDimensions.space24),
          Text(
            l10n.caseworkExpedienteDetailOperationsTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.space8),
          if (uploadSection != null) uploadSection! else if (detail.estado.permiteAportacion) UploadEvidenceSection(expedienteRef: detail.numero) else const _ClosedBanner(),
        ],
      ),
    );
  }
}

class _ClosedBanner extends StatelessWidget {
  const _ClosedBanner();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.warningContainer,
        border: Border.all(color: AppColors.warning),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.lock_outline, color: AppColors.warning),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Text(
              l10n.caseworkExpedienteDetailClosedBanner,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
