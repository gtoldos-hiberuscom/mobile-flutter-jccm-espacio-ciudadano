import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/localization/localization.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_empty_variant.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/widgets/recommendations_empty_view.dart';

GoRouter _routerFor(final Widget child) => GoRouter(
  initialLocation: '/host',
  routes: [
    GoRoute(path: '/host', builder: (final c, final s) => child),
    GoRoute(
      path: Routes.preferencesConsent,
      builder: (final c, final s) => const Scaffold(body: Text('PREFERENCES_CONSENT_PAGE')),
    ),
  ],
);

Widget _wrap(final Widget child) {
  final router = _routerFor(child);
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalization.delegates,
    supportedLocales: AppLocalization.supportedLocales,
    locale: const Locale('es'),
  );
}

void main() {
  testWidgets('unconfigured variant shows title + both CTAs and primary CTA navigates to preferences', (
    final tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Scaffold(
          body: RecommendationsEmptyView(
            variant: RecommendationsEmptyVariant.unconfigured,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Aún no tienes recomendaciones personalizadas'),
      findsOneWidget,
    );
    expect(find.text('Configurar mis preferencias'), findsOneWidget);
    expect(find.text('Ver mis hechos vitales'), findsOneWidget);

    await tester.tap(find.text('Configurar mis preferencias'));
    await tester.pumpAndSettle();
    expect(find.text('PREFERENCES_CONSENT_PAGE'), findsOneWidget);
  });

  testWidgets('unconfigured secondary CTA shows the coming-soon SnackBar fallback', (
    final tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Scaffold(
          body: RecommendationsEmptyView(
            variant: RecommendationsEmptyVariant.unconfigured,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ver mis hechos vitales'));
    await tester.pump(); // Surface the SnackBar.
    expect(
      find.text('Mis hechos vitales estará disponible próximamente'),
      findsOneWidget,
    );
  });

  testWidgets('unauthorised variant shows title and primary CTA navigates to preferences', (
    final tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Scaffold(
          body: RecommendationsEmptyView(
            variant: RecommendationsEmptyVariant.unauthorised,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Falta autorizar tus preferencias'), findsOneWidget);
    expect(find.text('Revisar consentimientos'), findsOneWidget);

    await tester.tap(find.text('Revisar consentimientos'));
    await tester.pumpAndSettle();
    expect(find.text('PREFERENCES_CONSENT_PAGE'), findsOneWidget);
  });

  testWidgets('configuredButEmpty variant fires onSeeAll when secondary CTA is tapped', (
    final tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        Scaffold(
          body: RecommendationsEmptyView(
            variant: RecommendationsEmptyVariant.configuredButEmpty,
            onSeeAll: () => taps++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Todo listo, sin novedades por ahora'), findsOneWidget);
    expect(find.text('Ver todos'), findsOneWidget);

    await tester.tap(find.text('Ver todos'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('configuredButEmpty hides the secondary CTA when onSeeAll is null', (
    final tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Scaffold(
          body: RecommendationsEmptyView(
            variant: RecommendationsEmptyVariant.configuredButEmpty,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Todo listo, sin novedades por ahora'), findsOneWidget);
    expect(find.text('Ver todos'), findsNothing);
  });
}
