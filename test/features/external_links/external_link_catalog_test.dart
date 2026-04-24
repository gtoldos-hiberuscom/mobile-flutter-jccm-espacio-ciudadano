import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link_category.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/3_data/external_link_catalog_impl.dart';

void main() {
  group('ExternalLinkCatalogImpl', () {
    const catalog = ExternalLinkCatalogImpl();

    test('exposes every STORY-28 inventory entry', () {
      final ids = catalog.all().map((final e) => e.id).toSet();
      expect(
        ids,
        containsAll(<String>{
          'educamos_clm',
          'empleo_clm',
          'empleo_publico_clm',
          'sede_dgt',
          'carpeta_ciudadana_age',
          'historia_social_unica',
          'infancia_familias',
        }),
      );
    });

    test('every entry uses https and has a non-empty host', () {
      for (final link in catalog.all()) {
        expect(link.url.scheme, 'https', reason: 'link ${link.id} must use https');
        expect(link.url.host, isNotEmpty, reason: 'link ${link.id} must have a host');
      }
    });

    test('every entry is uniquely identifiable by id', () {
      final ids = catalog.all().map((final e) => e.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'ids must be unique');
    });

    test('every entry maps to exactly one declared category', () {
      for (final link in catalog.all()) {
        expect(ExternalLinkCategory.values, contains(link.category));
      }
    });

    test('findById returns the matching entry and null for unknown ids', () {
      final found = catalog.findById('educamos_clm');
      expect(found, isNotNull);
      expect(found!.category, ExternalLinkCategory.educationCLM);

      expect(catalog.findById('does-not-exist'), isNull);
    });

    test('byCategory filters correctly', () {
      final dgt = catalog.byCategory(ExternalLinkCategory.dgtElectronic);
      expect(dgt, hasLength(1));
      expect(dgt.single.id, 'sede_dgt');
    });

    test('all() returns an unmodifiable view', () {
      final list = catalog.all();
      expect(() => list.removeAt(0), throwsUnsupportedError);
    });

    test('every entry uses a camelCase l10n display key', () {
      final pattern = RegExp(r'^externalLink[A-Z][A-Za-z]*Label$');
      for (final link in catalog.all()) {
        expect(
          pattern.hasMatch(link.displayKey),
          isTrue,
          reason: 'displayKey ${link.displayKey} must match $pattern',
        );
      }
    });
  });
}
