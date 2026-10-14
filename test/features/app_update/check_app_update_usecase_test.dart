import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/domain.dart';

import 'support/app_update_fakes.dart';

void main() {
  late FakeAppUpdateRepository decisions;

  CheckAppUpdateUsecase build({
    required final String installed,
    final AppUpdateDecision? decision,
    final Exception? decisionError,
    final Exception? installedError,
    final String? ignored,
  }) {
    decisions = FakeAppUpdateRepository(decision: decision, error: decisionError);
    return CheckAppUpdateUsecase(
      decisions: decisions,
      installedVersions: FakeInstalledVersionRepository(AppVersion.parse(installed), error: installedError),
      preferences: FakeAppUpdatePreferencesRepository(ignored: AppVersion.tryParse(ignored)),
    );
  }

  group('CheckAppUpdateUsecase', () {
    test('pregunta al servidor con el id de la app y la versión instalada', () async {
      await build(installed: '1.0.0', decision: buildDecision()).execute();
      expect(decisions.lastApplicationId, 'es.jccm.espaciociudadano');
      expect(decisions.lastInstalledVersion, const AppVersion(1, 0, 0));
    });

    test('forzada → aviso forzado con la versión publicada', () async {
      final result = await build(installed: '1.0.0', decision: buildDecision(policy: UpdatePolicy.forced)).execute();
      final info = (result as UpdateAvailable).info;
      expect(info.policy, UpdatePolicy.forced);
      expect(info.isForced, isTrue);
      expect(info.latestVersion, const AppVersion(2, 0, 0));
    });

    test('recomendada → aviso recomendado', () async {
      final result = await build(installed: '1.0.0', decision: buildDecision()).execute();
      expect((result as UpdateAvailable).info.policy, UpdatePolicy.recommended);
    });

    test('ninguna → nada', () async {
      final result = await build(installed: '1.0.0', decision: const AppUpdateDecision.none()).execute();
      expect(result, isA<UpdateNotRequired>());
    });

    test('propaga el mensaje del servidor al aviso', () async {
      final result = await build(installed: '1.0.0', decision: buildDecision(policy: UpdatePolicy.forced, message: 'Versión retirada')).execute();
      expect((result as UpdateAvailable).info.message, 'Versión retirada');
    });

    group('decisión incoherente → Failed (no bloquea)', () {
      test('forzada sin versión publicada', () async {
        final result = await build(installed: '1.0.0', decision: buildDecision(policy: UpdatePolicy.forced, published: null)).execute();
        expect(result, isA<CheckAppUpdateFailed>());
      });

      test('forzada a la misma versión instalada', () async {
        final result = await build(installed: '2.0.0', decision: buildDecision(policy: UpdatePolicy.forced)).execute();
        expect(result, isA<CheckAppUpdateFailed>());
      });

      test('recomendada a una versión anterior', () async {
        final result = await build(installed: '2.1.0', decision: buildDecision()).execute();
        expect(result, isA<CheckAppUpdateFailed>());
      });
    });

    test('la recomendada ya descartada (misma versión) no se repite', () async {
      final result = await build(installed: '1.0.0', decision: buildDecision(), ignored: '2.0.0').execute();
      expect(result, isA<UpdateNotRequired>());
    });

    test('haber descartado una versión posterior también la suprime (rollback remoto)', () async {
      final result = await build(installed: '1.0.0', decision: buildDecision(), ignored: '2.5.0').execute();
      expect(result, isA<UpdateNotRequired>());
    });

    test('una versión descartada anterior no suprime la nueva recomendada', () async {
      final result = await build(installed: '1.0.0', decision: buildDecision(published: '2.1.0'), ignored: '2.0.0').execute();
      expect(result, isA<UpdateAvailable>());
    });

    test('la versión descartada nunca suprime una forzada', () async {
      final result = await build(installed: '1.0.0', decision: buildDecision(policy: UpdatePolicy.forced), ignored: '2.0.0').execute();
      expect((result as UpdateAvailable).info.isForced, isTrue);
    });

    test('fallo del servidor de versiones → Failed con la causa', () async {
      final result = await build(installed: '1.0.0', decisionError: const FormatException('roto')).execute();
      expect(result, isA<CheckAppUpdateFailed>());
      expect((result as CheckAppUpdateFailed).cause, isA<FormatException>());
    });

    test('fallo al leer la versión instalada → Failed', () async {
      final result = await build(installed: '1.0.0', decision: buildDecision(), installedError: Exception('sin package info')).execute();
      expect(result, isA<CheckAppUpdateFailed>());
    });
  });
}
