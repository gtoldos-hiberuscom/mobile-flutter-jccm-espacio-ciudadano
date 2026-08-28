import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('anuncia mensaje y subtítulo como estado vacío', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const EmptyStateWidget(
          message: 'No hay expedientes',
          subtitle: 'Prueba a cambiar los filtros',
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Sin contenido: No hay expedientes. Prueba a cambiar los filtros').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('marca el mensaje como encabezado de nivel dos', (final tester) async {
    await tester.pumpWidget(
      buildApp(const EmptyStateWidget(message: 'No hay resultados')),
    );

    final heading = tester.getSemantics(find.text('No hay resultados'));
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 2);
  });

  testWidgets('mantiene la acción como control independiente', (final tester) async {
    var presses = 0;
    await tester.pumpWidget(
      buildApp(
        EmptyStateWidget(
          message: 'No hay resultados',
          action: AppButton(
            label: 'Limpiar filtros',
            onPressed: () => presses++,
          ),
        ),
      ),
    );

    final action = find.semantics.byLabel('Limpiar filtros');
    expect(action.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    tester.semantics.tap(action);
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('permite desactivar el anuncio para estados ya presentes', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const EmptyStateWidget(
          message: 'No hay elementos',
          announce: false,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Sin contenido: No hay elementos').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('permite personalizar la etiqueta accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const EmptyStateWidget(
          message: 'Lista vacía',
          semanticsLabel: 'No tienes notificaciones pendientes',
        ),
      ),
    );

    expect(find.semantics.byLabel('No tienes notificaciones pendientes'), findsOneWidget);
  });

  testWidgets('admite texto al 200 por ciento en pantalla estrecha', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          EmptyStateWidget(
            message: 'No se han encontrado resultados para tu búsqueda',
            subtitle: 'Modifica los criterios de búsqueda o elimina alguno de los filtros activos',
            action: AppButton(label: 'Limpiar filtros', onPressed: () {}),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
