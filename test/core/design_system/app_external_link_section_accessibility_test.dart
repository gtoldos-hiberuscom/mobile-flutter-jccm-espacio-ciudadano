import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_external_link_section.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
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
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('marca el título de la sección como encabezado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppExternalLinkSection(
          title: 'Servicios relacionados',
          links: [AppExternalLinkItem(label: 'Portal de empleo', onTap: () {})],
        ),
      ),
    );

    final heading = find.semantics.byLabel('Servicios relacionados').evaluate().single;
    expect(heading.flagsCollection.isHeader, isTrue);
  });

  testWidgets('expone una única acción con rol de enlace externo', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(AppExternalLinkItem(label: 'Portal de empleo', onTap: () => taps++)),
    );

    final node = find.semantics.byLabel('Portal de empleo').evaluate().single;
    final data = node.getSemanticsData();
    expect(node.flagsCollection.isLink, isTrue);
    expect(node.flagsCollection.isButton, isFalse);
    expect(data.hint, 'Abre en navegador externo');
    expect(data.hasAction(SemanticsAction.tap), isTrue);

    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre y la pista accesibles', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppExternalLinkItem(
          label: 'Más información',
          semanticLabel: 'Portal de vivienda de Castilla-La Mancha',
          semanticHint: 'Se abrirá fuera de esta aplicación',
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Portal de vivienda de Castilla-La Mancha').evaluate().single.getSemanticsData();
    expect(data.hint, 'Se abrirá fuera de esta aplicación');
  });

  testWidgets('localiza la pista del enlace en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppExternalLinkItem(label: 'Employment portal', onTap: () {}),
        locale: const Locale('en'),
      ),
    );

    final data = find.semantics.byLabel('Employment portal').evaluate().single.getSemanticsData();
    expect(data.hint, 'Opens in external browser');
  });

  testWidgets('mantiene 48 dp y no trunca al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'Consulta toda la información sobre las ayudas disponibles para vivienda';
    await tester.pumpWidget(
      buildApp(
        AppExternalLinkItem(label: label, onTap: () {}),
        textScaler: const TextScaler.linear(2),
      ),
    );

    final target = find
        .ancestor(
          of: find.text(label),
          matching: find.byType(ConstrainedBox),
        )
        .first;
    expect(tester.getSize(target).height, greaterThanOrEqualTo(48));
    expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
