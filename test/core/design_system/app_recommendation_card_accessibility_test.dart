import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  AppRecommendationCard card({final VoidCallback? onTap, final String? semanticLabel}) => AppRecommendationCard(
    title: 'Ayudas para rehabilitación',
    categoryLabels: const ['Últimos días'],
    detailLabel: 'Hechos vitales asociados',
    detailText: 'Quiero mejorar mi vivienda',
    statusText: 'Plazo abierto',
    semanticLabel: semanticLabel,
    onTap: onTap,
  );

  testWidgets('expone un enlace externo con nombre, pista, estado y una única acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(buildApp(card(onTap: () => taps++)));

    final data = find.semantics
        .byLabel(
          'Últimos días. Ayudas para rehabilitación. Hechos vitales asociados: Quiero mejorar mi vivienda. Estado: Plazo abierto',
        )
        .evaluate()
        .single
        .getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hint, 'Abre en navegador externo');
    expect(data.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(buildApp(card(onTap: () {}, semanticLabel: 'Abrir ayuda recomendada de vivienda')));

    expect(find.semantics.byLabel('Abrir ayuda recomendada de vivienda'), findsOneWidget);
  });

  testWidgets('la variante informativa conserva su contenido granular y no muestra icono externo', (final tester) async {
    await tester.pumpWidget(buildApp(card()));

    expect(find.semantics.byLabel('Ayudas para rehabilitación'), findsOneWidget);
    expect(find.byType(InkWell), findsNothing);
    expect(find.byIcon(Icons.open_in_new), findsNothing);
  });

  testWidgets('localiza el estado y la pista en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppRecommendationCard(
          title: 'Housing support',
          categoryLabels: const [],
          detailLabel: 'Associated life events',
          detailText: 'Improve my home',
          statusText: 'Open',
          onTap: () {},
        ),
        locale: const Locale('en'),
      ),
    );

    expect(find.text('STATUS'), findsOneWidget);
    final data = find.semantics.byLabel('Housing support. Associated life events: Improve my home. Status: Open').evaluate().single.getSemanticsData();
    expect(data.hint, 'Opens in external browser');
  });

  testWidgets('no trunca el título ni el detalle', (final tester) async {
    await tester.pumpWidget(buildApp(card(onTap: () {})));

    final title = tester.widget<Text>(find.text('Ayudas para rehabilitación'));
    final detail = tester.widget<Text>(find.text('Quiero mejorar mi vivienda'));
    expect(title.maxLines, isNull);
    expect(detail.maxLines, isNull);
  });

  testWidgets('admite texto al 200 por ciento en una pantalla de 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(card(onTap: () {})),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
