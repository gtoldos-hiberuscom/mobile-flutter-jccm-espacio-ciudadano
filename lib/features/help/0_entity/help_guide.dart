/// A help guide entry shown in the Help → Guías tab.
///
/// Entities are pure Dart — no Flutter, Riverpod, or infrastructure imports.
library;

import 'package:jccm_espacio_ciudadano/features/help/0_entity/faq_item.dart';

/// A short guide or resource that helps a citizen use the app or a service.
final class HelpGuide {
  const HelpGuide({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    this.externalUrl,
  });

  /// Unique identifier for the guide.
  final String id;

  /// Title displayed as the card heading.
  final String title;

  /// One-line summary of the guide content.
  final String summary;

  /// The thematic category this guide belongs to.
  final HelpCategory category;

  /// Optional external URL the user can open to read the full guide.
  final String? externalUrl;
}
