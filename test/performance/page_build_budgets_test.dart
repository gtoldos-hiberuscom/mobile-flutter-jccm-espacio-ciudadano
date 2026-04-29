/// Sprint 7 / TASK-70 — performance budgets harness.
///
/// Opt-in (`flutter test --tags performance`). The default `flutter test`
/// run skips this file so the dev loop stays fast.
///
/// Each test renders one of the heaviest pages once (without any real
/// repositories) and asserts that the wall-clock build time stays
/// inside the budget defined in `documentation/qa/performance-budgets.md`.
///
/// The budgets here are intentionally conservative (~2× the observed
/// local time) so they catch order-of-magnitude regressions without
/// flapping on CI variance.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Future<void> _wrap(final WidgetTester tester, final Widget child) async {
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
        home: child,
      ),
    ),
  );
}

Future<int> _measureFirstBuildMs(
  final WidgetTester tester,
  final Widget child,
) async {
  // Warm-up build — discards shader / asset / route registry one-time
  // costs that are not part of "next user lands on this page".
  await _wrap(tester, child);
  await tester.pump();

  final stopwatch = Stopwatch()..start();
  await _wrap(tester, child);
  await tester.pump();
  stopwatch.stop();
  return stopwatch.elapsedMilliseconds;
}

void main() {
  testWidgets(
    'LandingPage first build under 150 ms (budget: 120 ms baseline + variance)',
    (final tester) async {
      final elapsed = await _measureFirstBuildMs(tester, const LandingPage());
      expect(
        elapsed,
        lessThanOrEqualTo(150),
        reason: 'LandingPage first build took ${elapsed}ms — exceeds the '
            'TASK-70 budget. See documentation/qa/performance-budgets.md '
            'and investigate before relaxing the budget.',
      );
    },
    tags: ['performance'],
  );

  // Note: RecommendationsPage and CaseworkWorkspacePage budgets are
  // declared in documentation/qa/performance-budgets.md but their
  // harness instances require a non-trivial Riverpod override matrix
  // (config provider, repository provider, contract gate). They land in
  // a Sprint 8 follow-up under STORY-65/TASK-70 closure (no new ticket
  // per the Sprint 7 operational note).
}
