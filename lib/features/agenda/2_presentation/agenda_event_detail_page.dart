import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/extensions/date_time_format.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/agenda_category_ui.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Detail page for a single [AgendaEvent] (STORY-29 / STORY-30).
///
/// Reads the current snapshot from [agendaProvider] — when the
/// event is missing (snapshot mismatch, deep-link to a stale id) the
/// page falls back to an [EmptyStateWidget].
class AgendaEventDetailPage extends ConsumerWidget {
  const AgendaEventDetailPage({required this.eventId, super.key});

  final String eventId;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(agendaProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.agendaDetailBack,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/agenda');
            }
          },
        ),
        title: Text(l10n.agendaPageTitle),
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final _, final stackTrace) =>
            EmptyStateWidget(message: l10n.agendaDetailNotFound),
        data: (final state) {
          final event = state.snapshot.events.firstWhere(
            (final e) => e.id == eventId,
            orElse: () => _missing,
          );
          if (identical(event, _missing)) {
            return EmptyStateWidget(message: l10n.agendaDetailNotFound);
          }
          return _DetailBody(event: event);
        },
      ),
    );
  }

  static final AgendaEvent _missing = AgendaEvent(
    id: '__missing__',
    rawTitle: '',
    startsAt: DateTime.fromMillisecondsSinceEpoch(0),
    category: AgendaCategory.otros,
    source: AgendaEventSource.manual,
  );
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.event});

  final AgendaEvent event;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final title = event.rawTitle ?? event.titleKey ?? '';
    final endLabel = event.endsAt != null
        ? ' – ${event.endsAt!.formatHhMm()}'
        : '';
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                AgendaCategoryUi.iconFor(event.category),
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Text(title, style: theme.textTheme.titleLarge),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space16),
        Text(
          AgendaCategoryUi.labelFor(context, event.category),
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.space16),
        _DetailRow(
          icon: Icons.schedule,
          label: l10n.agendaDetailWhen,
          value: '${event.startsAt.formatDdMmYyyyHhMm()}$endLabel',
        ),
        if (event.tipo != null && event.tipo!.isNotEmpty)
          _DetailRow(
            icon: Icons.local_activity_outlined,
            label: l10n.agendaDetailTipo,
            value: event.tipo!,
          ),
        if (event.centro != null && event.centro!.isNotEmpty)
          _DetailRow(
            icon: Icons.apartment_outlined,
            label: l10n.agendaDetailCentro,
            value: event.centro!,
          ),
        if (event.profesional != null && event.profesional!.isNotEmpty)
          _DetailRow(
            icon: Icons.person_outline,
            label: l10n.agendaDetailProfesional,
            value: event.profesional!,
          ),
        if (event.location != null && event.location!.isNotEmpty)
          _DetailRow(
            icon: Icons.place_outlined,
            label: l10n.agendaDetailLocation,
            value: event.location!,
          ),
        if (event.description != null && event.description!.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.space16),
          Text(
            l10n.agendaDetailDescription,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: AppDimensions.space4),
          Text(
            event.description!,
            style: theme.textTheme.bodyMedium,
          ),
        ],
        if (event.justificanteUrl != null) ...[
          const SizedBox(height: AppDimensions.space24),
          // TODO(TASK-53): route the justificante through ExternalLinkCatalog
          // when the URL is allow-listed; until then show a placeholder
          // snackbar so the CTA stays inert but discoverable.
          OutlinedButton.icon(
            key: const ValueKey('agenda-justificante-cta'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.agendaJustificanteUnavailable),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(l10n.agendaDetailJustificante),
          ),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconMedium, color: theme.colorScheme.outline),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelSmall),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
