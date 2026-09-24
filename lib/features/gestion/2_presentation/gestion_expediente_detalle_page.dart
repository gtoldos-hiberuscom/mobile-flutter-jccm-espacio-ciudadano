import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
      onBack: () {
        if (context.canPop()) {
          context.pop();
          return;
        }
        context.go(
          tercero != null ? Routes.gestionAportacion : Routes.gestionExpedientes,
        );
      },
      body: detailAsync.when(
        loading: () => const LoadingStateWidget(),
        error: (final error, final _) => ErrorStateWidget(
          message: l10n.gestionExpedientesDetalleLoadError,
          onRetry: () => ref.refresh(expedienteDetailProvider(key)),
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
    final dataItems = <AppInfoLabelEntry>[
      if (_hasValue(expediente.consejeria))
        AppInfoLabelEntry(
          label: l10n.gestionExpedientesConsejeriaLabel,
          value: _sentenceCase(expediente.consejeria),
        ),
      if (_hasValue(expediente.oficinaTramitadora))
        AppInfoLabelEntry(
          label: l10n.gestionExpedientesOficinaTramitadoraLabel,
          value: _sentenceCase(expediente.oficinaTramitadora!),
          valueColor: AppColors.textBase,
        ),
      if (_hasValue(expediente.numexp))
        AppInfoLabelEntry(
          label: l10n.gestionExpedientesNumExpedienteLabel,
          value: expediente.numexp,
          valueColor: AppColors.textBase,
        ),
    ];
    final statusItems = <AppInfoLabelEntry>[
      if (_hasValue(expediente.fechaInicio))
        AppInfoLabelEntry(
          label: l10n.gestionExpedientesFechaInicioLabel,
          value: _formatDate(expediente.fechaInicio!),
          valueColor: AppColors.textBase,
        ),
      if (_hasValue(expediente.fechaFin))
        AppInfoLabelEntry(
          label: l10n.gestionExpedientesFechaCierreLabel,
          value: _formatDate(expediente.fechaFin!),
          valueColor: AppColors.textBase,
        ),
      if (_hasValue(expediente.estado))
        AppInfoLabelEntry(
          label: l10n.gestionExpedientesEstadoLabel,
          value: _sentenceCase(expediente.estado!),
          valueColor: AppColors.textBase,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: appPageHorizontalPadding(context),
              vertical: AppDimensions.space16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_hasValue(expediente.titulo)) ...[
                  AppTextBlock(
                    text: _sentenceCase(expediente.titulo),
                    variant: AppTextBlockVariant.h2,
                    color: AppColors.primary,
                    showLeadingIcon: false,
                    showTrailingIcon: false,
                  ),
                  const SizedBox(height: AppDimensions.space16),
                ],
                if (dataItems.isNotEmpty) ...[
                  AppTextBlock(
                    text: l10n.gestionExpedientesDatosExpedienteTitle,
                    variant: AppTextBlockVariant.h3,
                    color: AppColors.textBase,
                    showLeadingIcon: false,
                    showTrailingIcon: false,
                  ),
                  AppInfoLabelList(items: dataItems, horizontal: false),
                  const SizedBox(height: AppDimensions.space16),
                  const AppDivider(
                    dark: true,
                    strength: AppDividerStrength.soft,
                  ),
                  const SizedBox(height: AppDimensions.space16),
                ],
                if (statusItems.isNotEmpty) ...[
                  AppTextBlock(
                    text: l10n.gestionExpedientesEstadoTramitacionTitle,
                    variant: AppTextBlockVariant.h3,
                    color: AppColors.textBase,
                    showLeadingIcon: false,
                    showTrailingIcon: false,
                  ),
                  AppInfoLabelList(items: statusItems, horizontal: false),
                  const SizedBox(height: AppDimensions.space16),
                  const AppDivider(
                    dark: true,
                    strength: AppDividerStrength.soft,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (expediente.canAttachDocuments)
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

  bool _hasValue(final String? value) => value != null && value.trim().isNotEmpty;

  String _sentenceCase(final String value) {
    final trimmed = value.trim();
    if (trimmed != trimmed.toUpperCase()) {
      return trimmed;
    }
    const acronyms = {
      'EOI',
      'FSP',
      'JCCM',
      'CLM',
      'NIF',
      'CIF',
      'DNI',
      'NIE',
    };
    final words = trimmed.toLowerCase().split(' ');
    for (var index = 0; index < words.length; index++) {
      final uppercaseWord = words[index].toUpperCase();
      if (acronyms.contains(uppercaseWord)) {
        words[index] = uppercaseWord;
      }
    }
    final formatted = words.join(' ');
    return '${formatted[0].toUpperCase()}${formatted.substring(1)}';
  }

  String _formatDate(final String rawDate) {
    final date = DateTime.tryParse(rawDate);
    if (date == null) {
      return rawDate;
    }
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
