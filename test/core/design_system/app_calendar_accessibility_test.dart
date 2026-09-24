import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_calendar.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('expone fechas completas, selección y evento por separado', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCalendar(
          initialDate: DateTime(2026, 5),
          selectedDates: {DateTime(2026, 5, 15)},
          eventDates: {DateTime(2026, 5, 20)},
          onDateSelected: (_) {},
        ),
      ),
    );

    final selected = find.semantics.byLabel(RegExp('15.*mayo.*2026')).evaluate().single.getSemanticsData();
    expect(selected.flagsCollection.isSelected, Tristate.isTrue);
    expect(selected.hasAction(SemanticsAction.tap), isTrue);

    final event = find.semantics.byLabel(RegExp('20.*mayo.*2026.*con evento')).evaluate().single.getSemanticsData();
    expect(event.flagsCollection.isSelected, isNot(Tristate.isTrue));
  });

  testWidgets('deshabilita los días de otros meses y no ejecuta su acción', (final tester) async {
    var selections = 0;
    await tester.pumpWidget(
      buildApp(
        AppCalendar(
          initialDate: DateTime(2026, 5),
          onDateSelected: (_) => selections++,
        ),
      ),
    );

    final outside = find.semantics.byLabel(RegExp('27.*abril.*2026.*fuera del mes mostrado')).evaluate().single.getSemanticsData();
    expect(outside.flagsCollection.isEnabled, Tristate.isFalse);
    expect(outside.hasAction(SemanticsAction.tap), isFalse);
    expect(selections, 0);
  });

  testWidgets('localiza navegación, selector y cambio de mes', (final tester) async {
    DateTime? changedMonth;
    await tester.pumpWidget(
      buildApp(
        AppCalendar(
          initialDate: DateTime(2026, 5),
          onMonthChanged: (final month) => changedMonth = month,
        ),
        locale: const Locale('en'),
      ),
    );

    expect(find.semantics.byLabel('Previous month'), findsOneWidget);
    expect(find.semantics.byLabel('Select month and year, current May 2026'), findsOneWidget);
    final next = find.semantics.byLabel('Next month');
    tester.semantics.tap(next);
    await tester.pump();

    expect(changedMonth, DateTime(2026, 6));
    final month = find.semantics.byLabel('Displayed month: June 2026').evaluate().single;
    expect(month.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('no presenta los días como botones si el calendario es informativo', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppCalendar(initialDate: DateTime(2026, 5))),
    );

    final day = find.semantics.byLabel(RegExp('15.*mayo.*2026')).evaluate().single.getSemanticsData();
    expect(day.flagsCollection.isButton, isFalse);
    expect(day.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('mantiene objetivos de 48 dp en el modo compacto', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCalendar(
          initialDate: DateTime(2026, 5),
          compact: true,
          onDateSelected: (_) {},
        ),
      ),
    );

    final dayText = find.text('15');
    final target = find.ancestor(of: dayText, matching: find.byType(InkWell)).first;
    expect(tester.getSize(target), const Size(48, 48));
    final previousTarget = find.ancestor(
      of: find.byIcon(Icons.chevron_left),
      matching: find.byType(InkWell),
    );
    expect(tester.getSize(previousTarget), const Size(48, 48));
  });

  testWidgets('adapta las siete columnas y el encabezado al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppCalendar(
            initialDate: DateTime(2026, 5),
            compact: true,
            onDateSelected: (_) {},
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (final widget) => widget is SingleChildScrollView && widget.scrollDirection == Axis.horizontal,
      ),
      findsNothing,
    );
    final calendarRect = tester.getRect(find.byType(AppCalendar));
    final sundayRect = tester.getRect(find.text('Dom'));
    expect(sundayRect.right, lessThanOrEqualTo(calendarRect.right));
    expect(sundayRect.left, greaterThanOrEqualTo(calendarRect.left));
    final dayTarget = find.ancestor(of: find.text('15'), matching: find.byType(InkWell)).first;
    expect(tester.getSize(dayTarget).width, lessThan(48));
    expect(tester.getSize(dayTarget).height, 48);
    expect(tester.getTopLeft(find.text('Mayo 2026')).dy, lessThan(tester.getTopLeft(find.byIcon(Icons.chevron_left)).dy));
    expect(tester.takeException(), isNull);
  });

  testWidgets('encaja las siete columnas en la Agenda de 390 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppCalendar(
            initialDate: DateTime(2026, 8),
            eventDates: {DateTime(2026, 8, 14)},
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (final widget) => widget is SingleChildScrollView && widget.scrollDirection == Axis.horizontal,
      ),
      findsNothing,
    );

    final calendarRect = tester.getRect(find.byType(AppCalendar));
    final sundayRect = tester.getRect(find.text('Dom'));
    expect(sundayRect.right, lessThanOrEqualTo(calendarRect.right));
    expect(sundayRect.left, greaterThanOrEqualTo(calendarRect.left));

    final day14 = find.text('14');
    final day14Target = find.ancestor(
      of: day14,
      matching: find.byType(InkWell),
    );
    expect(tester.getSize(day14Target), const Size(48, 48));
    expect(tester.takeException(), isNull);
  });

  testWidgets('usa celdas de 64 dp en tablet sin tocar el modo compacto', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 1100);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: AppCalendar(
            initialDate: DateTime(2026, 8),
            eventDates: {DateTime(2026, 8, 14)},
          ),
        ),
      ),
    );

    final day14Target = find.ancestor(of: find.text('14'), matching: find.byType(InkWell));
    expect(tester.getSize(day14Target), const Size(64, 64));
    expect(tester.widget<Text>(find.text('14')).style?.fontSize, AppTypography.bodyRegular.fontSize);

    await tester.pumpWidget(
      buildApp(
        AppCalendar(
          initialDate: DateTime(2026, 8),
          compact: true,
        ),
      ),
    );
    final compactTarget = find.ancestor(of: find.text('14'), matching: find.byType(InkWell));
    expect(tester.getSize(compactTarget), const Size(48, 48));
    expect(tester.takeException(), isNull);
  });
}
