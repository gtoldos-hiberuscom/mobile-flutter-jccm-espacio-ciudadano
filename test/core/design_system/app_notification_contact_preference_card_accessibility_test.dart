import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_preference_cards.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  AppNotificationContactPreferenceCard card(final VoidCallback onEdit) => AppNotificationContactPreferenceCard(
    phone: '640559754',
    email: 'persona@correo.es',
    footerText: 'Actualizado el 14 ago 2026 a las 10:30',
    onEdit: onEdit,
  );

  testWidgets('anuncia estado y encabezado sin iconos decorativos', (final tester) async {
    await tester.pumpWidget(buildApp(card(() {})));

    expect(find.semantics.byLabel('Activo'), findsOneWidget);
    final title = tester.getSemantics(find.text('Datos de contacto para notificaciones'));
    expect(title.getSemanticsData().flagsCollection.isHeader, isTrue);
    expect(title.getSemanticsData().label, 'Datos de contacto para notificaciones');
  });

  testWidgets('asocia cada etiqueta con su valor', (final tester) async {
    await tester.pumpWidget(buildApp(card(() {})));

    expect(find.semantics.byLabel('Teléfono móvil. 0034 640 559 754'), findsOneWidget);
    expect(
      find.semantics.byLabel('Correo electrónico. persona@correo.es'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('TELÉFONO MÓVIL'), findsNothing);
  });

  testWidgets('editar datos permanece como acción independiente', (final tester) async {
    var edits = 0;
    await tester.pumpWidget(buildApp(card(() => edits++)));

    final action = find.semantics.byLabel('Editar datos').evaluate().single;
    expect(action.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    action.owner!.performAction(action.id, SemanticsAction.tap);
    await tester.pump();
    expect(edits, 1);
  });

  testWidgets('mantiene estado, título, datos, acción y pie en orden', (final tester) async {
    await tester.pumpWidget(buildApp(card(() {})));

    final status = find.semantics.byLabel('Activo').evaluate().single;
    final title = tester.getSemantics(find.text('Datos de contacto para notificaciones'));
    final data = find.semantics.byLabel('Teléfono móvil. 0034 640 559 754').evaluate().single;
    final action = find.semantics.byLabel('Editar datos').evaluate().single;
    final footer = find.semantics.byLabel('Actualizado el 14 ago 2026 a las 10:30').evaluate().single;
    expect((status.sortKey! as OrdinalSortKey).order, 0);
    expect((title.sortKey! as OrdinalSortKey).order, 1);
    expect((data.parent!.sortKey! as OrdinalSortKey).order, 2);
    expect((action.sortKey! as OrdinalSortKey).order, 3);
    expect((footer.sortKey! as OrdinalSortKey).order, 4);
  });

  testWidgets('no desborda al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(card(() {}), textScaler: const TextScaler.linear(2)),
    );

    expect(
      tester.widget<Text>(find.text('Datos de contacto para notificaciones')).maxLines,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });
}
