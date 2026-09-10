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
  });
}

Future<void> _pumpAgenda(
  final WidgetTester tester, {
  required final List<AgendaAppointment> appointments,
  final Set<AgendaAppointmentSource> failedSources = const {},
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
