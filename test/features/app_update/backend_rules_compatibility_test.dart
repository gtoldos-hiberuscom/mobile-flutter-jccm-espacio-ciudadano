import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/domain.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/app_update_decision_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/app_update_decision_mapper.dart';

import 'support/app_update_fakes.dart';

/// Compatibilidad con la lógica de reglas acordada con back el 14/10/2026
/// (`documentation/api/app-version-api.yaml`), sobre su configuración de
/// ejemplo para Android:
///
/// `versionPublicada` 0.2.0 · `versionMinima` 0.1.5 · `versionRecomendada`
/// 0.2.0 · `versionesBloqueadas` [0.1.7] · `mensajeForzada` «Versión retirada.»
///
/// Cada caso es la respuesta que esa lógica da para una versión instalada, y lo
/// que la app debe hacer con ella. La respuesta pasa por el mismo DTO y mapper
/// que la del servidor.
void main() {
  const forcedJson = '{"body": {"accion": "FORZADA", "versionPublicada": "0.2.0", "mensaje": "Versión retirada."}}';
  const recommendedJson = '{"body": {"accion": "RECOMENDADA", "versionPublicada": "0.2.0", "mensaje": null}}';
  const noneJson = '{"body": {"accion": "NINGUNA", "versionPublicada": null, "mensaje": null}}';

  Future<CheckAppUpdateResult> check({required final String installed, required final String response}) => CheckAppUpdateUsecase(
    decisions: FakeAppUpdateRepository(decision: AppUpdateDecisionMapper.fromDto(AppUpdateDecisionDto.fromJsonString(response))),
    installedVersions: FakeInstalledVersionRepository(AppVersion.parse(installed)),
    preferences: FakeAppUpdatePreferencesRepository(),
  ).execute();

  group('Lógica de reglas de back', () {
    test('paso 1 · plataforma o app sin configurar → NINGUNA → sin aviso', () async {
      expect(await check(installed: '0.1.9', response: noneJson), isA<UpdateNotRequired>());
    });

    test('paso 2 · instalada igual o superior a la publicada (también builds de pruebas) → sin aviso', () async {
      expect(await check(installed: '0.2.0', response: noneJson), isA<UpdateNotRequired>());
      expect(await check(installed: '0.3.0', response: noneJson), isA<UpdateNotRequired>());
    });

    test('paso 3 · versión bloqueada (0.1.7, por encima de la mínima) → forzada con su mensaje', () async {
      final info = (await check(installed: '0.1.7', response: forcedJson) as UpdateAvailable).info;
      expect(info.isForced, isTrue);
      expect(info.latestVersion, const AppVersion(0, 2, 0));
      expect(info.message, 'Versión retirada.');
    });

    test('paso 4 · por debajo de la mínima → forzada', () async {
      final info = (await check(installed: '0.1.4', response: forcedJson) as UpdateAvailable).info;
      expect(info.isForced, isTrue);
    });

    test('paso 5 · entre la mínima y la recomendada → recomendada a la publicada', () async {
      final info = (await check(installed: '0.1.9', response: recommendedJson) as UpdateAvailable).info;
      expect(info.policy, UpdatePolicy.recommended);
      expect(info.latestVersion, const AppVersion(0, 2, 0));
      expect(info.message, isNull);
    });

    test('la comparación es numérica: 0.10.0 instalada no se fuerza a 0.9.0', () async {
      // Back comparando como texto ("0.10.0" < "0.9.0") devolvería FORZADA;
      // la app la detecta como incoherente y no bloquea.
      const wrongJson = '{"body": {"accion": "FORZADA", "versionPublicada": "0.9.0", "mensaje": null}}';
      expect(await check(installed: '0.10.0', response: wrongJson), isA<CheckAppUpdateFailed>());
    });
  });
}
