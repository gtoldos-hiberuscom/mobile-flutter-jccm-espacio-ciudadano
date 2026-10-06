import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/itunes_lookup_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/itunes_manifest_mapper.dart';

const _bundleId = 'es.jccm.espaciociudadano';

/// Recorte de una respuesta real de iTunes, con claves que no se usan.
String _lookupJson({
  final int resultCount = 1,
  final String version = '0.1.9',
  final String trackViewUrl = 'https://apps.apple.com/es/app/espacio-ciudadano/id123456789?uo=4',
  final String? bundleId = _bundleId,
  final bool includeResult = true,
}) {
  final result =
      '''
    {
      "artistName": "Junta de Comunidades de Castilla-La Mancha",
      "trackName": "Espacio Ciudadano",
      "trackId": 123456789,
      ${bundleId == null ? '' : '"bundleId": "$bundleId",'}
      "version": "$version",
      "trackViewUrl": "$trackViewUrl",
      "minimumOsVersion": "15.0",
      "currentVersionReleaseDate": "2026-10-06T09:33:53Z",
      "releaseNotes": "Mejoras y correcciones [:mav=9.9.9]",
      "description": "Descripción larga de la ficha."
    }''';
  return '{"resultCount": $resultCount, "results": [${includeResult ? result : ''}]}';
}

void main() {
  group('ItunesManifestMapper.fromDto', () {
    test('con un resultado devuelve una recomendada con la versión de marketing', () {
      final manifest = ItunesManifestMapper.fromDto(ItunesLookupDto.fromJsonString(_lookupJson()), bundleId: _bundleId);

      expect(manifest.latestVersion, const AppVersion(0, 1, 9));
      expect(manifest.minVersion, const AppVersion(0, 0, 0));
      expect(manifest.policy, UpdatePolicy.recommended);
      expect(manifest.storeUrl.host, 'apps.apple.com');
      expect(manifest.displayVersion, '0.1.9');
    });

    test('ignora la descripción y las notas: nunca fuerza', () {
      final manifest = ItunesManifestMapper.fromDto(ItunesLookupDto.fromJsonString(_lookupJson()), bundleId: _bundleId);
      expect(manifest.minVersion, const AppVersion(0, 0, 0));
    });

    test('acepta el bundle id sin distinguir mayúsculas y sin bundle id en la respuesta', () {
      expect(ItunesManifestMapper.fromDto(ItunesLookupDto.fromJsonString(_lookupJson(bundleId: 'ES.JCCM.EspacioCiudadano')), bundleId: _bundleId).latestVersion, const AppVersion(0, 1, 9));
      expect(ItunesManifestMapper.fromDto(ItunesLookupDto.fromJsonString(_lookupJson(bundleId: null)), bundleId: _bundleId).latestVersion, const AppVersion(0, 1, 9));
    });

    test('sin resultados (app no publicada) falla', () {
      final dto = ItunesLookupDto.fromJsonString(_lookupJson(resultCount: 0, includeResult: false));
      expect(() => ItunesManifestMapper.fromDto(dto, bundleId: _bundleId), throwsFormatException);
    });

    test('si iTunes contesta por otra app, falla', () {
      final dto = ItunesLookupDto.fromJsonString(_lookupJson(bundleId: 'com.other.app'));
      expect(() => ItunesManifestMapper.fromDto(dto, bundleId: _bundleId), throwsFormatException);
    });

    test('una versión que no sea x.y.z falla', () {
      final dto = ItunesLookupDto.fromJsonString(_lookupJson(version: '1.2'));
      expect(() => ItunesManifestMapper.fromDto(dto, bundleId: _bundleId), throwsFormatException);
    });

    test('rechaza una ficha que no sea https o esté fuera de la lista blanca', () {
      for (final url in ['http://apps.apple.com/es/app/id1', 'https://evil.example.com/app/id1']) {
        final dto = ItunesLookupDto.fromJsonString(_lookupJson(trackViewUrl: url));
        expect(() => ItunesManifestMapper.fromDto(dto, bundleId: _bundleId), throwsFormatException, reason: url);
      }
    });
  });

  group('ItunesLookupDto', () {
    test('falla si falta version o trackViewUrl', () {
      expect(() => ItunesLookupDto.fromJsonString('{"resultCount": 1, "results": [{"trackViewUrl": "https://apps.apple.com/x"}]}'), throwsFormatException);
      expect(() => ItunesLookupDto.fromJsonString('{"resultCount": 1, "results": [{"version": "1.0.0"}]}'), throwsFormatException);
    });

    test('falla si resultCount o results tienen otra forma', () {
      expect(() => ItunesLookupDto.fromJsonString('{"resultCount": "1", "results": []}'), throwsFormatException);
      expect(() => ItunesLookupDto.fromJsonString('{"resultCount": 1, "results": {}}'), throwsFormatException);
      expect(() => ItunesLookupDto.fromJsonString('{"resultCount": 1, "results": ["x"]}'), throwsFormatException);
    });

    test('falla si la raíz no es un objeto o el JSON está roto', () {
      expect(() => ItunesLookupDto.fromJsonString('[]'), throwsFormatException);
      expect(() => ItunesLookupDto.fromJsonString('{"resultCount": '), throwsFormatException);
    });
  });
}
