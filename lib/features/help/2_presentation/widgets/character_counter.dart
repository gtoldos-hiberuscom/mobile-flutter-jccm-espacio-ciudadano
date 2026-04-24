import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';

/// Inline character counter with a leading icon — used by the description
/// field to surface the running length and a hard limit.
class CharacterCounter extends StatelessWidget {
  const CharacterCounter({
    required this.current,
    required this.max,
    super.key,
  });

  final int current;
  final int max;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isOver = current > max;
    final color = isOver
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.space4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '$current / $max',
          style: theme.textTheme.bodySmall?.copyWith(color: color),
        ),
      ),
    );
  }
}
