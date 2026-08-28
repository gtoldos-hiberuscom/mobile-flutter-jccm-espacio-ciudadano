import 'dart:ui' show SemanticsAction, SemanticsFlag;

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

  AppSuccessDialog dialog({
    final VoidCallback? onSecondary,
    final VoidCallback? onPrimary,
    final String? semanticsLabel,
  }) => AppSuccessDialog(
    title: 'Documentación registrada',
    description: 'La documentación se ha incorporado al expediente.',
    secondaryLabel: 'Cerrar sin descargar',
    primaryLabel: 'Descargar justificante',
    onSecondary: onSecondary ?? () {},
    onPrimary: onPrimary ?? () {},
    semanticsLabel: semanticsLabel,
  );

  testWidgets('anuncia el éxito mediante una ruta modal localizada', (final tester) async {
    await tester.pumpWidget(buildApp(dialog()));

    final route = find.semantics.byLabel('Operación correcta: Documentación registrada').evaluate().single.getSemanticsData();
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.scopesRoute), isTrue);
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.namesRoute), isTrue);
  });

  testWidgets('marca el título como encabezado de nivel uno', (final tester) async {
    await tester.pumpWidget(buildApp(dialog()));

    final heading = find.semantics.byLabel('Documentación registrada').evaluate().single.getSemanticsData();
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 1);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(dialog(semanticsLabel: 'Registro completado correctamente')),
    );

    expect(find.semantics.byLabel('Registro completado correctamente'), findsOneWidget);
  });

  testWidgets('mantiene las dos decisiones como acciones independientes', (final tester) async {
    var secondaryPressed = false;
    var primaryPressed = false;
    await tester.pumpWidget(
      buildApp(
        dialog(
          onSecondary: () => secondaryPressed = true,
          onPrimary: () => primaryPressed = true,
        ),
      ),
    );

    final secondary = find.semantics.byLabel('Cerrar sin descargar');
    final primary = find.semantics.byLabel('Descargar justificante');
    expect(secondary.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(primary.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    tester.semantics.tap(secondary);
    tester.semantics.tap(primary);
    expect(secondaryPressed, isTrue);
    expect(primaryPressed, isTrue);
  });

  testWidgets('show ejecuta la decisión después de cerrar y restaura el foco', (final tester) async {
    final openerFocus = FocusNode();
    addTearDown(openerFocus.dispose);
    var selected = false;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            focusNode: openerFocus,
            onPressed: () => AppSuccessDialog.show(
              context,
              title: 'Documentación registrada',
              description: 'La documentación se ha incorporado al expediente.',
              secondaryLabel: 'Cerrar sin descargar',
              primaryLabel: 'Descargar justificante',
              onSecondary: () {},
              onPrimary: () => selected = true,
            ),
            child: const Text('Abrir resultado'),
          ),
        ),
      ),
    );

    openerFocus.requestFocus();
    await tester.pump();
    await tester.tap(find.text('Abrir resultado'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descargar justificante'));
    await tester.pumpAndSettle();

    expect(selected, isTrue);
    expect(find.byType(AppSuccessDialog), findsNothing);
    expect(openerFocus.hasFocus, isTrue);
  });

  testWidgets('permite scroll con texto al 200 por ciento en pantalla estrecha', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 400);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(dialog()),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(
      tester.getCenter(find.text('Cerrar sin descargar')).dy,
      lessThan(tester.getCenter(find.text('Descargar justificante')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
