import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';

/// Lightweight breadcrumb header used at the top of the casework
/// workspace. Renders a chain of clickable / static segments separated
/// by a chevron — kept inside the feature tree so the workspace can
/// evolve its breadcrumb layout without affecting other features.
class CaseworkBreadcrumb extends StatelessWidget {
  const CaseworkBreadcrumb({required this.segments, super.key});

  final List<CaseworkBreadcrumbSegment> segments;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final widgets = <Widget>[];
    for (var i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final isLast = i == segments.length - 1;
      final style = (isLast ? theme.textTheme.titleSmall : theme.textTheme.bodyMedium)
          ?.copyWith(
        color: isLast ? theme.colorScheme.onSurface : muted,
        fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
      );
      widgets.add(
        Semantics(
          header: isLast,
          child: Text(seg.label, style: style),
        ),
      );
      if (!isLast) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space4,
            ),
            child: Icon(
              Icons.chevron_right,
              size: AppDimensions.iconSmall,
              color: muted,
            ),
          ),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widgets,
      ),
    );
  }
}

/// One segment of the breadcrumb. Pure data — no Flutter deps inside.
final class CaseworkBreadcrumbSegment {
  const CaseworkBreadcrumbSegment({required this.label});
  final String label;
}
