import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_external_navigation_dialog.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  AppExternalNavigationDialog dialog() => AppExternalNavigationDialog(
    onCancel: () {},
    onContinue: () {},
  );

  testWidgets('expone una ruta modal con nombre y encabezado de nivel uno', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(dialog()));

    final nodes = find.semantics.byLabel('Vas a salir de la aplicación').evaluate();
    expect(nodes.first.flagsCollection.scopesRoute, isTrue);
    expect(nodes.first.flagsCollection.namesRoute, isTrue);
    expect(nodes.last.flagsCollection.isHeader, isTrue);
    expect(nodes.last.headingLevel, 1);
  });

  testWidgets('mantiene las dos decisiones como acciones independientes', (final tester) async {
    var cancelled = false;
    var continued = false;
    await tester.pumpWidget(
      buildApp(
        AppExternalNavigationDialog(
          onCancel: () => cancelled = true,
          onContinue: () => continued = true,
        ),
      ),
    );

    final cancel = find.semantics.byLabel('Volver');
    final proceed = find.semantics.byLabel('Continuar');
    expect(cancel.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(proceed.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    tester.semantics.tap(cancel);
    tester.semantics.tap(proceed);
    expect(cancelled, isTrue);
    expect(continued, isTrue);
  });

  testWidgets('excluye de semántica el icono decorativo', (final tester) async {
    await tester.pumpWidget(buildApp(dialog()));

    expect(
      find.ancestor(
        of: find.byIcon(Icons.open_in_new),
        matching: find.byType(ExcludeSemantics),
      ),
      findsOneWidget,
    );
  });

  testWidgets('show devuelve el foco al control que abrió el diálogo', (final tester) async {
    final openerFocus = FocusNode();
    addTearDown(openerFocus.dispose);
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            focusNode: openerFocus,
            onPressed: () => AppExternalNavigationDialog.show(context),
            child: const Text('Abrir enlace'),
          ),
        ),
      ),
    );

    openerFocus.requestFocus();
    await tester.pump();
    await tester.tap(find.text('Abrir enlace'));
    await tester.pumpAndSettle();
    expect(find.byType(AppExternalNavigationDialog), findsOneWidget);

    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(openerFocus.hasFocus, isTrue);
  });

  testWidgets('ofrece scroll y apila acciones al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 400);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(dialog(), textScaler: const TextScaler.linear(2)),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(
      tester.getCenter(find.text('Volver')).dy,
      lessThan(tester.getCenter(find.text('Continuar')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
