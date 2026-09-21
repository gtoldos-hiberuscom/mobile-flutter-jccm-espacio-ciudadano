import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/accept_consent_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/load_clauses_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/save_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_usecase_providers.dart';

void main() {
  late _FakeConsentRepository repository;
  late _FakeLifeEventsRepository lifeEventsRepository;
  late List<String> callLog;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        loadClausesUsecaseProvider.overrideWithValue(LoadClausesUsecase(repository)),
        acceptConsentUsecaseProvider.overrideWithValue(AcceptConsentUsecase(repository)),
        loadLifeEventsUsecaseProvider.overrideWithValue(LoadLifeEventsUsecase(lifeEventsRepository)),
        saveLifeEventsUsecaseProvider.overrideWithValue(SaveLifeEventsUsecase(lifeEventsRepository)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    callLog = [];
    repository = _FakeConsentRepository()..callLog = callLog;
    lifeEventsRepository = _FakeLifeEventsRepository(callLog);
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

    test('a failed catalogue load surfaces as loadError and retryLoadClauses recovers', () async {
      repository.fetchError = const ConsentStatusUnknownException(message: 'clausulas endpoint unavailable');
      final container = buildContainer();
      final subscription = container.listen(consentProvider('PER1'), (final _, final _) {});
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(consentProvider('PER1')).status, ConsentStatus.loadError);

      repository
        ..fetchError = null
        ..clauses = const [Clause(id: 0, label: 'Protección de datos', isSelected: false)];
      await container.read(consentProvider('PER1').notifier).retryLoadClauses();

      final state = container.read(consentProvider('PER1'));
      expect(state.status, ConsentStatus.step1Locked);
      expect(state.clauses, hasLength(1));
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

  group('ConsentNotifier revocación de la cláusula de recomendaciones desde Preferencias', () {
    const editingClauses = [
      Clause(id: requiredConsentClauseId, label: 'Protección de datos', isSelected: true),
      Clause(id: recommendationsConsentClauseId, label: 'Recomendaciones', isSelected: true),
    ];

    Future<ConsentNotifier> enterEditingAndRevoke(final ProviderContainer container) async {
      final subscription = container.listen(consentProvider('PER1'), (final _, final _) {});
      addTearDown(subscription.close);
      final notifier = container.read(consentProvider('PER1').notifier);
      await notifier.enterPreferencesEditing();
      notifier.toggleClause(recommendationsConsentClauseId);
      return notifier;
    }

    test('limpia los hechos vitales deseleccionándolos (nunca DELETE /preferencias) y ANTES de persistir las cláusulas', () async {
      repository.clauses = editingClauses;
      lifeEventsRepository.events = const [
        LifeEvent(id: 1, label: 'Nacimiento', selected: true),
        LifeEvent(id: 2, label: 'Matrimonio', selected: false),
      ];
      final container = buildContainer();
      final notifier = await enterEditingAndRevoke(container);

      await notifier.accept(persistSession: false);

      final state = container.read(consentProvider('PER1'));
      expect(state.status, ConsentStatus.accepted);
      expect(
        lifeEventsRepository.resetCalls,
        isEmpty,
        reason: 'DELETE /preferencias arrasa el soporte entero del ciudadano en el gateway (cláusulas incluidas) y lo deja irrecuperable',
      );
      expect(lifeEventsRepository.saveCalls.single.every((final event) => !event.selected), isTrue);
      expect(
        callLog,
        ['loadLifeEvents', 'saveLifeEvents', 'markConsentAccepted'],
        reason: 'la limpieza va antes del PATCH de cláusulas, con la autorización de recomendaciones todavía viva en el backend',
      );
    });

    test('si la limpieza de hechos falla, las cláusulas no se tocan y el estado queda reintentable', () async {
      repository.clauses = editingClauses;
      lifeEventsRepository
        ..events = const [LifeEvent(id: 1, label: 'Nacimiento', selected: true)]
        ..saveError = Exception('hechos endpoint unavailable');
      final container = buildContainer();
      final notifier = await enterEditingAndRevoke(container);

      await notifier.accept(persistSession: false);

      final state = container.read(consentProvider('PER1'));
      expect(state.status, ConsentStatus.saveError);
      expect(repository.markCalls, isEmpty, reason: 'con la limpieza fallida no se persiste nada: reintentar parte de un estado íntegro');
    });

    test('sin hechos seleccionados no hay nada que limpiar y las cláusulas se persisten igual', () async {
      repository.clauses = editingClauses;
      lifeEventsRepository.events = const [LifeEvent(id: 1, label: 'Nacimiento', selected: false)];
      final container = buildContainer();
      final notifier = await enterEditingAndRevoke(container);

      await notifier.accept(persistSession: false);

      final state = container.read(consentProvider('PER1'));
      expect(state.status, ConsentStatus.accepted);
      expect(lifeEventsRepository.saveCalls, isEmpty);
      expect(repository.markCalls, hasLength(1));
    });
  });
}

final class _FakeConsentRepository implements ConsentRepository {
  Exception? fetchError;
  List<Clause> clauses = const [];
  List<String>? callLog;
  final List<List<Clause>> markCalls = [];

  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) => fetchClauses(idAgente: idAgente);

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
    callLog?.add('markConsentAccepted');
    markCalls.add(clauses);
  }

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();
}

final class _FakeLifeEventsRepository implements LifeEventsRepository {
  _FakeLifeEventsRepository(this._callLog);

  final List<String> _callLog;
  List<LifeEvent> events = const [];
  Exception? saveError;
  final List<List<LifeEvent>> saveCalls = [];
  final List<String> resetCalls = [];

  @override
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente}) async {
    _callLog.add('loadLifeEvents');
    return events;
  }

  @override
  Future<void> saveLifeEvents({required final String idAgente, required final List<LifeEvent> events}) async {
    _callLog.add('saveLifeEvents');
    final pendingError = saveError;
    if (pendingError != null) {
      throw pendingError;
    }
    saveCalls.add(events);
  }

  @override
  Future<void> resetPreferences({required final String idAgente}) async {
    _callLog.add('resetPreferences');
    resetCalls.add(idAgente);
  }
}
