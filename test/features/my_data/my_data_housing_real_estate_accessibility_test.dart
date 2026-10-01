import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/real_estate_property.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_real_estate_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_housing_real_estate_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_housing_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Hojas «Vivienda > Bienes inmuebles» y «Bienes inmuebles > Referencia
/// catastral» de la auditoría de accesibilidad.
void main() {
  Finder ring() => find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);

  final properties = [
    for (var i = 1; i <= 6; i++)
      RealEstateProperty(
        cadastralReference: 'REF-$i',
        kind: i.isEven ? RealEstatePropertyKind.rustic : RealEstatePropertyKind.urban,
        address: 'Calle $i, Toledo',
        cadastralValue: '1000 €',
        landValue: '500 €',
        constructionValue: '500 €',
        use: 'Residencial',
        cartographyUrl: 'https://www1.sedecatastro.gob.es/Cartografia/mapa.aspx?refcat=REF-$i',
        holders: const [RealEstatePropertyHolder(name: 'Abengozar Muñoz Nuria Magdalena', ownership: '40,00 % de propiedad')],
      ),
  ];

  Widget buildApp(final Widget home, {final TextScaler textScaler = TextScaler.noScaling}) => ProviderScope(
    overrides: [housingRealEstatePropertiesProvider.overrideWith((final ref) async => properties)],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: home,
    ),
  );

  Future<Set<String>> tabThrough(final WidgetTester tester, final List<String> names, {final double? viewportHeight}) async {
    final visited = <String>{};
    for (var i = 0; i < 40 && visited.length < names.length; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      final focusedFinder = find.byWidget(focused.widget);
      for (final name in names) {
        final byText = find.descendant(of: focusedFinder, matching: find.text(name));
        final byTooltip = find.ancestor(of: focusedFinder, matching: find.byTooltip(name));
        if (byText.evaluate().isNotEmpty || byTooltip.evaluate().isNotEmpty) {
          visited.add(name);
          expect(
            find.ancestor(of: focusedFinder, matching: ring()),
            findsOneWidget,
            reason: name,
          );
          if (viewportHeight != null && byText.evaluate().isNotEmpty) {
            // El foco trae el control a la vista (WCAG 2.1.1).
            final rect = tester.getRect(byText);
            expect(rect.top, greaterThanOrEqualTo(0), reason: name);
            expect(rect.bottom, lessThanOrEqualTo(viewportHeight), reason: name);
          }
        }
      }
    }
    return visited;
  }

  group('Bienes inmuebles', () {
    testWidgets('WCAG 2.1.1 / 2.4.7 / 1.4.11: el tabulador recorre filtros y todas las tarjetas, las trae a la vista y las marca', (final tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(375, 667);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp(const MyDataHousingRealEstatePage()));
      await tester.pumpAndSettle();

      final names = ['Atrás', 'Todo', 'Urbano', 'Rústico', for (var i = 1; i <= 6; i++) 'Referencia catastral REF-$i'];
      expect(await tabThrough(tester, names, viewportHeight: 667), names.toSet());
    });

    testWidgets('WCAG 4.1.2: los filtros se anuncian como pestañas', (final tester) async {
      await tester.pumpWidget(buildApp(const MyDataHousingRealEstatePage()));
      await tester.pumpAndSettle();

      for (final label in ['Todo', 'Urbano', 'Rústico']) {
        final node = find.semantics.byLabel(label).evaluate().single;
        expect(node.getSemanticsData().role, SemanticsRole.tab, reason: label);
        expect(node.parent!.getSemanticsData().role, SemanticsRole.tabBar, reason: label);
      }
    });

    testWidgets('WCAG 2.5.1: al 200 por ciento los filtros quedan a la vista sin deslizar', (final tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp(const MyDataHousingRealEstatePage(), textScaler: const TextScaler.linear(2)));
      await tester.pumpAndSettle();

      for (final label in ['Todo', 'Urbano', 'Rústico']) {
        final rect = tester.getRect(find.text(label));
        expect(rect.left, greaterThanOrEqualTo(0), reason: label);
        expect(rect.right, lessThanOrEqualTo(320), reason: label);
      }
      expect(find.descendant(of: find.byType(AppSegmentedControl), matching: find.byType(SingleChildScrollView)), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('Referencia catastral', () {
    const detail = MyDataHousingRealEstateDetailPage(reference: 'REF-1');

    testWidgets('WCAG 1.3.1: «Datos de la vivienda» y «Titulares» son encabezados', (final tester) async {
      await tester.pumpWidget(buildApp(detail));
      await tester.pumpAndSettle();

      for (final title in ['Datos de la vivienda', 'Titulares']) {
        await tester.ensureVisible(find.text(title));
        await tester.pumpAndSettle();
        final node = find.semantics.byLabel(title).evaluate().single;
        expect(node.flagsCollection.isHeader, isTrue, reason: title);
        expect(node.headingLevel, 2, reason: title);
      }
    });

    testWidgets('WCAG 4.1.2: «Mostrar cartografía» se anuncia como enlace externo', (final tester) async {
      await tester.pumpWidget(buildApp(detail));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Mostrar cartografía'));
      await tester.pumpAndSettle();

      final data = find.semantics.byLabel('Mostrar cartografía').evaluate().single.getSemanticsData();
      expect(data.flagsCollection.isLink, isTrue);
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.hint, 'Abre en navegador externo');
    });

    testWidgets('WCAG 2.4.7 / 1.4.11: «Cerrar» y «Mostrar cartografía» muestran el anillo de foco', (final tester) async {
      await tester.pumpWidget(buildApp(detail));
      await tester.pumpAndSettle();

      const names = ['Cerrar', 'Mostrar cartografía'];
      expect(await tabThrough(tester, names), names.toSet());
    });

    testWidgets('WCAG 1.4.4: al 200 por ciento cada titular se apila a todo el ancho y se lee en un nodo', (final tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp(detail, textScaler: const TextScaler.linear(2)));
      await tester.pumpAndSettle();
      final name = find.text('ABENGOZAR MUÑOZ NURIA MAGDALENA');
      await tester.ensureVisible(name);
      await tester.pumpAndSettle();

      final nameRect = tester.getRect(name);
      final ownershipRect = tester.getRect(find.text('40,00 % de propiedad'));
      // El porcentaje va debajo del nombre, no en una columna estrecha al lado.
      expect(ownershipRect.top, greaterThanOrEqualTo(nameRect.bottom));
      expect(ownershipRect.left, nameRect.left);
      expect(find.semantics.byLabel('Abengozar Muñoz Nuria Magdalena, 40,00 % de propiedad'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
