import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_label.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('anuncia la etiqueta obligatoria mediante estado semántico', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(const AppLabel(text: 'Correo electrónico', required: true)),
    );

    final node = find.semantics.byLabel('Correo electrónico').evaluate().single;
    expect(node.flagsCollection.isRequired, Tristate.isTrue);
    expect(find.text('CORREO ELECTRÓNICO*'), findsOneWidget);
  });

  testWidgets('no marca como obligatoria una etiqueta opcional', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppLabel(text: 'Segundo apellido', size: AppLabelSize.s)),
    );

    final node = find.semantics.byLabel('Segundo apellido').evaluate().single;
    expect(node.flagsCollection.isRequired, Tristate.isFalse);
  });

  testWidgets('no anuncia la transformación visual a mayúsculas', (final tester) async {
    await tester.pumpWidget(buildApp(const AppLabel(text: 'Nombre completo')));

    expect(find.text('NOMBRE COMPLETO'), findsOneWidget);
    expect(find.semantics.byLabel('Nombre completo'), findsOneWidget);
    expect(find.semantics.byLabel('NOMBRE COMPLETO'), findsNothing);
  });

  testWidgets('admite una pronunciación alternativa', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppLabel(
          text: 'NIF/NIE',
          semanticsLabel: 'Número de identificación fiscal o de extranjero',
        ),
      ),
    );

    expect(
      find.semantics.byLabel(
        'Número de identificación fiscal o de extranjero',
      ),
      findsOneWidget,
    );
  });

  testWidgets('no trunca a 320 dp con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'Dirección completa de la persona representante';
    await tester.pumpWidget(
      buildApp(
        const AppLabel(text: label, required: true),
        textScaler: const TextScaler.linear(2),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.maxLines, isNull);
    expect(text.overflow, isNull);
    expect(tester.takeException(), isNull);
  });
}
