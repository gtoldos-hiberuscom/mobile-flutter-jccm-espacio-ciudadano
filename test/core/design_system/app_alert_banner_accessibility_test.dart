import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('anuncia tipo y mensaje mediante una etiqueta unificada', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertBanner(
          severity: AppAlertSeverity.warning,
          message: 'Comprueba tu conexión a internet',
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Advertencia: Comprueba tu conexión a internet').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('marca el título como encabezado de nivel dos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertBanner(
          title: 'Conexión perdida',
          message: 'Comprueba la red',
        ),
      ),
    );

    final heading = tester.getSemantics(find.text('CONEXIÓN PERDIDA'));
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 2);
  });

  testWidgets('el cierre tiene nombre, acción y 48 dp', (final tester) async {
    var dismisses = 0;
    await tester.pumpWidget(
      buildApp(
        AppAlertBanner(
          message: 'Mensaje',
          onDismiss: () => dismisses++,
        ),
      ),
    );

    final close = find.semantics.byLabel('Cerrar');
    expect(close.evaluate().single.flagsCollection.isButton, isTrue);
    expect(close.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(tester.getSize(find.byType(InkWell)), const Size(48, 48));
    tester.semantics.tap(close);
    await tester.pump();
    expect(dismisses, 1);
  });

  testWidgets('mantiene una acción adicional como control independiente', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppAlertBanner(
          message: 'No hay conexión',
          action: AppButton(label: 'Reintentar', onPressed: () {}),
        ),
      ),
    );

    expect(find.semantics.byLabel('Reintentar'), findsOneWidget);
  });

  testWidgets('permite desactivar anuncios y personalizar etiquetas', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertBanner(
          message: 'Cambios pendientes',
          semanticsLabel: 'Aviso: hay cambios sin guardar',
          announce: false,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Aviso: hay cambios sin guardar').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('admite texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppAlertBanner(
            title: 'No se ha podido completar la operación',
            message: 'Comprueba tu conexión e inténtalo de nuevo dentro de unos minutos',
            onDismiss: () {},
            action: AppButton(label: 'Volver a intentarlo', onPressed: () {}),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
