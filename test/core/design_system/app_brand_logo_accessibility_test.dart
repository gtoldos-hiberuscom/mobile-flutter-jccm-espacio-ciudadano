import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('expone la marca como una única imagen localizada', (final tester) async {
    await tester.pumpWidget(buildApp(const AppBrandLogo()));

    final node = find.semantics.byLabel('Espacio Ciudadano').evaluate().single;
    expect(node.flagsCollection.isImage, isTrue);
    expect(find.semantics.byLabel('Escudo de Castilla-La Mancha'), findsNothing);
  });

  testWidgets('localiza el nombre de la aplicación en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppBrandLogo(), locale: const Locale('en')),
    );

    expect(find.semantics.byLabel('Citizen Space'), findsOneWidget);
  });

  testWidgets('admite un nombre de marca personalizado', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppBrandLogo(semanticsLabel: 'Portal ciudadano de Castilla-La Mancha')),
    );

    expect(
      find.semantics.byLabel('Portal ciudadano de Castilla-La Mancha'),
      findsOneWidget,
    );
  });

  testWidgets('puede excluirse cuando el contexto ya anuncia la marca', (final tester) async {
    await tester.pumpWidget(buildApp(const AppBrandLogo(decorative: true)));

    expect(find.semantics.byLabel('Espacio Ciudadano'), findsNothing);
    expect(find.byType(ExcludeSemantics), findsWidgets);
  });

  testWidgets('escala conjuntamente emblema y texto', (final tester) async {
    await tester.pumpWidget(buildApp(const AppBrandLogo(height: 50)));

    final boxes = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .where(
          (final box) => box.height == 50 || box.height == 40,
        );
    expect(
      boxes.any((final box) => box.height == 50 && box.width == 50),
      isTrue,
    );
    expect(
      boxes.any((final box) => box.height == 40 && box.width == 160),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
