import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_digital_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  AppDigitalCard card({final VoidCallback? onDownload, final bool isDownloading = false}) => AppDigitalCard(
    title: 'Familia numerosa',
    number: 'FN-123456789',
    primaryDateLabel: 'Fecha de emisión',
    primaryDate: '1 ene 2026',
    secondaryDateLabel: 'Fecha de caducidad',
    secondaryDate: '31 dic 2026',
    statusLabel: 'Definitivo',
    downloadLabel: 'Descargar',
    onDownload: onDownload,
    isDownloading: isDownloading,
  );

  testWidgets('resume los datos como información y no como botón', (final tester) async {
    await tester.pumpWidget(buildApp(card(onDownload: () {})));

    final data = find.semantics
        .byLabel(
          'Familia numerosa. Número de carnet: FN-123456789. Fecha de emisión: 1 ene 2026. Fecha de caducidad: 31 dic 2026. Definitivo',
        )
        .evaluate()
        .single
        .getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('mantiene descargar como único botón independiente', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(buildApp(card(onDownload: () => taps++)));

    final action = find.semantics.byLabel('Descargar').evaluate().single.getSemanticsData();
    expect(action.flagsCollection.isButton, isTrue);
    expect(action.flagsCollection.isEnabled, Tristate.isTrue);
    expect(action.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byType(TextButton));
    expect(taps, 1);
  });

  testWidgets('anuncia la descarga en curso y deshabilita la acción', (final tester) async {
    await tester.pumpWidget(buildApp(card(onDownload: () {}, isDownloading: true)));

    final action = find.semantics.byLabel('Descargar').evaluate().single;
    expect(action.flagsCollection.isEnabled, Tristate.isFalse);
    expect(action.flagsCollection.isLiveRegion, isTrue);
    expect(action.value, 'Cargando');
    expect(action.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('localiza las etiquetas visuales en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppDigitalCard(title: 'Youth card', number: 'Y-15', downloadLabel: 'Download'),
        locale: const Locale('en'),
      ),
    );

    expect(find.text('Title / Card'), findsOneWidget);
    expect(find.text('Card number'), findsOneWidget);
    expect(find.semantics.byLabel('Youth card. Card number: Y-15'), findsOneWidget);
  });

  testWidgets('no trunca el número y crece con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(card(onDownload: () {})),
      ),
    );

    final number = tester.widget<Text>(find.text('FN-123456789'));
    expect(number.maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
