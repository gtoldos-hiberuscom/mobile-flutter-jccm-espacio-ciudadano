import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/app/app_lifecycle_provider.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_decision.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/controllers/app_update_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_repository_providers.dart';

import 'support/app_update_fakes.dart';

void main() {
  late FakeAppUpdateRepository decisions;
  late FakeInstalledVersionRepository installed;
  late FakeAppUpdatePreferencesRepository preferences;
  late FakeAppStoreLauncher launcher;
  late StreamController<void> resumed;

  setUp(() {
    decisions = FakeAppUpdateRepository(decision: buildDecision());
    installed = FakeInstalledVersionRepository(const AppVersion(1, 0, 0));
    preferences = FakeAppUpdatePreferencesRepository();
    launcher = FakeAppStoreLauncher();
    resumed = StreamController<void>.broadcast();
    addTearDown(resumed.close);
  });

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        appUpdateStorePlatformProvider.overrideWithValue(StorePlatform.ios),
        appUpdateRepositoryProvider.overrideWithValue(decisions),
        installedVersionRepositoryProvider.overrideWithValue(installed),
        appUpdatePreferencesRepositoryProvider.overrideWithValue(preferences),
        appStoreLauncherProvider.overrideWithValue(launcher),
        appResumedFromBackgroundProvider.overrideWithValue(resumed.stream),
      ],
    );
    addTearDown(container.dispose);
    // Mantener el provider vivo durante el test, como hace el gate en la app.
    container.listen(appUpdateProvider, (final _, final _) {});
    return container;
  }

  Future<void> resume() async {
    resumed.add(null);
    await pumpEventQueue();
  }

  group('AppUpdateNotifier', () {
    test('arranca oculto y muestra la recomendada tras la primera comprobación', () async {
      final container = buildContainer();
      expect(container.read(appUpdateProvider), isA<AppUpdateHidden>());

      await pumpEventQueue();

      final state = container.read(appUpdateProvider);
      expect(state, isA<AppUpdateVisible>());
      expect((state as AppUpdateVisible).info.policy, UpdatePolicy.recommended);
      expect(decisions.calls, 1);
    });

    test('sin nada que avisar se queda oculto', () async {
      decisions.decision = const AppUpdateDecision.none();
      final container = buildContainer();
      await pumpEventQueue();
      expect(container.read(appUpdateProvider), isA<AppUpdateHidden>());
    });

    test('volver de segundo plano vuelve a comprobar', () async {
      final container = buildContainer();
      await pumpEventQueue();
      expect(decisions.calls, 1);

      await resume();

      expect(decisions.calls, 2);
      expect(container.read(appUpdateProvider), isA<AppUpdateVisible>());
    });

    test('las comprobaciones solapadas se descartan', () async {
      decisions.gate = Completer<void>();
      final container = buildContainer();
      await pumpEventQueue();
      expect(decisions.calls, 1);

      resumed
        ..add(null)
        ..add(null);
      await pumpEventQueue();
      expect(decisions.calls, 1);

      decisions.gate!.complete();
      await pumpEventQueue();
      expect(container.read(appUpdateProvider), isA<AppUpdateVisible>());
      expect(decisions.calls, 1);
    });

    test('un fallo no cambia el estado: oculto sigue oculto (fail-open)', () async {
      decisions.error = const FormatException('respuesta rota');
      final container = buildContainer();
      await pumpEventQueue();
      expect(container.read(appUpdateProvider), isA<AppUpdateHidden>());
    });

    test('un fallo no cambia el estado: una forzada visible sigue visible', () async {
      decisions.decision = buildDecision(policy: UpdatePolicy.forced);
      final container = buildContainer();
      await pumpEventQueue();
      expect((container.read(appUpdateProvider) as AppUpdateVisible).info.isForced, isTrue);

      decisions.error = const FormatException('transporte caído');
      await resume();

      expect((container.read(appUpdateProvider) as AppUpdateVisible).info.isForced, isTrue);
    });

    test('«Ahora no» oculta la recomendada y guarda la versión', () async {
      final container = buildContainer();
      await pumpEventQueue();

      await container.read(appUpdateProvider.notifier).dismiss();

      expect(container.read(appUpdateProvider), isA<AppUpdateHidden>());
      expect(preferences.saved, [const AppVersion(2, 0, 0)]);
    });

    test('la recomendada descartada no reaparece al volver de segundo plano', () async {
      final container = buildContainer();
      await pumpEventQueue();
      await container.read(appUpdateProvider.notifier).dismiss();

      await resume();

      expect(container.read(appUpdateProvider), isA<AppUpdateHidden>());
    });

    test('aunque falle la persistencia, en esta sesión no se repite la misma versión', () async {
      preferences.saveError = Exception('storage roto');
      final container = buildContainer();
      await pumpEventQueue();
      await container.read(appUpdateProvider.notifier).dismiss();
      expect(container.read(appUpdateProvider), isA<AppUpdateHidden>());

      await resume();

      expect(container.read(appUpdateProvider), isA<AppUpdateHidden>());
    });

    test('una versión más nueva que la descartada vuelve a avisar', () async {
      final container = buildContainer();
      await pumpEventQueue();
      await container.read(appUpdateProvider.notifier).dismiss();

      decisions.decision = buildDecision(published: '2.1.0');
      await resume();

      final state = container.read(appUpdateProvider);
      expect(state, isA<AppUpdateVisible>());
      expect((state as AppUpdateVisible).info.latestVersion, const AppVersion(2, 1, 0));
    });

    test('una forzada ignora «Ahora no»', () async {
      decisions.decision = buildDecision(policy: UpdatePolicy.forced);
      final container = buildContainer();
      await pumpEventQueue();

      await container.read(appUpdateProvider.notifier).dismiss();

      expect(container.read(appUpdateProvider), isA<AppUpdateVisible>());
      expect(preferences.saved, isEmpty);
    });

    test('«Actualizar» abre la tienda y deja el aviso en pantalla', () async {
      final container = buildContainer();
      await pumpEventQueue();

      await container.read(appUpdateProvider.notifier).openStore();

      expect(launcher.opened, 1);
      final state = container.read(appUpdateProvider) as AppUpdateVisible;
      expect(state.storeOpenFailed, isFalse);
    });

    test('si la tienda no se abre, el aviso lo enseña y se limpia al conseguirlo', () async {
      launcher.result = false;
      final container = buildContainer();
      await pumpEventQueue();

      await container.read(appUpdateProvider.notifier).openStore();
      expect((container.read(appUpdateProvider) as AppUpdateVisible).storeOpenFailed, isTrue);

      launcher.result = true;
      await container.read(appUpdateProvider.notifier).openStore();
      expect((container.read(appUpdateProvider) as AppUpdateVisible).storeOpenFailed, isFalse);
    });

    test('si abrir la tienda lanza, el aviso enseña el error en vez de propagarlo', () async {
      launcher.error = const FormatException('APP_STORE_ID inválido');
      final container = buildContainer();
      await pumpEventQueue();

      await container.read(appUpdateProvider.notifier).openStore();

      expect((container.read(appUpdateProvider) as AppUpdateVisible).storeOpenFailed, isTrue);
    });

    test('si el remoto deja de pedir actualización, el aviso se retira', () async {
      final container = buildContainer();
      await pumpEventQueue();
      expect(container.read(appUpdateProvider), isA<AppUpdateVisible>());

      decisions.decision = const AppUpdateDecision.none();
      await resume();

      expect(container.read(appUpdateProvider), isA<AppUpdateHidden>());
    });
  });
}
