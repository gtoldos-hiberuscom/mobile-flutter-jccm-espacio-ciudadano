import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_detail_scaffold.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );

  testWidgets('expone una ruta con el título visible como nombre', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppDetailScaffold(
          title: 'Detalle del inmueble',
          onBack: () {},
          body: const Text('Contenido del inmueble'),
        ),
      ),
    );

    final routes = find.semantics.byLabel('Detalle del inmueble').evaluate().where((final node) => node.flagsCollection.scopesRoute).toList();
    expect(routes, hasLength(1));
    expect(routes.single.flagsCollection.namesRoute, isTrue);
  });

  testWidgets('mantiene el cuerpo como contenido independiente de la ruta', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppDetailScaffold(
          title: 'Detalle',
          onBack: () {},
          body: Semantics(label: 'Referencia: EXP-15'),
        ),
      ),
    );

    expect(find.semantics.byLabel('Referencia: EXP-15'), findsOneWidget);
  });

  testWidgets('localiza y ejecuta la acción de volver', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppDetailScaffold(
          title: 'Detalle',
          onBack: () => taps++,
          body: const SizedBox.shrink(),
        ),
      ),
    );

    final back = tester.getSemantics(find.byTooltip('Atrás')).getSemanticsData();
    expect(back.flagsCollection.isButton, isTrue);
    expect(back.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byTooltip('Atrás'));
    expect(taps, 1);
  });

  testWidgets('localiza la acción de volver en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppDetailScaffold(
          title: 'Property details',
          onBack: () {},
          body: const SizedBox.shrink(),
        ),
        locale: const Locale('en'),
      ),
    );

    expect(find.byTooltip('Back'), findsOneWidget);
  });

  testWidgets('permite personalizar el nombre de ruta y la acción principal', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppDetailScaffold(
          title: 'EXP-15',
          semanticLabel: 'Detalle del expediente número 15',
          leadingTooltip: 'Volver a expedientes',
          onBack: () {},
          body: const SizedBox.shrink(),
        ),
      ),
    );

    final route = find.semantics.byLabel('Detalle del expediente número 15').evaluate().single;
    expect(route.flagsCollection.namesRoute, isTrue);
    expect(find.byTooltip('Volver a expedientes'), findsOneWidget);
  });
}
