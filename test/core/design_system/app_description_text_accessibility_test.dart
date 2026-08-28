import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('expone la ayuda como información sin rol ni anuncio', (final tester) async {
    await tester.pumpWidget(buildApp(const AppDescriptionText(text: 'Introduce un correo válido')));

    final data = find.semantics.byLabel('Introduce un correo válido').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLiveRegion, isFalse);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.actions, 0);
  });

  testWidgets('localiza y anuncia un error en español', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppDescriptionText(
          text: 'El correo no es válido',
          state: AppDescriptionTextState.error,
        ),
      ),
    );

    final error = find.semantics.byLabel('Error: El correo no es válido').evaluate().single;
    expect(error.flagsCollection.isLiveRegion, isTrue);
    expect(find.semantics.byLabel('El correo no es válido'), findsNothing);
  });

  testWidgets('localiza el error en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppDescriptionText(text: 'Invalid email', state: AppDescriptionTextState.error),
        locale: const Locale('en'),
      ),
    );

    expect(find.semantics.byLabel('Error: Invalid email'), findsOneWidget);
  });

  testWidgets('permite personalizar la etiqueta y desactivar el anuncio', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppDescriptionText(
          text: 'Formato incorrecto',
          state: AppDescriptionTextState.error,
          semanticsLabel: 'Error en el formato del documento',
          announceChanges: false,
        ),
      ),
    );

    final error = find.semantics.byLabel('Error en el formato del documento').evaluate().single;
    expect(error.flagsCollection.isLiveRegion, isFalse);
  });

  testWidgets('no trunca y admite texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppDescriptionText(
            text: 'El documento no se puede adjuntar porque supera el tamaño máximo permitido para este formulario.',
            state: AppDescriptionTextState.error,
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.textContaining('El documento no se puede adjuntar'));
    expect(text.maxLines, isNull);
    expect(text.style!.fontSize, greaterThanOrEqualTo(16));
    expect(tester.takeException(), isNull);
  });
}
