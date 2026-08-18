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
    home: Scaffold(bottomNavigationBar: child),
  );

  const items = [
    AppBottomTabBarItem(label: 'Inicio', icon: Icons.home_outlined),
    AppBottomTabBarItem(label: 'Gestión', icon: Icons.folder_outlined),
  ];

  testWidgets('cada destino expone nombre, selección y acción', (final tester) async {
    var selected = -1;
    await tester.pumpWidget(
      buildApp(
        AppBottomTabBar(
          items: items,
          currentIndex: 0,
          onTap: (final index) => selected = index,
        ),
      ),
    );

    final first = find.semantics.byLabel('Inicio').evaluate().single;
    final second = find.semantics.byLabel('Gestión').evaluate().single;
    expect(first.getSemanticsData().flagsCollection.isSelected, Tristate.isTrue);
    expect(second.getSemanticsData().flagsCollection.isSelected, Tristate.isFalse);
    expect(second.getSemanticsData().flagsCollection.isButton, isTrue);
    expect(second.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    second.owner!.performAction(second.id, SemanticsAction.tap);
    await tester.pump();
    expect(selected, 1);
  });

  testWidgets('permite una pronunciación alternativa', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppBottomTabBar(
          items: const [
            AppBottomTabBarItem(
              label: 'DGT',
              semanticLabel: 'Dirección General de Tráfico',
              icon: Icons.directions_car_outlined,
            ),
          ],
          currentIndex: 0,
          onTap: (_) {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Dirección General de Tráfico'), findsOneWidget);
    expect(find.semantics.byLabel('DGT'), findsNothing);
  });

  testWidgets('cada destino conserva un objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppBottomTabBar(items: items, currentIndex: 0, onTap: (_) {})),
    );

    for (final element in find.byType(InkWell).evaluate()) {
      expect(tester.getSize(find.byWidget(element.widget)).height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('usa desplazamiento horizontal y no trunca al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const scaledItems = [
      AppBottomTabBarItem(label: 'Inicio', icon: Icons.home_outlined),
      AppBottomTabBarItem(label: 'Mis gestiones', icon: Icons.folder_outlined),
      AppBottomTabBarItem(label: 'Recomendados', icon: Icons.star_outline),
    ];
    await tester.pumpWidget(
      buildApp(
        AppBottomTabBar(items: scaledItems, currentIndex: 0, onTap: (_) {}),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    for (final item in scaledItems) {
      expect(tester.widget<Text>(find.text(item.label)).maxLines, isNull);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza una selección fuera de rango', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppBottomTabBar(items: items, currentIndex: 2, onTap: (_) {})),
    );

    expect(tester.takeException(), isAssertionError);
  });
}
