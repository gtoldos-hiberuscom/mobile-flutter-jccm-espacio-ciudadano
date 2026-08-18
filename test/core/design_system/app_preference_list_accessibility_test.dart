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
    home: Scaffold(body: child),
  );

  testWidgets('permite identificar la región sin ocultar sus elementos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceList(
          semanticLabel: 'Preferencias disponibles',
          children: [Text('Notificaciones'), Text('Privacidad')],
        ),
      ),
    );

    expect(find.semantics.byLabel('Preferencias disponibles'), findsOneWidget);
    expect(find.semantics.byLabel('Notificaciones'), findsOneWidget);
    expect(find.semantics.byLabel('Privacidad'), findsOneWidget);
  });

  testWidgets('mantiene el orden semántico de los elementos', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceList(
          children: [Text('Primera preferencia'), Text('Segunda preferencia')],
        ),
      ),
    );

    final first = tester.getSemantics(find.text('Primera preferencia'));
    final second = tester.getSemantics(find.text('Segunda preferencia'));
    expect((first.sortKey! as OrdinalSortKey).order, 0);
    expect((second.sortKey! as OrdinalSortKey).order, 1);
  });

  testWidgets('sigue siendo desplazable con texto al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        AppPreferenceList(
          children: List.generate(
            8,
            (final index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('Preferencia número ${index + 1} con una descripción completa'),
            ),
          ),
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    final scrollable = find.byType(SingleChildScrollView);
    expect(scrollable, findsOneWidget);
    await tester.drag(scrollable, const Offset(0, -300));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza un nombre accesible vacío', (final tester) async {
    expect(
      () => AppPreferenceList(semanticLabel: '', children: const [Text('Preferencia')]),
      throwsAssertionError,
    );
  });
}
