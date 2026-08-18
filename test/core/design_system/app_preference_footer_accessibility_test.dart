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

  testWidgets('anuncia solo el texto y mantiene el icono decorativo', (final tester) async {
    const text = 'Actualizado el 14 ago 2026 a las 10:30';
    await tester.pumpWidget(buildApp(const AppPreferenceFooter(text: text)));

    final node = find.semantics.byLabel(text);
    expect(node, findsOneWidget);
    final data = node.evaluate().single.getSemanticsData();
    expect(data.actions, 0);
    expect(data.flagsCollection.isButton, isFalse);
  });

  testWidgets('permite personalizar la pronunciación', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceFooter(
          text: 'Actualizado 14/08/2026 10:30',
          semanticLabel: 'Actualizado el 14 de agosto de 2026 a las 10 y 30',
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Actualizado el 14 de agosto de 2026 a las 10 y 30'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('Actualizado 14/08/2026 10:30'), findsNothing);
  });

  testWidgets('no trunca ni desborda al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const text = 'Actualizado por última vez el 14 de agosto de 2026 a las 10:30 horas';
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceFooter(text: text),
        textScaler: const TextScaler.linear(2),
      ),
    );

    final widget = tester.widget<Text>(find.text(text));
    expect(widget.maxLines, isNull);
    expect(widget.overflow, isNot(TextOverflow.ellipsis));
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza textos y nombres accesibles vacíos', (final tester) async {
    expect(() => AppPreferenceFooter(text: ''), throwsAssertionError);
    expect(
      () => AppPreferenceFooter(text: 'Actualizado hoy', semanticLabel: ''),
      throwsAssertionError,
    );
  });
}
