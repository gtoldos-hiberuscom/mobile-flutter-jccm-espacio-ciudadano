import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('una tarjeta interactiva expone nombre, rol, estado y una única acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppSurfaceCard(
          semanticLabel: 'Abrir ayudas de vivienda',
          semanticHint: 'Muestra el detalle',
          onTap: () => taps++,
          child: const Text('Ayudas de vivienda'),
        ),
      ),
    );

    final data = find.semantics.byLabel('Abrir ayudas de vivienda').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hint, 'Muestra el detalle');
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('Ayudas de vivienda'), findsNothing);

    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });

  testWidgets('una tarjeta informativa conserva la semántica granular de su contenido', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppSurfaceCard(
          child: Column(
            children: [
              Text('Datos personales'),
              Text('Nombre y apellidos'),
            ],
          ),
        ),
      ),
    );

    expect(find.semantics.byLabel('Datos personales'), findsOneWidget);
    expect(find.semantics.byLabel('Nombre y apellidos'), findsOneWidget);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('permite resumir una tarjeta informativa sin anunciarla como botón', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppSurfaceCard(
          semanticLabel: 'Resumen de la solicitud: presentada',
          child: Text('Presentada'),
        ),
      ),
    );

    final data = find.semantics.byLabel('Resumen de la solicitud: presentada').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('garantiza 48 dp para una tarjeta interactiva con contenido pequeño', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppSurfaceCard(
          padding: EdgeInsets.zero,
          semanticLabel: 'Abrir elemento',
          onTap: () {},
          child: const SizedBox(height: 8),
        ),
      ),
    );

    expect(tester.getSize(find.byType(InkWell)).height, greaterThanOrEqualTo(48));
  });

  testWidgets('crece con texto al 200 por ciento en una pantalla estrecha', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppSurfaceCard(
            semanticLabel: 'Abrir información sobre ayudas para rehabilitación de viviendas',
            onTap: () {},
            child: const Text('Información sobre ayudas para rehabilitación de viviendas y mejora de accesibilidad'),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(InkWell)).height, greaterThan(48));
  });
}
