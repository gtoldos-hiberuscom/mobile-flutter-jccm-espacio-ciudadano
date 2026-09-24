import 'dart:ui' show SemanticsAction, SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_top_tab_bar.dart';

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

  testWidgets('cada pestaña expone selección y acción una sola vez', (
    final tester,
  ) async {
    var selected = -1;
    await tester.pumpWidget(
      buildApp(
        AppTopTabBar(
          tabs: const ['Pendientes', 'Finalizadas'],
          selectedIndex: 0,
          onTabSelected: (final index) => selected = index,
        ),
      ),
    );

    final first = find.semantics.byLabel('Pendientes').evaluate().single;
    final second = find.semantics.byLabel('Finalizadas').evaluate().single;
    expect(first.getSemanticsData().role, SemanticsRole.tab);
    expect(first.parent!.getSemanticsData().role, SemanticsRole.tabBar);
    expect(first.getSemanticsData().value, 'Tab 1 of 2');
    expect(first.getSemanticsData().flagsCollection.isSelected, Tristate.isTrue);
    expect(second.getSemanticsData().flagsCollection.isSelected, Tristate.isFalse);
    expect(second.getSemanticsData().flagsCollection.isButton, isFalse);
    expect(second.getSemanticsData().flagsCollection.isInMutuallyExclusiveGroup, isTrue);
    expect(second.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    second.owner!.performAction(second.id, SemanticsAction.tap);
    expect(selected, 1);
  });

  testWidgets('admite nombres pronunciables y un nombre para el grupo', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        AppTopTabBar(
          tabs: const ['IRPF', 'Tasas'],
          semanticLabels: const [
            'Impuesto sobre la renta de las personas físicas',
            'Tasas',
          ],
          semanticLabel: 'Clase de tributo',
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Clase de tributo'), findsOneWidget);
    expect(
      find.semantics.byLabel(
        'Impuesto sobre la renta de las personas físicas',
      ),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('IRPF'), findsNothing);
  });

  testWidgets('cada pestaña conserva un objetivo mínimo de 48 dp', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        AppTopTabBar(
          tabs: const ['Uno', 'Dos'],
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
      ),
    );

    for (final element in find.byType(InkWell).evaluate()) {
      expect(
        tester.getSize(find.byWidget(element.widget)).height,
        greaterThanOrEqualTo(48),
      );
    }
  });

  testWidgets('usa el fondo neutral light especificado en Figma', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppTopTabBar(
          tabs: const ['Entradas de registro', 'Salidas de registro'],
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
      ),
    );

    final background = tester.widget<DecoratedBox>(
      find.byWidgetPredicate(
        (final widget) => widget is DecoratedBox && widget.decoration is BoxDecoration && (widget.decoration as BoxDecoration).color == AppColors.backgroundBlueMutedLight,
      ),
    );
    expect((background.decoration as BoxDecoration).color, const Color(0xFFE0E5EB));
  });

  testWidgets('crece sin truncar al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const labels = [
      'Notificaciones pendientes de lectura',
      'Notificaciones aceptadas anteriormente',
    ];
    await tester.pumpWidget(
      buildApp(
        AppTopTabBar(
          tabs: labels,
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    for (final label in labels) {
      expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
      expect(tester.getSize(find.text(label)).height, greaterThan(40));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('valida pestañas, selección y nombres accesibles', (
    final tester,
  ) async {
    expect(
      () => AppTopTabBar(
        tabs: const [],
        selectedIndex: 0,
        onTabSelected: (_) {},
      ),
      throwsAssertionError,
    );
    expect(
      () => AppTopTabBar(
        tabs: const ['Uno'],
        selectedIndex: 1,
        onTabSelected: (_) {},
      ),
      throwsAssertionError,
    );
    expect(
      () => AppTopTabBar(
        tabs: const ['Uno', 'Dos'],
        semanticLabels: const ['Primero'],
        selectedIndex: 0,
        onTabSelected: (_) {},
      ),
      throwsAssertionError,
    );
  });
}
