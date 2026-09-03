import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_file_upload.dart';
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
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  AppFileUpload upload(
    final AppFileUploadStatus status, {
    final VoidCallback? onCancel,
    final VoidCallback? onRemove,
    final VoidCallback? onDelete,
    final VoidCallback? onRetry,
  }) => AppFileUpload(
    fileName: 'documento_acreditativo.pdf',
    fileInfo: 'PDF, 245 KB',
    status: status,
    progress: 0.45,
    onCancel: onCancel,
    onRemove: onRemove,
    onDelete: onDelete,
    onRetry: onRetry,
  );

  testWidgets('resume archivo y estado en un nodo vivo', (final tester) async {
    await tester.pumpWidget(buildApp(upload(AppFileUploadStatus.uploading)));

    final node = find.semantics.byLabel('Archivo: documento_acreditativo.pdf, PDF, 245 KB. Estado: Subiendo').evaluate().single;
    expect(node.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('mantiene cada acción como botón independiente', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(upload(AppFileUploadStatus.error, onRetry: () => taps++)),
    );

    final retry = find.semantics.byLabel('Reintentar');
    final data = retry.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);

    tester.semantics.tap(retry);
    expect(taps, 1);
  });

  testWidgets('localiza estado y acciones predeterminadas en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        upload(AppFileUploadStatus.uploaded, onDelete: () {}),
        locale: const Locale('en'),
      ),
    );

    expect(
      find.semantics.byLabel(
        'File: documento_acreditativo.pdf, PDF, 245 KB. Status: Uploaded',
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('Delete file'), findsOneWidget);
  });

  testWidgets('todas las acciones conservan un objetivo mínimo de 48 dp', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        Column(
          children: [
            upload(AppFileUploadStatus.uploading, onCancel: () {}),
            upload(AppFileUploadStatus.complete, onRemove: () {}),
            upload(AppFileUploadStatus.uploaded, onDelete: () {}),
            upload(AppFileUploadStatus.error, onRetry: () {}),
          ],
        ),
      ),
    );

    final controls = <Finder>[
      find.widgetWithText(TextButton, 'Cancelar'),
      find.widgetWithText(TextButton, 'Eliminar'),
      find.byTooltip('Eliminar archivo'),
      find.widgetWithText(TextButton, 'Reintentar'),
    ];
    for (final control in controls) {
      expect(tester.getSize(control).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(control).height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('la tarjeta en error ofrece reintentar y eliminar por separado', (final tester) async {
    var reintentos = 0;
    var borrados = 0;
    await tester.pumpWidget(
      buildApp(upload(AppFileUploadStatus.error, onRetry: () => reintentos++, onDelete: () => borrados++)),
    );

    final reintentar = find.widgetWithText(TextButton, 'Reintentar');
    final eliminar = find.byTooltip('Eliminar archivo');
    for (final control in [reintentar, eliminar]) {
      expect(tester.getSize(control).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(control).height, greaterThanOrEqualTo(48));
    }

    await tester.tap(eliminar);
    expect(borrados, 1);
    expect(reintentos, 0);
  });

  testWidgets('la tarjeta en error sin acción de borrado no la pinta', (final tester) async {
    await tester.pumpWidget(buildApp(upload(AppFileUploadStatus.error, onRetry: () {})));

    expect(find.byTooltip('Eliminar archivo'), findsNothing);
  });

  testWidgets('las dos acciones del error caben a 320 dp con texto al 200 por ciento', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        upload(AppFileUploadStatus.error, onRetry: () {}, onDelete: () {}),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('no trunca ni desborda a 320 dp con texto al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const longName = 'documento_acreditativo_de_la_solicitud_presentada.pdf';
    await tester.pumpWidget(
      buildApp(
        AppFileUpload(
          fileName: longName,
          fileInfo: 'Documento PDF, 2,5 MB',
          status: AppFileUploadStatus.uploading,
          progress: 0.45,
          onCancel: () {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(longName)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(longName)).overflow, isNull);
    expect(
      tester.getCenter(find.text('Documento PDF, 2,5 MB')).dy,
      lessThan(tester.getCenter(find.text('Cancelar')).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
