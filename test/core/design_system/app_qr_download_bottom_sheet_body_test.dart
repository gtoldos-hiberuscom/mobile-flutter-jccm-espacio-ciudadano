import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('blocks every format and shows feedback while downloading', (
    final tester,
  ) async {
    var pkPassPresses = 0;
    var pdfPresses = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppQrDownloadBottomSheetBody(
            downloadingFormat: 'PKPASS',
            onPkPassPressed: () => pkPassPresses++,
            onPdfPressed: () => pdfPresses++,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Descargando Cartera digital'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Descargando Cartera digital'));
    await tester.tap(find.bySemanticsLabel('Descargar PDF'));
    await tester.pump();

    expect(pkPassPresses, 0);
    expect(pdfPresses, 0);
  });

  Widget buildSheet() => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: AppQrDownloadBottomSheetBody(
        onPkPassPressed: () {},
      ),
    ),
  );

  testWidgets('labels the pass button after the platform wallet app', (final tester) async {
    await tester.pumpWidget(buildSheet());

    const expectedLabel = 'Cartera digital';
    expect(find.text(expectedLabel), findsOneWidget);
    expect(find.bySemanticsLabel('Descargar $expectedLabel'), findsOneWidget);
    expect(find.text('PKPASS'), findsNothing);
  }, variant: const TargetPlatformVariant({TargetPlatform.android, TargetPlatform.iOS}));

  testWidgets('labels QR consistently on Android and iOS', (final tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppQrDownloadBottomSheetBody(onQrPressed: () {}),
        ),
      ),
    );

    expect(find.text('Código QR'), findsOneWidget);
    expect(find.bySemanticsLabel('Descargar Código QR'), findsOneWidget);
  }, variant: const TargetPlatformVariant({TargetPlatform.android, TargetPlatform.iOS}));

  testWidgets('does not highlight a format when multiple downloads are available', (final tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppQrDownloadBottomSheetBody(
            onQrPressed: () {},
            onPkPassPressed: () {},
            onPdfPressed: () {},
          ),
        ),
      ),
    );

    final buttons = tester.widgetList<OutlinedButton>(find.byType(OutlinedButton));
    for (final button in buttons) {
      expect(button.style?.backgroundColor?.resolve({}), AppColors.backgroundWhite);
    }
  });

  testWidgets('keeps every download action visible on a short viewport', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 600);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppBottomSheet(
            body: AppQrDownloadBottomSheetBody(
              onQrPressed: () {},
              onPkPassPressed: () {},
              onPdfPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Descargar PDF').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
