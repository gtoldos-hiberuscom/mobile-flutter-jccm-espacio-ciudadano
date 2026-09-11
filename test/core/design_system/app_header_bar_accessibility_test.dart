import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_header_bar.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final AppHeaderBar header, {
    final Locale locale = const Locale('es'),
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(appBar: header, body: const Text('Contenido principal')),
  );

  testWidgets('expone un único H1 antes de la navegación', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppHeaderBar(title: 'Mis preferencias', onBack: () {})),
    );

    final heading = find.semantics.byLabel('Mis preferencias').evaluate().single;
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 1);
    expect(heading.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);

    final row = tester.widget<Row>(find.descendant(of: find.byType(AppBar), matching: find.byType(Row)).first);
    expect(row.children.first, isA<Semantics>());
    expect(find.byTooltip('Atrás'), findsOneWidget);
  });

  testWidgets('localiza las acciones predeterminadas en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppHeaderBar(title: 'Preferences', onBack: () {}, onInfo: () {}),
        locale: const Locale('en'),
      ),
    );

    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.byTooltip('Information'), findsOneWidget);
  });

  testWidgets('permite nombres accesibles específicos sin duplicar el título', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        AppHeaderBar(
          title: 'Datos IRPF',
          titleSemanticsLabel: 'Datos del impuesto sobre la renta',
          leadingTooltip: 'Volver a datos personales',
          infoTooltip: 'Información sobre datos fiscales',
          onBack: () {},
          onInfo: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Datos del impuesto sobre la renta'), findsOneWidget);
    expect(find.semantics.byLabel('Datos IRPF'), findsNothing);
    expect(find.byTooltip('Volver a datos personales'), findsOneWidget);
    expect(find.byTooltip('Información sobre datos fiscales'), findsOneWidget);
  });

  testWidgets('las acciones mantienen objetivos de 48 por 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppHeaderBar(title: 'Preferencias', onBack: () {}, onInfo: () {})),
    );

    for (final tooltip in ['Atrás', 'Información']) {
      final button = find.ancestor(of: find.byTooltip(tooltip), matching: find.byType(IconButton));
      expect(tester.getSize(button).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('el título permite dos líneas y no usa elipsis', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppHeaderBar(title: 'Editar datos de contacto', onBack: () {}),
      ),
    );

    final title = tester.widget<Text>(find.text('Editar datos de contacto'));
    expect(title.maxLines, 2);
    expect(title.overflow, isNull);
    expect(tester.takeException(), isNull);
  });
}
