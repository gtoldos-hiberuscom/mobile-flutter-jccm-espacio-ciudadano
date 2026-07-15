import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/tercero_identificacion.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Detalle de expediente — Figma node 44242:24873.
///
/// [tercero], si no es nulo, indica que se llegó desde la búsqueda de un
/// expediente ajeno (`GestionAportacionPage`): el detalle se consulta con el
/// documento del titular localizado, no con el del usuario autenticado.
class GestionExpedienteDetallePage extends ConsumerWidget {
  const GestionExpedienteDetallePage({required this.numexp, this.tercero, super.key});

  final String numexp;
  final TerceroIdentificacion? tercero;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final decodedNumexp = Uri.decodeComponent(numexp);
    final key = (numexp: decodedNumexp, tercero: tercero);
    final detailAsync = ref.watch(expedienteDetailProvider(key));

    return AppDetailScaffold(
      title: l10n.gestionExpedientesDetalleTitle,
      onBack: () => context.go(tercero != null ? Routes.gestionAportacion : Routes.gestionExpedientes),
      body: detailAsync.when(
        loading: () => const LoadingStateWidget(),
        error: (final error, final _) => ErrorStateWidget(
          message: l10n.gestionExpedientesDetalleLoadError,
          onRetry: () => ref.invalidate(expedienteDetailProvider(key)),
        ),
        data: (final expediente) => _ExpedienteDetalleBody(expediente: expediente, tercero: tercero),
      ),
    );
  }
}

class _ExpedienteDetalleBody extends StatelessWidget {
  const _ExpedienteDetalleBody({required this.expediente, this.tercero});

  final Expediente expediente;
  final TerceroIdentificacion? tercero;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextBlock(
                  text: expediente.titulo,
                  variant: AppTextBlockVariant.h2,
                  color: AppColors.textBase,
                  showLeadingIcon: false,
                  showTrailingIcon: false,
                ),
                AppTextBlock(
                  text: l10n.gestionExpedientesDatosExpedienteTitle,
                  variant: AppTextBlockVariant.h3,
                  color: AppColors.textBase,
                  showLeadingIcon: false,
                  showTrailingIcon: false,
                ),
                AppInfoLabelList(
                  items: [
                    AppInfoLabelEntry(
                      label: l10n.gestionExpedientesConsejeriaLabel,
                      value: expediente.consejeria.isNotEmpty ? expediente.consejeria : '-',
                    ),
                    AppInfoLabelEntry(
                      label: l10n.gestionExpedientesOficinaTramitadoraLabel,
                      value: expediente.oficinaTramitadora ?? '-',
                    ),
                    AppInfoLabelEntry(
                      label: l10n.gestionExpedientesNumExpedienteLabel,
                      value: expediente.numexp,
                    ),
                  ],
                ),
                const AppDivider(dark: true, strength: AppDividerStrength.soft),
                AppTextBlock(
                  text: l10n.gestionExpedientesEstadoTramitacionTitle,
                  variant: AppTextBlockVariant.h3,
                  color: AppColors.textBase,
                  showLeadingIcon: false,
                  showTrailingIcon: false,
                ),
                AppInfoLabelList(
                  items: [
                    AppInfoLabelEntry(
                      label: l10n.gestionExpedientesFechaInicioLabel,
                      value: expediente.fechaInicio ?? '-',
                    ),
                    AppInfoLabelEntry(
                      label: l10n.gestionExpedientesFechaCierreLabel,
                      value: expediente.fechaFin ?? '-',
                    ),
                    AppInfoLabelEntry(
                      label: l10n.gestionExpedientesEstadoLabel,
                      value: expediente.estado ?? '-',
                    ),
                  ],
                ),
                const AppDivider(dark: true, strength: AppDividerStrength.soft),
              ],
            ),
          ),
        ),
        AppStickybar(
          children: [
            AppButton(
              label: l10n.gestionExpedientesAportarDocumentacionButton,
              isExpanded: true,
              leadingIcon: AppIcons.upload,
              onPressed: () => context.go('${Routes.gestionExpedientes}/${Uri.encodeComponent(expediente.numexp)}/aportar-documentacion', extra: tercero),
            ),
          ],
        ),
      ],
    );
  }
}
