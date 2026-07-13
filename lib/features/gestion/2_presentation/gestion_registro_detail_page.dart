import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          onPressed: () => context.go(Routes.gestionRegistros),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space4,
                  vertical: AppDimensions.space8,
                ),
                child: Text(
                  registro.titulo,
                  style: AppTypography.h2.copyWith(color: AppColors.textBase),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.space4,
                  AppDimensions.space4,
                  AppDimensions.space4,
                  AppDimensions.space8,
                ),
                child: Text(
                  l10n.gestionRegistrosDatosRegistroTitle,
                  style: AppTypography.h3.copyWith(color: AppColors.textBase),
                ),
              ),
              _DetailField(
                label: l10n.gestionRegistrosNumRegistroLabel,
                value: registro.numregistro,
              ),
              _DetailField(
                label: l10n.gestionRegistrosFechaLabel,
                value: registro.fecha ?? '-',
              ),
              _DetailField(
                label: isEntrada ? l10n.gestionRegistrosConsejeriaDestinoLabel : l10n.gestionRegistrosConsejeriaOrigenLabel,
                value: registro.consejeria ?? '-',
              ),
            ],
          ),
        ),
      ),
    );
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
