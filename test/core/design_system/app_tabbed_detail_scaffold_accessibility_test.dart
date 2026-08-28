import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_tabbed_detail_scaffold.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );

  AppTabbedDetailScaffold scaffold({
    final int selectedIndex = 0,
    final ValueChanged<int>? onSelected,
  }) => AppTabbedDetailScaffold(
    title: 'Datos IRPF',
    titleSemanticsLabel: 'Datos del impuesto sobre la renta',
    leadingTooltip: 'Volver a mis datos',
    infoTooltip: 'Información sobre datos fiscales',
    onBack: () {},
    onInfo: () {},
    tabs: const ['Resumen', 'Detalle'],
    selectedIndex: selectedIndex,
    onTabSelected: onSelected ?? (_) {},
    tabViews: const [Text('Contenido resumido'), Text('Contenido detallado')],
  );

  testWidgets('expone un único encabezado con pronunciación alternativa', (final tester) async {
    await tester.pumpWidget(buildApp(scaffold()));

    final heading = find.semantics.byLabel('Datos del impuesto sobre la renta').evaluate().single;
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 1);
    expect(find.semantics.byLabel('Datos IRPF'), findsNothing);
  });

  testWidgets('personaliza las acciones superiores sin duplicarlas', (final tester) async {
    await tester.pumpWidget(buildApp(scaffold()));

    expect(find.byTooltip('Volver a mis datos'), findsOneWidget);
    expect(find.byTooltip('Información sobre datos fiscales'), findsOneWidget);
    expect(find.byTooltip('Volver'), findsNothing);
  });

  testWidgets('expone únicamente el contenido de la pestaña activa', (final tester) async {
    await tester.pumpWidget(buildApp(scaffold(selectedIndex: 1)));

    expect(find.text('Contenido resumido'), findsNothing);
    expect(find.text('Contenido detallado'), findsOneWidget);
  });

  testWidgets('permite identificar la región de contenido activa', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppTabbedDetailScaffold(
          title: 'Vivienda',
          onBack: () {},
          tabs: const ['Inmuebles', 'Ayudas'],
          selectedIndex: 0,
          onTabSelected: (_) {},
          activeViewSemanticLabel: 'Contenido de inmuebles',
          tabViews: const [Text('Listado de inmuebles'), Text('Listado de ayudas')],
        ),
      ),
    );

    expect(find.semantics.byLabel('Contenido de inmuebles'), findsOneWidget);
    expect(find.semantics.byLabel('Listado de inmuebles'), findsOneWidget);
  });

  testWidgets('rechaza estructuras e índices inválidos', (final tester) async {
    expect(
      () => AppTabbedDetailScaffold(
        title: 'Detalle',
        onBack: () {},
        tabs: const [],
        selectedIndex: 0,
        onTabSelected: (_) {},
        tabViews: const [],
      ),
      throwsAssertionError,
    );
    expect(
      () => AppTabbedDetailScaffold(
        title: 'Detalle',
        onBack: () {},
        tabs: const ['Una'],
        selectedIndex: 1,
        onTabSelected: (_) {},
        tabViews: const [Text('Contenido')],
      ),
      throwsAssertionError,
    );
  });
}
