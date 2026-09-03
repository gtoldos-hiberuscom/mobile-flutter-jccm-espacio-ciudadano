import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_repository_provider.dart';

final class RecommendationLifeEventOption {
  const RecommendationLifeEventOption({
    required this.id,
    required this.label,
  });

  final int id;
  final String label;
}

final class RecommendationsState {
  const RecommendationsState({
    required this.recommendations,
    required this.selectedLifeEvents,
    required this.selectedLifeEventOptions,
    required this.hasLifeEventsConsent,
    required this.updatedAt,
  });

  final List<Recommendation> recommendations;
  final List<String> selectedLifeEvents;
  final List<RecommendationLifeEventOption> selectedLifeEventOptions;
  final bool hasLifeEventsConsent;
  final DateTime updatedAt;

  bool get hasConfiguredLifeEvents => selectedLifeEvents.isNotEmpty;
}

final recommendationsProvider = FutureProvider.autoDispose.family<RecommendationsState, RecommendationsSegment>((final ref, final segment) async {
  // Antes leía `idAgente` directamente del token, saltándose
  // `citizenEndpointIdsProvider`. Con el gateway eso mandaba `PER…` en la ruta
  // mientras el resto de la app mandaba `sub_alt`, y las tres llamadas de esta
  // pantalla —cláusula, hechos y recomendaciones— respondían 403.
  final normalizedIdAgente = ref.watch(citizenEndpointIdsProvider).requireIdAgente();

  final consentResult = await ref
      .read(checkAcceptedConsentClauseUsecaseProvider)
      .execute(
        idAgente: normalizedIdAgente,
        clauseId: recommendationsConsentClauseId,
      );
  final hasLifeEventsConsent = switch (consentResult) {
    AcceptedConsentClauseStatus(:final isAccepted) => isAccepted,
    // AsyncError, nunca "sin consentimiento": el estado de autorización solo
    // puede afirmarse con respuesta del backend (mismo patrón que la rama
    // LoadLifeEventsFailed de más abajo).
    CheckAcceptedConsentClauseFailed(:final message) => throw StateError(message),
  };
  if (!hasLifeEventsConsent) {
    return RecommendationsState(
      recommendations: const [],
      selectedLifeEvents: const [],
      selectedLifeEventOptions: const [],
      hasLifeEventsConsent: false,
      updatedAt: DateTime.now(),
    );
  }

  final result = await ref.read(loadLifeEventsUsecaseProvider).execute(idAgente: normalizedIdAgente);

  final lifeEvents = switch (result) {
    LoadLifeEventsSuccess(:final events) => events,
    LoadLifeEventsFailed(:final message) => throw Exception(message),
  };
  final selected = lifeEvents.where((final event) => event.selected).toList(growable: false);
  final selectedLabels = selected.map((final event) => event.label.trim()).where((final label) => label.isNotEmpty).toList(growable: false);
  final selectedOptions = selected
      .map(
        (final event) => RecommendationLifeEventOption(
          id: event.id,
          label: event.label.trim(),
        ),
      )
      .where((final option) => option.label.isNotEmpty)
      .toList(growable: false);
  final selectedIds = selected.map((final event) => event.id).toList(growable: false);
  final recommendations = await ref
      .watch(recommendationsRepositoryProvider)
      .loadRecommendations(
        idAgente: normalizedIdAgente,
        lifeEventIds: selectedIds,
        segment: segment,
      );

  return RecommendationsState(
    recommendations: recommendations,
    selectedLifeEvents: selectedLabels,
    selectedLifeEventOptions: selectedOptions,
    hasLifeEventsConsent: true,
    updatedAt: DateTime.now(),
  );
});
