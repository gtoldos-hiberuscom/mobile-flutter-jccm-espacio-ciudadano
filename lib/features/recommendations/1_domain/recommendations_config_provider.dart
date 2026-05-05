import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_config_source.dart' show RecommendationsConfigSource;
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_config_source_provider.dart';

/// One-shot probe of [RecommendationsConfigState].
///
/// Backed by a [RecommendationsConfigSource] (STORY-57) instead of the
/// list repository so the empty / onboarding logic can evolve
/// independently from the paged list. Invalidate this provider after
/// the citizen completes the preferences / consent flow to pick up the
/// new state.
final recommendationsConfigProvider = FutureProvider<RecommendationsConfigState>(
  (final ref) async {
    final source = ref.watch(recommendationsConfigSourceProvider);
    return source.loadState();
  },
  name: 'recommendationsConfigProvider',
);
