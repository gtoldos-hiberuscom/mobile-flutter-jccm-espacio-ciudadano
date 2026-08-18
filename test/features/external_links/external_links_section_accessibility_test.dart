import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link_category.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_button.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_links_section.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  final links = [
    ExternalLink(
      id: 'educamos',
      displayKey: 'externalLinkEducamosClmLabel',
      url: Uri.parse('https://educamosclm.castillalamancha.es'),
      category: ExternalLinkCategory.educationCLM,
    ),
    ExternalLink(
      id: 'empleo',
      displayKey: 'externalLinkEmpleoClmLabel',
      url: Uri.parse('https://empleoyformacion.castillalamancha.es'),
      category: ExternalLinkCategory.employmentCLM,
    ),
  ];

  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => ProviderScope(
    overrides: [
      externalLinkCatalogProvider.overrideWithValue(_Catalog(links)),
    ],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );

  testWidgets('expone un encabezado de sección y enlaces independientes', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const ExternalLinksSection(linkIds: ['educamos', 'empleo']),
      ),
    );

    final heading = find.semantics.byLabel('Enlaces externos').evaluate().single.getSemanticsData();
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(heading.headingLevel, 2);
    expect(find.semantics.byLabel('Educamos CLM'), findsOneWidget);
    expect(find.semantics.byLabel('Empleo CLM'), findsOneWidget);
  });

  testWidgets('elimina enlaces repetidos y descarta identificadores desconocidos', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const ExternalLinksSection(
          linkIds: ['educamos', 'desconocido', 'educamos'],
        ),
      ),
    );

    expect(find.byType(ExternalLinkButton), findsOneWidget);
    expect(find.semantics.byLabel('Educamos CLM'), findsOneWidget);
  });

  testWidgets('conserva el orden de foco indicado por la entrada', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const ExternalLinksSection(linkIds: ['empleo', 'educamos']),
      ),
    );

    final orders = tester.widgetList<FocusTraversalOrder>(find.byType(FocusTraversalOrder)).map((final widget) => (widget.order as NumericFocusOrder).order).toList();
    expect(orders, [0, 1]);
    expect(
      tester.getTopLeft(find.text('Empleo CLM')).dy,
      lessThan(tester.getTopLeft(find.text('Educamos CLM')).dy),
    );
  });

  testWidgets('no crea una sección vacía sin enlaces válidos', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const ExternalLinksSection(linkIds: ['desconocido']),
      ),
    );

    expect(find.semantics.byLabel('Enlaces externos'), findsNothing);
    expect(find.byType(ExternalLinkButton), findsNothing);
  });

  testWidgets('no trunca los enlaces al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        const ExternalLinksSection(linkIds: ['educamos', 'empleo']),
        textScaler: const TextScaler.linear(2),
      ),
    );

    for (final label in ['Educamos CLM', 'Empleo CLM']) {
      expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
    }
    expect(tester.takeException(), isNull);
  });
}

final class _Catalog implements ExternalLinkCatalog {
  const _Catalog(this.links);

  final List<ExternalLink> links;

  @override
  List<ExternalLink> all() => links;

  @override
  List<ExternalLink> byCategory(final ExternalLinkCategory category) => links.where((final link) => link.category == category).toList();

  @override
  ExternalLink? findById(final String id) {
    for (final link in links) {
      if (link.id == id) {
        return link;
      }
    }
    return null;
  }
}
