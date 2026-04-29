import 'package:flutter/material.dart';

/// Standard loading placeholder for the recommendations list.
///
/// Wraps a [CircularProgressIndicator] with a `Semantics(liveRegion)` so
/// screen readers announce the loading transition.
class RecommendationsLoadingView extends StatelessWidget {
  const RecommendationsLoadingView({super.key, this.label});

  final String? label;

  @override
  Widget build(final BuildContext context) => Semantics(
    liveRegion: true,
    label: label,
    child: const Center(child: CircularProgressIndicator()),
  );
}
