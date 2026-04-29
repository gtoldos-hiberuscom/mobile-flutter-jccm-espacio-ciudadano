import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/extensions/date_time_format.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/agenda_category_ui.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Single row in the agenda list view (STORY-29) with an inline
/// expand/collapse affordance for the event preview (STORY-30).
///
/// Tapping the title still navigates to the dedicated detail page via
/// [onTap]; the expand chevron only toggles the inline preview.
class AgendaEventTile extends StatefulWidget {
  const AgendaEventTile({
    required this.event,
    required this.subtitle,
    required this.onTap,
    super.key,
    this.initiallyExpanded = false,
  });

  final AgendaEvent event;
  final String subtitle;
  final VoidCallback onTap;
  final bool initiallyExpanded;

  @override
  State<AgendaEventTile> createState() => _AgendaEventTileState();
}

class _AgendaEventTileState extends State<AgendaEventTile> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final categoryLabel = AgendaCategoryUi.labelFor(context, widget.event.category);
    final title = widget.event.rawTitle ?? widget.event.titleKey ?? '';
    final hasInlineDetail = widget.event.centro != null || widget.event.profesional != null || widget.event.tipo != null || (widget.event.description != null && widget.event.description!.isNotEmpty);

    return Semantics(
      container: true,
      label: '$title — $categoryLabel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                AgendaCategoryUi.iconFor(widget.event.category),
                color: theme.colorScheme.onPrimaryContainer,
                size: AppDimensions.iconMedium,
              ),
            ),
            title: Text(title),
            subtitle: Text(widget.subtitle),
            trailing: hasInlineDetail
                ? IconButton(
                    key: const ValueKey('agenda-tile-expand'),
                    tooltip: _expanded ? l10n.agendaTileCollapse : l10n.agendaTileExpand,
                    icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: _toggle,
                  )
                : const Icon(Icons.chevron_right),
            onTap: widget.onTap,
          ),
          if (hasInlineDetail && _expanded)
            Padding(
              key: const ValueKey('agenda-tile-inline-detail'),
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space64,
                0,
                AppDimensions.space16,
                AppDimensions.space12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.event.tipo != null)
                    _InlineLine(
                      label: l10n.agendaDetailTipo,
                      value: widget.event.tipo!,
                    ),
                  if (widget.event.centro != null)
                    _InlineLine(
                      label: l10n.agendaDetailCentro,
                      value: widget.event.centro!,
                    ),
                  if (widget.event.profesional != null)
                    _InlineLine(
                      label: l10n.agendaDetailProfesional,
                      value: widget.event.profesional!,
                    ),
                  _InlineLine(
                    label: l10n.agendaDetailWhen,
                    value: widget.event.startsAt.formatDdMmYyyyHhMm(),
                  ),
                  if (widget.event.description != null && widget.event.description!.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.space8),
                    Text(
                      widget.event.description!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: AppDimensions.space8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: widget.onTap,
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: Text(l10n.agendaTileOpenDetail),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _InlineLine extends StatelessWidget {
  const _InlineLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
