import 'dart:ui' show SemanticsAction, SemanticsRole, Tristate;

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
    home: Scaffold(body: child),
  );

  testWidgets('expone nombre, selección, estado y acción por pestaña', (final tester) async {
    var selected = -1;
    await tester.pumpWidget(
      buildApp(
        AppFloatingNavigation(
          tabs: const ['Pendientes', 'Leídas'],
          selectedIndex: 0,
          onTabSelected: (final index) => selected = index,
        ),
      ),
    );

    final first = find.semantics.byLabel('Pendientes').evaluate().single;
    final second = find.semantics.byLabel('Leídas').evaluate().single;
    expect(first.getSemanticsData().role, SemanticsRole.tab);
    expect(first.parent!.getSemanticsData().role, SemanticsRole.tabBar);
    expect(first.getSemanticsData().value, 'Tab 1 of 2');
    expect(second.getSemanticsData().value, 'Tab 2 of 2');
    expect(first.getSemanticsData().flagsCollection.isSelected, Tristate.isTrue);
    expect(second.getSemanticsData().flagsCollection.isSelected, Tristate.isFalse);
    expect(second.getSemanticsData().flagsCollection.isButton, isFalse);
    expect(second.getSemanticsData().flagsCollection.isInMutuallyExclusiveGroup, isTrue);
    expect(second.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    second.owner!.performAction(second.id, SemanticsAction.tap);
    await tester.pump();
    expect(selected, 1);
  });

  testWidgets('una pestaña deshabilitada no expone acción', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFloatingNavigation(
          tabs: const ['Activas', 'Expiradas'],
          selectedIndex: 0,
          enabledTabs: const [true, false],
          onTabSelected: (_) {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Expiradas').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('cada pestaña conserva un objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFloatingNavigation(
          tabs: const ['Hoy', 'Próximas'],
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
      ),
    );

    for (final element in find.byType(InkWell).evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('permite desplazamiento horizontal y no trunca al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const labels = ['Notificaciones pendientes', 'Notificaciones aceptadas', 'Expiradas'];
    await tester.pumpWidget(
      buildApp(
        AppFloatingNavigation(
          tabs: labels,
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    for (final label in labels) {
      expect(tester.widget<Text>(find.text(label)).maxLines, 1);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('mantiene las etiquetas en una línea en el modo desplazable', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        AppFloatingNavigation(
          tabs: const ['Todos', 'Últimos días', 'Novedades'],
          selectedIndex: 0,
          minTabWidths: const [76, 150, 150],
          scrollable: true,
          onTabSelected: (_) {},
        ),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    for (final label in ['Todos', 'Últimos días', 'Novedades']) {
      final text = tester.widget<Text>(find.text(label));
      expect(text.maxLines, 1);
      expect(text.softWrap, isFalse);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('admite que ninguna pestaña visible esté seleccionada', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        AppFloatingNavigation(
          tabs: const ['Novedades', 'Inmediatos'],
          selectedIndex: -1,
          onTabSelected: (_) {},
        ),
      ),
    );

    for (final label in ['Novedades', 'Inmediatos']) {
      final data = find.semantics.byLabel(label).evaluate().single.getSemanticsData();
      expect(data.flagsCollection.isSelected, isNot(Tristate.isTrue));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza listas y selecciones inválidas', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFloatingNavigation(
          tabs: const [],
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
      ),
    );

    expect(tester.takeException(), isAssertionError);
  });
}
