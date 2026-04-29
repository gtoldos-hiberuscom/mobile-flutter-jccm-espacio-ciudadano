import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_config_source.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_config_source_mock.dart';

/// Composition root for the [RecommendationsConfigSource].
///
/// Returns a single in-memory mock instance so that mutations performed
/// through [RecommendationsConfigSource.markPreferencesAcknowledged]
/// survive across reads and the `recommendationsConfigProvider` can
/// observe the transition after invalidation.
///
// TODO(future-sprint): swap for a live implementation once the
//                      preferences / authorisation backend is wired.
final recommendationsConfigSourceProvider = Provider<RecommendationsConfigSource>(
  (final ref) => RecommendationsConfigSourceMock(),
  name: 'recommendationsConfigSourceProvider',
);
