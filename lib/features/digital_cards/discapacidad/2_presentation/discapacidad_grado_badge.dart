/// Carnet Discapacidad (EPIC-7 / STORY-51) — presentation widget.
library;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Pill-style badge that surfaces the grado de discapacidad.
///
/// When [grado] is non-null the badge renders the canonical
/// "{grado}%" label; when it is null but [rawLabel] is provided it
/// echoes the raw backend label as a fallback; otherwise it renders
/// the localised "no disponible" message and a neutral colour scheme
/// so the affordance does not look like a positive state.
class DiscapacidadGradoBadge extends StatelessWidget {
  const DiscapacidadGradoBadge({
    required this.grado,
    this.rawLabel,
    super.key,
  });

  /// Canonical grado integer (1..100) — null when the backend payload
  /// did not yield a structured value.
  final int? grado;

  /// Raw label the backend returned (e.g. `"Grado 65 - Vigente"`).
  /// Used as a fallback when [grado] is null but the backend at least
  /// surfaced something.
  final String? rawLabel;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final bool isUnknown = grado == null && (rawLabel == null || rawLabel!.trim().isEmpty);
    final String label;
    if (grado != null) {
      label = l10n.discapacidadGradoBadge(grado!);
    } else if (rawLabel != null && rawLabel!.trim().isNotEmpty) {
      label = rawLabel!.trim();
    } else {
      label = l10n.discapacidadGradoUnknown;
    }

    final Color background = isUnknown
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.primaryContainer;
    final Color foreground = isUnknown
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.onPrimaryContainer;

    return Semantics(
      label: '${l10n.discapacidadGradoLabel}: $label',
      child: Container(
        key: const ValueKey('discapacidadGradoBadge'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space4,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppDimensions.space16),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
