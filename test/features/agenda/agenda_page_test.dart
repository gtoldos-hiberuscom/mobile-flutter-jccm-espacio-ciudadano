import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_page.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_elevation_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _citasSanitariasCaidas = 'No hemos podido cargar tus citas sanitarias.';
const _sinCip = 'No encontramos tu código de identificación personal (CIP) en el Servicio de Salud de Castilla-La Mancha (SESCAM)';
const _eventosCaidos = 'No hemos podido cargar los eventos de tu agenda.';
const _errorTotal = 'No hemos podido cargar tu agenda.';
const _sinCitas = 'No tienes eventos próximos en tu agenda en este momento. Cuando tengas citas o notificaciones importantes, podrás consultarlas aquí.';
const _hospitalariasOcultas = 'Citas hospitalarias ocultas';
const _verificar = 'Verificar';
const _verificacionCompletada = 'Verificación completada';

void main() {
  group('marca «Actualizado…»', () {
    testWidgets('si fue hoy dice «hoy a las HH:MM h»', (final tester) async {
      final now = DateTime.now();
      await _pumpAgenda(tester, appointments: const [], updatedAt: DateTime(now.year, now.month, now.day, 0, 5));
      expect(find.text('Actualizado hoy a las 00:05 h'), findsOneWidget);
    });

    testWidgets('si fue ayer dice «ayer a las HH:MM h»', (final tester) async {
      final yesterday = DateUtils.addDaysToDate(DateUtils.dateOnly(DateTime.now()), -1);
      await _pumpAgenda(tester, appointments: const [], updatedAt: DateTime(yesterday.year, yesterday.month, yesterday.day, 23));
      expect(find.text('Actualizado ayer a las 23:00 h'), findsOneWidget);
    });

    testWidgets('otro día dice «el DD mmm a las HH:MM h», sin año', (final tester) async {
      await _pumpAgenda(tester, appointments: const [], updatedAt: DateTime(2026, 10, 30, 12, 10));
      expect(find.text('Actualizado el 30 oct a las 12:10 h'), findsOneWidget);
    });
  });

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
    // Las citas de primaria no muestran el centro (JCCMEC-274).
    expect(find.textContaining('Centro'), findsNothing);
    expect(find.textContaining('PALOMAREJOS', findRichText: true), findsNothing);
    expect(find.textContaining('palomarejos', findRichText: true), findsNothing);
  });

  testWidgets('un evento con párrafos etiquetados se pinta con título, intro y una fila por etiqueta (JCCMEC-256)', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: [
        AgendaAppointment(
          dateTime: DateTime(2026, 11, 2, 13),
          title: 'Cita de atención hospitalaria',
          description: 'Tiene una cita de atención hospitalaria para el próximo 02/11/2026',
          kind: AgendaAppointmentKind.hospital,
          details: const [
            (label: 'Servicio', value: 'MEDICINA INTERNA'),
            (label: 'Centro', value: 'HOSPITAL UNIVERSITARIO DE TOLEDO'),
            (label: 'Sala', value: 'CONSULTAS B-203'),
          ],
        ),
      ],
    );

    expect(find.text('Cita de atención hospitalaria'), findsOneWidget);
    expect(find.text('Tiene una cita de atención hospitalaria para el próximo 02/11/2026'), findsNothing);
    final hospitalTitle = tester.widget<Text>(find.text('Cita de atención hospitalaria'));
    expect(hospitalTitle.style?.fontSize, AppTypography.bodyBold.fontSize);
    expect(hospitalTitle.style?.fontWeight, AppTypography.bodyBold.fontWeight);
    expect(find.text('Servicio: Medicina interna'), findsOneWidget);
    expect(find.text('Centro: Hospital universitario de toledo'), findsOneWidget);
    expect(find.text('Sala: Consultas B-203'), findsOneWidget);
    expect(find.textContaining('Hora'), findsNothing);
    // Es una cita sanitaria: corazón, no el sobre de las notificaciones.
    expect(find.byWidgetPredicate((final widget) => widget is AppSvgIcon && widget.assetPath == AppIconAssets.health), findsOneWidget);
    expect(find.byWidgetPredicate((final widget) => widget is AppSvgIcon && widget.assetPath == AppIconAssets.mail), findsNothing);
  });

  testWidgets('la cita de primaria publicada por la agenda general usa el mismo diseño por filas que el resto de eventos', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: [
        AgendaAppointment(
          dateTime: DateTime(2026, 10, 19, 14, 6),
          title: 'Cita de atención primaria',
          description: 'Tiene una cita de atención primaria el próximo 19/10/2026',
          kind: AgendaAppointmentKind.health,
          channel: 'Presencial',
          details: const [
            (label: 'Profesional', value: 'CAMPO CRIPTANA MOLINO'),
            (label: 'Tipo de cita', value: 'VACUNA GRIPE'),
            (label: 'Modo de cita', value: 'Presencial'),
          ],
        ),
      ],
    );

    expect(find.text('Cita de atención primaria'), findsOneWidget);
    // Como en hospitalaria, la intro «Tiene una cita…» no se pinta.
    expect(find.text('Tiene una cita de atención primaria el próximo 19/10/2026'), findsNothing);
    expect(find.text('Profesional: Campo criptana molino'), findsOneWidget);
    expect(find.text('Tipo de cita: Vacuna gripe'), findsOneWidget);
    expect(find.text('Modo de cita: Presencial'), findsOneWidget);
    // La jerarquía sanitaria (canal en mayúsculas sobre el profesional) queda
    // para las citas estructuradas de SESCAM.
    expect(find.text('PRESENCIAL'), findsNothing);
    expect(find.text('Campo criptana molino'), findsNothing);
  });

  testWidgets('el usuario sin CIP ve el aviso informativo específico', (final tester) async {
    await _pumpAgenda(
      tester,
      appointments: const [],
      healthCipMissing: true,
    );

    expect(find.textContaining(_sinCip), findsOneWidget);
    expect(find.text(_citasSanitariasCaidas), findsNothing);
    expect(find.text(_sinCitas), findsNothing);
    expect(tester.getTopLeft(find.textContaining(_sinCip)).dy, lessThan(tester.getTopLeft(find.byType(AppCalendar)).dy));
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

  testWidgets('la (i) abre la hoja «Saber más sobre Agenda»', (final tester) async {
    await _pumpAgenda(tester, appointments: const []);

    await tester.tap(find.byTooltip('Saber más sobre Agenda'));
    await tester.pumpAndSettle();

    expect(find.text('Saber más sobre Agenda'), findsWidgets);
    expect(find.textContaining('verifiques tu identidad con un método de seguridad alta'), findsOneWidget);
    expect(find.text('Consultar más información'), findsOneWidget);
  });

  testWidgets('con nivel suficiente no se avisa de citas hospitalarias ocultas', (final tester) async {
    await _pumpAgenda(tester, appointments: const []);

    expect(find.text(_hospitalariasOcultas), findsNothing);
  });

  testWidgets('sin nivel suficiente el aviso va antes del calendario y «Verificar» explica la verificación', (final tester) async {
    await _pumpAgenda(tester, appointments: const [], hospitalAppointmentsLocked: true);

    expect(find.text(_hospitalariasOcultas), findsOneWidget);
    expect(tester.getTopLeft(find.text(_hospitalariasOcultas)).dy, lessThan(tester.getTopLeft(find.byType(AppCalendar)).dy));

    await tester.tap(find.text(_verificar));
    await tester.pumpAndSettle();

    expect(find.text('Verificación de identidad'), findsOneWidget);
  });

  testWidgets('al terminar la verificación con éxito se muestra «Verificación completada»', (final tester) async {
    await _pumpAgenda(tester, appointments: const [], hospitalAppointmentsLocked: true, elevation: _SucceedingElevationNotifier.new);

    await tester.tap(find.text(_verificar));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Acceder a cl@ve'));
    await tester.tap(find.text('Acceder a cl@ve'));
    await tester.pumpAndSettle();

    expect(find.text(_verificacionCompletada), findsOneWidget);
  });

  testWidgets('si se cancela Cl@ve no se anuncia nada y el aviso sigue', (final tester) async {
    await _pumpAgenda(tester, appointments: const [], hospitalAppointmentsLocked: true, elevation: _CancellingElevationNotifier.new);

    await tester.tap(find.text(_verificar));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Acceder a cl@ve'));
    await tester.tap(find.text('Acceder a cl@ve'));
    await tester.pumpAndSettle();

    expect(find.text(_verificacionCompletada), findsNothing);
    expect(find.text(_hospitalariasOcultas), findsOneWidget);
  });
}

class _SucceedingElevationNotifier extends ElevationNotifier {
  @override
  Future<void> elevate({required final AuthenticationLevel minimum}) async {
    state = const ElevationState(outcome: ElevationOutcome.succeeded);
  }
}

class _CancellingElevationNotifier extends ElevationNotifier {
  @override
  Future<void> elevate({required final AuthenticationLevel minimum}) async {
    state = const ElevationState(outcome: ElevationOutcome.cancelled);
  }
}

Future<void> _pumpAgenda(
  final WidgetTester tester, {
  required final List<AgendaAppointment> appointments,
  final Set<AgendaAppointmentSource> failedSources = const {},
  final bool healthCipMissing = false,
  final bool hospitalAppointmentsLocked = false,
  final ElevationNotifier Function()? elevation,
  final DateTime? updatedAt,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (elevation != null) elevationProvider.overrideWith(elevation),
        agendaAppointmentsProvider.overrideWith(
          (final ref) async => AgendaAppointmentsState(
            appointments: appointments,
            updatedAt: updatedAt ?? DateTime(2026, 9, 10),
            hasJccmAuthorization: true,
            failedSources: failedSources,
            healthCipMissing: healthCipMissing,
            hospitalAppointmentsLocked: hospitalAppointmentsLocked,
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
