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
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('la variante extendida es un único botón con acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppFab(label: 'Añadir documento', icon: Icons.add, onPressed: () => taps++),
      ),
    );

    final node = find.semantics.byLabel('Añadir documento').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('la variante compacta usa su nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFab(
          semanticsLabel: 'Crear nueva solicitud',
          icon: Icons.add,
          onPressed: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Crear nueva solicitud'), findsOneWidget);
  });

  testWidgets('sin acción se anuncia deshabilitado y no permite pulsación', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const AppFab(label: 'Acción no disponible', icon: Icons.block, onPressed: null),
      ),
    );

    final data = tester.getSemantics(find.byType(AppFab)).getSemanticsData();
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('ambas variantes superan el objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppFab(label: 'Añadir', icon: Icons.add, onPressed: () {}),
            AppFab(semanticsLabel: 'Editar', icon: Icons.edit, onPressed: () {}),
          ],
        ),
      ),
    );

    for (final element in find.byType(InkWell).evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('la variante extendida admite texto al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'Mostrar todos los carnés digitales disponibles';
    await tester.pumpWidget(
      buildApp(
        AppFab(label: label, icon: Icons.badge_outlined, onPressed: () {}),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
