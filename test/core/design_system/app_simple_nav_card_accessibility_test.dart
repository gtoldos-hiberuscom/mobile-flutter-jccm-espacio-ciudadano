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
        AppSimpleNavCard(
          label: 'Mis trámites',
          description: 'Consulta el estado de tus solicitudes',
          onTap: () => taps++,
        ),
      ),
    );

    final node = find.semantics.byLabel('Mis trámites. Consulta el estado de tus solicitudes').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('Mis trámites'), findsNothing);

    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppSimpleNavCard(
          label: 'DGT',
          description: 'Consulta tus vehículos',
          semanticLabel: 'Dirección General de Tráfico. Consulta tus vehículos',
          onTap: () {},
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Dirección General de Tráfico. Consulta tus vehículos'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('DGT'), findsNothing);
  });

  testWidgets('sin acción queda deshabilitada y no expone pulsación', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppSimpleNavCard(
          label: 'Servicio no disponible',
          description: 'Vuelve a intentarlo más tarde',
          onTap: null,
        ),
      ),
    );

    final data = tester.getSemantics(find.byType(AppSimpleNavCard)).getSemanticsData();
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('la tarjeta completa supera el objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppSimpleNavCard(
          label: 'Educación',
          description: 'Información académica',
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
        AppSimpleNavCard(
          label: label,
          description: description,
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
