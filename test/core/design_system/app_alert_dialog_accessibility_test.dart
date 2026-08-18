import 'dart:ui' show CheckedState, SemanticsAction, SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('expone una ruta modal con nombre y título de nivel uno', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppAlertDialog(
          title: 'Aviso de cierre',
          description: 'Se cerrará la sesión actual',
          confirmLabel: 'Cerrar sesión',
          cancelLabel: 'Cancelar',
          onConfirm: () {},
          onCancel: () {},
        ),
      ),
    );

    final nodes = find.semantics.byLabel('Aviso de cierre').evaluate();
    final route = nodes.first.getSemanticsData();
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.scopesRoute), isTrue);
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.namesRoute), isTrue);

    final heading = nodes.last.getSemanticsData();
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 1);
  });

  testWidgets('admite un nombre accesible cuando no hay título visible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppAlertDialog(
          semanticsLabel: 'Confirmación de descarga',
          description: '¿Quieres descargar el documento?',
          confirmLabel: 'Descargar',
          cancelLabel: 'Cancelar',
          onConfirm: () {},
          onCancel: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Confirmación de descarga'), findsOneWidget);
  });

  testWidgets('expone el checkbox como un único control con estado', (final tester) async {
    var checked = true;
    await tester.pumpWidget(
      buildApp(
        AppAlertDialog(
          title: 'Preferencias',
          checkboxLabel: 'No volver a mostrar',
          isChecked: checked,
          onCheckboxChanged: (final value) => checked = value,
          confirmLabel: 'Aceptar',
          cancelLabel: 'Cancelar',
          onConfirm: () {},
          onCancel: () {},
        ),
      ),
    );

    final checkbox = find.semantics.byLabel('No volver a mostrar');
    final data = checkbox.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isChecked, CheckedState.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    final checkboxTapTarget = find.ancestor(
      of: find.text('No volver a mostrar'),
      matching: find.byType(InkWell),
    );
    expect(tester.getSize(checkboxTapTarget).height, greaterThanOrEqualTo(48));
    tester.semantics.tap(checkbox);
    expect(checked, isFalse);
  });

  testWidgets('mantiene las acciones como controles independientes y ordenados', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppAlertDialog(
          title: 'Confirmación',
          infoLabel: 'Más información',
          onInfo: () {},
          confirmLabel: 'Aceptar',
          cancelLabel: 'Cancelar',
          onConfirm: () {},
          onCancel: () {},
        ),
      ),
    );

    for (final label in ['Más información', 'Cancelar', 'Aceptar']) {
      final data = find.semantics.byLabel(label).evaluate().single.getSemanticsData();
      expect(data.hasAction(SemanticsAction.tap), isTrue);
    }
    expect(tester.getTopLeft(find.text('Cancelar')).dx, lessThan(tester.getTopLeft(find.text('Aceptar')).dx));
  });

  testWidgets('show devuelve la acción elegida y devuelve el foco al origen', (final tester) async {
    final openerFocus = FocusNode();
    addTearDown(openerFocus.dispose);
    bool? result;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            focusNode: openerFocus,
            onPressed: () async {
              result = await AppAlertDialog.show(
                context,
                title: 'Confirmación',
                confirmLabel: 'Aceptar',
                cancelLabel: 'Cancelar',
              );
            },
            child: const Text('Abrir'),
          ),
        ),
      ),
    );

    openerFocus.requestFocus();
    await tester.pump();
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(AppAlertDialog), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
    expect(openerFocus.hasFocus, isTrue);
  });

  testWidgets('ofrece scroll y apila acciones con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 400);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppAlertDialog(
            title: 'Confirmar la operación solicitada',
            description: 'Revisa toda la información antes de continuar con esta operación.',
            confirmLabel: 'Confirmar operación',
            cancelLabel: 'Cancelar operación',
            onConfirm: () {},
            onCancel: () {},
          ),
        ),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(
      tester.getCenter(find.text('Cancelar operación')).dy,
      lessThan(tester.getCenter(find.text('Confirmar operación')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
