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
        const AppAlertToast(
          severity: AppAlertSeverity.success,
          message: 'Cambios guardados',
        ),
      ),
    );

    final finder = find.semantics.byLabel('Operación correcta: Cambios guardados');
    expect(finder, findsOneWidget);
    expect(finder.evaluate().single.flagsCollection.isLiveRegion, isTrue);
    expect(find.semantics.byLabel('Cambios guardados'), findsNothing);
  });

  testWidgets('permite personalizar la etiqueta y el anuncio', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAlertToast(
          message: 'Texto visual',
          semanticsLabel: 'Documento copiado al portapapeles',
          announce: false,
        ),
      ),
    );

    final semantics = find.semantics.byLabel('Documento copiado al portapapeles').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('show reutiliza el componente y dura al menos cuatro segundos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            onPressed: () => AppAlertToast.show(
              context,
              message: 'Cambios guardados',
              severity: AppAlertSeverity.success,
            ),
            child: const Text('Mostrar'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mostrar'));
    await tester.pump();

    expect(find.byType(AppAlertToast), findsOneWidget);
    expect(tester.widget<SnackBar>(find.byType(SnackBar)).duration, const Duration(seconds: 4));
  });

  testWidgets('permanece visible durante la duración accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        Builder(
          builder: (final context) => TextButton(
            onPressed: () => AppAlertToast.show(context, message: 'Mensaje temporal'),
            child: const Text('Mostrar'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mostrar'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(AppAlertToast), findsOneWidget);
  });

  testWidgets('admite texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppAlertToast(
            severity: AppAlertSeverity.error,
            message: 'No se ha podido completar la operación solicitada',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
