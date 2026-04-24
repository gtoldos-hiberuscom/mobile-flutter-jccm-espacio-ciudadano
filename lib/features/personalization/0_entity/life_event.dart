import 'package:meta/meta.dart';

/// Categories used to group life events on the selection screen.
///
/// The values map 1:1 to the `categoria` field surfaced by the
/// `/hechos-vitales/hechos/{idAgente}` endpoint when it ships.
enum LifeEventCategory {
  familia,
  salud,
  empleo,
  vivienda,
  educacion,
}

/// A single selectable life event (`hecho vital`).
///
/// Pure Dart — no Flutter, Riverpod, Dio, or `BuildContext` imports allowed.
@immutable
final class LifeEvent {
  const LifeEvent({
    required this.id,
    required this.label,
    required this.category,
  });

  /// Stable identifier used for selection persistence and equality.
  final String id;

  /// Human-readable label as returned by the backend mock. Real wiring
  /// will replace this with a localizable key once the catalog ships.
  final String label;

  final LifeEventCategory category;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is LifeEvent && other.id == id && other.label == label && other.category == category;

  @override
  int get hashCode => Object.hash(id, label, category);
}
