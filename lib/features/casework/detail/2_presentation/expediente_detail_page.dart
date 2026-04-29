import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/offline_banner.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/1_domain/expediente_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/2_presentation/widgets/expediente_fichero_tile.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/2_presentation/widgets/expediente_metadata_block.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/upload_evidence_section.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Detail screen for an expediente (STORY-35).
///
/// Embeds [UploadEvidenceSection] (STORY-38) as the operational
/// aportación zone when the expediente is in `abierto` state. When
/// `cerrado`, an informative banner replaces the upload zone.
class ExpedienteDetailPage extends ConsumerWidget {
  const ExpedienteDetailPage({required this.expedienteRef, super.key});

  final String expedienteRef;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncDetail = ref.watch(expedienteDetailProvider(expedienteRef));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.caseworkExpedienteDetailBack,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/casework');
            }
          },
        ),
        title: Text(l10n.caseworkExpedienteDetailTitle),
      ),
      body: OfflineBanner(
        child: asyncDetail.when(
        loading: () => LoadingStateWidget(
          message: l10n.caseworkExpedienteDetailLoading,
        ),
        error: (final error, final _) => ErrorStateWidget(
          message: l10n.caseworkExpedienteDetailErrorTitle,
          detail: l10n.caseworkExpedienteDetailErrorBody,
          onRetry: () => ref.read(expedienteDetailProvider(expedienteRef).notifier).refresh(),
        ),
        data: (final detail) => _LoadedView(detail: detail),
      ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.detail});

  final ExpedienteDetail detail;

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
          if (detail.estado.permiteAportacion) UploadEvidenceSection(expedienteRef: detail.numero) else _ClosedBanner(),
        ],
      ),
    );
  }
}

class _ClosedBanner extends StatelessWidget {
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
