import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_feature_flags.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_mock.dart';

/// Composition root for the recommendations repository.
///
/// While [kRecommendationsLiveBackendEnabled] stays `false`, the mock
/// backed by `recommendations_repository_mock.dart` is wired. Tests
/// override this provider with their own fakes via
/// `ProviderScope.overrides`.
///
// TODO(future-sprint): wire RecommendationsRepositoryHttp once 7.1 / 7.2
//                      endpoints are confirmed (TASK-58 OP-1..OP-4) and
//                      `idAgente` extraction (OP-5) is finalised.
final recommendationsRepositoryProvider = Provider<RecommendationsRepository>(
  (final ref) {
    if (kRecommendationsLiveBackendEnabled) {
      throw UnimplementedError(
        'Live RecommendationsRepository is not wired yet. '
        'See TASK-58 §D6 and recommendations_feature_flags.dart.',
      );
    }
    return RecommendationsRepositoryMock();
  },
  name: 'recommendationsRepositoryProvider',
);
