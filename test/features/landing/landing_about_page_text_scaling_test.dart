import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_about_page.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// WCAG 1.4.4: «Información y ayuda sobre el espacio» amplía todo su texto,
/// incluido el párrafo descriptivo, y el título de la barra no se recorta.
void main() {
  Widget buildApp({required final TextScaler textScaler}) => ProviderScope(
    overrides: [
      landingProvider.overrideWith(_StaticLandingNotifier.new),
      // La página lee el flag del modo demostración; apagado, como en producción,
      // la barra inferior conserva el único botón que miden estos tests.
      appConfigProvider.overrideWithValue(const AppConfig.fromMap({'DEMO_MODE_ENABLED': 'false'})),
    ],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const LandingAboutPage(),
    ),
  );

  testWidgets('el párrafo descriptivo se amplía al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp(textScaler: TextScaler.noScaling));
    await tester.pump();
    final l10n = AppLocalizations.of(tester.element(find.byType(LandingAboutPage)));
    final paragraph = find.text(l10n.landingAboutBody);
    final baseHeight = tester.getSize(paragraph).height;

    await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
    await tester.pump();

    expect(tester.getSize(paragraph).height, greaterThan(baseHeight * 1.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('el título de la barra ocupa varias líneas sin recortarse', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
    await tester.pump();
    final l10n = AppLocalizations.of(tester.element(find.byType(LandingAboutPage)));
    final title = find.descendant(of: find.byType(AppBar), matching: find.text(l10n.landingAboutPageTitle));

    final titleRect = tester.getRect(title);
    final barRect = tester.getRect(find.byType(AppBar));
    expect(titleRect.height, greaterThan(28 * 2.0));
    expect(titleRect.bottom, lessThanOrEqualTo(barRect.bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('la barra no muestra el icono de información', (final tester) async {
    await tester.pumpWidget(buildApp(textScaler: TextScaler.noScaling));
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.info_outline),
      ),
      findsNothing,
    );
  });
}

class _StaticLandingNotifier extends LandingNotifier {
  @override
  void consumeLoginSuccess() {}

  @override
  Future<void> tryRestoreSession({
    required final String localizedTitle,
    required final String localizedReason,
    required final String localizedCancel,
  }) async {}
}
