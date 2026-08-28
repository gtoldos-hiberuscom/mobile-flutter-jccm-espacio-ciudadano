import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_attachment_field.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('asocia etiqueta e instrucción sin convertir el grupo en botón', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppAttachmentField(
          label: 'Documentación',
          hint: 'Archivo PDF de hasta 20 MB',
          pickLabel: 'Seleccionar archivo',
          changeLabel: 'Cambiar archivo',
          onPick: () {},
          onRemove: () {},
        ),
      ),
    );

    final field = find.semantics.byLabel('Documentación. Archivo PDF de hasta 20 MB').evaluate().single.getSemanticsData();
    expect(field.hasAction(SemanticsAction.tap), isFalse);
    expect(find.semantics.byLabel('Seleccionar archivo'), findsOneWidget);
  });

  testWidgets('anuncia obligatoriedad y permite una etiqueta específica', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppAttachmentField(
          label: 'Documentación',
          hint: 'Archivo PDF',
          pickLabel: 'Seleccionar archivo',
          changeLabel: 'Cambiar archivo',
          isRequired: true,
          semanticsLabel: 'Justificante obligatorio en formato PDF',
          onPick: () {},
          onRemove: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Justificante obligatorio en formato PDF'), findsOneWidget);
  });

  testWidgets('anuncia el archivo seleccionado y mantiene acciones separadas', (final tester) async {
    var picks = 0;
    var removals = 0;
    await tester.pumpWidget(
      buildApp(
        AppAttachmentField(
          label: 'Documentación',
          hint: 'Archivo PDF',
          pickLabel: 'Seleccionar archivo',
          changeLabel: 'Cambiar archivo',
          fileName: 'justificante.pdf',
          fileBytes: 2048,
          onPick: () => picks++,
          onRemove: () => removals++,
        ),
      ),
    );

    final status = find.semantics.byLabel('Archivo adjunto: justificante.pdf, 2.0 KB').evaluate().single;
    expect(status.flagsCollection.isLiveRegion, isTrue);
    expect(find.semantics.byLabel('Cambiar archivo'), findsOneWidget);
    expect(find.byTooltip('Eliminar archivo'), findsOneWidget);

    await tester.tap(find.text('Cambiar archivo'));
    await tester.tap(find.byTooltip('Eliminar archivo'));
    expect(picks, 1);
    expect(removals, 1);
  });

  testWidgets('asocia y anuncia el error una sola vez', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppAttachmentField(
          label: 'Documentación',
          hint: 'Archivo PDF',
          pickLabel: 'Seleccionar archivo',
          changeLabel: 'Cambiar archivo',
          errorText: 'El archivo supera el tamaño permitido',
          onPick: () {},
          onRemove: () {},
        ),
      ),
    );

    final error = find.semantics.byLabel('Error, Documentación: El archivo supera el tamaño permitido').evaluate().single;
    expect(error.flagsCollection.isLiveRegion, isTrue);
    expect(find.semantics.byLabel('El archivo supera el tamaño permitido'), findsNothing);
  });

  testWidgets('admite contenido largo al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          AppAttachmentField(
            label: 'Adjuntar documentación justificativa',
            hint: 'Selecciona un archivo PDF con un tamaño máximo permitido de veinte megabytes',
            pickLabel: 'Seleccionar documento justificativo',
            changeLabel: 'Cambiar documento justificativo',
            isExpanded: true,
            hintAfterButton: true,
            onPick: () {},
            onRemove: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
