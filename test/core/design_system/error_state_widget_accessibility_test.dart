import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('anuncia tipo, mensaje y detalle en una región activa', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const ErrorStateWidget(
          message: 'No se han podido cargar los expedientes',
          detail: 'Comprueba tu conexión e inténtalo de nuevo',
        ),
      ),
    );

    final semantics = find.semantics
        .byLabel(
          'Error: No se han podido cargar los expedientes. Comprueba tu conexión e inténtalo de nuevo',
        )
        .evaluate()
        .single;
    expect(semantics.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('marca el mensaje visible como encabezado de nivel dos', (final tester) async {
    await tester.pumpWidget(
      buildApp(const ErrorStateWidget(message: 'No se han podido cargar los datos')),
    );

    final heading = tester.getSemantics(find.text('No se han podido cargar los datos'));
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 2);
  });

  testWidgets('mantiene reintentar como una acción independiente', (final tester) async {
    var retries = 0;
    await tester.pumpWidget(
      buildApp(
        ErrorStateWidget(
          message: 'No se han podido cargar los datos',
          onRetry: () => retries++,
        ),
      ),
    );

    final retry = find.semantics.byLabel('Reintentar');
    expect(retry, findsOneWidget);
    expect(retry.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    tester.semantics.tap(retry);
    await tester.pump();
    expect(retries, 1);
  });

  testWidgets('permite desactivar live region para errores ya presentes', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const ErrorStateWidget(
          message: 'Error histórico',
          announce: false,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Error: Error histórico').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('permite una etiqueta accesible específica', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const ErrorStateWidget(
          message: 'Operación fallida',
          semanticsLabel: 'Error al guardar las preferencias',
        ),
      ),
    );

    expect(find.semantics.byLabel('Error al guardar las preferencias'), findsOneWidget);
  });

  testWidgets('admite texto al 200 por ciento en pantalla estrecha', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          ErrorStateWidget(
            message: 'No se ha podido completar la operación solicitada',
            detail: 'Comprueba la conexión y vuelve a intentarlo dentro de unos minutos',
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
