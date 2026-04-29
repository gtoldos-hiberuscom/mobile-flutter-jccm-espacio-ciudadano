/// Familia numerosa carnet (EPIC-7 / STORY-49) — presentation.
library;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_member.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// List tile rendering a single carnet member: localised parentesco,
/// printed name and (when present) a formatted birth date. Pure
/// presentational widget — no state, no providers.
class FamiliaNumerosaMemberTile extends StatelessWidget {
  const FamiliaNumerosaMemberTile({
    required this.member,
    super.key,
  });

  final FamiliaNumerosaMember member;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final materialL10n = MaterialLocalizations.of(context);
    final parentesco = _parentescoLabelFor(l10n, member.parentesco);
    final displayName = member.name.isEmpty ? l10n.familiaNumerosaMemberFallbackName : member.name;
    final formattedBirth = member.fechaNacimiento == null ? null : materialL10n.formatCompactDate(member.fechaNacimiento!);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.person_outline, size: AppDimensions.iconMedium),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(displayName, style: theme.textTheme.bodyLarge),
                const SizedBox(height: AppDimensions.space2),
                Text(
                  parentesco,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (formattedBirth != null) ...<Widget>[
                  const SizedBox(height: AppDimensions.space2),
                  Text(
                    formattedBirth,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _parentescoLabelFor(final AppLocalizations l10n, final String slug) {
    switch (slug.toLowerCase()) {
      case 'titular':
        return l10n.familiaNumerosaParentescoTitular;
      case 'conyuge':
      case 'cónyuge':
        return l10n.familiaNumerosaParentescoConyuge;
      case 'hijo':
        return l10n.familiaNumerosaParentescoHijo;
      case 'hija':
        return l10n.familiaNumerosaParentescoHija;
      default:
        return l10n.familiaNumerosaParentescoOtro;
    }
  }
}
