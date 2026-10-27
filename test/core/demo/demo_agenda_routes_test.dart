import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_health_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_agenda_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_my_data_routes.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/agenda_repository_impl.dart';

final _now = DateTime(2026, 10, 16, 10, 30);

Dio _demoDio(final List<DemoRoute> routes, {final String? accessToken}) =>
    Dio(
        BaseOptions(
          baseUrl: 'https://demo.invalid',
          headers: <String, Object?>{if (accessToken != null) 'Authorization': 'Bearer $accessToken'},
        ),
      )
      ..httpClientAdapter = DemoHttpClientAdapter(
        DemoBackend(routes: routes, now: () => _now),
        latency: Duration.zero,
      );

/// Las dos listas, como las registra `DemoBackend.seeded`: la fuente de salud
/// de la agenda es la ruta compartida que vive en `demoMyDataRoutes`.
List<DemoRoute> _allRoutes() => [...demoMyDataRoutes(now: () => _now), ...demoAgendaRoutes(now: () => _now)];

void main() {
  group('demoAgendaRoutes', () {
    test('carga las dos fuentes y deduplica la cita de primaria que publican ambas', () async {
      final repository = AgendaRepositoryImpl(dio: _demoDio(_allRoutes()));

      final snapshot = await repository.loadAppointments(documentNumber: DemoSession.idAgente, agentId: DemoSession.idAgente);

      expect(snapshot.failedSources, isEmpty);
      expect(snapshot.isPartial, isFalse);
      expect(snapshot.healthCipMissing, isFalse);
      // Dos citas de SESCAM más tres eventos, uno de ellos la misma cita de
      // primaria en la misma franja, que se descarta a favor de la de SESCAM.
      expect(snapshot.appointments, hasLength(4));
      expect(snapshot.appointments.where((final appointment) => appointment.kind == AgendaAppointmentKind.health), hasLength(2));
      expect(snapshot.appointments.where((final appointment) => appointment.kind == AgendaAppointmentKind.notification), hasLength(1));
      expect(snapshot.appointments.where((final appointment) => appointment.kind == AgendaAppointmentKind.credential), hasLength(1));
      expect(snapshot.appointments.every((final appointment) => appointment.dateTime.isAfter(_now)), isTrue);

      // Gana la de SESCAM: trae profesional y modo en campos propios.
      final primaryCare = snapshot.appointments.firstWhere((final appointment) => appointment.kind == AgendaAppointmentKind.health);
      expect(primaryCare.title, DemoHealthFixtures.primaryCareProfessional);
      expect(primaryCare.description, 'Cita de Atención Primaria');
      expect(primaryCare.channel, 'Presencial');
      expect(primaryCare.detail, 'Consulta a demanda');
      // El centro llega de SESCAM, pero en primaria no se muestra (JCCMEC-274).
      expect(primaryCare.center, isNull);
    });

    test('la fuente de salud la sirve la ruta compartida de my_data', () async {
      // Solo con las rutas de agenda, SESCAM responde 404 y la agenda lo lee
      // como «sin citas» (no como fuente caída): sobrevive la cita de primaria
      // publicada como evento general, pero las de SESCAM no están.
      final repository = AgendaRepositoryImpl(dio: _demoDio(demoAgendaRoutes(now: () => _now)));

      final snapshot = await repository.loadAppointments(documentNumber: DemoSession.idAgente, agentId: DemoSession.idAgente);

      expect(snapshot.failedSources, isEmpty);
      expect(snapshot.appointments, hasLength(3));
      expect(snapshot.appointments.where((final appointment) => appointment.kind == AgendaAppointmentKind.health), hasLength(1));
    });

    test('sin nivel suficiente no publica la cita hospitalaria', () async {
      final repository = AgendaRepositoryImpl(
        dio: _demoDio(_allRoutes(), accessToken: DemoSession.buildAccessToken(now: _now)),
      );

      final snapshot = await repository.loadAppointments(documentNumber: DemoSession.idAgente, agentId: DemoSession.idAgente);

      expect(snapshot.appointments, hasLength(4));
      expect(snapshot.appointments.where(_isHospital), isEmpty);
    });

    test('con el nivel elevado publica la cita hospitalaria pendiente', () async {
      final repository = AgendaRepositoryImpl(
        dio: _demoDio(
          _allRoutes(),
          accessToken: DemoSession.buildAccessToken(now: _now, level: DemoSession.elevatedLevel),
        ),
      );

      final snapshot = await repository.loadAppointments(documentNumber: DemoSession.idAgente, agentId: DemoSession.idAgente);

      expect(snapshot.appointments, hasLength(5));
      final hospital = snapshot.appointments.singleWhere(_isHospital);
      expect(hospital.dateTime, DemoHealthFixtures.hospitalPendingDate(_now));
    });

    test('refrescar responde y la app puede recargar los eventos', () async {
      final repository = AgendaRepositoryImpl(dio: _demoDio(_allRoutes()));

      await expectLater(repository.refreshEvents(agentId: DemoSession.idAgente), completes);
    });

    test('el segmento {id} acepta cualquier identificador', () async {
      final repository = AgendaRepositoryImpl(dio: _demoDio(_allRoutes()));

      final snapshot = await repository.loadAppointments(documentNumber: DemoSession.personIdentifier, agentId: 'otro-identificador');

      expect(snapshot.failedSources, isEmpty);
      expect(snapshot.appointments, hasLength(4));
    });
  });
}

bool _isHospital(final AgendaAppointment appointment) => appointment.title.toLowerCase().contains('hospitalaria');
