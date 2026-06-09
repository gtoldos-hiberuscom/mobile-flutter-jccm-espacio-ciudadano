import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_repository_provider.dart';

final class RecommendationsState {
  const RecommendationsState({
    required this.recommendations,
    required this.selectedLifeEvents,
    required this.updatedAt,
  });

  final List<Recommendation> recommendations;
  final List<String> selectedLifeEvents;
  final DateTime updatedAt;

  bool get hasConfiguredLifeEvents => selectedLifeEvents.isNotEmpty;
}

final recommendationsProvider = FutureProvider.autoDispose<RecommendationsState>((final ref) async {
  final idAgente = ref.watch(jwtClaimsProvider)?.idAgente;
  if (idAgente == null || idAgente.trim().isEmpty) {
    throw StateError('No se ha encontrado el identificador del usuario.');
  }

  final result = await ref.read(loadLifeEventsUsecaseProvider).execute(idAgente: idAgente.trim());

  final lifeEvents = switch (result) {
    LoadLifeEventsSuccess(:final events) => events,
    LoadLifeEventsFailed(:final message) => throw Exception(message),
  };
  final selected = lifeEvents.where((final event) => event.selected).toList(growable: false);
  final selectedLabels = selected.map((final event) => event.label.trim()).where((final label) => label.isNotEmpty).toList(growable: false);
  final selectedIds = selected.map((final event) => event.id).toList(growable: false);
  final recommendations = await ref
      .watch(recommendationsRepositoryProvider)
      .loadRecommendations(
        idAgente: idAgente.trim(),
        lifeEventIds: selectedIds,
      );

  return RecommendationsState(
    recommendations: recommendations,
    selectedLifeEvents: selectedLabels,
    updatedAt: DateTime.now(),
  );
});
