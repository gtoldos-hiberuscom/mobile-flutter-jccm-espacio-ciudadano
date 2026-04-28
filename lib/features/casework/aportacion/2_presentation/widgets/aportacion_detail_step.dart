import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/1_domain/expediente_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/2_presentation/widgets/expediente_detail_view.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/upload_evidence_section.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Step 4 of the aportación wizard — embeds the resolved expediente
/// detail and the upload section (STORY-37).
///
/// Loads the detail via [expedienteDetailProvider] and reuses
/// [ExpedienteDetailView] (additive widget extracted from STORY-35) so
/// the original `ExpedienteDetailPage` is not modified. The upload
/// section is the same one consumed by STORY-38; once it reports
/// `finalized == true` the wizard advances to the success step.
class AportacionDetailStep extends ConsumerWidget {
  const AportacionDetailStep({required this.expedienteRef, super.key});

  final String expedienteRef;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncDetail = ref.watch(expedienteDetailProvider(expedienteRef));

    ref.listen(uploadSessionProvider, (final previous, final next) {
      final wasFinalized = previous?.finalized ?? false;
      if (!wasFinalized && next.finalized) {
        ref.read(aportacionSessionProvider.notifier).onUploadFinalized();
      }
    });

    return asyncDetail.when(
      loading: () => LoadingStateWidget(
        message: l10n.caseworkExpedienteDetailLoading,
      ),
      error: (final error, final _) => ErrorStateWidget(
        message: l10n.caseworkExpedienteDetailErrorTitle,
        detail: l10n.caseworkExpedienteDetailErrorBody,
        onRetry: () => ref.read(expedienteDetailProvider(expedienteRef).notifier).refresh(),
      ),
      data: (final detail) => ExpedienteDetailView(
        detail: detail,
        uploadSection: detail.estado.permiteAportacion ? UploadEvidenceSection(expedienteRef: detail.numero) : null,
      ),
    );
  }
}
