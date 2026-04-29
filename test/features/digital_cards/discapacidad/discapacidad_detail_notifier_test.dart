import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/0_entity/discapacidad_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/3_data/discapacidad_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';

class _FakeRepository implements DiscapacidadRepository {
  _FakeRepository(this._cards);

  final List<DiscapacidadCard> _cards;
  int _calls = 0;

  int get calls => _calls;

  @override
  Future<DiscapacidadCard> loadCard() async {
    final idx = _calls.clamp(0, _cards.length - 1);
    _calls++;
    return _cards[idx];
  }

  @override
  Future<BinaryArtifact> requestPkpass() async => const BinaryArtifact(
    sourceKind: BinaryArtifactKind.pkpass,
    source: BinaryArtifactSource.text('x'),
    suggestedFileNameBase: 'x',
    originEndpoint: 'x',
  );
}

class _UnavailableRepository implements DiscapacidadRepository {
  @override
  Future<DiscapacidadCard> loadCard() async => throw const DiscapacidadUnavailable('no_card');

  @override
  Future<BinaryArtifact> requestPkpass() async => throw UnimplementedError();
}

DiscapacidadCard _card({final int grado = 65}) => DiscapacidadCard(
  id: 'card-1',
  holderName: 'Antonio Pérez Soto',
  grado: grado,
  status: DigitalCardStatus.available,
  expiryDate: DateTime(2027, 10, 22),
);

void main() {
  group('DiscapacidadDetailNotifier', () {
    test('build resolves the carnet from the repository', () async {
      final fake = _FakeRepository([_card()]);
      final container = ProviderContainer(
        overrides: [
          discapacidadRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);
      final card = await container.read(discapacidadDetailNotifierProvider.future);
      expect(card.grado, 65);
      expect(fake.calls, 1);
    });

    test('refresh forces a second fetch and updates the value', () async {
      final fake = _FakeRepository([_card(), _card(grado: 75)]);
      final container = ProviderContainer(
        overrides: [
          discapacidadRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);
      await container.read(discapacidadDetailNotifierProvider.future);
      await container.read(discapacidadDetailNotifierProvider.notifier).refresh();
      final refreshed = container.read(discapacidadDetailNotifierProvider).requireValue;
      expect(refreshed.grado, 75);
      expect(fake.calls, 2);
    });

    test('repository unavailable surfaces as AsyncError', () async {
      final container = ProviderContainer(
        overrides: [
          discapacidadRepositoryProvider.overrideWithValue(_UnavailableRepository()),
        ],
      );
      addTearDown(container.dispose);
      container.read(discapacidadDetailNotifierProvider);
      for (var i = 0; i < 100; i++) {
        await Future<void>.delayed(Duration.zero);
        final s = container.read(discapacidadDetailNotifierProvider);
        if (!s.isLoading) {
          break;
        }
      }
      final state = container.read(discapacidadDetailNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<DiscapacidadUnavailable>());
    });
  });
}
