import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_mode_banner.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_mode_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  // Sin la cinta «DEBUG» de MaterialApp, que usa el mismo widget `Banner` y
  // confundiría la búsqueda.
  Widget buildApp({required final bool demo}) => ProviderScope(
    overrides: [demoModeProvider.overrideWithValue(demo)],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DemoModeBanner(child: Scaffold(body: Text('contenido'))),
    ),
  );

  final demoRibbon = find.byWidgetPredicate((final widget) => widget is Banner && widget.message == 'DEMO');

  testWidgets('fuera de la demo no pinta nada encima', (final tester) async {
    await tester.pumpWidget(buildApp(demo: false));

    expect(demoRibbon, findsNothing);
    expect(find.text('contenido'), findsOneWidget);
  });

  testWidgets('en la demo pinta la cinta DEMO sin quitar el contenido', (final tester) async {
    await tester.pumpWidget(buildApp(demo: true));

    expect(demoRibbon, findsOneWidget);
    expect(find.text('contenido'), findsOneWidget);
  });
}
