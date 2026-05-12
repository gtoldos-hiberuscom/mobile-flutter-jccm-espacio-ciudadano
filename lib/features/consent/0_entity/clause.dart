import 'package:meta/meta.dart';

/// Domain entity representing a single legal authorisation clause.
///
/// Pure Dart — no Flutter, Riverpod, Dio, or infrastructure imports.
@immutable
final class Clause {
  const Clause({
    required this.id,
    required this.label,
    required this.isSelected,
    this.version = '1.0',
  });

  final int id;

  /// Human-readable clause text shown to the citizen.
  final String label;

  /// Whether the citizen has checked this clause.
  final bool isSelected;

  /// Version string for consent-record traceability.
  final String version;

  Clause copyWith({final bool? isSelected}) => Clause(
        id: id,
        label: label,
        isSelected: isSelected ?? this.isSelected,
        version: version,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is Clause &&
          id == other.id &&
          isSelected == other.isSelected &&
          version == other.version;

  @override
  int get hashCode => Object.hash(id, isSelected, version);
}
