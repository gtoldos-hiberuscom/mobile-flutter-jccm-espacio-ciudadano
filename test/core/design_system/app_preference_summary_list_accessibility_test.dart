import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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

  testWidgets('expone cada elemento una sola vez y sin viñetas', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceSummaryList(
          items: ['Nacimiento de un hijo', 'Cambio de domicilio'],
        ),
      ),
    );

    for (final item in ['Nacimiento de un hijo', 'Cambio de domicilio']) {
      final node = find.semantics.byLabel(item);
      expect(node, findsOneWidget);
      expect(node.evaluate().single.getSemanticsData().actions, 0);
    }
  });

  testWidgets('permite identificar la región sin ocultar sus elementos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceSummaryList(
          semanticLabel: 'Hechos vitales seleccionados',
          items: ['Emancipación', 'Jubilación'],
        ),
      ),
    );

    expect(find.semantics.byLabel('Hechos vitales seleccionados'), findsOneWidget);
    expect(find.semantics.byLabel('Emancipación'), findsOneWidget);
    expect(find.semantics.byLabel('Jubilación'), findsOneWidget);
  });

  testWidgets('mantiene el orden semántico de los elementos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceSummaryList(items: ['Primero', 'Segundo', 'Tercero']),
      ),
    );

    for (var index = 0; index < 3; index++) {
      final label = ['Primero', 'Segundo', 'Tercero'][index];
      final node = find.semantics.byLabel(label).evaluate().single;
      expect((node.sortKey! as OrdinalSortKey).order, index);
    }
  });

  testWidgets('no trunca ni desborda al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const item = 'Cambio de residencia habitual y actualización de domicilio';
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceSummaryList(items: [item]),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(item)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza listas y valores vacíos', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppPreferenceSummaryList(items: [])),
    );
    expect(tester.takeException(), isAssertionError);

    await tester.pumpWidget(
      buildApp(const AppPreferenceSummaryList(items: [''])),
    );
    expect(tester.takeException(), isAssertionError);
  });
}
