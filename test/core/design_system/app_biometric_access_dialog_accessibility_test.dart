import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Locale locale) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (final context) => TextButton(
          onPressed: () => AppBiometricAccessDialog.show(context),
          child: const Text('Open'),
        ),
      ),
    ),
  );

  testWidgets('abre una ruta modal accesible con textos en español', (final tester) async {
    await tester.pumpWidget(buildApp(const Locale('es')));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final route = find.semantics.byLabel('¿Quieres activar el acceso rápido con huella o reconocimiento facial?').evaluate().first.getSemanticsData();
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.scopesRoute), isTrue);
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.namesRoute), isTrue);
    expect(find.semantics.byLabel('Ahora no'), findsOneWidget);
    expect(find.semantics.byLabel('Activar acceso rápido'), findsOneWidget);
  });

  testWidgets('localiza título, explicación y decisiones en inglés', (final tester) async {
    await tester.pumpWidget(buildApp(const Locale('en')));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(
      find.semantics.byLabel(
        'Would you like to enable quick access with fingerprint or facial recognition?',
      ),
      findsWidgets,
    );
    expect(find.text('This will let you enter the app without signing in again. Authentication will be requested periodically to keep your data protected.'), findsOneWidget);
    expect(find.semantics.byLabel('Not now'), findsOneWidget);
    expect(find.semantics.byLabel('Enable quick access'), findsOneWidget);
  });

  testWidgets('devuelve true al activar el acceso rápido', (final tester) async {
    // El diálogo ha crecido desde que se escribió este test y sus botones
    // caían fuera de la superficie de 800x600 por defecto — fuera, no
    // ocultos: el tap no llegaba a impactar nada.
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (final context) => TextButton(
              onPressed: () async => result = await AppBiometricAccessDialog.show(context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Activar acceso rápido'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.byType(AppAlertDialog), findsNothing);
  });

  testWidgets('devuelve false al elegir ahora no', (final tester) async {
    // El diálogo ha crecido desde que se escribió este test y sus botones
    // caían fuera de la superficie de 800x600 por defecto — fuera, no
    // ocultos: el tap no llegaba a impactar nada.
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (final context) => TextButton(
              onPressed: () async => result = await AppBiometricAccessDialog.show(context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ahora no'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
