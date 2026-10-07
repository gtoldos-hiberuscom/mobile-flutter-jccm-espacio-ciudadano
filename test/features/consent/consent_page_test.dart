import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/pages/consent_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('the information action opens the authorizations help sheet', (final tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (final context) => TextButton(
            onPressed: () => showConsentAuthorizationsInfoSheet(context),
            child: const Text('Información'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Información'));
    await tester.pumpAndSettle();

    expect(
      find.text('Saber más sobre Condiciones de uso y autorización'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Si no autorizas el uso de tus datos, las Administraciones públicas no podrán mostrarte la información que tienen sobre ti.',
      ),
      findsOneWidget,
    );
    expect(find.text('Cerrar'), findsOneWidget);
  });

  group('consentAcceptedDestination', () {
    test('opens life-events onboarding after first login when recommendations are accepted', () {
      final destination = consentAcceptedDestination(
        isOnboarding: true,
        isPreferencesEditing: false,
        returnTo: Routes.home,
        clauses: const [
          Clause(
            id: recommendationsConsentClauseId,
            label: 'Recomendaciones',
            isSelected: true,
          ),
        ],
      );

      expect(destination, Routes.lifeEventsOnboarding);
    });

    test('opens home after first login when recommendations are not accepted', () {
      final destination = consentAcceptedDestination(
        isOnboarding: true,
        isPreferencesEditing: false,
        returnTo: Routes.home,
        clauses: const [
          Clause(
            id: recommendationsConsentClauseId,
            label: 'Recomendaciones',
            isSelected: false,
          ),
        ],
      );

      expect(destination, Routes.home);
    });

    test('does not reopen onboarding outside the first-login flow', () {
      final destination = consentAcceptedDestination(
        isOnboarding: false,
        isPreferencesEditing: false,
        returnTo: Routes.home,
        clauses: const [
          Clause(
            id: recommendationsConsentClauseId,
            label: 'Recomendaciones',
            isSelected: true,
          ),
        ],
      );

      expect(destination, Routes.home);
    });

    test('keeps the requested return route when editing preferences', () {
      final destination = consentAcceptedDestination(
        isOnboarding: false,
        isPreferencesEditing: true,
        returnTo: Routes.myData,
        clauses: const [],
      );

      expect(destination, Routes.myData);
    });
  });
}
