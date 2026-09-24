import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bottom_sheet.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_calendar.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_list_filter_sheet.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final Locale locale = const Locale('es'),
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  AppListFilterSheet sheet({final AppListFilters filters = const AppListFilters()}) => AppListFilterSheet(
    initialFilters: filters,
    fields: const [
      AppListTextFilterField(
        id: 'description',
        label: 'Descripción',
        hint: 'Introduce palabras',
      ),
      AppListDateRangeFilterField(id: 'date', label: 'Fecha de registro'),
    ],
  );

  testWidgets('agrupa limpiar y aplicar como acciones de filtros', (final tester) async {
    await tester.pumpWidget(buildApp(sheet()));

    expect(find.semantics.byLabel('Acciones de filtros'), findsOneWidget);
    expect(find.text('Limpiar filtros'), findsOneWidget);
    expect(find.text('Aplicar filtros'), findsOneWidget);
  });

  testWidgets('localiza acciones y selector de fechas en inglés', (final tester) async {
    await tester.pumpWidget(buildApp(sheet(), locale: const Locale('en')));

    expect(find.text('Clear filters'), findsOneWidget);
    expect(find.text('Apply filters'), findsOneWidget);
    expect(find.text('Select date range'), findsOneWidget);
  });

  testWidgets('anuncia el rango con fechas pronunciables', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        sheet(
          filters: AppListFilters(
            dateRanges: {
              'date': DateTimeRange(
                start: DateTime(2026, 1, 2),
                end: DateTime(2026, 2, 15),
              ),
            },
          ),
        ),
        locale: const Locale('en'),
      ),
    );

    expect(
      find.semantics.byLabel(
        'Fecha de registro. From January 2, 2026 to February 15, 2026',
      ),
      findsOneWidget,
    );
  });

  testWidgets('aplica el texto introducido y devuelve el resultado', (final tester) async {
    AppListFilters? result;
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            onPressed: () => unawaited(
              AppBottomSheet.show<AppListFilters>(
                context: context,
                title: 'Filtrar resultados',
                body: sheet(),
              ).then((final value) => result = value),
            ),
            child: const Text('Abrir filtros'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir filtros'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  vivienda  ');
    await tester.tap(find.text('Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(result?.text('description'), 'vivienda');
  });

  testWidgets('usa el scroll del modal y no desborda al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            onPressed: () => unawaited(
              AppBottomSheet.show<AppListFilters>(
                context: context,
                title: 'Filtrar resultados disponibles',
                body: sheet(),
              ),
            ),
            child: const Text('Abrir filtros'),
          ),
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    await tester.tap(find.text('Abrir filtros'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBottomSheet), matching: find.byType(SingleChildScrollView)),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('mantiene el modal alto dentro de los márgenes verticales', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(393, 780);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            onPressed: () => unawaited(
              AppBottomSheet.show<AppListFilters>(
                context: context,
                title: 'Filtrar expedientes',
                body: const AppListFilterSheet(
                  initialFilters: AppListFilters(),
                  fields: [
                    AppListTextFilterField(id: 'number', label: 'Número de expediente', hint: 'Introduce el número'),
                    AppListTextFilterField(id: 'description', label: 'Descripción del expediente', hint: 'Introduce palabras'),
                    AppListDateRangeFilterField(id: 'startDate', label: 'Fecha de inicio'),
                    AppListDateRangeFilterField(id: 'endDate', label: 'Fecha de cierre'),
                  ],
                ),
              ),
            ),
            child: const Text('Abrir filtros'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir filtros'));
    await tester.pumpAndSettle();

    final card = find
        .descendant(
          of: find.byType(AppBottomSheet),
          matching: find.byWidgetPredicate(
            (final widget) => widget is Container && widget.decoration is BoxDecoration,
          ),
        )
        .first;
    final cardRect = tester.getRect(card);
    expect(cardRect.top, greaterThanOrEqualTo(32));
    expect(cardRect.bottom, lessThanOrEqualTo(780 - 32));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('muestra las siete columnas del calendario dentro de un modal de 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 700);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            onPressed: () => unawaited(
              AppBottomSheet.show<AppListFilters>(
                context: context,
                title: 'Filtrar resultados',
                body: sheet(),
              ),
            ),
            child: const Text('Abrir filtros'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seleccionar rango de fechas'));
    await tester.pumpAndSettle();

    final sheetRect = tester.getRect(find.byType(AppBottomSheet).last);
    final calendarRect = tester.getRect(find.byType(AppCalendar));
    final sundayRect = tester.getRect(find.text('Dom'));
    expect(calendarRect.left, greaterThan(sheetRect.left));
    expect(calendarRect.right, lessThan(sheetRect.right));
    expect(sundayRect.left, greaterThanOrEqualTo(calendarRect.left));
    expect(sundayRect.right, lessThanOrEqualTo(calendarRect.right));
    expect(tester.takeException(), isNull);
  });
}
