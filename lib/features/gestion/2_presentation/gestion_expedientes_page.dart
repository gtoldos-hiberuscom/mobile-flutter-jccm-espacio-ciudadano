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

    return AppCard(
      title: expediente.titulo,
      categoryLabel: expediente.consejeria.toUpperCase(),
      showArrow: true,
      refNumber: expediente.numexp,
      refNumberLabel: l10n.gestionExpedientesNumExpedienteLabel,
      expiryDate: expediente.fechaInicio ?? '-',
      expiryDateLabel: l10n.gestionExpedientesFechaInicioLabel,
      extraLabel: expediente.estado != null ? l10n.gestionExpedientesEstadoLabel : null,
      extraText: expediente.estado,
    );
  }
}
