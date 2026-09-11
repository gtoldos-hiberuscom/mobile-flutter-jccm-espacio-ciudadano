import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/repositories/agenda_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/usecases/load_agenda_appointments_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';

void main() {
  ProviderContainer buildContainer({
    required final ConsentRepository consentRepository,
    final AgendaRepository? agendaRepository,
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
        loadAgendaAppointmentsUsecaseProvider.overrideWithValue(
          LoadAgendaAppointmentsUsecase(agendaRepository ?? _FakeAgendaRepository()),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('an unanswerable authorization check surfaces as AsyncError — the agenda error state becomes reachable', () async {
    final container = buildContainer(
      consentRepository: _FakeConsentRepository(error: const ConsentStatusUnknownException(message: 'gateway down')),
    );

    await expectLater(
      container.read(agendaAppointmentsProvider.future),
      throwsA(isA<StateError>()),
    );
  });

  test('a genuinely unaccepted clause renders the empty state with the authorization flag off', () async {
    final container = buildContainer(consentRepository: _FakeConsentRepository(accepted: false));

    final state = await container.read(agendaAppointmentsProvider.future);

    expect(state.hasJccmAuthorization, isFalse);
    expect(state.appointments, isEmpty);
  });

  test('with authorization granted the appointments load', () async {
    final container = buildContainer(
      consentRepository: _FakeConsentRepository(accepted: true),
      agendaRepository: _FakeAgendaRepository(
        appointments: [
          AgendaAppointment(
            dateTime: DateTime(2026, 9),
            title: 'Cita',
            description: 'Consulta',
            kind: AgendaAppointmentKind.health,
          ),
        ],
      ),
    );

    final state = await container.read(agendaAppointmentsProvider.future);

    expect(state.hasJccmAuthorization, isTrue);
    expect(state.appointments, hasLength(1));
    expect(state.isPartial, isFalse);
    // Sin fuentes caídas el recuento sí se publica: la portada lo pinta.
    expect(state.upcomingAppointmentsCount(DateTime(2026, 8)), 1);
  });

  test('una fuente caída llega como carga parcial y deja el recuento de portada en null', () async {
    // La pantalla sigue viva (no es AsyncError) y la portada, que no puede
    // distinguir "0 citas" de "no las hemos podido contar", recibe null y
    // mantiene visible la tarjeta de próximas citas sin número.
    final container = buildContainer(
      consentRepository: _FakeConsentRepository(accepted: true),
      agendaRepository: _FakeAgendaRepository(
        appointments: [
          AgendaAppointment(
            dateTime: DateTime(2026, 9),
            title: 'Cita',
            description: 'Consulta',
            kind: AgendaAppointmentKind.health,
          ),
        ],
        failedSources: const {AgendaAppointmentSource.health},
      ),
    );

    final state = await container.read(agendaAppointmentsProvider.future);

    expect(state.hasJccmAuthorization, isTrue);
    expect(state.appointments, hasLength(1));
    expect(state.isPartial, isTrue);
    expect(state.failedSources, unorderedEquals(<AgendaAppointmentSource>{AgendaAppointmentSource.health}));
    expect(state.upcomingAppointmentsCount(DateTime(2026, 8)), isNull);
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

final class _FakeAgendaRepository implements AgendaRepository {
  _FakeAgendaRepository({this.appointments = const [], this.failedSources = const {}});

  final List<AgendaAppointment> appointments;
  final Set<AgendaAppointmentSource> failedSources;

  @override
  Future<AgendaAppointmentsSnapshot> loadAppointments({
    required final String documentNumber,
    final String? agentId,
  }) async => AgendaAppointmentsSnapshot(appointments: appointments, failedSources: failedSources);

  @override
  Future<void> refreshEvents({required final String agentId}) async {}
}
