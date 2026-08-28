import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_tag.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('anuncia el estado una sola vez sin icono ni acciones', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppTag(status: AppTagStatus.warning, label: 'Pendiente')),
    );

    final node = find.semantics.byLabel('Pendiente');
    expect(node, findsOneWidget);
    expect(find.semantics.byLabel('PENDIENTE'), findsNothing);
    final data = node.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.actions, 0);
  });

  testWidgets('permite personalizar la pronunciación', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppTag(
          status: AppTagStatus.infoInactive,
          label: 'Exp.',
          semanticLabel: 'Notificación expirada',
        ),
      ),
    );

    expect(find.semantics.byLabel('Notificación expirada'), findsOneWidget);
    expect(find.semantics.byLabel('Exp.'), findsNothing);
  });

  testWidgets('puede anunciar cambios de estado dinámicos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppTag(
          status: AppTagStatus.success,
          label: 'Aceptada',
          announceChanges: true,
        ),
      ),
    );

    final data = find.semantics.byLabel('Aceptada').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('no trunca ni desborda al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'Pendiente de revisión por el organismo responsable';
    await tester.pumpWidget(
      buildApp(
        const AppTag(status: AppTagStatus.warning, label: label),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(label.toUpperCase())).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza textos y nombres accesibles vacíos', (final tester) async {
    expect(
      () => AppTag(status: AppTagStatus.success, label: ''),
      throwsAssertionError,
    );
    expect(
      () => AppTag(
        status: AppTagStatus.success,
        label: 'Activo',
        semanticLabel: '',
      ),
      throwsAssertionError,
    );
  });
}
