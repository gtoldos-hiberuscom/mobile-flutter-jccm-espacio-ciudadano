import 'dart:ui' show SemanticsAction, SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bottom_sheet.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('expone una ruta aislada y el título como encabezado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppBottomSheet(
          title: 'Opciones de descarga',
          body: Text('Selecciona un formato'),
        ),
      ),
    );

    final nodes = find.semantics.byLabel('Opciones de descarga').evaluate();
    final route = nodes.first.getSemanticsData();
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.scopesRoute), isTrue);
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.namesRoute), isTrue);
    final heading = nodes.last.getSemanticsData();
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 1);
  });

  testWidgets('usa un nombre genérico localizado si no hay título', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppBottomSheet(body: Text('Content')),
        locale: const Locale('en'),
      ),
    );

    expect(find.semantics.byLabel('Bottom sheet'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('permite personalizar el nombre accesible de la ruta', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppBottomSheet(
          semanticsLabel: 'Selector de formato del justificante',
          body: Text('Selecciona un formato'),
        ),
      ),
    );

    expect(find.semantics.byLabel('Selector de formato del justificante'), findsOneWidget);
  });

  testWidgets('el cierre es una acción única con área mínima de 48 dp', (final tester) async {
    var closes = 0;
    await tester.pumpWidget(
      buildApp(
        AppBottomSheet(
          title: 'Ayuda',
          body: const Text('Información'),
          onClose: () => closes++,
        ),
      ),
    );

    final close = find.semantics.byLabel('Cerrar');
    expect(close.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    final closeTarget = find.ancestor(of: find.text('Cerrar'), matching: find.byType(InkWell));
    expect(tester.getSize(closeTarget).height, greaterThanOrEqualTo(48));
    tester.semantics.tap(close);
    expect(closes, 1);
  });

  testWidgets('show cierra la hoja y devuelve el foco al control de origen', (final tester) async {
    final openerFocus = FocusNode();
    addTearDown(openerFocus.dispose);
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            focusNode: openerFocus,
            onPressed: () => AppBottomSheet.show<void>(
              context: context,
              title: 'Ayuda',
              body: const Text('Información de ayuda'),
            ),
            child: const Text('Abrir'),
          ),
        ),
      ),
    );

    openerFocus.requestFocus();
    await tester.pump();
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();

    expect(find.byType(AppBottomSheet), findsNothing);
    expect(openerFocus.hasFocus, isTrue);
  });

  testWidgets('permite scroll con texto al 200 por ciento y teclado visible', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 500);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(2),
          viewInsets: EdgeInsets.only(bottom: 120),
        ),
        child: buildApp(
          const AppBottomSheet(
            title: 'Información importante de la solicitud',
            body: Text(
              'Este contenido es deliberadamente largo para comprobar que puede recorrerse completo sin quedar oculto por el teclado virtual.',
            ),
            footer: Text('Acciones y notas finales de la solicitud'),
          ),
        ),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
