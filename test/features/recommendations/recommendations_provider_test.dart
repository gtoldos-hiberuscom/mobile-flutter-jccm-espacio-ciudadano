import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_repository_provider.dart';

void main() {
  ProviderContainer buildContainer({
    required final ConsentRepository consentRepository,
    final LifeEventsRepository? lifeEventsRepository,
    final RecommendationsRepository? recommendationsRepository,
  }) {
    final container = ProviderContainer(
      overrides: [
        jwtClaimsProvider.overrideWith(
          () => _StubJwtClaimsNotifier(
            const JwtClaims(
              exp: 0,
              iat: 0,
              iss: 'issuer',
              aud: [],
              sub: 'subject',
              subAlt: 'PER1',
            ),
          ),
        ),
        checkAcceptedConsentClauseUsecaseProvider.overrideWithValue(
          CheckAcceptedConsentClauseUsecase(consentRepository),
        ),
        loadLifeEventsUsecaseProvider.overrideWithValue(
          LoadLifeEventsUsecase(lifeEventsRepository ?? _FakeLifeEventsRepository()),
        ),
        if (recommendationsRepository != null) recommendationsRepositoryProvider.overrideWithValue(recommendationsRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('an unanswerable clause check surfaces as AsyncError, never as "sin consentimiento"', () async {
    final container = buildContainer(
      consentRepository: _FakeConsentRepository(error: const ConsentStatusUnknownException(message: 'gateway down')),
    );

    await expectLater(
      container.read(recommendationsProvider(RecommendationsSegment.all).future),
      throwsA(isA<StateError>()),
    );
  });

  test('a genuinely unaccepted clause short-circuits without touching life events', () async {
    final lifeEventsRepository = _FakeLifeEventsRepository();
    final container = buildContainer(
      consentRepository: _FakeConsentRepository(accepted: false),
      lifeEventsRepository: lifeEventsRepository,
    );

    final state = await container.read(recommendationsProvider(RecommendationsSegment.all).future);

    expect(state.hasLifeEventsConsent, isFalse);
    expect(lifeEventsRepository.loadCalls, 0);
  });

  test('with consent granted the recommendations load for the selected life events', () async {
    final recommendationsRepository = _FakeRecommendationsRepository();
    final container = buildContainer(
      consentRepository: _FakeConsentRepository(accepted: true),
      lifeEventsRepository: _FakeLifeEventsRepository(
        events: const [
          LifeEvent(id: 1, label: 'Familia', selected: true),
          LifeEvent(id: 2, label: 'Empleo', selected: false),
        ],
      ),
      recommendationsRepository: recommendationsRepository,
    );

    final state = await container.read(recommendationsProvider(RecommendationsSegment.all).future);

    expect(state.hasLifeEventsConsent, isTrue);
    expect(recommendationsRepository.lastLifeEventIds, [1]);
  });
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}

final class _FakeConsentRepository implements ConsentRepository {
  _FakeConsentRepository({this.accepted, this.error});

  final bool? accepted;
  final Exception? error;

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) async {
    final pendingError = error;
    if (pendingError != null) {
      throw pendingError;
    }
    return accepted!;
  }

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) => throw UnimplementedError();
  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) => throw UnimplementedError();
}

final class _FakeLifeEventsRepository implements LifeEventsRepository {
  _FakeLifeEventsRepository({this.events = const []});

  final List<LifeEvent> events;
  int loadCalls = 0;

  @override
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente}) async {
    loadCalls++;
    return events;
  }

  @override
  Future<void> saveLifeEvents({required final String idAgente, required final List<LifeEvent> events}) => throw UnimplementedError();

  @override
  Future<void> resetPreferences({required final String idAgente}) => throw UnimplementedError();
}

final class _FakeRecommendationsRepository implements RecommendationsRepository {
  List<int>? lastLifeEventIds;

  @override
  Future<List<Recommendation>> loadRecommendations({
    required final String idAgente,
    required final List<int> lifeEventIds,
    required final RecommendationsSegment segment,
  }) async {
    lastLifeEventIds = lifeEventIds;
    return const [];
  }
}
