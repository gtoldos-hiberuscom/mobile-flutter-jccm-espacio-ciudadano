import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/3_data/discapacidad_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/binary_artifact_resolver.dart';

void main() {
  group('DiscapacidadRepositoryImpl mock variants', () {
    test('vigente → grado 65, holder, available, expiry +30 months', () async {
      const repo = DiscapacidadRepositoryImpl();
      final card = await repo.loadCard();
      expect(card.id, 'discapacidad-mock');
      expect(card.holderName, 'Antonio Pérez Soto');
      expect(card.grado, 65);
      expect(card.status, DigitalCardStatus.available);
      expect(card.expiryDate, isNotNull);
      final now = DateTime.now();
      final expected = DateTime(now.year, now.month + 30, now.day);
      expect(card.expiryDate, expected);
      expect(card.actionsEnabled, isTrue);
    });

    test('noVigente → grado parsed from string, status notValid', () async {
      const repo = DiscapacidadRepositoryImpl(mockVariant: DiscapacidadMockVariant.noVigente);
      final card = await repo.loadCard();
      expect(card.grado, 65);
      expect(card.status, DigitalCardStatus.notValid);
      expect(card.actionsEnabled, isFalse);
    });

    test('parseError → loadCard throws so the page can route to the error surface', () async {
      const repo = DiscapacidadRepositoryImpl(mockVariant: DiscapacidadMockVariant.parseError);
      await expectLater(repo.loadCard(), throwsA(isA<Exception>()));
    });

    test('requestPkpass returns a magic-valid PKPass payload', () async {
      const repo = DiscapacidadRepositoryImpl();
      final artifact = await repo.requestPkpass();
      expect(artifact.sourceKind, BinaryArtifactKind.pkpass);
      expect(artifact.suggestedFileNameBase, 'discapacidad');
      expect(artifact.originEndpoint, '/carnet-digital/discapacidad-pkpass/{dni}');
      expect(artifact.validateMagic(), isNull);
      expect(validateBinaryArtifact(artifact), isNull);
      final bytes = artifact.tryDecodeBytes();
      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThanOrEqualTo(4096));
      expect(bytes.sublist(0, 4), <int>[0x50, 0x4B, 0x03, 0x04]);
      final ascii = String.fromCharCodes(bytes);
      expect(ascii.contains('pass.json'), isTrue);
    });
  });
}
