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
    home: Scaffold(
      body: Center(child: SizedBox(width: 180, height: 220, child: child)),
    ),
  );

  testWidgets('es una única parada con nombre, rol y acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppQuickAccessCard(
          label: 'Educación',
          icon: Icons.school_outlined,
          onTap: () => taps++,
        ),
      ),
    );

    final node = find.semantics.byLabel('Educación').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.byIcon(Icons.school_outlined), findsOneWidget);

    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppQuickAccessCard(
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
        const AppQuickAccessCard(
          label: 'Servicio no disponible',
          icon: Icons.info_outline,
          onTap: null,
        ),
      ),
    );

    final data = tester.getSemantics(find.byType(AppQuickAccessCard)).getSemanticsData();
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('la tarjeta completa supera el objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppQuickAccessCard(
          label: 'Vivienda',
          icon: Icons.home_outlined,
          onTap: () {},
        ),
      ),
    );

    final size = tester.getSize(find.byType(InkWell));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('no trunca el contenido con texto al 200 por ciento', (final tester) async {
    const label = 'Bienestar Social';
    await tester.pumpWidget(
      buildApp(
        AppQuickAccessCard(
          label: label,
          icon: Icons.people_outline,
          onTap: () {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    final text = tester.widget<Text>(find.text(label));
    expect(text.maxLines, isNull);
    expect(text.overflow, isNot(TextOverflow.ellipsis));
    expect(tester.takeException(), isNull);
  });
}
