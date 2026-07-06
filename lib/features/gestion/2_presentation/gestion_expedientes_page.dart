import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Mis expedientes list screen — Figma node 41672:55115.
class GestionExpedientesPage extends ConsumerWidget {
  const GestionExpedientesPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final expedientesAsync = ref.watch(expedientesProvider);

    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        title: l10n.gestionExpedientesPageTitle,
        onBack: () => context.go(Routes.gestion),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.search),
            onPressed: () => AppAlertSnackbar.show(
              context,
              message: l10n.gestionSectionComingSoon,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: expedientesAsync.when(
            loading: () => const LoadingStateWidget(),
            error: (final error, final _) => ErrorStateWidget(
              message: l10n.gestionExpedientesLoadError,
              onRetry: () => ref.invalidate(expedientesProvider),
            ),
            data: (final expedientes) => expedientes.isEmpty
                ? EmptyStateWidget(message: l10n.gestionExpedientesEmpty)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space16,
                      vertical: AppDimensions.space24,
                    ),
                    itemCount: expedientes.length,
                    separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
                    itemBuilder: (final context, final index) => _GestionExpedienteCard(expediente: expedientes[index]),
                  ),
          ),
        ),
      ),
    );
  }
}

class _GestionExpedienteCard extends StatelessWidget {
  const _GestionExpedienteCard({required this.expediente});

  final Expediente expediente;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space16,
              AppDimensions.space12,
              AppDimensions.space16,
              AppDimensions.space8,
            ),
            child: Text(
              expediente.consejeria.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space16,
              0,
              AppDimensions.space16,
              AppDimensions.space12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    expediente.titulo,
                    style: AppTypography.leadingMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                const Icon(AppIcons.arrowForward, size: 20, color: AppColors.primary),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.backgroundLightBlue,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RefRow(label: l10n.gestionExpedientesNumExpedienteLabel, value: expediente.numexp),
                const SizedBox(height: AppDimensions.space8),
                _RefRow(
                  label: l10n.gestionExpedientesFechaInicioLabel,
                  value: expediente.fechaInicio ?? '-',
                ),
              ],
            ),
          ),
          if (expediente.estado != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space16,
                AppDimensions.space12,
                AppDimensions.space16,
                AppDimensions.space4,
              ),
              child: Text(
                l10n.gestionExpedientesEstadoLabel,
                style: AppTypography.captionUppercase.copyWith(color: AppColors.textSecondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space16,
                0,
                AppDimensions.space16,
                AppDimensions.space12,
              ),
              child: Text(
                expediente.estado!,
                style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RefRow extends StatelessWidget {
  const _RefRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionUppercase.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: AppDimensions.space8),
        Expanded(
          child: Text(
            value,
            style: AppTypography.smallRegular.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
