import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_icon_navigation_card.dart';

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
        AppIconNavigationCard(
          title: 'Vivienda',
          description: 'Consulta tus inmuebles y ayudas',
          icon: Icons.home_outlined,
          onTap: () => taps++,
        ),
      ),
    );

    final card = find.semantics.byLabel('Vivienda. Consulta tus inmuebles y ayudas').evaluate().single;
    final data = card.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('Vivienda'), findsNothing);

    card.owner!.performAction(card.id, SemanticsAction.tap);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppIconNavigationCard(
          title: 'DGT',
          description: 'Consulta tus vehículos',
          semanticLabel: 'Dirección General de Tráfico. Consulta tus vehículos',
          icon: Icons.directions_car_outlined,
          onTap: () {},
        ),
      ),
    );

    expect(
      find.semantics.byLabel(
        'Dirección General de Tráfico. Consulta tus vehículos',
      ),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('DGT'), findsNothing);
  });

  testWidgets('la tarjeta completa mantiene un objetivo mayor de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppIconNavigationCard(
          title: 'Educación',
          description: 'Información académica',
          icon: Icons.school_outlined,
          onTap: () {},
        ),
      ),
    );

    final target = find.byType(InkWell);
    expect(tester.getSize(target).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(target).height, greaterThanOrEqualTo(48));
  });

  testWidgets('no trunca ni desborda a 320 dp con texto al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const title = 'Prestaciones y servicios de bienestar social';
    const description = 'Consulta toda la información disponible y accede a los trámites relacionados.';
    await tester.pumpWidget(
      buildApp(
        AppIconNavigationCard(
          title: title,
          description: description,
          icon: Icons.people_outline,
          onTap: () {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(title)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(description)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
