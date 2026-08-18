import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_text_block.dart';

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

  testWidgets('expone el texto una sola vez y omite los iconos decorativos', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(const AppTextBlock(text: 'Consultar')));

    final node = find.semantics.byLabel('Consultar');
    expect(node, findsOneWidget);
    final data = node.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('identifica las variantes de título como encabezados', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const AppTextBlock(
          text: 'Datos del expediente',
          variant: AppTextBlockVariant.h2,
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Datos del expediente').evaluate().single.getSemanticsData().flagsCollection.isHeader,
      isTrue,
    );
  });

  testWidgets('expone enlace y ejecuta su acción semántica', (final tester) async {
    var activations = 0;
    await tester.pumpWidget(
      buildApp(
        AppTextBlock(
          text: 'Abrir sede electrónica',
          isLink: true,
          onTap: () => activations++,
        ),
      ),
    );

    final node = find.semantics.byLabel('Abrir sede electrónica').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isTrue);

    node.owner!.performAction(node.id, SemanticsAction.tap);
    expect(activations, 1);
  });

  testWidgets('permite personalizar el nombre accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppTextBlock(
          text: 'IRPF',
          semanticLabel: 'Impuesto sobre la renta de las personas físicas',
        ),
      ),
    );

    expect(
      find.semantics.byLabel(
        'Impuesto sobre la renta de las personas físicas',
      ),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('IRPF'), findsNothing);
  });

  testWidgets('no trunca ni desborda al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const text = 'Consultar toda la información disponible del expediente';
    await tester.pumpWidget(
      buildApp(
        const AppTextBlock(text: text),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(text)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza textos y nombres accesibles vacíos', (final tester) async {
    expect(() => AppTextBlock(text: ''), throwsAssertionError);
    expect(
      () => AppTextBlock(text: 'Contenido', semanticLabel: ''),
      throwsAssertionError,
    );
  });
}
