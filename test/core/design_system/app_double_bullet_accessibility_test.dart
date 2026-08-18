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
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('queda explícitamente excluido del árbol semántico', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [AppDoubleBullet(), Text('Cambio de domicilio')],
        ),
      ),
    );

    expect(find.semantics.byLabel('Cambio de domicilio'), findsOneWidget);
  });

  testWidgets('no crea una parada accesible por sí solo', (final tester) async {
    await tester.pumpWidget(buildApp(const AppDoubleBullet()));

    expect(find.byType(AppDoubleBullet), findsOneWidget);
    final exclusion = tester.widget<ExcludeSemantics>(
      find.descendant(
        of: find.byType(AppDoubleBullet),
        matching: find.byType(ExcludeSemantics),
      ),
    );
    expect(exclusion.excluding, isTrue);
  });

  testWidgets('mantiene su tamaño decorativo con texto al 200 por ciento', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppDoubleBullet(),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.getSize(find.byType(AppDoubleBullet)), const Size(20, 8));
    expect(tester.takeException(), isNull);
  });
}
