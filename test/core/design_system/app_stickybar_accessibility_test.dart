import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_stickybar.dart';
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
    home: Scaffold(bottomNavigationBar: child),
  );

  testWidgets('expone una región localizada con acciones independientes', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppStickybar(
          children: [
            AppButton(label: 'Cancelar', onPressed: () {}),
            AppButton(label: 'Guardar', onPressed: () {}),
          ],
        ),
      ),
    );

    final heading = find.semantics.byLabel('Acciones principales').evaluate().single.getSemanticsData();
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 2);
    for (final label in ['Cancelar', 'Guardar']) {
      final data = find.semantics.byLabel(label).evaluate().single.getSemanticsData();
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
    }
  });

  testWidgets('permite personalizar el nombre de la región', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppStickybar(
          semanticLabel: 'Acciones del formulario de contacto',
          children: [AppButton(label: 'Guardar', onPressed: () {})],
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Acciones del formulario de contacto'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('Acciones principales'), findsNothing);
  });

  testWidgets('mantiene el orden semántico de los hijos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppStickybar(
          children: [
            AppButton(label: 'Volver', onPressed: () {}),
            AppButton(label: 'Continuar', onPressed: () {}),
          ],
        ),
      ),
    );

    final first = find.semantics.byLabel('Volver').evaluate().single;
    final second = find.semantics.byLabel('Continuar').evaluate().single;
    expect((first.sortKey! as OrdinalSortKey).order, 0);
    expect((second.sortKey! as OrdinalSortKey).order, 1);
  });

  testWidgets('apila acciones en horizontal cuando el texto está al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        AppStickybar(
          children: [
            AppButton(label: 'Cancelar y volver al formulario anterior', onPressed: () {}),
            AppButton(label: 'Guardar todos los cambios realizados', onPressed: () {}),
          ],
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(find.descendant(of: find.byType(AppStickybar), matching: find.byType(Column)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza una barra sin contenido', (final tester) async {
    expect(() => AppStickybar(children: const []), throwsAssertionError);
  });
}
