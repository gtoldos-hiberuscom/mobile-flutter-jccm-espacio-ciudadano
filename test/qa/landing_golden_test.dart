/// Sprint 7 / STORY-67 — golden baseline (curated set).
///
/// We intentionally keep the golden surface area small (≤10 goldens)
/// to limit maintenance burden. Each golden captures a stable visual
/// state on a fixed device size with the AppLocalizations baseline.
///
/// Update goldens with:
///
///   flutter test --update-goldens test/qa/goldens/
///
/// Goldens live next to their tests under `goldens/` for easy diffing.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Future<void> _pumpLanding(final WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: LandingPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('LandingPage golden — phone portrait', (final tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpLanding(tester);
    await expectLater(
      find.byType(LandingPage),
      matchesGoldenFile('goldens/landing_page_phone_portrait.png'),
    );
  });
}
