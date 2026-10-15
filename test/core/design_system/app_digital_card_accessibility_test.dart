import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_digital_card.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
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

    expect(find.text('Número de carnet'), findsOneWidget);
    expect(find.text('FN-123456789'), findsOneWidget);
    expect(find.text('Fecha de emisión'), findsOneWidget);
    expect(find.text('1 ene 2026'), findsOneWidget);
    expect(find.text('Fecha de caducidad'), findsOneWidget);
    expect(find.text('31 dic 2026'), findsOneWidget);

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

  testWidgets('identifica el carnet en el nombre del botón de descarga', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(buildApp(card(onDownload: () => taps++)));

    final action = find.semantics.byLabel('Descargar Familia numerosa').evaluate().single.getSemanticsData();
    expect(action.flagsCollection.isButton, isTrue);
    expect(action.flagsCollection.isEnabled, Tristate.isTrue);
    expect(action.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byType(TextButton));
    expect(taps, 1);
  });

  testWidgets('anuncia la descarga en curso y deshabilita la acción', (final tester) async {
    await tester.pumpWidget(buildApp(card(onDownload: () {}, isDownloading: true)));

    final action = find.semantics.byLabel('Descargar Familia numerosa').evaluate().single;
    expect(action.flagsCollection.isEnabled, Tristate.isFalse);
    expect(action.flagsCollection.isLiveRegion, isTrue);
    expect(action.value, 'Cargando');
    expect(action.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('distingue los botones cuando se muestran varios carnets', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        Column(
          children: [
            card(onDownload: () {}),
            const AppDigitalCard(
              title: 'Carnet de discapacidad',
              downloadLabel: 'Descargar',
              onDownload: _noop,
            ),
          ],
        ),
      ),
    );

    expect(find.semantics.byLabel('Descargar Familia numerosa'), findsOneWidget);
    expect(find.semantics.byLabel('Descargar Carnet de discapacidad'), findsOneWidget);
    expect(find.semantics.byLabel('Descargar'), findsNothing);
  });

  testWidgets('localiza las etiquetas visuales en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppDigitalCard(title: 'Youth card', number: 'Y-15', downloadLabel: 'Download'),
        locale: const Locale('en'),
      ),
    );

    expect(find.text('Youth card'), findsOneWidget);
    expect(find.semantics.byLabel('Youth card. Card number: Y-15'), findsOneWidget);
  });

  testWidgets('reduce un número de carnet largo antes de dividirlo en dos líneas', (final tester) async {
    const number = '2445447E-R955-X239-U642-X865';
    await tester.pumpWidget(
      buildApp(
        const AppDigitalCard(
          title: 'Carnet Joven',
          number: number,
          downloadLabel: 'Descargar',
        ),
      ),
    );

    final value = tester.widget<Text>(find.text(number));
    expect(value.maxLines, 1);
    expect(value.softWrap, isFalse);
  });

  testWidgets('crece sin errores con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(card(onDownload: () {})),
      ),
    );

    expect(find.text('Familia numerosa'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mantiene dentro del carnet las decoraciones del nuevo diseño', (final tester) async {
    final variants = <AppDigitalCard>[
      card(onDownload: () {}),
      const AppDigitalCard(title: 'Joven', number: '00000000000000000000', downloadLabel: 'Descargar'),
    ];

    for (final variant in variants) {
      await tester.pumpWidget(buildApp(variant));

      final cardBounds = tester.getRect(find.byType(AppDigitalCard));
      final cornerBounds = tester.getRect(find.byKey(const ValueKey('digital-card-corner-circle')));
      final brandingBounds = tester.getRect(find.byKey(const ValueKey('digital-card-branding')));

      expect(cardBounds.overlaps(cornerBounds), isTrue);
      expect(cardBounds.contains(brandingBounds.bottomRight), isTrue);
    }
  });

  testWidgets('usa la ilustración específica del carnet', (final tester) async {
    await tester.pumpWidget(buildApp(card(onDownload: () {})));

    expect(find.byKey(const ValueKey('digital-card-branding')), findsOneWidget);
    expect(find.byKey(const ValueKey('digital-card-corner-circle')), findsOneWidget);
  });

  testWidgets('WCAG 1.4.3: «Descargar» alcanza 4,5:1 sobre el carnet', (final tester) async {
    double contrast(final Color a, final Color b) {
      final la = a.computeLuminance();
      final lb = b.computeLuminance();
      final (hi, lo) = la > lb ? (la, lb) : (lb, la);
      return (hi + 0.05) / (lo + 0.05);
    }

    await tester.pumpWidget(buildApp(card(onDownload: () {})));

    expect(contrast(downloadColor, AppColors.primaryLight), greaterThanOrEqualTo(4.5));
    final button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.style!.foregroundColor!.resolve(const {}), downloadColor);
    // El foco no pinta un velo que baje el contraste del texto.
    expect(button.style!.overlayColor!.resolve(const {WidgetState.focused}), Colors.transparent);
  });

  testWidgets('WCAG 1.4.11 / 2.4.7: «Descargar» muestra el anillo de foco', (final tester) async {
    await tester.pumpWidget(buildApp(card(onDownload: () {})));
    final ring = find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);
    expect(ring, findsNothing);

    Focus.of(tester.element(find.text('Descargar'))).requestFocus();
    await tester.pumpAndSettle();

    expect(find.ancestor(of: find.text('Descargar'), matching: ring), findsOneWidget);
  });
}

void _noop() {}
