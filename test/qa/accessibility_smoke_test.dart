/// Sprint 7 / STORY-67 — accessibility smoke tests.
///
/// These are NOT a full a11y audit (see
/// `documentation/qa/accessibility-checklist.md` for the matrix and
/// what is automated vs manual). The goal of this file is to catch
/// regressions on the highest-traffic public surface (LandingPage)
/// using Flutter's built-in accessibility guideline matchers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Future<void> _pumpLanding(final WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LandingPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('LandingPage accessibility smoke', () {
    testWidgets('meets Android tap-target guideline', (final tester) async {
      await _pumpLanding(tester);
      final handle = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('meets iOS tap-target guideline', (final tester) async {
      await _pumpLanding(tester);
      final handle = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('meets text-contrast guideline', (final tester) async {
      await _pumpLanding(tester);
      final handle = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('meets labeled-tappable-node guideline', (final tester) async {
      await _pumpLanding(tester);
      final handle = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });
}
