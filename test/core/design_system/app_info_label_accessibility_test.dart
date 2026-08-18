import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_info_label.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('une etiqueta y valor en un único dato no interactivo', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppInfoLabel(label: 'Estado', value: 'Activo')),
    );

    final node = find.semantics.byLabel('Estado: Activo').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
    expect(find.semantics.byLabel('ESTADO'), findsNothing);
    expect(find.semantics.byLabel('Activo'), findsNothing);
  });

  testWidgets('admite pronunciación alternativa para etiqueta y valor', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppInfoLabel(
          label: 'NIF',
          value: '12345678A',
          semanticLabel: 'Número de identificación fiscal',
          semanticValue: 'uno dos tres cuatro cinco seis siete ocho A',
        ),
      ),
    );

    expect(
      find.semantics.byLabel(
        'Número de identificación fiscal: uno dos tres cuatro cinco seis siete ocho A',
      ),
      findsOneWidget,
    );
  });

  testWidgets('la lista conserva cada par como nodo independiente', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppInfoLabelList(
          items: [
            AppInfoLabelEntry(label: 'Provincia', value: 'Toledo'),
            AppInfoLabelEntry(label: 'Municipio', value: 'Talavera de la Reina'),
          ],
        ),
      ),
    );

    expect(find.semantics.byLabel('Provincia: Toledo'), findsOneWidget);
    expect(find.semantics.byLabel('Municipio: Talavera de la Reina'), findsOneWidget);
  });

  testWidgets('apila y no desborda a 320 dp con texto al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'Referencia catastral completa';
    const value = '9876543VK4797S0001WX';
    await tester.pumpWidget(
      buildApp(
        const AppInfoLabel(label: label, value: value),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(
      tester.getTopLeft(find.text(value)).dy,
      greaterThan(tester.getTopLeft(find.text(label.toUpperCase())).dy),
    );
    expect(tester.widget<Text>(find.text(value)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
