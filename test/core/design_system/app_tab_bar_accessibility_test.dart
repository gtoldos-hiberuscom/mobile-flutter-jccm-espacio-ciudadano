import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';

void main() {
  Widget buildApp(
    final AppTabBar tabBar, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: DefaultTabController(
      length: tabBar.tabs.length,
      child: Scaffold(
        appBar: tabBar,
        body: const TabBarView(children: [Text('Contenido uno'), Text('Contenido dos')]),
      ),
    ),
  );

  const basicTabs = [AppTabItem(label: 'Información'), AppTabItem(label: 'Servicios')];

  testWidgets('anuncia selección y acción de cada pestaña', (final tester) async {
    await tester.pumpWidget(buildApp(const AppTabBar(tabs: basicTabs)));

    final first = tester.getSemantics(find.text('Información')).getSemanticsData();
    final second = tester.getSemantics(find.text('Servicios')).getSemanticsData();
    expect(first.flagsCollection.isSelected, Tristate.isTrue);
    expect(second.flagsCollection.isSelected, Tristate.isFalse);
    expect(second.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.text('Servicios'));
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.text('Servicios')).flagsCollection.isSelected,
      Tristate.isTrue,
    );
  });

  testWidgets('permite una pronunciación alternativa sin duplicar el icono', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const AppTabBar(
          tabs: [
            AppTabItem(
              label: 'DGT',
              semanticsLabel: 'Dirección General de Tráfico',
              icon: Icons.directions_car_outlined,
            ),
            AppTabItem(label: 'Educación', icon: Icons.school_outlined),
          ],
        ),
      ),
    );

    final data = tester.getSemantics(find.text('DGT')).getSemanticsData();
    expect(data.label, contains('Dirección General de Tráfico'));
    expect(data.label, isNot(contains('DGT')));
  });

  testWidgets('usa 72 dp cuando las pestañas contienen iconos', (final tester) async {
    const bar = AppTabBar(
      tabs: [
        AppTabItem(label: 'Uno', icon: Icons.looks_one_outlined),
        AppTabItem(label: 'Dos', icon: Icons.looks_two_outlined),
      ],
    );
    await tester.pumpWidget(buildApp(bar));

    expect(bar.preferredSize.height, 72);
    expect(tester.getSize(find.byType(Tab).first).height, greaterThanOrEqualTo(48));
  });

  testWidgets('se vuelve desplazable al 200 por ciento sin truncar', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const firstLabel = 'Información y servicios disponibles';
    const secondLabel = 'Gestiones y trámites relacionados';
    await tester.pumpWidget(
      buildApp(
        const AppTabBar(
          tabs: [
            AppTabItem(label: firstLabel),
            AppTabItem(label: secondLabel),
          ],
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isTrue);
    expect(tester.widget<Text>(find.text(firstLabel)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(secondLabel)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
