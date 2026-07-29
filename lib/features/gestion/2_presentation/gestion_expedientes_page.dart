import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
      title: _sentenceCase(expediente.titulo),
      categoryLabel: expediente.consejeria.toUpperCase(),
      showArrow: true,
      refNumber: expediente.numexp,
      refNumberLabel: l10n.gestionExpedientesNumExpedienteLabel,
      expiryDate: _formatDate(context, expediente.fechaInicio),
      expiryDateLabel: l10n.gestionExpedientesFechaInicioLabel,
      extraLabel: expediente.estado != null ? l10n.gestionExpedientesEstadoLabel : null,
      extraText: expediente.estado == null ? null : _sentenceCase(expediente.estado!),
      onTap: () => context.push(
        '${Routes.gestionExpedientes}/${Uri.encodeComponent(expediente.numexp)}',
      ),
    );
  }

  String _formatDate(final BuildContext context, final String? rawDate) {
    final date = rawDate == null ? null : DateTime.tryParse(rawDate);
    if (date == null) {
      return rawDate ?? '-';
    }
    final formatted = DateFormat(
      'd MMM yyyy',
      Localizations.localeOf(context).languageCode,
    ).format(date);
    final parts = formatted.split(' ');
    if (parts.length < 3 || parts[1].isEmpty) {
      return formatted;
    }
    parts[1] = '${parts[1][0].toUpperCase()}${parts[1].substring(1)}';
    return parts.join(' ');
  }

  String _sentenceCase(final String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed != trimmed.toUpperCase()) {
      return trimmed;
    }
    return _formatExpedienteSentenceCase(trimmed);
  }
}

String _formatExpedienteSentenceCase(final String value) {
  const acronyms = {'EOI', 'FSP', 'JCCM', 'CLM', 'NIF', 'CIF', 'DNI', 'NIE'};
  final words = value.toLowerCase().split(' ');
  for (var index = 0; index < words.length; index++) {
    final uppercaseWord = words[index].toUpperCase();
    if (acronyms.contains(uppercaseWord)) {
      words[index] = uppercaseWord;
    }
  }
  final formatted = words.join(' ');
  return '${formatted[0].toUpperCase()}${formatted.substring(1)}';
}
