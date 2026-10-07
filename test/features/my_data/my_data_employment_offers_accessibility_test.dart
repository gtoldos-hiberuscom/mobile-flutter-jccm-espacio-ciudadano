import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_employment_offers_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_employment_offers_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// «Mis datos > Empleo > Inscripciones en ofertas».
void main() {
  final offer = EmploymentOfferRegistration(
    title: 'Auxiliar administrativo',
    publicationDate: DateTime(2026, 9, 2),
    registrationDate: DateTime(2026, 9, 5),
    selectionEndDate: DateTime(2026, 10, 2),
    applicationStatus: 'Inscrita',
  );

  Widget buildPage({final TextScaler textScaler = TextScaler.noScaling}) => ProviderScope(
    overrides: [
      employmentOfferRegistrationsProvider.overrideWith((final ref) async => [offer]),
    ],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const MyDataEmploymentOffersPage(),
    ),
  );

  testWidgets('WCAG 1.3.1: cada oferta se anuncia en un único nodo con sus etiquetas', (final tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    final node = find.semantics.byLabel(
      'Auxiliar administrativo. Inscrita. Fecha publicación: 2 sep 2026. ${_label(tester, (final l) => l.myDataEmploymentOfferRegistrationDateLabel)}: 5 sep 2026. ${_label(tester, (final l) => l.myDataEmploymentOfferSelectionEndDateLabel)}: 2 oct 2026',
    );
    expect(node, findsOneWidget);
    expect(find.semantics.byLabel('Auxiliar administrativo'), findsNothing);
    expect(find.semantics.byLabel('2 sep 2026'), findsNothing);
  });

  testWidgets('WCAG 1.4.4: al 200 por ciento etiqueta y fecha se apilan y el título no se recorta', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 740);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(buildPage(textScaler: const TextScaler.linear(2)));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyDataEmploymentOffersPage)));

    final label = tester.getRect(find.text(l10n.myDataEmploymentOfferPublicationDateLabel.toUpperCase()));
    final value = tester.getRect(find.text('2 sep 2026'));
    expect(value.top, greaterThanOrEqualTo(label.bottom));

    final titleRect = tester.getRect(find.descendant(of: find.byType(AppBar), matching: find.text(l10n.myDataEmploymentOffersPageTitle)));
    expect(titleRect.bottom, lessThanOrEqualTo(tester.getRect(find.byType(AppBar)).bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('WCAG 2.1.1 / 4.1.2: el enlace de más información de la ayuda es un enlace externo', (final tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyDataEmploymentOffersPage)));

    await tester.tap(find.byTooltip('Información'));
    await tester.pumpAndSettle();

    final link = tester.widget<AppButton>(find.byType(AppButton));
    expect(link.label, l10n.myDataEmploymentInfoSheetOfficeContactsButton);
    expect(link.isExternalLink, isTrue);
  });
}

String _label(final WidgetTester tester, final String Function(AppLocalizations) pick) => pick(AppLocalizations.of(tester.element(find.byType(MyDataEmploymentOffersPage))));
