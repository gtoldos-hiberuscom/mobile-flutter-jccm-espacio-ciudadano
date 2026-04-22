/// A single FAQ entry shown in the Help → FAQ tab.
///
/// Entities are pure Dart — no Flutter, Riverpod, or infrastructure imports.
library;

/// Categories used to group FAQ items and help guides.
enum HelpCategory {
  general,
  clave,
  tramites,
  notificaciones,
  carnets,
  otros,
}

/// An individual FAQ entry with a question, answer, and category.
final class FaqItem {
  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  /// Unique identifier for the FAQ entry.
  final String id;

  /// The question text displayed in the accordion header.
  final String question;

  /// The full answer text revealed when the accordion is expanded.
  final String answer;

  /// The thematic category this FAQ belongs to.
  final HelpCategory category;
}
