import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_segmented_control.dart';

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

  testWidgets('cada opción expone nombre, selección y acción', (final tester) async {
    var selected = -1;
    await tester.pumpWidget(
      buildApp(
        AppSegmentedControl(
          segments: const ['Viviendas', 'Parcelas'],
          selectedIndex: 0,
          onSelected: (final index) => selected = index,
        ),
      ),
    );

    final first = find.semantics.byLabel('Viviendas').evaluate().single;
    final second = find.semantics.byLabel('Parcelas').evaluate().single;
    expect(first.getSemanticsData().flagsCollection.isSelected, Tristate.isTrue);
    expect(second.getSemanticsData().flagsCollection.isSelected, Tristate.isFalse);
    expect(second.getSemanticsData().flagsCollection.isButton, isTrue);
    expect(second.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    second.owner!.performAction(second.id, SemanticsAction.tap);
    await tester.pump();
    expect(selected, 1);
  });

  testWidgets('una opción deshabilitada conserva el rol sin acción', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppSegmentedControl(
          segments: const ['Disponibles', 'Archivadas'],
          selectedIndex: 0,
          enabledSegments: const [true, false],
          onSelected: (_) {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Archivadas').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('admite nombres alternativos y nombre para el grupo', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppSegmentedControl(
          semanticLabel: 'Tipo de inmueble',
          segments: const ['VV.', 'PR.'],
          semanticLabels: const ['Viviendas', 'Parcelas'],
          selectedIndex: 0,
          onSelected: (_) {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Tipo de inmueble'), findsOneWidget);
    expect(find.semantics.byLabel('Viviendas'), findsOneWidget);
    expect(find.semantics.byLabel('Parcelas'), findsOneWidget);
    expect(find.semantics.byLabel('VV.'), findsNothing);
  });

  testWidgets('cada opción conserva un objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppSegmentedControl(
          segments: const ['Uno', 'Dos'],
          selectedIndex: 0,
          onSelected: (_) {},
        ),
      ),
    );

    for (final element in find.byType(InkWell).evaluate()) {
      expect(tester.getSize(find.byWidget(element.widget)).height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('se desplaza y no trunca opciones al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const labels = ['Viviendas habituales', 'Bienes inmuebles arrendados', 'Parcelas rústicas'];
    await tester.pumpWidget(
      buildApp(
        AppSegmentedControl(
          segments: labels,
          selectedIndex: 0,
          onSelected: (_) {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    for (final label in labels) {
      expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
    }
    expect(tester.takeException(), isNull);
  });
}
