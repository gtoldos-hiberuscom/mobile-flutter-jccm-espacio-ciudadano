import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_filter_controls.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('expone nombre, rol, selección y una única acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppSelectableFilterChip(
          label: 'Educación',
          isSelected: true,
          onTap: () => taps++,
        ),
      ),
    );

    final finder = find.semantics.byLabel('Educación');
    final semantics = finder.evaluate().single;
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isSelected, Tristate.isTrue);
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(finder, findsOneWidget);

    tester.semantics.tap(finder);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('actualiza el estado seleccionado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppSelectableFilterChip(
          label: 'Educación',
          isSelected: false,
          onTap: () {},
        ),
      ),
    );

    var semantics = find.semantics.byLabel('Educación').evaluate().single;
    expect(semantics.flagsCollection.isSelected, Tristate.isFalse);

    await tester.pumpWidget(
      buildApp(
        AppSelectableFilterChip(
          label: 'Educación',
          isSelected: true,
          onTap: () {},
        ),
      ),
    );
    semantics = find.semantics.byLabel('Educación').evaluate().single;
    expect(semantics.flagsCollection.isSelected, Tristate.isTrue);
    expect(find.byType(AppIcon), findsOneWidget);
  });

  testWidgets('deshabilitado anuncia el estado y no ofrece acción', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppSelectableFilterChip(
          label: 'Educación',
          isSelected: false,
          onTap: null,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Educación').evaluate().single;
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('se activa mediante teclado', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppSelectableFilterChip(
          label: 'Educación',
          isSelected: false,
          onTap: () => taps++,
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('mantiene 48 dp y admite texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppSelectableFilterChip(
            label: 'Educación, formación y aprendizaje permanente',
            isSelected: true,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(InkWell)).height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });
}
