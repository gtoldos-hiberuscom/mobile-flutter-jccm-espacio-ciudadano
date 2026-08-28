import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_confirmation_state.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('anuncia título y mensaje como encabezado principal', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppConfirmationState(
          title: 'Solicitud enviada',
          message: 'Hemos recibido tu solicitud',
          actionLabel: 'Enviar otra solicitud',
          onAction: () {},
        ),
      ),
    );

    final result = find.semantics.byLabel('Solicitud enviada. Hemos recibido tu solicitud').evaluate().single;
    expect(result.flagsCollection.isHeader, isTrue);
    expect(result.headingLevel, 1);
    expect(result.flagsCollection.isLiveRegion, isTrue);
    expect(find.semantics.byLabel('Solicitud enviada'), findsNothing);
    expect(find.semantics.byLabel('Hemos recibido tu solicitud'), findsNothing);
  });

  testWidgets('mantiene la acción como botón independiente', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppConfirmationState(
          title: 'Solicitud enviada',
          message: 'Hemos recibido tu solicitud',
          actionLabel: 'Enviar otra solicitud',
          onAction: () => taps++,
        ),
      ),
    );

    final action = find.semantics.byLabel('Enviar otra solicitud').evaluate().single.getSemanticsData();
    expect(action.flagsCollection.isButton, isTrue);
    expect(action.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.text('Enviar otra solicitud'));
    expect(taps, 1);
  });

  testWidgets('permite personalizar la etiqueta y desactivar el anuncio', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppConfirmationState(
          title: 'Operación completada',
          message: 'Los cambios se han guardado',
          actionLabel: 'Continuar',
          semanticsLabel: 'Cambios guardados correctamente',
          announceChanges: false,
          onAction: () {},
        ),
      ),
    );

    final result = find.semantics.byLabel('Cambios guardados correctamente').evaluate().single;
    expect(result.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('el icono es decorativo y no crea otra parada semántica', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppConfirmationState(
          title: 'Solicitud enviada',
          message: 'Hemos recibido tu solicitud',
          actionLabel: 'Continuar',
          icon: Icons.warning,
          onAction: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel(RegExp('warning|advertencia', caseSensitive: false)), findsNothing);
  });

  testWidgets('permite desplazarse con texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 320);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppConfirmationState(
            title: 'La solicitud se ha enviado correctamente',
            message: 'Hemos recibido toda la información y enviaremos una confirmación por correo electrónico.',
            actionLabel: 'Enviar una nueva solicitud',
            onAction: () {},
          ),
        ),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
