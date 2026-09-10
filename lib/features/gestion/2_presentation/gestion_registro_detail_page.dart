import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Detalle de registro — Figma nodes 41672:55956 (salida) y 41932:6988 (entrada).
class GestionRegistroDetailPage extends StatelessWidget {
  const GestionRegistroDetailPage({
    required this.registro,
    required this.isEntrada,
    super.key,
  });

  final Registro registro;
  final bool isEntrada;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailFields = <Widget>[
      if (_hasValue(registro.numregistro))
        _DetailField(
          label: l10n.gestionRegistrosNumRegistroLabel,
          value: registro.numregistro,
        ),
      if (_hasValue(registro.fecha))
        _DetailField(
          label: l10n.gestionRegistrosFechaLabel,
          value: _formatDate(context, registro.fecha!),
        ),
      if (_hasValue(registro.consejeria))
        _DetailField(
          label: isEntrada ? l10n.gestionRegistrosConsejeriaDestinoLabel : l10n.gestionRegistrosConsejeriaOrigenLabel,
          value: _sentenceCase(registro.consejeria!),
        ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppNavBar(
        type: AppNavBarType.detail,
        title: isEntrada ? l10n.gestionRegistrosDetalleEntradaTitle : l10n.gestionRegistrosDetalleSalidaTitle,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.arrowBack,
            size: AppDimensions.iconLarge,
            color: AppColors.textPrimary,
          ),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(Routes.gestionRegistros);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: appPageHorizontalPadding(context),
            vertical: AppDimensions.space8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_hasValue(registro.titulo))
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space4,
                    vertical: AppDimensions.space8,
                  ),
                  child: Text(
                    _sentenceCase(registro.titulo),
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textBase,
                    ),
                  ),
                ),
              if (detailFields.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.space4,
                    AppDimensions.space4,
                    AppDimensions.space4,
                    AppDimensions.space8,
                  ),
                  child: Text(
                    l10n.gestionRegistrosDatosRegistroTitle,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textBase,
                    ),
                  ),
                ),
                ...detailFields,
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _sentenceCase(final String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed != trimmed.toUpperCase()) {
      return trimmed;
    }
    final lowerCase = trimmed.toLowerCase();
    return '${lowerCase[0].toUpperCase()}${lowerCase.substring(1)}';
  }

  bool _hasValue(final String? value) => value != null && value.trim().isNotEmpty;

  String _formatDate(final BuildContext context, final String rawDate) {
    final date = DateTime.tryParse(rawDate);
    if (date == null) {
      return rawDate;
    }
    return DateFormat(
      'd MMM yyyy',
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.space4),
          Text(
            value,
            style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
          ),
        ],
      ),
    );
  }
}
