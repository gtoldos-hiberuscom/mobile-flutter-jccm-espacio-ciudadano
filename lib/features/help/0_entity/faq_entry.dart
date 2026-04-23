import 'package:meta/meta.dart';

/// Immutable value object describing a single FAQ entry shown on the
/// help center page (canon §11, 0_entity layer — pure Dart only).
///
/// - [id] is the stable, locale-independent identifier (snake_case).
/// - [questionKey] / [answerKey] are ARB localisation keys resolved by
///   the presentation layer; the entity never carries rendered text so
///   it remains locale-safe.
/// - [category] groups entries thematically (also a localisation key).
@immutable
final class FaqEntry {
  const FaqEntry({
    required this.id,
    required this.questionKey,
    required this.answerKey,
    required this.category,
  });

  /// Stable identifier (snake_case).
  final String id;

  /// ARB key for the question text.
  final String questionKey;

  /// ARB key for the answer text.
  final String answerKey;

  /// ARB key for the category label.
  final String category;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is FaqEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          questionKey == other.questionKey &&
          answerKey == other.answerKey &&
          category == other.category;

  @override
  int get hashCode => Object.hash(id, questionKey, answerKey, category);

  @override
  String toString() => 'FaqEntry(id: $id, category: $category)';
}
