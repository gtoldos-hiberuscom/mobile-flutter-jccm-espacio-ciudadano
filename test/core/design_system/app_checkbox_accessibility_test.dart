import 'dart:ui' show CheckedState, SemanticsAction, SemanticsValidationResult, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_checkbox.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('expone nombre, estado y una unica accion', (final tester) async {
    bool? newValue;

    await tester.pumpWidget(
      buildApp(
        AppCheckbox(
          label: 'Acepto las condiciones',
          value: false,
          onChanged: (final value) => newValue = value,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Acepto las condiciones').evaluate().single;
    expect(semantics.label, 'Acepto las condiciones');
    expect(semantics.flagsCollection.isChecked, CheckedState.isFalse);
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    tester.semantics.tap(find.semantics.byLabel('Acepto las condiciones'));
    await tester.pump();

    expect(newValue, isTrue);
  });

  testWidgets('representa el estado indeterminado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCheckbox(
          label: 'Seleccionar documentos',
          value: null,
          tristate: true,
          onChanged: (_) {},
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Seleccionar documentos').evaluate().single;
    expect(semantics.flagsCollection.isChecked, CheckedState.mixed);
  });

  testWidgets('deshabilitado anuncia el estado y no ofrece accion', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppCheckbox(
          label: 'Acepto las condiciones',
          value: false,
          onChanged: null,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Acepto las condiciones').evaluate().single;
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('asocia el error sin crear un segundo nodo semantico', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCheckbox(
          label: 'Acepto las condiciones',
          value: false,
          isError: true,
          errorText: 'Debes aceptar para continuar',
          onChanged: (_) {},
        ),
      ),
    );

    const combinedLabel = 'Acepto las condiciones, Debes aceptar para continuar';
    final semantics = find.semantics.byLabel(combinedLabel).evaluate().single;
    expect(semantics.label, combinedLabel);
    expect(semantics.getSemanticsData().validationResult, SemanticsValidationResult.invalid);
    expect(find.semantics.byLabel('Debes aceptar para continuar'), findsNothing);
  });

  testWidgets('toda la fila mantiene al menos 48 dp de altura', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCheckbox(
          label: 'Acepto',
          value: false,
          onChanged: (_) {},
        ),
      ),
    );

    final size = tester.getSize(find.byType(InkWell));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('admite texto al 200 por ciento sin desbordamiento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppCheckbox(
            label: 'Autorizo el uso y la gestion de mis datos personales',
            value: false,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
