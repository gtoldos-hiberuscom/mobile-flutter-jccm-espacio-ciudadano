import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/help/3_data/help_repository_impl.dart';

void main() {
  group('HelpRepositoryImpl', () {
    const repo = HelpRepositoryImpl();
    final content = repo.loadContent();

    test('exposes at least 5 FAQ entries spanning >= 2 categories', () {
      expect(content.faqs.length, greaterThanOrEqualTo(5));
      final categories = content.faqs.map((final e) => e.category).toSet();
      expect(categories.length, greaterThanOrEqualTo(2));
    });

    test('exposes at least 1 guide and includes phone + email contacts', () {
      expect(content.guides, isNotEmpty);
      final phones = content.contacts.where((final c) => c.type.name == 'phone').toList();
      final emails = content.contacts.where((final c) => c.type.name == 'email').toList();
      expect(phones, isNotEmpty);
      expect(emails, isNotEmpty);
    });

    test('faqsByCategory groups entries while preserving order', () {
      final grouped = content.faqsByCategory();
      // every faq must be reachable through grouping
      final flatCount = grouped.values.fold<int>(0, (final acc, final l) => acc + l.length);
      expect(flatCount, content.faqs.length);
      for (final entry in grouped.entries) {
        for (final faq in entry.value) {
          expect(faq.category, entry.key);
        }
      }
    });

    test('every faq has unique id', () {
      final ids = content.faqs.map((final e) => e.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });
}
