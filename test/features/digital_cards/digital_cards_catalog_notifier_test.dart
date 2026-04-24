import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/digital_cards_catalog_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/digital_cards_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/3_data/digital_cards_repository_provider.dart';

class _FakeRepository implements DigitalCardsRepository {
  _FakeRepository(this._result);

  final Object _result;

  @override
  Future<DigitalCardsCatalog> loadCatalog() async {
    final result = _result;
    if (result is DigitalCardsCatalog) {
      return result;
    }
    if (result is Error) {
      throw result;
    }
    throw Exception(result.toString());
  }
}

void main() {
  group('DigitalCardsCatalogNotifier', () {
    final loadedCatalog = DigitalCardsCatalog(
      cards: const <DigitalCard>[
        DigitalCard(
          id: 'card-1',
          type: DigitalCardType.familiaNumerosa,
          status: DigitalCardStatus.available,
        ),
      ],
      lastUpdatedAt: DateTime(2026, 4, 22),
      state: DigitalCardsCatalogState.loaded,
    );

    final emptyCatalog = DigitalCardsCatalog(
      cards: const <DigitalCard>[],
      lastUpdatedAt: DateTime(2026, 4, 22),
      state: DigitalCardsCatalogState.empty,
    );

    ProviderContainer makeContainer(final Object result) => ProviderContainer(
      overrides: [
        digitalCardsRepositoryProvider.overrideWith(
          (final ref) => _FakeRepository(result),
        ),
      ],
    );

    test('loaded state exposes all cards from the repository', () async {
      final container = makeContainer(loadedCatalog);
      addTearDown(container.dispose);
      final catalog = await container.read(digitalCardsCatalogProvider.future);
      expect(catalog.state, DigitalCardsCatalogState.loaded);
      expect(catalog.cards, hasLength(1));
      expect(catalog.cards.single.type, DigitalCardType.familiaNumerosa);
    });

    test('empty state exposes zero cards', () async {
      final container = makeContainer(emptyCatalog);
      addTearDown(container.dispose);
      final catalog = await container.read(digitalCardsCatalogProvider.future);
      expect(catalog.state, DigitalCardsCatalogState.empty);
      expect(catalog.cards, isEmpty);
    });

    test('error from the repository surfaces as AsyncError', () async {
      final container = makeContainer(StateError('boom'));
      addTearDown(container.dispose);
      await expectLater(
        container.read(digitalCardsCatalogProvider.future),
        throwsA(isA<StateError>()),
      );
      final state = container.read(digitalCardsCatalogProvider);
      expect(state.hasError, isTrue);
    });
  });
}
