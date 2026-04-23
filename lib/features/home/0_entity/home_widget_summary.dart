import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_block_id.dart';

/// Per-block load outcome.
///
/// The home dashboard hydrates each block independently so that one block
/// failing does not prevent the rest of the home from being rendered
/// (canon §16, partial-error tolerance).
enum HomeBlockLoadState {
  /// Data was loaded and at least one item is available.
  loaded,

  /// Data was loaded successfully but the result set is empty.
  empty,

  /// Data could not be loaded — show a per-block error with retry affordance.
  error,
}

/// Immutable per-block summary value object.
///
/// Pure Dart — no Flutter, Riverpod or infrastructure imports allowed
/// (canon §11, 0_entity layer).
final class HomeWidgetSummary {
  const HomeWidgetSummary({
    required this.blockId,
    required this.loadState,
    this.lastUpdatedAt,
    this.count,
    this.headline,
    this.errorMessage,
  });

  /// Identifier of the block this summary describes.
  final HomeBlockId blockId;

  /// Per-block load outcome — see [HomeBlockLoadState].
  final HomeBlockLoadState loadState;

  /// Timestamp of the last successful refresh for this block.
  ///
  /// Always shown to the user so they can judge data freshness.
  /// `null` when the block has never been loaded successfully.
  final DateTime? lastUpdatedAt;

  /// Optional aggregated count (e.g. number of pending notifications).
  final int? count;

  /// Optional short headline (e.g. the title of the next event).
  final String? headline;

  /// Generic, PII-free error label when [loadState] is [HomeBlockLoadState.error].
  final String? errorMessage;
}
