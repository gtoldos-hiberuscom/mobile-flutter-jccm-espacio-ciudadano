import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Read-only mini card for the CIP / Tarjeta Sanitaria, rendered at the
/// top of the digital cards catalogue per TASK-71 (CIP_REUSE).
///
/// Has NO wallet/QR/PDF actions; the only affordance is an inline link
/// pointing at STORY-31's salud surface.
///
/// // TODO(STORY-31): replace this local placeholder with the shared
///   `CipCard` widget owned by `lib/features/agenda/2_presentation/widgets/`
///   once STORY-31 ships. The widget API expected here is read-only and
///   does not require any wallet-style action slot.
class CipReadOnlyMiniCard extends StatelessWidget {
  const CipReadOnlyMiniCard({super.key, this.onOpenSalud});

  /// Optional CTA invoked when the citizen taps "ver tarjeta sanitaria".
  /// When null, the card renders without a CTA (used by the catalogue
  /// when no salud destination is wired yet).
  final VoidCallback? onOpenSalud;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      key: const ValueKey('digitalCardsCipMiniCard'),
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.medical_information_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppDimensions.space8),
                Expanded(
                  child: Text(
                    l10n.digitalCardsCipMiniTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space4),
            Text(
              l10n.digitalCardsCipMiniReadOnly,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onOpenSalud != null) ...<Widget>[
              const SizedBox(height: AppDimensions.space8),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: onOpenSalud,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(l10n.digitalCardsCipMiniOpenAction),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
