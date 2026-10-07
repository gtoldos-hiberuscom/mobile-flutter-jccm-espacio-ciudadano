import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_page.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _citasSanitariasCaidas = 'No hemos podido cargar tus citas sanitarias.';
const _sinCip = 'En el servicio del SESCAM no existe ningún CIP vinculado a su identidad. Puede que no podamos mostrar esta información ahora. Inténtelo de nuevo más tarde.';
const _eventosCaidos = 'No hemos podido cargar los eventos de tu agenda.';
const _errorTotal = 'No hemos podido cargar tu agenda.';
const _sinCitas = 'No hay citas para el periodo seleccionado.';

void main() {
  testWidgets('con una fuente caída se pintan las citas que sí llegaron y un aviso que nombra la que falta', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: [
        AgendaAppointment(
          dateTime: DateTime(2030, 6, 15, 9),
          title: 'Registro',
          description: 'Trámite administrativo',
        ),
      ],
      failedSources: const {AgendaAppointmentSource.health},
    );

    expect(find.text('Registro'), findsOneWidget);
    expect(find.text(_citasSanitariasCaidas), findsOneWidget);
    // La degradación no debe llevarse por delante la pantalla entera.
    expect(find.text(_errorTotal), findsNothing);
  });

  testWidgets('la fuente de eventos caída se nombra por su cuenta', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: [
        AgendaAppointment(
          dateTime: DateTime(2030, 6, 15, 9),
          title: 'Consulta',
          description: 'Cita sanitaria',
          kind: AgendaAppointmentKind.health,
        ),
      ],
      failedSources: const {AgendaAppointmentSource.general},
    );

    expect(find.text(_eventosCaidos), findsOneWidget);
    expect(find.text(_citasSanitariasCaidas), findsNothing);
  });

  testWidgets('sin fuentes caídas no hay ningún aviso', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: [
        AgendaAppointment(
          dateTime: DateTime(2030, 6, 15, 9),
          title: 'Registro',
          description: 'Trámite administrativo',
        ),
      ],
    );

    expect(find.byType(AppAlertContextual), findsNothing);
  });

  testWidgets('la notificación muestra título, asunto y unidad emisora', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: [
        AgendaAppointment(
          dateTime: DateTime(2030, 6, 11, 23, 30),
          title: 'Caducidad de notificación',
          description: 'Asunto: Gestión electrónica de la Contratación',
          detail: 'Servicio de contratación electrónica y registros',
        ),
      ],
    );

    expect(find.text('Caducidad de notificación'), findsOneWidget);
    expect(find.text('Asunto: Gestión electrónica de la Contratación'), findsOneWidget);
    expect(find.text('Servicio de contratación electrónica y registros'), findsOneWidget);
  });

  testWidgets('la cita de primaria sigue la jerarquía de contenido de Figma', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: [
        AgendaAppointment(
          dateTime: DateTime(2026, 9, 25, 10),
          title: 'ALVARO NOMBRE LARGO GARCIA BULERO',
          description: 'Cita de Atención Primaria',
          kind: AgendaAppointmentKind.health,
          channel: 'Presencial',
          detail: 'Consulta a demanda',
          center: 'C.S. PALOMAREJOS_PREN',
        ),
      ],
    );

    expect(find.text('Cita de Atención Primaria'), findsOneWidget);
    expect(find.text('PRESENCIAL'), findsOneWidget);
    expect(find.text('Alvaro nombre largo garcia bulero'), findsOneWidget);
    expect(find.text('Consulta a demanda'), findsOneWidget);
    expect(find.text('C.S. PALOMAREJOS_PREN'), findsNothing);
  });

  testWidgets('el usuario sin CIP ve el aviso informativo específico', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: const [],
      healthCipMissing: true,
    );

    expect(find.text(_sinCip), findsOneWidget);
    expect(find.text(_citasSanitariasCaidas), findsNothing);
    expect(find.text(_sinCitas), findsNothing);
    expect(tester.getTopLeft(find.text(_sinCip)).dy, lessThan(tester.getTopLeft(find.byType(AppCalendar)).dy));
  });

  testWidgets('si la fuente que sobrevive no trae nada, el aviso sustituye al estado vacío', (final tester) async {
    // Decir "no hay citas" cuando no hemos podido mirarlo todo sería mentira.
    await _pumpAgenda(
      tester,
      appointments: const [],
      failedSources: const {AgendaAppointmentSource.general},
    );

    expect(find.text(_eventosCaidos), findsOneWidget);
    expect(find.text(_sinCitas), findsNothing);
  });

  testWidgets('sin citas y sin fallos sí se dice que el periodo está vacío', (final tester) async {
    await _pumpAgenda(tester, appointments: const []);

    expect(find.text(_sinCitas), findsOneWidget);
    expect(tester.getTopLeft(find.text(_sinCitas)).dy, lessThan(tester.getTopLeft(find.byType(AppCalendar)).dy));
  });
}

Future<void> _pumpAgenda(
  final WidgetTester tester, {
  required final List<AgendaAppointment> appointments,
  final Set<AgendaAppointmentSource> failedSources = const {},
  final bool healthCipMissing = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        agendaAppointmentsProvider.overrideWith(
          (final ref) async => AgendaAppointmentsState(
            appointments: appointments,
            updatedAt: DateTime(2026, 9, 10),
            hasJccmAuthorization: true,
            failedSources: failedSources,
            healthCipMissing: healthCipMissing,
          ),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AgendaPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
