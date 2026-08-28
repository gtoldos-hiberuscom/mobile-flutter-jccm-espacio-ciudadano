import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation_card.dart';

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
        AppNavigationCard(
          title: 'Mis expedientes',
          description: 'Consulta el estado de tus trámites',
          onTap: () => taps++,
        ),
      ),
    );

    final node = find.semantics.byLabel('Mis expedientes. Consulta el estado de tus trámites').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('Mis expedientes'), findsNothing);

    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavigationCard(
          title: 'DGT',
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

  testWidgets('deshabilitada conserva el rol pero no permite pulsación', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppNavigationCard(
          title: 'Servicio no disponible',
          isDisabled: true,
          onTap: () {},
        ),
      ),
    );

    final data = tester.getSemantics(find.byType(AppNavigationCard)).getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('la tarjeta completa supera el objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppNavigationCard(title: 'Educación', onTap: () {})),
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

    const title = 'Prestaciones y servicios de bienestar social';
    const description = 'Consulta toda la información disponible y los trámites relacionados.';
    await tester.pumpWidget(
      buildApp(
        AppNavigationCard(title: title, description: description, onTap: () {}),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(title)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(description)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
