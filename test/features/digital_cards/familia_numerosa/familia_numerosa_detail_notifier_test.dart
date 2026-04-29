import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_categoria.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_member.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/1_domain/familia_numerosa_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/1_domain/familia_numerosa_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/3_data/familia_numerosa_repository_provider.dart';

class _FakeRepository implements FamiliaNumerosaRepository {
  _FakeRepository(this._cards);

  final List<FamiliaNumerosaCard> _cards;
  int _calls = 0;

  int get calls => _calls;

  @override
  Future<FamiliaNumerosaCard> loadCard() async {
    final idx = _calls.clamp(0, _cards.length - 1);
    _calls++;
    return _cards[idx];
  }

  @override
  Future<BinaryArtifact> requestQr() async => const BinaryArtifact(
    sourceKind: BinaryArtifactKind.qrText,
    source: BinaryArtifactSource.text('x'),
    suggestedFileNameBase: 'x',
    originEndpoint: 'x',
  );

  @override
  Future<BinaryArtifact> requestPdf() async => requestQr();

  @override
  Future<BinaryArtifact> requestPkpass() async => requestQr();
}

FamiliaNumerosaCard _card({final String holderName = 'María García López'}) => FamiliaNumerosaCard(
  id: 'card-1',
  holderName: holderName,
  cardNumber: 'FN-0451-78',
  categoria: FamiliaNumerosaCategoria.especial,
  status: DigitalCardStatus.available,
  members: const <FamiliaNumerosaMember>[
    FamiliaNumerosaMember(name: 'María García López', parentesco: 'titular'),
  ],
);

void main() {
  group('FamiliaNumerosaDetailNotifier', () {
    test('build resolves the carnet from the repository', () async {
      final fake = _FakeRepository([_card()]);
      final container = ProviderContainer(
        overrides: [
          familiaNumerosaRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);
      final card = await container.read(familiaNumerosaDetailNotifierProvider.future);
      expect(card.holderName, 'María García López');
      expect(fake.calls, 1);
    });

    test('refresh forces a second fetch and updates the value', () async {
      final fake = _FakeRepository([
        _card(),
        _card(holderName: 'Otra Persona'),
      ]);
      final container = ProviderContainer(
        overrides: [
          familiaNumerosaRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);
      await container.read(familiaNumerosaDetailNotifierProvider.future);
      await container.read(familiaNumerosaDetailNotifierProvider.notifier).refresh();
      final refreshed = container.read(familiaNumerosaDetailNotifierProvider).requireValue;
      expect(refreshed.holderName, 'Otra Persona');
      expect(fake.calls, 2);
    });

    test('repository unavailable surfaces as AsyncError', () async {
      final container = ProviderContainer(
        overrides: [
          familiaNumerosaRepositoryProvider.overrideWithValue(_ThrowingRepository()),
        ],
      );
      addTearDown(container.dispose);
      // Trigger a build via a synchronous read; then poll the state
      // until it transitions out of `loading`.
      container.read(familiaNumerosaDetailNotifierProvider);
      for (var i = 0; i < 100; i++) {
        await Future<void>.delayed(Duration.zero);
        final s = container.read(familiaNumerosaDetailNotifierProvider);
        if (!s.isLoading) {
          break;
        }
      }
      final state = container.read(familiaNumerosaDetailNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<FamiliaNumerosaUnavailable>());
    });
  });
}

class _ThrowingRepository implements FamiliaNumerosaRepository {
  @override
  Future<FamiliaNumerosaCard> loadCard() async => throw const FamiliaNumerosaUnavailable('no_card');

  @override
  Future<BinaryArtifact> requestQr() async => throw UnimplementedError();

  @override
  Future<BinaryArtifact> requestPdf() async => throw UnimplementedError();

  @override
  Future<BinaryArtifact> requestPkpass() async => throw UnimplementedError();
}
