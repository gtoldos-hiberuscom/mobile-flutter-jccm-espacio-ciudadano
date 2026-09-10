import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/consent_revocation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_guard.dart';

int _revocationSignals = 0;

void main() {
  /// Provider de prueba que ejecuta el guard sobre una consulta que siempre
  /// rechaza por autorización, que es el caso que hay que resolver.
  final probeProvider = FutureProvider.autoDispose<String>((final ref) {
    return withMyDataAuthorizationGuard(
      ref,
      requiredClauseIds: const {requiredConsentClauseId, jccmDataConsentClauseId},
      request: () async => throw const MyDataAuthorizationRequired(),
    );
  });

  ProviderContainer buildContainer(final _FakeConsentRepository repository) {
    final container = ProviderContainer(
      // El reintento con espera creciente de Riverpod haría esperar al test:
      // en producción estos desenlaces se excluyen en cada provider.
      retry: (final _, final _) => null,
      overrides: [
        citizenEndpointIdsProvider.overrideWithValue((numDocumento: 'PER9998003', idAgente: 'PER9998003')),
        resolveAuthorizationFailureUsecaseProvider.overrideWithValue(ResolveAuthorizationFailureUsecase(repository)),
        // El cierre de sesión real necesita medio bootstrap; aquí solo hace
        // falta saber que se pidió.
        consentRevocationProvider.overrideWith(_RecordingRevocationNotifier.new),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Mantiene vivo el provider `autoDispose` mientras se espera su future: la
  /// resolución de la autorización introduce un hueco asíncrono suficiente
  /// para que Riverpod lo tire antes de emitir.
  Future<T> readAlive<T>(final ProviderContainer container, final FutureProvider<T> provider) {
    final subscription = container.listen(provider, (final _, final _) {}, onError: (final _, final _) {});
    addTearDown(subscription.close);
    return container.read(provider.future);
  }

  setUp(() => _revocationSignals = 0);

  test('la cláusula concreta que falta vuelve como MyDataAuthorizationRequired', () async {
    // Es el tipo que las pantallas ya saben pintar con su acción a
    // Preferencias, que es donde se concede.
    final container = buildContainer(
      _FakeConsentRepository(clauses: _clauses({requiredConsentClauseId: true, jccmDataConsentClauseId: false})),
    );

    await expectLater(
      readAlive(container, probeProvider),
      throwsA(isA<MyDataAuthorizationRequired>()),
    );
  });

  test('si no se pudo comprobar, es error reintentable y no una acusación', () async {
    // El gateway falla cerrado: devuelve el mismo sobre cuando no puede leer
    // preferencias. Invitar a autorizar ahí dejaba al ciudadano dando vueltas
    // entre Preferencias y la pantalla.
    final container = buildContainer(
      _FakeConsentRepository(error: const ConsentStatusUnknownException(message: 'clausulas 500', statusCode: 500)),
    );

    await expectLater(
      readAlive(container, probeProvider),
      throwsA(isA<AuthorizationUnknown>()),
    );
  });

  test('la cláusula obligatoria retirada no invita a autorizar: es revocación', () async {
    final container = buildContainer(
      _FakeConsentRepository(clauses: _clauses({requiredConsentClauseId: false, jccmDataConsentClauseId: true})),
    );

    await expectLater(
      readAlive(container, probeProvider),
      throwsA(isA<ConsentRevoked>()),
    );
    expect(_revocationSignals, 1);
  });
}

final class _RecordingRevocationNotifier extends ConsentRevocationNotifier {
  @override
  Future<void> signalRevoked() async {
    _revocationSignals++;
    state = true;
  }
}

List<Clause> _clauses(final Map<int, bool> selection) {
  return [
    for (final entry in selection.entries) Clause(id: entry.key, label: 'Cláusula ${entry.key}', isSelected: entry.value),
  ];
}

final class _FakeConsentRepository implements ConsentRepository {
  _FakeConsentRepository({this.clauses = const [], this.error});

  final List<Clause> clauses;
  final Exception? error;

  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) async {
    final pending = error;
    if (pending != null) {
      throw pending;
    }
    return clauses;
  }

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) async => clauses;

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) => throw UnimplementedError();
}
