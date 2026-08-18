import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('expone nombre y porcentaje localizados en un único nodo', (final tester) async {
    await tester.pumpWidget(buildApp(const AppProgressBar(value: 0.42)));

    final data = find.semantics.byLabel('Progreso').evaluate().single.getSemanticsData();
    expect(data.value, '42 %');
    expect(find.semantics.byValue('42%'), findsNothing);
  });

  testWidgets('describe el progreso indeterminado', (final tester) async {
    await tester.pumpWidget(buildApp(const AppProgressBar()));

    final data = find.semantics.byLabel('Progreso').evaluate().single.getSemanticsData();
    expect(data.value, 'En curso');
  });

  testWidgets('localiza nombre, porcentaje y estado indeterminado en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(const Column(children: [AppProgressBar(value: 0.75), AppProgressBar()]), locale: const Locale('en')),
    );

    expect(find.semantics.byLabel('Progress'), findsNWidgets(2));
    expect(find.semantics.byValue('75%'), findsOneWidget);
    expect(find.semantics.byValue('In progress'), findsOneWidget);
  });

  testWidgets('permite personalizar el nombre y el valor accesibles', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppProgressBar(
          value: 0.5,
          semanticsLabel: 'Carga del documento',
          semanticsValue: 'Dos de cuatro partes',
        ),
      ),
    );

    final data = find.semantics.byLabel('Carga del documento').evaluate().single.getSemanticsData();
    expect(data.value, 'Dos de cuatro partes');
  });

  testWidgets('no usa live region por defecto y permite activarla', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const Column(
          children: [
            AppProgressBar(value: 0.2, semanticsLabel: 'Progreso silencioso'),
            AppProgressBar(value: 0.8, semanticsLabel: 'Progreso anunciado', announceChanges: true),
          ],
        ),
      ),
    );

    expect(
      find.semantics.byLabel('Progreso silencioso').evaluate().single.flagsCollection.isLiveRegion,
      isFalse,
    );
    expect(
      find.semantics.byLabel('Progreso anunciado').evaluate().single.flagsCollection.isLiveRegion,
      isTrue,
    );
  });

  testWidgets('respeta la altura visual configurada', (final tester) async {
    await tester.pumpWidget(buildApp(const AppProgressBar(value: 0.5, height: 24)));

    expect(tester.getSize(find.byType(LinearProgressIndicator)).height, 24);
    expect(tester.takeException(), isNull);
  });
}
