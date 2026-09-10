import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_page.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('agrupa las citas bajo un único encabezado mensual y una lista', (final tester) async {
    final semantics = tester.ensureSemantics();
    final appointment = AgendaAppointment(
      dateTime: DateTime(2026, 9, 15, 10, 30),
      title: 'Cita sanitaria',
      description: 'Consulta de atención primaria',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          agendaAppointmentsProvider.overrideWith(
            (final ref) async => AgendaAppointmentsState(
              appointments: [appointment],
              updatedAt: DateTime(2026, 9),
              hasJccmAuthorization: true,
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

    final pending = find.semantics.byLabel('Citas pendientes').evaluate().single;
    expect(pending.flagsCollection.isHeader, isTrue);
    expect(pending.headingLevel, 2);

    final month = find.semantics.byLabel('septiembre de 2026').evaluate().single;
    expect(month.flagsCollection.isHeader, isTrue);
    expect(month.headingLevel, 3);
    expect(find.semantics.byLabel('septiembre'), findsNothing);
    expect(find.semantics.byLabel('2026'), findsNothing);

    expect(
      find.byWidgetPredicate(
        (final widget) => widget is Semantics && widget.properties.role == SemanticsRole.list,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (final widget) => widget is Semantics && widget.properties.role == SemanticsRole.listItem,
      ),
      findsOneWidget,
    );

    semantics.dispose();
  });
}
