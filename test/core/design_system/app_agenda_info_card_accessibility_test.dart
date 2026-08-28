import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_agenda_info_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('resume una notificación en un único nodo no interactivo', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAgendaInfoCard(
          type: AppAgendaInfoCardType.notification,
          day: '11',
          weekday: 'martes',
          time: '23:32',
          title: 'Caducidad de notificación',
          primaryText: 'Asunto: Gestión electrónica',
        ),
      ),
    );

    final card = find.semantics
        .byLabel(
          'Notificación: 11, martes, 23:32, Caducidad de notificación, Asunto: Gestión electrónica',
        )
        .evaluate()
        .single
        .getSemanticsData();
    expect(card.hasAction(SemanticsAction.tap), isFalse);
    expect(find.semantics.byLabel('Caducidad de notificación'), findsNothing);
  });

  testWidgets('localiza el tipo de las variantes sanitaria y acreditación', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const Column(
          children: [
            AppAgendaInfoCard(
              type: AppAgendaInfoCardType.health,
              day: '13',
              weekday: 'jueves',
              time: '9:00',
              title: 'Cita médica',
            ),
            AppAgendaInfoCard(
              type: AppAgendaInfoCardType.credential,
              day: '12',
              weekday: 'miércoles',
              title: 'Carnet de familia numerosa',
            ),
          ],
        ),
      ),
    );

    expect(find.semantics.byLabel('Cita sanitaria: 13, jueves, 9:00, Cita médica'), findsOneWidget);
    expect(
      find.semantics.byLabel(
        'Caducidad de acreditación: 12, miércoles, Carnet de familia numerosa',
      ),
      findsOneWidget,
    );
  });

  testWidgets('usa tipos accesibles en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAgendaInfoCard(
          type: AppAgendaInfoCardType.health,
          day: '13',
          weekday: 'Thursday',
          title: 'Primary care appointment',
        ),
        locale: const Locale('en'),
      ),
    );

    expect(
      find.semantics.byLabel(
        'Healthcare appointment: 13, Thursday, Primary care appointment',
      ),
      findsOneWidget,
    );
  });

  testWidgets('permite proporcionar un resumen accesible específico', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAgendaInfoCard(
          type: AppAgendaInfoCardType.credential,
          day: '12',
          weekday: 'miércoles',
          title: 'Carnet',
          semanticsLabel: 'El carnet caduca el miércoles 12',
        ),
      ),
    );

    expect(find.semantics.byLabel('El carnet caduca el miércoles 12'), findsOneWidget);
  });

  testWidgets('reordena fecha y contenido con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppAgendaInfoCard(
            type: AppAgendaInfoCardType.health,
            day: '13',
            weekday: 'jueves',
            time: '9:00',
            title: 'Cita de atención primaria con enfermería',
            primaryText: 'Centro de salud de referencia',
          ),
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('jueves')).dy,
      lessThan(tester.getCenter(find.text('Cita de atención primaria con enfermería')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
