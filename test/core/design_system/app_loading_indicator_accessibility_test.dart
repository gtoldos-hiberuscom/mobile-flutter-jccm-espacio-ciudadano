import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('anuncia una carga localizada mediante live region', (final tester) async {
    await tester.pumpWidget(buildApp(const AppLoadingIndicator()));

    final semantics = find.semantics.byLabel('Cargando').evaluate().single;
    expect(semantics.flagsCollection.isLiveRegion, isTrue);
    expect(find.semantics.byLabel(RegExp('.*%.*')), findsNothing);
  });

  testWidgets('permite describir una operación concreta', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppLoadingIndicator(semanticsLabel: 'Cargando notificaciones')),
    );

    expect(find.semantics.byLabel('Cargando notificaciones'), findsOneWidget);
  });

  testWidgets('anuncia la finalización una sola vez al desaparecer', (final tester) async {
    await tester.pumpWidget(buildApp(const AppLoadingIndicator()));
    tester.takeAnnouncements();

    await tester.pumpWidget(buildApp(const SizedBox.shrink()));
    await tester.pump();

    expect(
      tester.takeAnnouncements(),
      hasLength(1),
    );
  });

  testWidgets('puede ser decorativo y no anuncia su finalización', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppLoadingIndicator(decorative: true)),
    );

    expect(find.semantics.byLabel('Cargando'), findsNothing);
    tester.takeAnnouncements();

    await tester.pumpWidget(buildApp(const SizedBox.shrink()));
    await tester.pump();
    expect(tester.takeAnnouncements(), isEmpty);
  });

  testWidgets('permite desactivar únicamente el anuncio final', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppLoadingIndicator(announceCompletion: false)),
    );
    expect(find.semantics.byLabel('Cargando'), findsOneWidget);
    tester.takeAnnouncements();

    await tester.pumpWidget(buildApp(const SizedBox.shrink()));
    await tester.pump();
    expect(tester.takeAnnouncements(), isEmpty);
  });
}
