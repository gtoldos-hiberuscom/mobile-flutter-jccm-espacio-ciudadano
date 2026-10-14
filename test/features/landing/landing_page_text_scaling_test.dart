import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// WCAG 1.4.4: la pantalla previa al acceso debe admitir el texto del sistema
/// al 200 % sin encoger los logotipos ni perder contenido.
void main() {
  Widget buildApp({required final TextScaler textScaler}) => ProviderScope(
    overrides: [landingProvider.overrideWith(_StaticLandingNotifier.new)],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const LandingPage(),
    ),
  );

  testWidgets('al 200 por ciento el logotipo conserva su tamaño y el eslogan se amplía', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp(textScaler: TextScaler.noScaling));
    await tester.pump();
    final l10n = AppLocalizations.of(tester.element(find.byType(LandingPage)));
    final taglineFinder = find.text(l10n.landingTagline);
    final baseTaglineHeight = tester.getSize(taglineFinder).height;
    final baseLogoSize = tester.getSize(find.byType(SvgPicture).first);

    await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
    await tester.pump();

    expect(tester.getSize(find.byType(SvgPicture).first), baseLogoSize);
    expect(tester.getSize(taglineFinder).height, greaterThan(baseTaglineHeight * 1.5));
    expect(find.ancestor(of: find.byType(SvgPicture).first, matching: find.byType(SingleChildScrollView)), findsOneWidget);
    expect(find.semantics.byLabel(l10n.a11yCastillaLogoLabel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('las tres acciones siguen alcanzables al 200 por ciento en una pantalla pequeña', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
    await tester.pump();
    final l10n = AppLocalizations.of(tester.element(find.byType(LandingPage)));

    for (final label in [l10n.landingHelpLink, l10n.landingAboutButton, l10n.landingCtaButton]) {
      expect(find.semantics.byLabel(label), findsOneWidget);
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.text(label));
      expect(rect.top, greaterThanOrEqualTo(0));
      expect(rect.bottom, lessThanOrEqualTo(667));
    }
    expect(tester.takeException(), isNull);
  });
}

class _StaticLandingNotifier extends LandingNotifier {
  @override
  void consumeLoginSuccess() {}

  /// Neutralizado: la landing intenta reanudar la sesión guardada al montarse,
  /// lo que arrastraría el almacén seguro y `AppConfig` a un test de layout.
  @override
  Future<void> tryRestoreSession({
    required final String localizedTitle,
    required final String localizedReason,
    required final String localizedCancel,
  }) async {}
}
