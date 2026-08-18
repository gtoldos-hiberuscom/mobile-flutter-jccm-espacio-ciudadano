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

  testWidgets('asocia etiqueta y valor en una única unidad informativa', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceDataRow(label: 'TELÉFONO MÓVIL', value: '0034 640 559 754'),
      ),
    );

    final node = find.semantics.byLabel('TELÉFONO MÓVIL. 0034 640 559 754');
    expect(node, findsOneWidget);
    expect(find.semantics.byLabel('TELÉFONO MÓVIL'), findsNothing);
    expect(find.semantics.byLabel('0034 640 559 754'), findsNothing);
    expect(node.evaluate().single.getSemanticsData().flagsCollection.isButton, isFalse);
  });

  testWidgets('permite personalizar la pronunciación del dato', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceDataRow(
          label: 'DNI',
          value: '12345678A',
          semanticLabel: 'Documento nacional de identidad. 12345678 A',
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Documento nacional de identidad. 12345678 A'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('DNI'), findsNothing);
  });

  testWidgets('reorganiza etiqueta y valor al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'CORREO ELECTRÓNICO DE NOTIFICACIONES';
    const value = 'persona.apellidos@correo-ejemplo.es';
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceDataRow(label: label, value: value),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(value)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza etiquetas, valores o nombres accesibles vacíos', (final tester) async {
    expect(
      () => AppPreferenceDataRow(label: '', value: 'Dato'),
      throwsAssertionError,
    );
    expect(
      () => AppPreferenceDataRow(label: 'Campo', value: ''),
      throwsAssertionError,
    );
    expect(
      () => AppPreferenceDataRow(
        label: 'Campo',
        value: 'Dato',
        semanticLabel: '',
      ),
      throwsAssertionError,
    );
  });
}
