import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/domain_section.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  testWidgets('identifica el título como encabezado de nivel dos', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const DomainSection(
          title: 'Enlaces externos',
          child: Text('Contenido'),
        ),
      ),
    );

    final data = find.semantics.byLabel('Enlaces externos').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    expect(data.headingLevel, 2);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('la ayuda es un botón accesible que muestra el tooltip', (
    final tester,
  ) async {
    const help = 'Información sobre los enlaces disponibles';
    await tester.pumpWidget(
      buildApp(
        const DomainSection(
          title: 'Enlaces externos',
          infoTooltip: help,
          child: Text('Contenido'),
        ),
      ),
    );

    final node = find.semantics.byLabel(help).evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(tester.getSize(find.byType(IconButton)), const Size(48, 48));

    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pump();
    expect(find.text(help), findsOneWidget);
  });

  testWidgets('mantiene las acciones del contenido como nodos separados', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        DomainSection(
          title: 'Servicios',
          subtitle: 'Seleccione una opción',
          child: TextButton(onPressed: () {}, child: const Text('Solicitar')),
        ),
      ),
    );

    expect(find.semantics.byLabel('Servicios'), findsOneWidget);
    expect(find.semantics.byLabel('Seleccione una opción'), findsOneWidget);
    expect(find.semantics.byLabel('Solicitar'), findsOneWidget);
  });

  testWidgets('admite título y subtítulo al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const title = 'Información y servicios relacionados con la ciudadanía';
    const subtitle = 'Consulte todas las opciones disponibles en esta sección';
    await tester.pumpWidget(
      buildApp(
        const SingleChildScrollView(
          child: DomainSection(
            title: title,
            subtitle: subtitle,
            infoTooltip: 'Más información',
            child: Text('Contenido'),
          ),
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(title)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(subtitle)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza textos estructurales vacíos', (final tester) async {
    expect(
      () => DomainSection(title: '', child: const SizedBox()),
      throwsAssertionError,
    );
    expect(
      () => DomainSection(
        title: 'Servicios',
        subtitle: '',
        child: const SizedBox(),
      ),
      throwsAssertionError,
    );
    expect(
      () => DomainSection(
        title: 'Servicios',
        infoTooltip: '',
        child: const SizedBox(),
      ),
      throwsAssertionError,
    );
  });
}
