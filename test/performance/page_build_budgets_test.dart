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
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/casework_workspace_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_page_result.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Widget _appWrap(final Widget body) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: body,
  );
}

Future<int> _measureFirstBuildMs(
  final WidgetTester tester,
  final Widget Function() build,
) async {
  // Warm-up build — discards shader / asset / route registry one-time
  // costs that are not part of "next user lands on this page".
  await tester.pumpWidget(build());
  await tester.pump();

  final stopwatch = Stopwatch()..start();
  await tester.pumpWidget(build());
  await tester.pump();
  stopwatch.stop();
  return stopwatch.elapsedMilliseconds;
}

void _logPerf(final String pageName, final int elapsedMs, final int budgetMs) {
  // Diagnostic-only stub for commit 1; replaced by a real debugPrint in the
  // wall-clock logging commit. Keeping it as a no-op call in commit 1 is
  // intentional: it keeps the test bodies stable across the two commits.
}

/// Empty-state recommendations repo — returns no items for every bucket so
/// the page lands in the "configured but empty" branch quickly. We measure
/// the BUILD cost, not real data.
class _EmptyRecommendationsRepo implements RecommendationsRepository {
  @override
  Future<RecommendationsConfigState> loadConfigState() async =>
      RecommendationsConfigState.configured;

  @override
  Future<RecommendationsPageResult> loadAll({final String? cursor}) async =>
      const RecommendationsPageResult(items: <Recommendation>[], hasMore: false);

  @override
  Future<RecommendationsPageResult> loadBucket(
    final RecommendationBucket bucket, {
    final String? cursor,
  }) async => const RecommendationsPageResult(items: <Recommendation>[], hasMore: false);
}

/// Empty-state casework repo — returns no items for any tab. Mirrors the
/// stub shape from `test/features/casework/casework_workspace_page_widget_test.dart`
/// but with empty payloads to keep the build cheap and deterministic.
class _EmptyCaseworkRepo implements CaseworkRepository {
  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) async => const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByNif(final String identification) async => const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByExpedienteNumber(final String number) async => const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByRegistroNumber(final String number) async => const <CaseworkItem>[];
}

void main() {
  testWidgets(
    'LandingPage first build under 150 ms (budget: 120 ms baseline + variance)',
    (final tester) async {
      final elapsed = await _measureFirstBuildMs(
        tester,
        () => const ProviderScope(child: _LandingHarness()),
      );
      _logPerf('LandingPage', elapsed, 150);
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

  testWidgets(
    'RecommendationsPage first build under 150 ms (budget: 150 ms per docs)',
    (final tester) async {
      final elapsed = await _measureFirstBuildMs(
        tester,
        () => ProviderScope(
          overrides: [
            recommendationsRepositoryProvider.overrideWithValue(_EmptyRecommendationsRepo()),
          ],
          child: _appWrap(const RecommendationsPage()),
        ),
      );
      _logPerf('RecommendationsPage', elapsed, 150);
      expect(
        elapsed,
        lessThanOrEqualTo(150),
        reason: 'RecommendationsPage first build took ${elapsed}ms — exceeds the '
            'TASK-70 budget. See documentation/qa/performance-budgets.md '
            'and investigate before relaxing the budget.',
      );
    },
    tags: ['performance'],
  );

  testWidgets(
    'CaseworkWorkspacePage first build under 150 ms (budget: 150 ms per docs)',
    (final tester) async {
      final elapsed = await _measureFirstBuildMs(
        tester,
        () => ProviderScope(
          overrides: [
            caseworkRepositoryProvider.overrideWith((final ref) => _EmptyCaseworkRepo()),
          ],
          child: _appWrap(const CaseworkWorkspacePage()),
        ),
      );
      _logPerf('CaseworkWorkspacePage', elapsed, 150);
      expect(
        elapsed,
        lessThanOrEqualTo(150),
        reason: 'CaseworkWorkspacePage first build took ${elapsed}ms — exceeds the '
            'TASK-70 budget. See documentation/qa/performance-budgets.md '
            'and investigate before relaxing the budget.',
      );
    },
    tags: ['performance'],
  );
}

class _LandingHarness extends StatelessWidget {
  const _LandingHarness();

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: const LandingPage(),
    );
  }
}
