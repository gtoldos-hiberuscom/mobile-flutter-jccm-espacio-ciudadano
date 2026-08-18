import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_contact_content.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone el texto visible como encabezado de nivel dos', (final tester) async {
    await tester.pumpWidget(buildApp(const AppSectionHeading('Preguntas frecuentes')));

    final heading = find.semantics.byLabel('Preguntas frecuentes').evaluate().single;
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 2);
  });

  testWidgets('permite configurar el nivel dentro de la jerarquía de la pantalla', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const Column(
          children: [
            AppSectionHeading('Ayuda', headingLevel: 1),
            AppSectionHeading('Canales de contacto', headingLevel: 3),
          ],
        ),
      ),
    );

    expect(find.semantics.byLabel('Ayuda').evaluate().single.headingLevel, 1);
    expect(find.semantics.byLabel('Canales de contacto').evaluate().single.headingLevel, 3);
  });

  testWidgets('no expone acciones ni roles interactivos', (final tester) async {
    await tester.pumpWidget(buildApp(const AppSectionHeading('Guías de ayuda')));

    final data = find.semantics.byLabel('Guías de ayuda').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.actions, 0);
  });

  testWidgets('crece con texto al 200 por ciento en una pantalla de 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppSectionHeading('Información y canales de contacto disponibles para la ciudadanía'),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(Text)).height, greaterThan(48));
  });
}
