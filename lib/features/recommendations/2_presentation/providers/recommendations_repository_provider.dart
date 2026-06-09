import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_impl.dart';

final recommendationsRepositoryProvider = Provider<RecommendationsRepository>((final ref) {
  return RecommendationsRepositoryImpl(dio: ref.watch(dioProvider));
});
