import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_data_summary_card.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  const entries = [
    AppDataSummaryEntry(label: 'Dirección', value: 'Calle Mayor, 1'),
    AppDataSummaryEntry(label: 'Valor catastral', value: '85.000 euros'),
  ];

  testWidgets('una tarjeta interactiva resume título y pares como un único botón', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppDataSummaryCard(
          title: 'Referencia catastral 123',
          highlightedItems: entries,
          onTap: () => taps++,
        ),
      ),
    );

    final data = find.semantics.byLabel('Referencia catastral 123. Dirección: Calle Mayor, 1. Valor catastral: 85.000 euros').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('Dirección: Calle Mayor, 1'), findsNothing);

    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });

  testWidgets('permite personalizar nombre y pista de la tarjeta interactiva', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppDataSummaryCard(
          title: 'RC 123',
          semanticLabel: 'Abrir inmueble con referencia catastral 123',
          semanticHint: 'Muestra todos los datos del inmueble',
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Abrir inmueble con referencia catastral 123').evaluate().single.getSemanticsData();
    expect(data.hint, 'Muestra todos los datos del inmueble');
  });

  testWidgets('la tarjeta informativa asocia cada etiqueta con su valor', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppDataSummaryCard(title: 'Datos del inmueble', highlightedItems: entries)),
    );

    expect(find.semantics.byLabel('Datos del inmueble'), findsOneWidget);
    expect(find.semantics.byLabel('Dirección: Calle Mayor, 1'), findsOneWidget);
    expect(find.semantics.byLabel('Valor catastral: 85.000 euros'), findsOneWidget);
  });

  testWidgets('permite resumir una tarjeta informativa sin convertirla en botón', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppDataSummaryCard(
          title: 'Datos del inmueble',
          highlightedItems: entries,
          semanticLabel: 'Resumen del inmueble principal',
        ),
      ),
    );

    final data = find.semantics.byLabel('Resumen del inmueble principal').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('garantiza 48 dp para una tarjeta interactiva compacta', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppDataSummaryCard(title: 'Inmueble', onTap: () {})),
    );

    expect(tester.getSize(find.byType(InkWell)).height, greaterThanOrEqualTo(48));
  });

  testWidgets('apila etiquetas y valores con texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppDataSummaryCard(
            title: 'Información detallada del inmueble',
            highlightedItems: entries,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(Column), findsWidgets);
  });
}
