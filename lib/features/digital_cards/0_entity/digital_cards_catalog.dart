import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';

/// Load outcome for the digital cards catalogue payload.
///
/// - [loading] — initial async build.
/// - [loaded]  — at least one federated card decoded.
/// - [empty]   — the citizen has no federated cards (CIP mini card may
///   still be rendered at the top per TASK-71).
/// - [error]   — repository failure; UI shows a recoverable error surface.
enum DigitalCardsCatalogState { loading, loaded, empty, error }

/// Aggregated catalogue snapshot returned by the repository.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
final class DigitalCardsCatalog {
  const DigitalCardsCatalog({
    required this.cards,
    required this.lastUpdatedAt,
    required this.state,
    this.errorReason,
  });

  /// Empty placeholder used by the notifier on first build.
  factory DigitalCardsCatalog.empty() => DigitalCardsCatalog(
    cards: const <DigitalCard>[],
    lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    state: DigitalCardsCatalogState.loading,
  );

  final List<DigitalCard> cards;
  final DateTime lastUpdatedAt;
  final DigitalCardsCatalogState state;

  /// Optional, locale-independent reason associated with
  /// [DigitalCardsCatalogState.error]. Never rendered raw — the UI
  /// maps it to a localised message.
  final String? errorReason;
}
