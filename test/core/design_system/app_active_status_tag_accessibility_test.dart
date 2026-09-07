import 'package:flutter/material.dart';
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
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('anuncia el estado una sola vez y no como control', (final tester) async {
    await tester.pumpWidget(buildApp(const AppActiveStatusTag()));

    final node = find.semantics.byLabel('Activo');
    expect(node, findsOneWidget);
    expect(find.semantics.byLabel('ACTIVO'), findsNothing);
    final data = node.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.actions, 0);
  });

  testWidgets('permite personalizar la pronunciación del estado', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppActiveStatusTag(semanticLabel: 'Preferencia activa')),
    );

    expect(find.semantics.byLabel('Preferencia activa'), findsOneWidget);
    expect(find.semantics.byLabel('Activo'), findsNothing);
  });

  testWidgets('conserva el texto completo al 200 por ciento', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppActiveStatusTag(),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text('ACTIVO')).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza un nombre accesible vacío', (final tester) async {
    expect(() => AppActiveStatusTag(semanticLabel: ''), throwsAssertionError);
  });
}
