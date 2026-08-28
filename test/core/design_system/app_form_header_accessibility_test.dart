import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_form_header.dart';

void main() {
  Widget buildApp(final Widget child, {final TextScaler textScaler = TextScaler.noScaling}) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone el título como encabezado de nivel dos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppFormHeader(
          title: 'Datos personales',
          description: 'Completa la información solicitada.',
        ),
      ),
    );

    final heading = find.semantics.byLabel('Datos personales').evaluate().single;
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 2);
    expect(heading.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('permite declarar otro nivel estructural', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppFormHeader(
          title: 'Dirección postal',
          description: 'Indica tu domicilio habitual.',
          headingLevel: 3,
        ),
      ),
    );

    expect(find.semantics.byLabel('Dirección postal').evaluate().single.headingLevel, 3);
  });

  testWidgets('admite un nombre accesible sin duplicar el título visible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppFormHeader(
          title: 'Datos IRPF',
          titleSemanticsLabel: 'Datos del impuesto sobre la renta',
          description: 'Introduce los datos fiscales.',
        ),
      ),
    );

    expect(find.text('Datos IRPF'), findsOneWidget);
    expect(find.semantics.byLabel('Datos del impuesto sobre la renta'), findsOneWidget);
    expect(find.semantics.byLabel('Datos IRPF'), findsNothing);
    expect(find.semantics.byLabel('Introduce los datos fiscales.'), findsOneWidget);
  });

  testWidgets('no trunca ni desborda a 320 dp con texto al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const title = 'Información de la persona representante';
    const description = 'Completa todos los datos necesarios para continuar con la presentación de la solicitud.';
    await tester.pumpWidget(
      buildApp(
        const AppFormHeader(title: title, description: description),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(title)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(description)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
