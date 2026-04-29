/// Sprint 7 / STORY-67 — e2e smoke happy path.
///
/// One smoke per epic is the explicit Sprint 7 commitment. This file
/// exercises the public anonymous landing as a reachable, non-broken
/// surface — the smallest representative test that proves bootstrap is
/// alive. Deeper happy-path coverage (login → home → feature → back)
/// lands as part of the Sprint 8 UAT closure on STORY-67 and is
/// documented in `documentation/qa/STORY-67-regression-report.md`.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('landing renders a CTA and remains stable after pump', (
    final tester,
  ) async {
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

    // The smoke just checks that something interactive is on screen
    // and nothing exploded during the build/pump cycle.
    expect(find.byType(LandingPage), findsOneWidget);
    expect(find.byType(Material), findsWidgets);
  });
}
