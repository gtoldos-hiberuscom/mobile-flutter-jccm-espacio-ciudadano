import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link_category.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_button.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  final link = ExternalLink(
    id: 'educamos',
    displayKey: 'externalLinkEducamosClmLabel',
    url: Uri.parse('https://educamosclm.castillalamancha.es'),
    category: ExternalLinkCategory.educationCLM,
  );

  Widget buildApp(
    final Widget child, {
    final ExternalLinkCatalog? catalog,
    final TextScaler textScaler = TextScaler.noScaling,
  }) => ProviderScope(
    overrides: [
      externalLinkCatalogProvider.overrideWithValue(catalog ?? _Catalog([link])),
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

  const card = ExternalLinkCard(
    title: 'Educación',
    description: 'Acceso a los servicios educativos de Castilla-La Mancha.',
    linkId: 'educamos',
  );

  testWidgets('expone el título como encabezado de nivel tres', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card));

    final data = find.semantics.byLabel('Educación').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    expect(data.headingLevel, 3);
    expect(data.flagsCollection.isButton, isFalse);
  });

  testWidgets('mantiene descripción y enlace como nodos independientes', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(card));

    expect(
      find.semantics.byLabel(
        'Acceso a los servicios educativos de Castilla-La Mancha.',
      ),
      findsOneWidget,
    );
    final link = find.semantics.byLabel('Educamos CLM').evaluate().single;
    expect(link.flagsCollection.isLink, isTrue);
    expect(link.flagsCollection.isButton, isFalse);
  });

  testWidgets('omite la acción cuando el catálogo no contiene el enlace', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(card, catalog: const _Catalog([])),
    );

    expect(find.byType(ExternalLinkButton), findsNothing);
    expect(find.semantics.byLabel('Educación'), findsOneWidget);
    expect(
      find.semantics.byLabel(
        'Acceso a los servicios educativos de Castilla-La Mancha.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('permite nivel y pronunciación alternativos para el título', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        const ExternalLinkCard(
          title: 'JCCM',
          titleSemanticLabel: 'Junta de Comunidades de Castilla-La Mancha',
          headingLevel: 2,
          description: 'Sede electrónica regional.',
          linkId: 'educamos',
        ),
      ),
    );

    final data = find.semantics.byLabel('Junta de Comunidades de Castilla-La Mancha').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
    expect(data.headingLevel, 2);
    expect(find.semantics.byLabel('JCCM'), findsNothing);
  });

  testWidgets('no trunca título ni descripción al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const title = 'Servicios educativos disponibles para la ciudadanía';
    const description = 'Consulte todos los servicios y recursos educativos disponibles en Castilla-La Mancha.';
    await tester.pumpWidget(
      buildApp(
        const ExternalLinkCard(
          title: title,
          description: description,
          linkId: 'educamos',
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(title)).maxLines, isNull);
    expect(tester.widget<Text>(find.text(description)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza contenido estructural vacío y niveles inválidos', (
    final tester,
  ) async {
    expect(
      () => ExternalLinkCard(title: '', description: 'Detalle', linkId: 'id'),
      throwsAssertionError,
    );
    expect(
      () => ExternalLinkCard(title: 'Título', description: '', linkId: 'id'),
      throwsAssertionError,
    );
    expect(
      () => ExternalLinkCard(title: 'Título', description: 'Detalle', linkId: ''),
      throwsAssertionError,
    );
    expect(
      () => ExternalLinkCard(
        title: 'Título',
        description: 'Detalle',
        linkId: 'id',
        headingLevel: 7,
      ),
      throwsAssertionError,
    );
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
