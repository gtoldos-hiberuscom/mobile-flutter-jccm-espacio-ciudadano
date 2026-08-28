import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_preference_cards.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  testWidgets('expone una única parada con rol, estado y acción', (final tester) async {
    var presses = 0;
    await tester.pumpWidget(
      buildApp(
        AppPreferenceActionButton(
          label: 'Editar datos',
          icon: Icons.edit,
          onPressed: () => presses++,
        ),
      ),
    );

    final node = find.semantics.byLabel('Editar datos').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('sin acción conserva el rol y se anuncia deshabilitado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceActionButton(
          label: 'Acción no disponible',
          icon: Icons.block,
          onPressed: null,
        ),
      ),
    );

    final data = find.semantics.byLabel('Acción no disponible').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppPreferenceActionButton(
          label: 'DGT',
          semanticLabel: 'Editar datos de la Dirección General de Tráfico',
          icon: Icons.edit,
          onPressed: () {},
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Editar datos de la Dirección General de Tráfico'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('DGT'), findsNothing);
  });

  testWidgets('mantiene un objetivo táctil mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppPreferenceActionButton(label: 'Editar', icon: Icons.edit, onPressed: () {}),
      ),
    );

    final size = tester.getSize(find.byType(InkWell));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('no trunca ni desborda al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'Gestionar los medios de contacto para notificaciones';
    await tester.pumpWidget(
      buildApp(
        AppPreferenceActionButton(
          label: label,
          icon: Icons.edit,
          onPressed: () {},
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
