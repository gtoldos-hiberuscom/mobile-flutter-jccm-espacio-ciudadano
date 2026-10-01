import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  final recommendations = [
    for (var i = 1; i <= 6; i++)
      Recommendation(
        id: '$i',
        title: 'Trámite recomendado $i',
        lifeEventId: 1,
        lifeEventName: 'Quiero mejorar mi vivienda',
        badges: const {},
        detailUrl: Uri.parse('https://www.jccm.es/tramite/$i'),
      ),
  ];

  Widget buildApp({final TextScaler textScaler = TextScaler.noScaling}) => ProviderScope(
    overrides: [
      recommendationsProvider.overrideWith(
        (final ref, final segment) async => RecommendationsState(
          recommendations: recommendations,
          selectedLifeEvents: const ['Quiero mejorar mi vivienda'],
          selectedLifeEventOptions: const [],
          hasLifeEventsConsent: true,
          updatedAt: DateTime(2026, 9),
        ),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const RecommendationsPage(),
    ),
  );

  Finder ring() => find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);

  testWidgets('WCAG 2.1.1: el tabulador recorre todas las recomendaciones y las trae a la vista', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final reached = <String>{};
    for (var i = 0; i < 40 && reached.length < recommendations.length; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      for (final recommendation in recommendations) {
        final title = find.text(recommendation.title);
        final isInside = find.descendant(of: find.byWidget(focused.widget), matching: title).evaluate().isNotEmpty;
        if (isInside) {
          reached.add(recommendation.title);
          // Visible en pantalla y con el anillo de foco (2.4.7).
          final rect = tester.getRect(title);
          expect(rect.top, greaterThanOrEqualTo(0));
          expect(rect.bottom, lessThanOrEqualTo(667));
          expect(find.ancestor(of: title, matching: ring()), findsOneWidget);
        }
      }
    }
    expect(reached, recommendations.map((final r) => r.title).toSet());
  });

  testWidgets('WCAG 4.1.2: las recomendaciones se anuncian como enlace externo', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final data = find.semantics.byLabel(RegExp('Trámite recomendado 1')).evaluate().first.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hint, 'Abre en navegador externo');
  });

  testWidgets('WCAG 4.1.2: los filtros anuncian rol, estado y posición sobre los cuatro', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((final w) => w is Semantics && w.properties.role == SemanticsRole.tabBar),
      findsOneWidget,
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(RecommendationsPage)));
    final all = find.semantics.byLabel(l10n.recommendationsTabAll).evaluate().single.getSemanticsData();
    expect(all.value, 'Pestaña 1 de 4');

    // Tras pasar al segundo grupo, «Trámite inmediato» es la pestaña 4 de 4.
    await tester.tap(find.byTooltip(l10n.recommendationsTabImmediate));
    await tester.pumpAndSettle();
    final immediate = find.semantics.byLabel(l10n.recommendationsTabImmediate).evaluate().single.getSemanticsData();
    expect(immediate.value, 'Pestaña 4 de 4');
  });

  testWidgets('WCAG 2.5.1: al 200 por ciento los cuatro filtros se ven sin deslizar ni flechas', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp(textScaler: const TextScaler.linear(2)));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(RecommendationsPage)));

    for (final label in [l10n.recommendationsTabAll, l10n.recommendationsTabRecent, l10n.recommendationsTabNew, l10n.recommendationsTabImmediate]) {
      final rect = tester.getRect(find.text(label));
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(375));
    }
    expect(find.byTooltip(l10n.recommendationsTabImmediate), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
