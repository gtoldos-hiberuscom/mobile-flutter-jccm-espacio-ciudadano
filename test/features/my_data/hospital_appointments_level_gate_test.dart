import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level_required.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';

/// El requisito de citas hospitalarias (JCCM, septiembre de 2026, apartados 4 y
/// 5) exige nivel `substantial` y obliga a bloquear por debajo. Lo que estos
/// tests fijan es que el bloqueo ocurre **antes de la red** y que no se
/// confunde con la falta de clausulado, que se arregla en otro sitio.
void main() {
  late _SpyHealthRepository repository;

  setUp(() => repository = _SpyHealthRepository());

  ProviderContainer buildContainer({
    required final String? authNLevel,
    final bool clauseAccepted = true,
  }) {
    // El guard de cláusulas es reactivo: se dispara con el 403 de la fachada,
    // no comprobando antes. Para simular la cláusula retirada hay que hacer que
    // el repositorio rechace, que es lo que ocurre de verdad.
    repository.rejectsWithoutAuthorization = !clauseAccepted;
    final container = ProviderContainer(
      // La misma política que monta `bootstrap.dart`. Sin esto, Riverpod 3
      // reintenta sola cualquier `Exception` lanzada por un provider —los
      // `Error` no—, así que el bloqueo por nivel se quedaba reintentando y el
      // futuro no resolvía nunca. En la app real ya está desactivado.
      retry: (final _, final _) => null,
      overrides: [
        jwtClaimsProvider.overrideWith(
          () => _StubJwtClaimsNotifier(
            JwtClaims(
              exp: 0,
              iat: 0,
              iss: 'issuer',
              aud: const [],
              sub: 'subject',
              subAlt: 'PER1',
              idAgente: 'PER1',
              authNLevelRaw: authNLevel,
            ),
          ),
        ),
        checkAcceptedConsentClauseUsecaseProvider.overrideWithValue(
          CheckAcceptedConsentClauseUsecase(_FakeConsentRepository(accepted: clauseAccepted)),
        ),
        myDataHealthRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Los providers de citas son `autoDispose`: sin una suscripción viva,
  /// Riverpod los destruye antes de que el futuro complete y el test ve un
  /// `StateError` de disposición en vez del resultado real.
  Future<List<HospitalAppointment>> readHospital(
    final ProviderContainer container, [
    final HealthAppointmentFilter filter = HealthAppointmentFilter.pending,
  ]) {
    final subscription = container.listen(
      myDataHospitalAppointmentsProvider(filter),
      (final _, final _) {},
      // Sin esto, el error del provider se relanza a la zona del test y lo
      // tumba antes de que `expectLater` pueda mirarlo. Aquí solo retenemos.
      onError: (final _, final _) {},
    );
    addTearDown(subscription.close);
    return container.read(myDataHospitalAppointmentsProvider(filter).future);
  }

  test('substantial reaches the service', () async {
    final container = buildContainer(authNLevel: 'substantial');

    final appointments = await readHospital(container);

    expect(appointments, hasLength(1));
    expect(repository.hospitalCalls, 1);
  });

  test('a level above the minimum also reaches the service', () async {
    final container = buildContainer(authNLevel: 'high');

    await readHospital(container);

    expect(repository.hospitalCalls, 1);
  });

  // Lo que se prueba aquí no es solo que falle, sino que **no sale la
  // petición**: el gate es local y corre antes de la red.
  test('a low level blocks before the request is made', () async {
    final container = buildContainer(authNLevel: 'low');

    await expectLater(
      readHospital(container),
      throwsA(
        isA<AuthenticationLevelRequired>()
            .having((final e) => e.current, 'current', const KnownAuthenticationLevel(AuthenticationLevel.low, 'low'))
            .having((final e) => e.minimum, 'minimum', AuthenticationLevel.substantial),
      ),
    );
    expect(repository.hospitalCalls, isZero);
  });

  test('a missing claim blocks, and says so distinguishably', () async {
    final container = buildContainer(authNLevel: null);

    await expectLater(
      readHospital(container),
      throwsA(
        isA<AuthenticationLevelRequired>().having((final e) => e.current, 'current', const MissingAuthenticationLevel()),
      ),
    );
    expect(repository.hospitalCalls, isZero);
  });

  test('an unreadable literal blocks instead of granting by default', () async {
    final container = buildContainer(authNLevel: 'enhanced');

    await expectLater(
      readHospital(container),
      throwsA(
        isA<AuthenticationLevelRequired>().having((final e) => e.current, 'current', const UnknownAuthenticationLevel('enhanced')),
      ),
    );
    expect(repository.hospitalCalls, isZero);
  });

  // Con nivel suficiente la petición sale y el rechazo por clausulado sigue su
  // propio camino: lo importante aquí es que el guard de nivel no se lo come ni
  // lo disfraza. La resolución del clausulado en sí ya la cubre
  // `my_data_authorization_guard_test.dart`.
  test('with enough level, a clause rejection is not reported as a level problem', () async {
    final container = buildContainer(authNLevel: 'substantial', clauseAccepted: false);

    await expectLater(
      readHospital(container),
      throwsA(isNot(isA<AuthenticationLevelRequired>())),
    );
    expect(repository.hospitalCalls, 1);
  });

  // Fija el orden decidido: con las dos cosas pendientes gana el nivel, porque
  // es el único que no puede equivocarse por una caída del backend.
  test('when both are missing, the level wins', () async {
    final container = buildContainer(authNLevel: 'low', clauseAccepted: false);

    await expectLater(
      readHospital(container),
      throwsA(isA<AuthenticationLevelRequired>()),
    );
    expect(repository.hospitalCalls, isZero);
  });

  // Primaria no tiene este requisito: gatearla habría roto una consulta que hoy
  // funciona con cualquier nivel.
  test('primary care is not gated by the level', () async {
    final container = buildContainer(authNLevel: 'low');

    await container.read(myDataPrimaryCarePendingAppointmentsProvider.future);

    expect(repository.primaryCareCalls, 1);
  });
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}

final class _SpyHealthRepository implements MyDataHealthRepository {
  int hospitalCalls = 0;
  int primaryCareCalls = 0;

  /// Simula el 403 con el que la fachada señala la cláusula no aceptada.
  bool rejectsWithoutAuthorization = false;

  @override
  Future<String?> loadCip({required final String citizenId}) async => 'CIP';

  @override
  Future<List<HealthAppointment>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  }) async {
    primaryCareCalls++;
    return const [];
  }

  @override
  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  }) async {
    hospitalCalls++;
    if (rejectsWithoutAuthorization) {
      throw const MyDataAuthorizationRequired();
    }
    return [
      HospitalAppointment(
        dateTime: DateTime(2026, 2, 3, 11, 40),
        service: 'TRAUMATOLOGIA',
        provision: 'CONSULTA SUCESIVA',
      ),
    ];
  }
}

final class _FakeConsentRepository implements ConsentRepository {
  _FakeConsentRepository({required this.accepted});

  final bool accepted;

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) async => accepted;

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
