import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/pages/consent_page.dart';

void main() {
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
