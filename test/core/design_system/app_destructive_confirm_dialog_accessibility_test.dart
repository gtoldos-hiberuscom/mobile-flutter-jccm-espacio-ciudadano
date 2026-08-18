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

  AppDestructiveConfirmDialog dialog({
    final VoidCallback? onConfirm,
    final VoidCallback? onCancel,
    final String? semanticsLabel,
  }) => AppDestructiveConfirmDialog(
    title: 'Eliminar cuenta',
    description: 'Esta acción no se puede deshacer.',
    confirmLabel: 'Eliminar definitivamente',
    cancelLabel: 'Conservar cuenta',
    onConfirm: onConfirm ?? () {},
    onCancel: onCancel ?? () {},
    semanticsLabel: semanticsLabel,
  );

  testWidgets('expone una ruta aislada y un encabezado de nivel uno', (final tester) async {
    await tester.pumpWidget(buildApp(dialog()));

    final nodes = find.semantics.byLabel('Eliminar cuenta').evaluate();
    final route = nodes.first.getSemanticsData();
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.scopesRoute), isTrue);
    // ignore: deprecated_member_use
    expect(route.hasFlag(SemanticsFlag.namesRoute), isTrue);

    final heading = nodes.last.getSemanticsData();
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 1);
  });

  testWidgets('permite personalizar el nombre accesible del diálogo', (final tester) async {
    await tester.pumpWidget(
      buildApp(dialog(semanticsLabel: 'Confirmación para eliminar la cuenta definitivamente')),
    );

    expect(
      find.semantics.byLabel('Confirmación para eliminar la cuenta definitivamente'),
      findsOneWidget,
    );
  });

  testWidgets('mantiene cancelar y eliminar como acciones independientes', (final tester) async {
    var cancelled = false;
    var confirmed = false;
    await tester.pumpWidget(
      buildApp(
        dialog(
          onCancel: () => cancelled = true,
          onConfirm: () => confirmed = true,
        ),
      ),
    );

    final cancel = find.semantics.byLabel('Conservar cuenta');
    final confirm = find.semantics.byLabel('Eliminar definitivamente');
    expect(cancel.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(confirm.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    tester.semantics.tap(cancel);
    tester.semantics.tap(confirm);
    expect(cancelled, isTrue);
    expect(confirmed, isTrue);
  });

  testWidgets('show devuelve cancelar y restaura el foco del origen', (final tester) async {
    final openerFocus = FocusNode();
    addTearDown(openerFocus.dispose);
    bool? result;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            focusNode: openerFocus,
            onPressed: () async {
              result = await AppDestructiveConfirmDialog.show(
                context,
                title: 'Eliminar cuenta',
                description: 'Esta acción no se puede deshacer.',
                confirmLabel: 'Eliminar definitivamente',
                cancelLabel: 'Conservar cuenta',
              );
            },
            child: const Text('Abrir confirmación'),
          ),
        ),
      ),
    );

    openerFocus.requestFocus();
    await tester.pump();
    await tester.tap(find.text('Abrir confirmación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Conservar cuenta'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
    expect(openerFocus.hasFocus, isTrue);
  });

  testWidgets('ofrece scroll y apila las acciones con texto al 200 por ciento', (final tester) async {
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
      tester.getCenter(find.text('Conservar cuenta')).dy,
      lessThan(tester.getCenter(find.text('Eliminar definitivamente')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
