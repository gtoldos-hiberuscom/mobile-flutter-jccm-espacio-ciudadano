import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/digital_cards_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/digital_cards_catalog_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/3_data/digital_cards_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _FakeRepository implements DigitalCardsRepository {
  _FakeRepository(this._catalog);

  final DigitalCardsCatalog _catalog;

  @override
  Future<DigitalCardsCatalog> loadCatalog() async => _catalog;
}

void main() {
  testWidgets('DigitalCardsCatalogPage renders the CIP read-only mini card at top', (final tester) async {
    final catalog = DigitalCardsCatalog(
      cards: const <DigitalCard>[
        DigitalCard(
          id: 'page-card-1',
          type: DigitalCardType.familiaNumerosa,
          status: DigitalCardStatus.available,
        ),
      ],
      lastUpdatedAt: DateTime(2026, 4, 22),
      state: DigitalCardsCatalogState.loaded,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          digitalCardsRepositoryProvider.overrideWith(
            (final ref) => _FakeRepository(catalog),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<Object>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('es'),
          home: DigitalCardsCatalogPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final cipFinder = find.byKey(const ValueKey('digitalCardsCipMiniCard'));
    final tileFinder = find.byKey(const ValueKey('digitalCardsTile-page-card-1'));
    expect(cipFinder, findsOneWidget);
    expect(tileFinder, findsOneWidget);

    // CIP mini card must render before the federated card tile.
    final cipY = tester.getTopLeft(cipFinder).dy;
    final tileY = tester.getTopLeft(tileFinder).dy;
    expect(cipY, lessThan(tileY));

    // Read-only subtitle is present on the CIP card.
    expect(find.text('Sólo lectura'), findsOneWidget);
  });
}
