/// Sprint 9 / STORY-67 — RecommendationsPage golden (one filter state).
///
/// Captures the *Todos* tab populated with a deterministic non-empty
/// bucket served by an in-memory fake repository. Mirrors the minimal
/// Riverpod-override pattern used by
/// `test/features/recommendations/recommendations_page_widget_test.dart`.
///
/// Update with:
///
///   flutter test --update-goldens \
///     test/qa/goldens/recommendations_list_golden_test.dart
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_page_result.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _GoldenRepo implements RecommendationsRepository {
  const _GoldenRepo();

  @override
  Future<RecommendationsConfigState> loadConfigState() async => RecommendationsConfigState.configured;

  @override
  Future<RecommendationsPageResult> loadAll({final String? cursor}) async => _page;

  @override
  Future<RecommendationsPageResult> loadBucket(
    final RecommendationBucket bucket, {
    final String? cursor,
  }) async => _page;

  static const RecommendationsPageResult _page = RecommendationsPageResult(
    items: <Recommendation>[
      Recommendation(
        id: 'rec-001',
        title: 'Solicitud de ayuda al alquiler',
        summary: 'Tramitación electrónica para residentes.',
        isImmediateProcessing: true,
        responsibleUnit: 'Vivienda',
        deadlineLabel: '30 días',
      ),
      Recommendation(
        id: 'rec-002',
        title: 'Renovación del título de familia numerosa',
        summary: 'Actualiza el carnet vigente.',
        isImmediateProcessing: false,
        responsibleUnit: 'Familia',
        deadlineLabel: 'Hasta 31/12',
      ),
    ],
    hasMore: false,
  );
}

Future<void> _pump(final WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        recommendationsRepositoryProvider.overrideWithValue(
          const _GoldenRepo(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        home: const RecommendationsPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('RecommendationsPage golden — Todos tab populated', (
    final tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pump(tester);
    await expectLater(
      find.byType(RecommendationsPage),
      matchesGoldenFile('recommendations_page_todos.png'),
    );
  });
}
