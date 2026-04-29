/// Familia numerosa carnet (EPIC-7 / STORY-49) — presentation.
library;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_categoria.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Compact pill rendering the carnet `categoria` (general / especial /
/// unknown). Pure presentational widget — no state, no providers.
class FamiliaNumerosaCategoriaBadge extends StatelessWidget {
  const FamiliaNumerosaCategoriaBadge({
    required this.categoria,
    super.key,
  });

  final FamiliaNumerosaCategoria categoria;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final Color background;
    final Color foreground;
    final String label;
    switch (categoria) {
      case FamiliaNumerosaCategoria.general:
        background = scheme.secondaryContainer;
        foreground = scheme.onSecondaryContainer;
        label = l10n.familiaNumerosaCategoriaGeneral;
      case FamiliaNumerosaCategoria.especial:
        background = scheme.primaryContainer;
        foreground = scheme.onPrimaryContainer;
        label = l10n.familiaNumerosaCategoriaEspecial;
      case FamiliaNumerosaCategoria.unknown:
        background = scheme.surfaceContainerHighest;
        foreground = scheme.onSurfaceVariant;
        label = l10n.familiaNumerosaCategoriaUnknown;
    }
    return Container(
      key: const ValueKey('familiaNumerosaCategoriaBadge'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: foreground),
      ),
    );
  }
}
