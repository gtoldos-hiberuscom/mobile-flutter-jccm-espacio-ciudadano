import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';

/// Localiza el anillo pintado por [AppFocusRing].
Finder findFocusRing() => find.byWidgetPredicate(
  (final widget) => widget is CustomPaint && widget.foregroundPainter is AppFocusRingPainter,
);

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('pinta el anillo mientras un descendiente tiene el foco y lo retira al perderlo', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFocusRing(
          child: ElevatedButton(onPressed: () {}, child: const Text('Continuar')),
        ),
      ),
    );
    expect(findFocusRing(), findsNothing);

    final node = Focus.of(tester.element(find.text('Continuar')))..requestFocus();
    await tester.pumpAndSettle();
    expect(findFocusRing(), findsOneWidget);

    node.unfocus();
    await tester.pumpAndSettle();
    expect(findFocusRing(), findsNothing);
  });

  testWidgets('no altera el tamaño del control al enfocarlo', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFocusRing(
          child: ElevatedButton(onPressed: () {}, child: const Text('Continuar')),
        ),
      ),
    );
    final before = tester.getRect(find.byType(ElevatedButton));

    Focus.of(tester.element(find.text('Continuar'))).requestFocus();
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byType(ElevatedButton)), before);
  });

  testWidgets('no añade una parada de foco ni un nodo semántico propio', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        Column(
          children: [
            AppFocusRing(
              child: ElevatedButton(onPressed: () {}, child: const Text('Uno')),
            ),
            AppFocusRing(
              child: ElevatedButton(onPressed: () {}, child: const Text('Dos')),
            ),
          ],
        ),
      ),
    );

    Focus.of(tester.element(find.text('Uno'))).requestFocus();
    await tester.pumpAndSettle();
    primaryFocus!.nextFocus();
    await tester.pumpAndSettle();

    expect(Focus.of(tester.element(find.text('Dos'))).hasPrimaryFocus, isTrue);
    expect(find.semantics.byLabel('Uno'), findsOneWidget);
  });

  testWidgets('con trackEnclosingFocus observa el nodo de foco ancestro', (final tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      buildApp(
        Material(
          child: InkWell(
            focusNode: node,
            onTap: () {},
            child: const AppFocusRing(
              trackEnclosingFocus: true,
              child: Padding(padding: EdgeInsets.all(16), child: Text('Pestaña')),
            ),
          ),
        ),
      ),
    );
    expect(findFocusRing(), findsNothing);

    node.requestFocus();
    await tester.pumpAndSettle();
    expect(findFocusRing(), findsOneWidget);

    node.unfocus();
    await tester.pumpAndSettle();
    expect(findFocusRing(), findsNothing);
  });

  testWidgets('deshabilitado no pinta nada aunque haya foco', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFocusRing(
          enabled: false,
          child: ElevatedButton(onPressed: () {}, child: const Text('Continuar')),
        ),
      ),
    );

    Focus.of(tester.element(find.text('Continuar'))).requestFocus();
    await tester.pumpAndSettle();

    expect(findFocusRing(), findsNothing);
  });

  test('usa dos bordes de 2 dp, uno oscuro y otro claro (técnica C40)', () {
    expect(AppFocusRing.strokeWidth, 2);
    expect(AppFocusRing.darkColor.computeLuminance(), lessThan(0.05));
    expect(AppFocusRing.lightColor.computeLuminance(), greaterThan(0.95));
  });
}
