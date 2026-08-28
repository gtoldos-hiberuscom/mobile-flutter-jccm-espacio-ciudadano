import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_filter_controls.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('sin filtros activos anuncia el texto visible', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppFilterButton(label: 'Filtrar resultados', onPressed: () {})),
    );

    final semantics = find.semantics.byLabel('Filtrar resultados').evaluate().single;
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
  });

  testWidgets('anuncia el recuento activo con pluralización localizada', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFilterButton(
          label: 'Filtrar resultados',
          activeFilterCount: 2,
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Filtrar resultados (2)'), findsOneWidget);
    expect(find.semantics.byLabel('Filtrar resultados, 2 filtros activos'), findsOneWidget);

    await tester.pumpWidget(
      buildApp(
        AppFilterButton(
          label: 'Filtrar resultados',
          activeFilterCount: 1,
          onPressed: () {},
        ),
      ),
    );
    expect(find.semantics.byLabel('Filtrar resultados, 1 filtro activo'), findsOneWidget);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppFilterButton(
          label: 'Filtros',
          semanticsLabel: 'Abrir filtros de recomendaciones',
          onPressed: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Abrir filtros de recomendaciones'), findsOneWidget);
  });

  testWidgets('deshabilitado no ofrece acción', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppFilterButton(label: 'Filtrar resultados', onPressed: null)),
    );

    final semantics = find.semantics.byLabel('Filtrar resultados').evaluate().single;
    expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('admite texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppFilterButton(
            label: 'Filtrar las recomendaciones disponibles',
            activeFilterCount: 12,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppFilterButton)).height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });
}
