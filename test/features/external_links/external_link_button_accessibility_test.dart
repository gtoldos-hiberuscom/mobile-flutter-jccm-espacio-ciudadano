import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_external_navigation_dialog.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link_category.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  final link = ExternalLink(
    id: 'test',
    displayKey: 'test',
    url: Uri.parse('https://www.jccm.es'),
    category: ExternalLinkCategory.jccmElectronic,
  );

  Widget buildApp(
    final Widget child, {
    final Locale locale = const Locale('es'),
    final TextScaler textScaler = TextScaler.noScaling,
  }) => ProviderScope(
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: Scaffold(body: Center(child: child)),
    ),
  );

  testWidgets('expone un único enlace con pista y acción', (final tester) async {
    await tester.pumpWidget(
      buildApp(ExternalLinkButton(link: link, label: 'Sede electrónica')),
    );

    final node = find.semantics.byLabel('Sede electrónica').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hint, 'Abre en navegador externo');
    expect(data.hasAction(SemanticsAction.tap), isTrue);
  });

  testWidgets('la acción semántica abre la confirmación de navegación', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(ExternalLinkButton(link: link, label: 'Sede electrónica')),
    );

    final node = find.semantics.byLabel('Sede electrónica').evaluate().single;
    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pumpAndSettle();

    expect(find.byType(AppExternalNavigationDialog), findsOneWidget);
  });

  testWidgets('permite personalizar nombre y pista accesibles', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        ExternalLinkButton(
          link: link,
          label: 'JCCM',
          semanticLabel: 'Junta de Comunidades de Castilla-La Mancha',
          semanticHint: 'Se abrirá fuera de esta aplicación',
        ),
      ),
    );

    final data = find.semantics.byLabel('Junta de Comunidades de Castilla-La Mancha').evaluate().single.getSemanticsData();
    expect(data.hint, 'Se abrirá fuera de esta aplicación');
    expect(find.semantics.byLabel('JCCM'), findsNothing);
  });

  testWidgets('localiza la pista del enlace en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        ExternalLinkButton(link: link, label: 'Electronic office'),
        locale: const Locale('en'),
      ),
    );

    expect(
      find.semantics.byLabel('Electronic office').evaluate().single.getSemanticsData().hint,
      'Opens in external browser',
    );
  });

  testWidgets('mantiene 48 dp y no trunca al 200 por ciento', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const label = 'Acceder a todos los servicios de la sede electrónica';
    await tester.pumpWidget(
      buildApp(
        ExternalLinkButton(link: link, label: label),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(label)).maxLines, isNull);
    expect(tester.getSize(find.byType(AppButton)).height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza etiquetas accesibles vacías', (final tester) async {
    expect(
      () => ExternalLinkButton(link: link, label: ''),
      throwsAssertionError,
    );
    expect(
      () => ExternalLinkButton(
        link: link,
        label: 'Sede',
        semanticLabel: '',
      ),
      throwsAssertionError,
    );
    expect(
      () => ExternalLinkButton(
        link: link,
        label: 'Sede',
        semanticHint: '',
      ),
      throwsAssertionError,
    );
  });
}
