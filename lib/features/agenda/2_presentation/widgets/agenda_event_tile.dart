import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/agenda_category_ui.dart';

/// Single row in the agenda list view.
class AgendaEventTile extends StatelessWidget {
  const AgendaEventTile({
    required this.event,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final AgendaEvent event;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final categoryLabel = AgendaCategoryUi.labelFor(context, event.category);
    final title = event.rawTitle ?? event.titleKey ?? '';
    return Semantics(
      button: true,
      label: '$title — $categoryLabel',
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            AgendaCategoryUi.iconFor(event.category),
            color: theme.colorScheme.onPrimaryContainer,
            size: AppDimensions.iconMedium,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
