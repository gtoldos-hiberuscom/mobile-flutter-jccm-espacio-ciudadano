import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_config_source.dart';

/// Default mock value returned by [RecommendationsConfigSourceMock].
///
/// Reviewers and demos can flip this constant locally to exercise the
/// onboarding / unauthorised variants without touching tests or wiring
/// a backend. Tests override the source via `ProviderScope.overrides`
/// rather than mutating this constant.
const RecommendationsConfigState kRecommendationsMockConfigState =
    RecommendationsConfigState.configured;

/// In-memory mock of [RecommendationsConfigSource].
///
/// Holds the state in a private field so the page can drive transitions
/// (e.g. unconfigured → configured after the citizen returns from the
/// preferences / consent flow) by calling
/// [markPreferencesAcknowledged] and invalidating the
/// `recommendationsConfigProvider`.
class RecommendationsConfigSourceMock implements RecommendationsConfigSource {
  RecommendationsConfigSourceMock({
    final RecommendationsConfigState initial = kRecommendationsMockConfigState,
  }) : _state = initial;

  RecommendationsConfigState _state;

  /// Test / debug accessor — the current in-memory value.
  RecommendationsConfigState get debugState => _state;

  /// Test / debug setter — mirrors what
  /// [markPreferencesAcknowledged] does but lets callers (and tests)
  /// move to *any* state, not just [RecommendationsConfigState.configured].
  // ignore: use_setters_to_change_properties
  void debugSetState(final RecommendationsConfigState next) {
    _state = next;
  }

  @override
  Future<RecommendationsConfigState> loadState() async => _state;

  @override
  Future<void> markPreferencesAcknowledged() async {
    _state = RecommendationsConfigState.configured;
  }
}
