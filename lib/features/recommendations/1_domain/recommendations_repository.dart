import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';

abstract interface class RecommendationsRepository {
  Future<List<Recommendation>> loadRecommendations({
    required final String idAgente,
    required final List<int> lifeEventIds,
  });
}
