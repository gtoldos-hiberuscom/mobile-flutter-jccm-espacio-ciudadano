import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/accept_consent_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/load_clauses_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';

void main() {
  late _FakeConsentRepository repository;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        loadClausesUsecaseProvider.overrideWithValue(LoadClausesUsecase(repository)),
        acceptConsentUsecaseProvider.overrideWithValue(AcceptConsentUsecase(repository)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    repository = _FakeConsentRepository();
  });

  group('ConsentNotifier P-04 guard', () {
    test('accept() without clause 0 in the catalogue blocks instead of POSTing an incomplete payload', () async {
      repository.fetchError = const ConsentStatusUnknownException(message: 'clausulas endpoint unavailable');
      final container = buildContainer();
      final subscription = container.listen(consentProvider('PER1'), (final _, final _) {});
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero); // flush the initial _loadClauses microtask

      await container.read(consentProvider('PER1').notifier).accept(persistSession: false);

      final state = container.read(consentProvider('PER1'));
      expect(state.status, ConsentStatus.saveError);
      expect(state.errorMessage, consentClauseCatalogueUnavailable);
      expect(repository.markCalls, isEmpty, reason: 'a payload without clause $requiredConsentClauseId must never reach the backend');
    });

    test('accept() recovers when the catalogue reload succeeds', () async {
      repository.fetchError = const ConsentStatusUnknownException(message: 'clausulas endpoint unavailable');
      final container = buildContainer();
      final subscription = container.listen(consentProvider('PER1'), (final _, final _) {});
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero);

      repository
        ..fetchError = null
        ..clauses = const [
          Clause(id: 0, label: 'Protección de datos', isSelected: false),
          Clause(id: 1, label: 'Hechos JCCM', isSelected: false),
        ];
      await container.read(consentProvider('PER1').notifier).accept(persistSession: false);

      final state = container.read(consentProvider('PER1'));
      expect(state.status, ConsentStatus.accepted);
      expect(
        repository.markCalls.single.any((final clause) => clause.id == requiredConsentClauseId && clause.isSelected),
        isTrue,
      );
    });
  });
}

final class _FakeConsentRepository implements ConsentRepository {
  Exception? fetchError;
  List<Clause> clauses = const [];
  final List<List<Clause>> markCalls = [];

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) async {
    final pendingError = fetchError;
    if (pendingError != null) {
      throw pendingError;
    }
    return clauses;
  }

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) async {
    markCalls.add(clauses);
  }

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();
}
