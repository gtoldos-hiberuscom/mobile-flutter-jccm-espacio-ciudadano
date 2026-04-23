import 'package:jccm_espacio_ciudadano/features/help/0_entity/faq_entry.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_contact.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_guide.dart';
import 'package:meta/meta.dart';

/// Aggregate value object returned by `HelpRepository`.
///
/// Bundles the FAQ list, guide list and contact list into one cohesive
/// payload so the presentation layer subscribes to a single provider.
@immutable
final class HelpContent {
  const HelpContent({
    required this.faqs,
    required this.guides,
    required this.contacts,
  });

  final List<FaqEntry> faqs;
  final List<HelpGuide> guides;
  final List<HelpContact> contacts;

  /// Returns the FAQ entries grouped by their [FaqEntry.category] ARB key,
  /// preserving the original list order inside each group.
  Map<String, List<FaqEntry>> faqsByCategory() {
    final result = <String, List<FaqEntry>>{};
    for (final entry in faqs) {
      result.putIfAbsent(entry.category, () => <FaqEntry>[]).add(entry);
    }
    return result;
  }
}
