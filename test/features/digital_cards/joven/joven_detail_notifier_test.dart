import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/0_entity/joven_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/1_domain/joven_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/1_domain/joven_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/3_data/joven_repository_provider.dart';

class _FakeRepository implements JovenRepository {
  _FakeRepository(this._cards);

  final List<JovenCard> _cards;
  int _calls = 0;

  int get calls => _calls;

  @override
  Future<JovenCard> loadCard() async {
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

JovenCard _card({final String holderName = 'Lucía Fernández Ruiz'}) => JovenCard(
  id: 'card-1',
  holderName: holderName,
  codigo: 'CJ-2025-088771',
  status: DigitalCardStatus.available,
  expiryDate: DateTime(2027, 10, 22),
);

void main() {
  group('JovenDetailNotifier', () {
    test('build resolves the carnet from the repository', () async {
      final fake = _FakeRepository([_card()]);
      final container = ProviderContainer(
        overrides: [
          jovenRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);
      final card = await container.read(jovenDetailNotifierProvider.future);
      expect(card.holderName, 'Lucía Fernández Ruiz');
      expect(fake.calls, 1);
    });

    test('refresh forces a second fetch and updates the value', () async {
      final fake = _FakeRepository([
        _card(),
        _card(holderName: 'Otra Persona'),
      ]);
      final container = ProviderContainer(
        overrides: [
          jovenRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);
      await container.read(jovenDetailNotifierProvider.future);
      await container.read(jovenDetailNotifierProvider.notifier).refresh();
      final refreshed = container.read(jovenDetailNotifierProvider).requireValue;
      expect(refreshed.holderName, 'Otra Persona');
      expect(fake.calls, 2);
    });

    test('repository unavailable surfaces as AsyncError', () async {
      final container = ProviderContainer(
        overrides: [
          jovenRepositoryProvider.overrideWithValue(_ThrowingRepository()),
        ],
      );
      addTearDown(container.dispose);
      container.read(jovenDetailNotifierProvider);
      for (var i = 0; i < 100; i++) {
        await Future<void>.delayed(Duration.zero);
        final s = container.read(jovenDetailNotifierProvider);
        if (!s.isLoading) {
          break;
        }
      }
      final state = container.read(jovenDetailNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<JovenUnavailable>());
    });
  });
}

class _ThrowingRepository implements JovenRepository {
  @override
  Future<JovenCard> loadCard() async => throw const JovenUnavailable('no_card');

  @override
  Future<BinaryArtifact> requestQr() async => throw UnimplementedError();

  @override
  Future<BinaryArtifact> requestPdf() async => throw UnimplementedError();

  @override
  Future<BinaryArtifact> requestPkpass() async => throw UnimplementedError();
}
