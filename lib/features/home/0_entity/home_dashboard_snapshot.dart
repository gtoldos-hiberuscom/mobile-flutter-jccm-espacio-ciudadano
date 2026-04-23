import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_block_id.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_widget_summary.dart';

/// Aggregated dashboard payload returned by the home repository.
///
/// Holds one [HomeWidgetSummary] per [HomeBlockId]. Each summary carries
/// its own [HomeBlockLoadState] so partial errors are encoded in the value
/// object instead of as a top-level failure.
///
/// Pure Dart — no Flutter, Riverpod or infrastructure imports allowed
/// (canon §11, 0_entity layer).
final class HomeDashboardSnapshot {
  const HomeDashboardSnapshot({required this.blocks});

  /// One summary per [HomeBlockId]. Order is the canonical render order
  /// of the home dashboard.
  final List<HomeWidgetSummary> blocks;

  /// Returns the summary for [id], or `null` when the snapshot does not
  /// contain that block.
  HomeWidgetSummary? findById(final HomeBlockId id) {
    for (final block in blocks) {
      if (block.blockId == id) {
        return block;
      }
    }
    return null;
  }
}
