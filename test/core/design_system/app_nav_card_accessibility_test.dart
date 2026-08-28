import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';

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

  testWidgets('es una única parada con nombre, rol y acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppNavCard(
          label: 'Cita previa',
          description: 'Solicita una cita presencial',
          icon: Icons.calendar_today_outlined,
          onTap: () => taps++,
        ),
      ),
    );

    final node = find.semantics.byLabel('Cita previa. Solicita una cita presencial').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('Cita previa'), findsNothing);

    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavCard(
          label: 'DGT',
          semanticLabel: 'Dirección General de Tráfico',
          icon: Icons.directions_car_outlined,
          onTap: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Dirección General de Tráfico'), findsOneWidget);
    expect(find.semantics.byLabel('DGT'), findsNothing);
  });

  testWidgets('sin acción queda deshabilitada y no expone pulsación', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppNavCard(
          label: 'Servicio no disponible',
          icon: Icons.info_outline,
          onTap: null,
        ),
      ),
    );

    final data = tester.getSemantics(find.byType(AppNavCard)).getSemanticsData();
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('la tarjeta completa supera el objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavCard(
          label: 'Educación',
          icon: Icons.school_outlined,
          onTap: () {},
        ),
      ),
    );

    final size = tester.getSize(find.byType(InkWell));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('no trunca ni desborda a 320 dp con texto al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'Prestaciones y servicios de bienestar social';
    const description = 'Consulta toda la información disponible y los trámites relacionados.';
    await tester.pumpWidget(
      buildApp(
        AppNavCard(
          label: label,
          description: description,
          icon: Icons.people_outline,
          onTap: () {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(description)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
