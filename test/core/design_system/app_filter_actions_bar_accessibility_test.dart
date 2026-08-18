import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_filter_controls.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Align(alignment: Alignment.bottomCenter, child: child),
    ),
  );

  testWidgets('expone un grupo localizado con dos acciones ordenadas', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppFilterActionsBar(onClear: () {}, onApply: () {})),
    );

    expect(find.semantics.byLabel('Acciones de filtros'), findsOneWidget);
    final clear = find.semantics.byLabel('Desmarcar todo').evaluate().single;
    final apply = find.semantics.byLabel('Aplicar filtros').evaluate().single;
    expect(clear.flagsCollection.isButton, isTrue);
    expect(apply.flagsCollection.isButton, isTrue);
    expect((clear.sortKey! as OrdinalSortKey).order, 1);
    expect((apply.sortKey! as OrdinalSortKey).order, 2);
  });

  testWidgets('permite etiquetas específicas', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFilterActionsBar(
          semanticsLabel: 'Acciones del filtro de recomendaciones',
          clearLabel: 'Restablecer selección',
          applyLabel: 'Mostrar resultados',
          onClear: () {},
          onApply: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Acciones del filtro de recomendaciones'), findsOneWidget);
    expect(find.semantics.byLabel('Restablecer selección'), findsOneWidget);
    expect(find.semantics.byLabel('Mostrar resultados'), findsOneWidget);
  });

  testWidgets('cada acción puede estar deshabilitada independientemente', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppFilterActionsBar(onClear: null, onApply: () {})),
    );

    final clear = find.semantics.byLabel('Desmarcar todo').evaluate().single;
    final apply = find.semantics.byLabel('Aplicar filtros').evaluate().single;
    expect(clear.flagsCollection.isEnabled, Tristate.isFalse);
    expect(clear.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    expect(apply.flagsCollection.isEnabled, Tristate.isTrue);
  });

  testWidgets('usa fila en horizontal con escala normal', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 360);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(AppFilterActionsBar(onClear: () {}, onApply: () {})),
    );

    expect(tester.getCenter(find.text('Desmarcar todo')).dy, tester.getCenter(find.text('Aplicar filtros')).dy);
  });

  testWidgets('usa columna en horizontal con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 360);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppFilterActionsBar(
            clearLabel: 'Desmarcar todos los filtros seleccionados',
            applyLabel: 'Aplicar filtros y mostrar resultados',
            onClear: () {},
            onApply: () {},
          ),
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('Desmarcar todos los filtros seleccionados')).dy,
      lessThan(tester.getCenter(find.text('Aplicar filtros y mostrar resultados')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
