import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_registros_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Mis registros list screen — Figma node 41672:55987.
class GestionRegistrosPage extends StatefulWidget {
  const GestionRegistrosPage({super.key});

  @override
  State<GestionRegistrosPage> createState() => _GestionRegistrosPageState();
}

class _GestionRegistrosPageState extends State<GestionRegistrosPage> {
  _RegistrosTab _selectedTab = _RegistrosTab.entradas;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        title: l10n.gestionRegistrosPageTitle,
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
      body: Column(
        children: [
          AppTopTabBar(
            tabs: [l10n.gestionRegistrosEntradasTab, l10n.gestionRegistrosSalidasTab],
            selectedIndex: _selectedTab.index,
            onTabSelected: (final index) => setState(() => _selectedTab = _RegistrosTab.values[index]),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.backgroundBlueLighter,
              child: SafeArea(
                top: false,
                child: switch (_selectedTab) {
                  _RegistrosTab.entradas => const _EntradasTab(),
                  _RegistrosTab.salidas => const _SalidasTab(),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _RegistrosTab { entradas, salidas }

class _EntradasTab extends ConsumerWidget {
  const _EntradasTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(entradasProvider)
        .when(
          loading: () => const LoadingStateWidget(),
          error: (final error, final _) => ErrorStateWidget(
            message: l10n.gestionRegistrosEntradasLoadError,
            onRetry: () => ref.invalidate(entradasProvider),
          ),
          data: (final registros) => registros.isEmpty
              ? EmptyStateWidget(message: l10n.gestionRegistrosEntradasEmpty)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space24,
                  ),
                  itemCount: registros.length,
                  separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
                  itemBuilder: (final context, final index) => _RegistroCard(
                    registro: registros[index],
                    isEntrada: true,
                  ),
                ),
        );
  }
}

class _SalidasTab extends ConsumerWidget {
  const _SalidasTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(salidasProvider)
        .when(
          loading: () => const LoadingStateWidget(),
          error: (final error, final _) => ErrorStateWidget(
            message: l10n.gestionRegistrosSalidasLoadError,
            onRetry: () => ref.invalidate(salidasProvider),
          ),
          data: (final registros) => registros.isEmpty
              ? EmptyStateWidget(message: l10n.gestionRegistrosSalidasEmpty)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space24,
                  ),
                  itemCount: registros.length,
                  separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
                  itemBuilder: (final context, final index) => _RegistroCard(
                    registro: registros[index],
                    isEntrada: false,
                  ),
                ),
        );
  }
}

class _RegistroCard extends StatelessWidget {
  const _RegistroCard({required this.registro, required this.isEntrada});

  final Registro registro;
  final bool isEntrada;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      onTap: () => context.go(
        Routes.gestionRegistrosDetail,
        extra: (registro, isEntrada),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space16,
              AppDimensions.space12,
              AppDimensions.space16,
              AppDimensions.space12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    registro.titulo,
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
                _RefRow(
                  label: l10n.gestionRegistrosNumRegistroLabel,
                  value: registro.numregistro,
                ),
                const SizedBox(height: AppDimensions.space8),
                _RefRow(
                  label: l10n.gestionRegistrosFechaLabel,
                  value: registro.fecha ?? '-',
                ),
              ],
            ),
          ),
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
