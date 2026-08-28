import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('anuncia severidad y mensaje en una única región activa', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertSnackbar(
          severity: AppAlertSeverity.error,
          message: 'No se han podido guardar los cambios',
        ),
      ),
    );

    final alert = find.semantics.byLabel('Error: No se han podido guardar los cambios');
    expect(alert, findsOneWidget);
    expect(alert.evaluate().single.flagsCollection.isLiveRegion, isTrue);
    expect(find.semantics.byLabel('No se han podido guardar los cambios'), findsNothing);
  });

  testWidgets('mantiene la acción como control independiente y de 48 dp', (final tester) async {
    var presses = 0;
    await tester.pumpWidget(
      buildApp(
        AppAlertSnackbar(
          message: 'Se ha eliminado el elemento',
          actionLabel: 'Deshacer',
          onAction: () => presses++,
        ),
      ),
    );

    final action = find.semantics.byLabel('Deshacer');
    expect(action.evaluate().single.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    expect(tester.getSize(find.widgetWithText(TextButton, 'Deshacer')).height, greaterThanOrEqualTo(48));
    tester.semantics.tap(action);
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('permite personalizar la etiqueta y desactivar el anuncio', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertSnackbar(
          message: 'Texto visual',
          semanticsLabel: 'El documento ya estaba guardado',
          announce: false,
        ),
      ),
    );

    final alert = find.semantics.byLabel('El documento ya estaba guardado').evaluate().single;
    expect(alert.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('show reutiliza el componente y conserva cinco segundos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            onPressed: () => AppAlertSnackbar.show(context, message: 'Cambios guardados'),
            child: const Text('Mostrar'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mostrar'));
    await tester.pump();

    expect(find.byType(AppAlertSnackbar), findsOneWidget);
    expect(tester.widget<SnackBar>(find.byType(SnackBar)).duration, const Duration(seconds: 5));
  });

  testWidgets('cambia a columna con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppAlertSnackbar(
            message: 'No se ha podido completar la operación solicitada',
            actionLabel: 'Volver a intentar',
            onAction: () {},
          ),
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('No se ha podido completar la operación solicitada')).dy,
      lessThan(tester.getCenter(find.text('Volver a intentar')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
