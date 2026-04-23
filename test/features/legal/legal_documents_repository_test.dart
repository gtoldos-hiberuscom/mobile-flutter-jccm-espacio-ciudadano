import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';
import 'package:jccm_espacio_ciudadano/features/legal/3_data/legal_documents_repository_impl.dart';

void main() {
  group('LegalDocumentsRepositoryImpl', () {
    const repo = LegalDocumentsRepositoryImpl();

    test('exposes the four required documents', () {
      final ids = repo.all().map((final d) => d.id).toSet();
      expect(
        ids,
        equals(<LegalDocumentId>{
          LegalDocumentId.terms,
          LegalDocumentId.privacy,
          LegalDocumentId.accessibility,
          LegalDocumentId.legalNotice,
        }),
      );
    });

    test('every document has a non-empty title key and body', () {
      for (final doc in repo.all()) {
        expect(doc.titleKey, isNotEmpty);
        expect(doc.bodyMarkdown.trim(), isNotEmpty);
      }
    });

    test('findById returns the matching document and null for unknown', () {
      final priv = repo.findById(LegalDocumentId.privacy);
      expect(priv, isNotNull);
      expect(priv!.titleKey, 'legalPrivacyTitle');
    });

    test('privacy document includes the consent reuse paragraph', () {
      final priv = repo.findById(LegalDocumentId.privacy)!;
      expect(priv.bodyMarkdown, contains('RGPD'));
      expect(priv.bodyMarkdown, contains('LOPDGDD'));
    });
  });
}
