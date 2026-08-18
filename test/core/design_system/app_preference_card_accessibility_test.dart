import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_preference_cards.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  AppPreferenceCard card({
    final AppPreferenceStatus status = AppPreferenceStatus.pending,
    final List<String> summaryItems = const [],
    final VoidCallback? onAction,
  }) => AppPreferenceCard(
    title: 'Mis hechos vitales',
    icon: const Icon(Icons.favorite_outline),
    status: status,
    inactiveDescription: 'Debes autorizar primero el uso de estos datos.',
    pendingDescription: 'Selecciona los temas sobre los que quieres recibir información.',
    activeDescription: 'Tienes temas seleccionados.',
    actionLabel: 'Seleccionar',
    actionIcon: Icons.edit,
    onAction: onAction,
    summaryItems: summaryItems,
  );

  testWidgets('anuncia estado, encabezado, contenido y acción por separado', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card(onAction: () {})));

    expect(find.semantics.byLabel('Pendiente'), findsOneWidget);
    final title = tester.getSemantics(find.text('Mis hechos vitales'));
    expect(title.getSemanticsData().flagsCollection.isHeader, isTrue);
    expect(
      find.semantics.byLabel('Selecciona los temas sobre los que quieres recibir información.'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('Seleccionar'), findsOneWidget);
  });

  testWidgets('anuncia activado aunque el resumen sustituya a la etiqueta visual', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        card(
          status: AppPreferenceStatus.enabled,
          summaryItems: const ['Nacimiento de un hijo', 'Cambio de domicilio'],
          onAction: () {},
        ),
      ),
    );

    expect(find.semantics.byLabel('Activado'), findsOneWidget);
    expect(find.text('Nacimiento de un hijo'), findsOneWidget);
    expect(find.text('Cambio de domicilio'), findsOneWidget);
  });

  testWidgets('la acción mantiene estado y pulsación independientes', (final tester) async {
    var actions = 0;
    await tester.pumpWidget(buildApp(card(onAction: () => actions++)));

    final action = find.semantics.byLabel('Seleccionar').evaluate().single;
    expect(action.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    action.owner!.performAction(action.id, SemanticsAction.tap);
    await tester.pump();
    expect(actions, 1);

    await tester.pumpWidget(buildApp(card()));
    expect(
      find.semantics
          .byLabel('Seleccionar')
          .evaluate()
          .single
          .getSemanticsData()
          .hasAction(
            SemanticsAction.tap,
          ),
      isFalse,
    );
  });

  testWidgets('mantiene el orden lógico de lectura', (final tester) async {
    await tester.pumpWidget(buildApp(card(onAction: () {})));

    final status = find.semantics.byLabel('Pendiente').evaluate().single;
    final title = tester.getSemantics(find.text('Mis hechos vitales'));
    final description = find.semantics.byLabel('Selecciona los temas sobre los que quieres recibir información.').evaluate().single;
    final action = find.semantics.byLabel('Seleccionar').evaluate().single;
    expect((status.sortKey! as OrdinalSortKey).order, 0);
    expect((title.sortKey! as OrdinalSortKey).order, 1);
    expect((description.sortKey! as OrdinalSortKey).order, 2);
    expect((action.sortKey! as OrdinalSortKey).order, 3);
  });

  testWidgets('no desborda al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(card(onAction: () {}), textScaler: const TextScaler.linear(2)),
    );

    expect(tester.widget<Text>(find.text('Mis hechos vitales')).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
