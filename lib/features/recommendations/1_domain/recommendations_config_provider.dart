import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_provider.dart';

/// One-shot probe of [RecommendationsConfigState].
///
/// STORY-56 only branches on [RecommendationsConfigState.configured];
/// STORY-57 will exercise the other two values to render the
/// onboarding / empty variants.
final recommendationsConfigProvider = FutureProvider<RecommendationsConfigState>(
  (final ref) async {
    final repo = ref.watch(recommendationsRepositoryProvider);
    return repo.loadConfigState();
  },
  name: 'recommendationsConfigProvider',
);
