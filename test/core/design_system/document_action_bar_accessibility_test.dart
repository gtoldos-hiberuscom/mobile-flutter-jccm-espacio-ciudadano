import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/document_action_bar.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('cada acción tiene nombre, rol y acción semántica únicos', (
    final tester,
  ) async {
    var opened = 0;
    var downloaded = 0;
    var shared = 0;
    await tester.pumpWidget(
      buildApp(
        DocumentActionBar(
          documentName: 'resolucion.pdf',
          onOpen: () => opened++,
          onDownload: () => downloaded++,
          onShare: () => shared++,
        ),
      ),
    );

    for (final label in [
      'Abrir documento: resolucion.pdf',
      'Descargar documento: resolucion.pdf',
      'Compartir documento: resolucion.pdf',
    ]) {
      final node = find.semantics.byLabel(label).evaluate().single;
      final data = node.getSemanticsData();
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.flagsCollection.isEnabled, Tristate.isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      node.owner!.performAction(node.id, SemanticsAction.tap);
    }
    expect(opened, 1);
    expect(downloaded, 1);
    expect(shared, 1);
  });

  testWidgets('solo crea controles para las acciones disponibles', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        DocumentActionBar(
          documentName: 'informe.pdf',
          onDownload: () {},
        ),
      ),
    );

    expect(find.byType(IconButton), findsOneWidget);
    expect(find.semantics.byLabel('Descargar documento: informe.pdf'), findsOneWidget);
    expect(find.semantics.byLabel('Abrir documento: informe.pdf'), findsNothing);
    expect(find.semantics.byLabel('Compartir documento: informe.pdf'), findsNothing);
  });

  testWidgets('las acciones conservan objetivos táctiles de 48 dp', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        DocumentActionBar(
          documentName: 'informe.pdf',
          onOpen: () {},
          onDownload: () {},
          onShare: () {},
        ),
      ),
    );

    for (final element in find.byType(IconButton).evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('anuncia la carga y el documento en una región activa', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const DocumentActionBar(
          documentName: 'notificacion.pdf',
          isLoading: true,
        ),
      ),
    );

    final node = find.semantics.byLabel('Cargando: notificacion.pdf');
    expect(node, findsOneWidget);
    final data = node.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLiveRegion, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(tester.getSize(find.byType(SizedBox).first), const Size(48, 48));
  });

  testWidgets('permite una pronunciación alternativa del documento', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        DocumentActionBar(
          documentName: 'RES_001.pdf',
          documentSemanticLabel: 'Resolución número uno, PDF',
          onOpen: () {},
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Abrir documento: Resolución número uno, PDF'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('Abrir documento: RES_001.pdf'), findsNothing);
  });

  testWidgets('rechaza nombres visibles y accesibles vacíos', (final tester) async {
    expect(() => DocumentActionBar(documentName: ''), throwsAssertionError);
    expect(
      () => DocumentActionBar(
        documentName: 'informe.pdf',
        documentSemanticLabel: '',
      ),
      throwsAssertionError,
    );
  });
}
