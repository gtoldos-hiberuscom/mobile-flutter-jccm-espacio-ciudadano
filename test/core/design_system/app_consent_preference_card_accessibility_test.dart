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

  testWidgets('expone el título como encabezado sin anunciar el icono', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppConsentPreferenceCard(onEdit: () {})),
    );

    final title = tester.getSemantics(find.text('Condiciones de uso y autorizaciones'));
    expect(title.getSemanticsData().flagsCollection.isHeader, isTrue);
    expect(title.getSemanticsData().label, 'Condiciones de uso y autorizaciones');
  });

  testWidgets('mantiene editar como acción independiente', (final tester) async {
    var edits = 0;
    await tester.pumpWidget(
      buildApp(AppConsentPreferenceCard(onEdit: () => edits++)),
    );

    final action = find.semantics.byLabel('Editar').evaluate().single;
    expect(action.getSemanticsData().flagsCollection.isButton, isTrue);
    expect(action.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    action.owner!.performAction(action.id, SemanticsAction.tap);
    await tester.pump();
    expect(edits, 1);
  });

  testWidgets('el encabezado precede a la acción en el orden semántico', (final tester) async {
    await tester.pumpWidget(
      buildApp(AppConsentPreferenceCard(onEdit: () {})),
    );

    final title = tester.getSemantics(find.text('Condiciones de uso y autorizaciones'));
    final action = find.semantics.byLabel('Editar').evaluate().single;
    expect((title.sortKey! as OrdinalSortKey).order, 0);
    expect((action.sortKey! as OrdinalSortKey).order, 1);
  });

  testWidgets('no desborda al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        AppConsentPreferenceCard(onEdit: () {}),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(
      tester.widget<Text>(find.text('Condiciones de uso y autorizaciones')).maxLines,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });
}
