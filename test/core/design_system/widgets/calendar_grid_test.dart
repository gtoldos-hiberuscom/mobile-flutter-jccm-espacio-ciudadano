import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_calendar.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  group('calendarGridDays', () {
    test('usa semanas completas: 35 o 42 celdas según el mes', () {
      // Marzo, agosto y noviembre de 2026 empiezan tarde en la semana y
      // necesitan seis filas; mayo cabe en cinco.
      expect(calendarGridDays(month: DateTime(2026, 5)), hasLength(35));
      expect(calendarGridDays(month: DateTime(2026, 3)), hasLength(42));
      expect(calendarGridDays(month: DateTime(2026, 8)), hasLength(42));
      expect(calendarGridDays(month: DateTime(2026, 11)), hasLength(42));
    });

    test('pinta todos los días de cada mes de 2026, empiece cuando empiece', () {
      for (var month = 1; month <= 12; month++) {
        final days = calendarGridDays(month: DateTime(2026, month));
        final ofMonth = days.where((final d) => d.month == month && d.year == 2026).map((final d) => d.day).toList();
        expect(
          ofMonth,
          List.generate(DateUtils.getDaysInMonth(2026, month), (final i) => i + 1),
          reason: 'la rejilla de 2026-$month debe contener todos sus días, en orden y sin repetir',
        );
      }
    });

    test('no repite ninguna fecha en el mes del cambio de hora', () {
      // Octubre de 2026: el domingo 25 dura 25 h. Sumar Duration(days: 1)
      // no cambiaba de día y la rejilla repetía el 25.
      final days = calendarGridDays(month: DateTime(2026, 10));

      expect(days.toSet(), hasLength(days.length));
      expect(days.where((final d) => d.month == DateTime.october && d.day == 25), hasLength(1));
    });

    test('todas las celdas son medianoche local, también tras el cambio de hora', () {
      // Las comparaciones de selección y de evento van contra fechas
      // normalizadas a medianoche: una celda a las 23:00 no casaba con ninguna.
      for (final month in [DateTime(2026, 3), DateTime(2026, 10)]) {
        for (final day in calendarGridDays(month: month)) {
          expect(day, DateUtils.dateOnly(day), reason: '$day debería ser medianoche local');
        }
      }
    });

    test('es continua: cada celda es el día civil siguiente a la anterior', () {
      final days = calendarGridDays(month: DateTime(2026, 10));

      for (var i = 1; i < days.length; i++) {
        expect(days[i], DateTime(days[i - 1].year, days[i - 1].month, days[i - 1].day + 1));
      }
    });

    test('respeta el primer día de la semana', () {
      final startingMonday = calendarGridDays(month: DateTime(2026, 3));
      final startingSunday = calendarGridDays(month: DateTime(2026, 3), firstDayOfWeek: DateTime.sunday);

      // 2026-03-01 cae en domingo: con semanas de lunes a domingo hacen falta
      // seis filas y seis días de relleno; empezando en domingo, ninguno.
      expect(startingMonday.first, DateTime(2026, 2, 23));
      expect(startingMonday.first.weekday, DateTime.monday);
      expect(startingMonday, hasLength(42));
      expect(startingSunday.first, DateTime(2026, 3));
      expect(startingSunday.first.weekday, DateTime.sunday);
      expect(startingSunday, hasLength(35));
    });

    test('arranca en el propio día 1 cuando el mes empieza en el primer día de la semana', () {
      // Junio de 2026 empieza en lunes: sin días de relleno por delante.
      final days = calendarGridDays(month: DateTime(2026, 6));

      expect(days.first, DateTime(2026, 6));
      expect(days, hasLength(35));
    });
  });

  group('AppCalendar', () {
    Widget buildApp(final Widget child) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

    testWidgets('pinta y deja seleccionar los últimos días de un mes de seis filas', (final tester) async {
      DateTime? selected;
      await tester.pumpWidget(
        buildApp(
          AppCalendar(
            initialDate: DateTime(2026, 3),
            eventDates: {DateTime(2026, 3, 31)},
            onDateSelected: (final date) => selected = date,
          ),
        ),
      );

      // Con la rejilla fija de 35 celdas, el 30 y el 31 de marzo no existían.
      final last = find.semantics.byLabel(RegExp('31.*marzo.*2026.*con evento'));
      expect(last, findsOne);
      expect(last.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      expect(find.semantics.byLabel(RegExp('30.*marzo.*2026')), findsOne);

      await tester.tap(find.text('31'));
      expect(selected, DateTime(2026, 3, 31));
    });

    testWidgets('no duplica el día del cambio de hora', (final tester) async {
      await tester.pumpWidget(buildApp(AppCalendar(initialDate: DateTime(2026, 10), onDateSelected: (_) {})));

      expect(find.semantics.byLabel(RegExp('25.*octubre.*2026')), findsOne);
      expect(find.text('25'), findsOneWidget);
    });
  });
}
