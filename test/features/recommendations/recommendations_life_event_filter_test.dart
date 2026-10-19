import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendation_life_event_filters_page.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendations_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Filtro por hechos vitales de Recomendaciones (JCCMEC-257).
///
/// Revisión del cliente del 08/10: con un hecho filtrado, «Desmarcar todos» +
/// «Aplicar filtros» dejaba el listado vacío y obligaba a «Reiniciar filtro»
/// para volver a ver las recomendaciones. Una selección vacía tiene que
/// equivaler a «sin filtro».
void main() {
  const independence = RecommendationLifeEventOption(id: 1, label: 'Me gustaría independizarme');
  const housing = RecommendationLifeEventOption(id: 2, label: 'Quiero mejorar mi vivienda');

  final recommendations = [
    Recommendation(id: '1-10', title: 'Ayuda al alquiler para jóvenes', lifeEventId: independence.id, lifeEventName: independence.label, badges: const {}),
    Recommendation(id: '1-11', title: 'Bono de emancipación', lifeEventId: independence.id, lifeEventName: independence.label, badges: const {}),
    Recommendation(id: '2-20', title: 'Rehabilitación de vivienda', lifeEventId: housing.id, lifeEventName: housing.label, badges: const {}),
  ];
  final independenceTitles = recommendations.where((final r) => r.lifeEventId == independence.id).map((final r) => r.title).toList(growable: false);
  final housingTitles = recommendations.where((final r) => r.lifeEventId == housing.id).map((final r) => r.title).toList(growable: false);

  GoRouter buildRouter() => GoRouter(
    initialLocation: Routes.recommendations,
    routes: [
      GoRoute(path: Routes.recommendations, builder: (final _, final _) => const RecommendationsPage()),
      GoRoute(
        path: Routes.recommendationLifeEventFilters,
        builder: (final _, final state) => RecommendationLifeEventFiltersPage(args: state.extra! as RecommendationLifeEventFiltersArgs),
      ),
    ],
  );

  Widget buildApp() => ProviderScope(
    overrides: [
      recommendationsProvider.overrideWith(
        (final ref, final segment) async => RecommendationsState(
          recommendations: recommendations,
          selectedLifeEvents: [independence.label, housing.label],
          selectedLifeEventOptions: const [independence, housing],
          hasLifeEventsConsent: true,
          updatedAt: DateTime(2026, 10, 16),
        ),
      ),
    ],
    child: MaterialApp.router(
      routerConfig: buildRouter(),
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );

  AppLocalizations l10nOf(final WidgetTester tester) => AppLocalizations.of(tester.element(find.byType(RecommendationsPage)));

  Future<void> openFilters(final WidgetTester tester) async {
    await tester.tap(find.byType(AppFilterButton));
    await tester.pumpAndSettle();
    expect(find.byType(RecommendationLifeEventFiltersPage), findsOneWidget);
  }

  Future<void> applyFilters(final WidgetTester tester) async {
    await tester.tap(find.widgetWithText(AppButton, 'Aplicar filtros'));
    await tester.pumpAndSettle();
    expect(find.byType(RecommendationLifeEventFiltersPage), findsNothing);
  }

  void expectTitles(final Iterable<String> visible, final Iterable<String> hidden) {
    for (final title in visible) {
      expect(find.text(title), findsOneWidget, reason: '«$title» debería verse');
    }
    for (final title in hidden) {
      expect(find.text(title), findsNothing, reason: '«$title» no debería verse');
    }
  }

  testWidgets('tras «Desmarcar todos» + «Aplicar filtros» vuelven a verse todas las recomendaciones sin pasar por «Reiniciar filtro»', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    final l10n = l10nOf(tester);
    expectTitles([...independenceTitles, ...housingTitles], const []);

    // 1. Filtrar por «Me gustaría independizarme»: solo sus trámites.
    await openFilters(tester);
    await tester.tap(find.widgetWithText(AppSelectableFilterChip, independence.label));
    await tester.pump();
    await applyFilters(tester);
    expectTitles(independenceTitles, housingTitles);
    expect(find.text('${l10n.recommendationsFilterByLifeEvents} (1)'), findsOneWidget);

    // 2. «Desmarcar todos» + «Aplicar filtros»: equivale a no filtrar.
    await openFilters(tester);
    await tester.tap(find.widgetWithText(AppButton, l10n.lifeEventsClearAllAction));
    await tester.pump();
    await applyFilters(tester);

    expectTitles([...independenceTitles, ...housingTitles], const []);
    expect(find.text(l10n.recommendationsEmptyFiltered), findsNothing);
    expect(find.text(l10n.recommendationsResetFilterCta), findsNothing);
    expect(find.text(l10n.recommendationsFilterByLifeEvents), findsOneWidget);
    expect(find.text('${l10n.recommendationsFilterByLifeEvents} (1)'), findsNothing);
  });

  testWidgets('desmarcar los hechos vitales no cambia la pestaña de segmento elegida', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    final l10n = l10nOf(tester);

    await tester.tap(find.text(l10n.recommendationsTabNew));
    await tester.pumpAndSettle();

    await openFilters(tester);
    await tester.tap(find.widgetWithText(AppSelectableFilterChip, housing.label));
    await tester.pump();
    await applyFilters(tester);
    expectTitles(housingTitles, independenceTitles);

    await openFilters(tester);
    await tester.tap(find.widgetWithText(AppButton, l10n.lifeEventsClearAllAction));
    await tester.pump();
    await applyFilters(tester);

    expectTitles([...independenceTitles, ...housingTitles], const []);
    final newsTab = find.semantics.byLabel(l10n.recommendationsTabNew).evaluate().single.getSemanticsData();
    expect(newsTab.flagsCollection.isSelected, Tristate.isTrue, reason: 'la pestaña «Novedades» debe seguir seleccionada');
  });
}
