import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/app/app_lifecycle_provider.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/providers/app_update_repository_providers.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/widgets/app_update_dialog.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/widgets/app_update_gate.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

import 'support/app_update_fakes.dart';

const _pageButtonLabel = 'Pulsar';

void main() {
  late FakeAppUpdateRepository manifests;
  late FakeInstalledVersionRepository installed;
  late FakeAppUpdatePreferencesRepository preferences;
  late FakeAppStoreLauncher launcher;
  late int pagePresses;

  setUp(() {
    manifests = FakeAppUpdateRepository(manifest: buildManifest());
    installed = FakeInstalledVersionRepository(const AppVersion(1, 0, 0));
    preferences = FakeAppUpdatePreferencesRepository();
    launcher = FakeAppStoreLauncher();
    pagePresses = 0;
  });

  Future<void> pumpApp(final WidgetTester tester) async {
    // Mismo montaje que `App`: el gate va en `builder:` por encima del router.
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (final context, final state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => pagePresses++,
                child: const Text(_pageButtonLabel),
              ),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appUpdateStorePlatformProvider.overrideWithValue(StorePlatform.ios),
          appUpdateRepositoryProvider.overrideWithValue(manifests),
          installedVersionRepositoryProvider.overrideWithValue(installed),
          appUpdatePreferencesRepositoryProvider.overrideWithValue(preferences),
          appStoreLauncherProvider.overrideWithValue(launcher),
          appResumedFromBackgroundProvider.overrideWithValue(const Stream<void>.empty()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (final context, final child) => AppUpdateGate(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pressBack(final WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }

  group('AppUpdateGate', () {
    testWidgets('sin aviso, la página se usa con normalidad', (final tester) async {
      // El handle se libera a mano: la verificación de fin de test corre antes
      // que los `addTearDown`.
      final semantics = tester.ensureSemantics();
      installed.version = const AppVersion(2, 0, 0);
      await pumpApp(tester);

      expect(find.byType(AppUpdateDialog), findsNothing);
      expect(find.semantics.byLabel(_pageButtonLabel), findsOne);
      await tester.tap(find.text(_pageButtonLabel));
      expect(pagePresses, 1);
      semantics.dispose();
    });

    testWidgets('forzada: aviso sin «Ahora no», lo de debajo no responde y atrás no la cierra', (final tester) async {
      installed.version = const AppVersion(0, 5, 0);
      await pumpApp(tester);

      expect(find.text('Actualización necesaria'), findsOneWidget);
      expect(find.text('Actualizar'), findsOneWidget);
      expect(find.text('Ahora no'), findsNothing);

      await tester.tap(find.text(_pageButtonLabel), warnIfMissed: false);
      await tester.pump();
      expect(pagePresses, 0);

      await pressBack(tester);
      expect(find.text('Actualización necesaria'), findsOneWidget);
    });

    testWidgets('mientras hay aviso, la página queda fuera del árbol de semántica', (final tester) async {
      final semantics = tester.ensureSemantics();
      installed.version = const AppVersion(0, 5, 0);
      await pumpApp(tester);

      // `find.semantics` recorre el árbol de semántica vivo; `bySemanticsLabel`
      // lee el nodo cacheado en cada render object y vería el botón excluido.
      expect(find.semantics.byLabel(_pageButtonLabel), findsNothing);
      expect(find.semantics.byLabel('Aviso de actualización de la aplicación'), findsOne);
      semantics.dispose();
    });

    testWidgets('recomendada: «Ahora no» cierra el aviso y recuerda la versión', (final tester) async {
      await pumpApp(tester);

      expect(find.text('Hay una nueva versión disponible'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsOneWidget);

      await tester.tap(find.text('Ahora no'));
      await tester.pumpAndSettle();

      expect(find.text('Hay una nueva versión disponible'), findsNothing);
      expect(preferences.saved, [const AppVersion(2, 0, 0)]);
      await tester.tap(find.text(_pageButtonLabel));
      expect(pagePresses, 1);
    });

    testWidgets('recomendada: el botón atrás equivale a «Ahora no»', (final tester) async {
      await pumpApp(tester);
      expect(find.text('Hay una nueva versión disponible'), findsOneWidget);

      await pressBack(tester);

      expect(find.text('Hay una nueva versión disponible'), findsNothing);
      expect(preferences.saved, [const AppVersion(2, 0, 0)]);
    });

    testWidgets('«Actualizar» abre la tienda y el aviso se queda', (final tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Actualizar'));
      await tester.pumpAndSettle();

      expect(launcher.opened, [playStoreUrl]);
      expect(find.text('Hay una nueva versión disponible'), findsOneWidget);
      expect(find.text('No se ha podido abrir la tienda de aplicaciones. Inténtalo de nuevo más tarde.'), findsNothing);
    });

    testWidgets('si la tienda no se abre, el aviso enseña el error', (final tester) async {
      launcher.result = false;
      await pumpApp(tester);

      await tester.tap(find.text('Actualizar'));
      await tester.pumpAndSettle();

      expect(find.text('No se ha podido abrir la tienda de aplicaciones. Inténtalo de nuevo más tarde.'), findsOneWidget);
    });

    testWidgets('con política none no se muestra nada', (final tester) async {
      manifests.manifest = buildManifest(policy: UpdatePolicy.none);
      await pumpApp(tester);
      expect(find.byType(AppUpdateDialog), findsNothing);
    });
  });
}
