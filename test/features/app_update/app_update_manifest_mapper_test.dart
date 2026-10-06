import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/app_update_manifest_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/app_update_manifest_mapper.dart';

const _validJson = '''
{
  "android": { "latestVersion": "1.2.0", "minVersion": "1.0.0", "policy": "recommended", "storeUrl": "https://play.google.com/store/apps/details?id=es.jccm.espaciociudadano" },
  "ios":     { "latestVersion": "1.3.0", "minVersion": "1.1.0", "policy": "none", "storeUrl": "https://apps.apple.com/es/app/id123456789" },
  "updatedAt": "2026-10-05"
}
''';

String _platformJson({
  final String latest = '1.2.0',
  final String min = '1.0.0',
  final String policy = 'recommended',
  final String storeUrl = 'https://play.google.com/store/apps/details?id=es.jccm.espaciociudadano',
}) => '{"android": {"latestVersion": "$latest", "minVersion": "$min", "policy": "$policy", "storeUrl": "$storeUrl"}}';

void main() {
  group('AppUpdateManifestMapper.fromDto', () {
    test('resuelve la entrada de cada plataforma e ignora claves desconocidas', () {
      final dto = AppUpdateManifestDto.fromJsonString(_validJson);

      final android = AppUpdateManifestMapper.fromDto(dto, platformKey: 'android');
      expect(android.latestVersion, const AppVersion(1, 2, 0));
      expect(android.minVersion, const AppVersion(1, 0, 0));
      expect(android.policy, UpdatePolicy.recommended);
      expect(android.storeUrl.host, 'play.google.com');
      expect(android.displayVersion, '1.2.0');

      final ios = AppUpdateManifestMapper.fromDto(dto, platformKey: 'ios');
      expect(ios.latestVersion, const AppVersion(1, 3, 0));
      expect(ios.policy, UpdatePolicy.none);
      expect(ios.storeUrl.host, 'apps.apple.com');
    });

    test('falla si falta la plataforma pedida', () {
      final dto = AppUpdateManifestDto.fromJsonString(_platformJson());
      expect(() => AppUpdateManifestMapper.fromDto(dto, platformKey: 'ios'), throwsFormatException);
    });

    test('falla con una política desconocida', () {
      final dto = AppUpdateManifestDto.fromJsonString(_platformJson(policy: 'urgent'));
      expect(() => AppUpdateManifestMapper.fromDto(dto, platformKey: 'android'), throwsFormatException);
    });

    test('acepta "forced" como política explícita', () {
      final dto = AppUpdateManifestDto.fromJsonString(_platformJson(policy: 'forced'));
      expect(AppUpdateManifestMapper.fromDto(dto, platformKey: 'android').policy, UpdatePolicy.forced);
    });

    test('falla con una versión mal formada', () {
      final dto = AppUpdateManifestDto.fromJsonString(_platformJson(latest: '1.2'));
      expect(() => AppUpdateManifestMapper.fromDto(dto, platformKey: 'android'), throwsFormatException);
    });

    test('rechaza una URL de tienda que no sea https', () {
      final dto = AppUpdateManifestDto.fromJsonString(_platformJson(storeUrl: 'http://play.google.com/store/apps/details?id=x'));
      expect(() => AppUpdateManifestMapper.fromDto(dto, platformKey: 'android'), throwsFormatException);
    });

    test('rechaza una URL de tienda con un host fuera de la lista blanca', () {
      final dto = AppUpdateManifestDto.fromJsonString(_platformJson(storeUrl: 'https://evil.example.com/app'));
      expect(() => AppUpdateManifestMapper.fromDto(dto, platformKey: 'android'), throwsFormatException);
    });
  });

  group('AppUpdateManifestDto', () {
    test('falla si falta un campo obligatorio', () {
      const json = '{"android": {"latestVersion": "1.2.0", "policy": "none", "storeUrl": "https://play.google.com/x"}}';
      expect(() => AppUpdateManifestDto.fromJsonString(json), throwsFormatException);
    });

    test('falla si un campo obligatorio viene vacío o con otro tipo', () {
      expect(() => AppUpdateManifestDto.fromJsonString(_platformJson(min: ' ')), throwsFormatException);
      const numeric = '{"android": {"latestVersion": 1, "minVersion": "1.0.0", "policy": "none", "storeUrl": "https://play.google.com/x"}}';
      expect(() => AppUpdateManifestDto.fromJsonString(numeric), throwsFormatException);
    });

    test('falla si la plataforma no es un objeto', () {
      expect(() => AppUpdateManifestDto.fromJsonString('{"android": "1.2.0"}'), throwsFormatException);
    });

    test('falla si la raíz no es un objeto o el JSON está roto', () {
      expect(() => AppUpdateManifestDto.fromJsonString('[]'), throwsFormatException);
      expect(() => AppUpdateManifestDto.fromJsonString('{"android": '), throwsFormatException);
    });

    test('una plataforma ausente es null, no un error, hasta que se pide', () {
      final dto = AppUpdateManifestDto.fromJsonString(_platformJson());
      expect(dto.android, isNotNull);
      expect(dto.ios, isNull);
      expect(dto.forPlatform('web'), isNull);
    });
  });
}
