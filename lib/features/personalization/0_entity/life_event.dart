import 'package:meta/meta.dart';

/// Domain entity representing one selectable life event.
///
/// Immutable snapshot — [selected] reflects current local selection state.
/// Pure Dart (aside from the meta annotation): no Flutter widgets, Riverpod,
/// Dio, or infrastructure imports.
@immutable
final class LifeEvent {
  const LifeEvent({
    required this.id,
    required this.label,
    required this.selected,
  });

  /// Backend identifier for this life-event entry.
  final int id;

  /// Display name shown in the UI list.
  final String label;

  /// Whether the citizen has selected this life event.
  final bool selected;

  /// Returns a copy of this entity with [selected] overridden.
  LifeEvent copyWith({final bool? selected}) =>
      LifeEvent(id: id, label: label, selected: selected ?? this.selected);

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is LifeEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          selected == other.selected;

  @override
  int get hashCode => Object.hash(id, label, selected);

  @override
  String toString() => 'LifeEvent(id: $id, label: $label, selected: $selected)';
}
