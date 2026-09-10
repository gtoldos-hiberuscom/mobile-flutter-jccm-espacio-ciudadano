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

  testWidgets('anuncia una sola vez cada estado', (final tester) async {
    const cases = {
      AppPreferenceStatus.disabled: 'Desactivado',
      AppPreferenceStatus.pending: 'Pendiente',
      AppPreferenceStatus.enabled: 'Activado',
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(
        buildApp(
          AppPreferenceStatusTag(status: entry.key, showInactiveIcon: true),
        ),
      );
      expect(find.semantics.byLabel(entry.value), findsOneWidget);
      expect(find.semantics.byLabel(entry.value.toUpperCase()), findsNothing);
    }
  });

  testWidgets('estado e icono no se anuncian como controles', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceStatusTag(
          status: AppPreferenceStatus.pending,
          showInactiveIcon: true,
        ),
      ),
    );

    final data = find.semantics.byLabel('Pendiente').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.actions, 0);
  });

  testWidgets('permite personalizar la pronunciación', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceStatusTag(
          status: AppPreferenceStatus.disabled,
          showInactiveIcon: false,
          semanticLabel: 'Preferencia desactivada',
        ),
      ),
    );

    expect(find.semantics.byLabel('Preferencia desactivada'), findsOneWidget);
    expect(find.semantics.byLabel('Desactivado'), findsNothing);
  });

  testWidgets('conserva el texto completo al 200 por ciento', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppPreferenceStatusTag(
          status: AppPreferenceStatus.disabled,
          showInactiveIcon: true,
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text('DESACTIVADO')).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza un nombre accesible vacío', (final tester) async {
    expect(
      () => AppPreferenceStatusTag(
        status: AppPreferenceStatus.enabled,
        showInactiveIcon: false,
        semanticLabel: '',
      ),
      throwsAssertionError,
    );
  });
}
