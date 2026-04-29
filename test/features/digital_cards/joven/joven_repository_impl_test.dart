import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/binary_artifact_resolver.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/3_data/joven_repository_impl.dart';

void main() {
  group('JovenRepositoryImpl mock content', () {
    const repo = JovenRepositoryImpl();

    test('loadCard returns the deterministic carnet snapshot', () async {
      final card = await repo.loadCard();
      expect(card.id, 'joven-mock');
      expect(card.holderName, 'Lucía Fernández Ruiz');
      expect(card.codigo, 'CJ-2025-088771');
      expect(card.status, DigitalCardStatus.available);
      expect(card.expiryDate, isNotNull);
      // Expiry must be 24 months in the future.
      final now = DateTime.now();
      final expected = DateTime(now.year, now.month + 24, now.day);
      expect(card.expiryDate, expected);
      expect(card.actionsEnabled, isTrue);
    });

    test('requestQr returns a stable URL text artifact that validates', () async {
      final artifact = await repo.requestQr();
      expect(artifact.sourceKind, BinaryArtifactKind.qrText);
      expect(artifact.suggestedFileNameBase, 'joven');
      expect(artifact.originEndpoint, '/carnet-digital/qr/{dni}');
      final source = artifact.source;
      expect(source, isA<BinaryArtifactSourceText>());
      expect((source as BinaryArtifactSourceText).value, 'https://carnet.jccm.es/joven/CJ-2025-088771');
      expect(artifact.validateMagic(), isNull);
      expect(validateBinaryArtifact(artifact), isNull);
    });

    test('requestPdf returns a magic-valid PDF payload', () async {
      final artifact = await repo.requestPdf();
      expect(artifact.sourceKind, BinaryArtifactKind.pdf);
      expect(artifact.originEndpoint, '/carnet-digital/pdf/{dni}');
      expect(artifact.validateMagic(), isNull);
      expect(validateBinaryArtifact(artifact), isNull);
      final bytes = artifact.tryDecodeBytes();
      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThanOrEqualTo(1024));
      // First five bytes are the %PDF- magic.
      expect(bytes.sublist(0, 5), <int>[0x25, 0x50, 0x44, 0x46, 0x2D]);
    });

    test('requestPkpass returns a magic-valid PKPass payload', () async {
      final artifact = await repo.requestPkpass();
      expect(artifact.sourceKind, BinaryArtifactKind.pkpass);
      expect(artifact.originEndpoint, '/carnet-digital/pkpass/{dni}');
      expect(artifact.validateMagic(), isNull);
      expect(validateBinaryArtifact(artifact), isNull);
      final bytes = artifact.tryDecodeBytes();
      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThanOrEqualTo(4096));
      // First four bytes are the ZIP local-file-header magic.
      expect(bytes.sublist(0, 4), <int>[0x50, 0x4B, 0x03, 0x04]);
      // Embeds the literal `pass.json` file-name token.
      final ascii = String.fromCharCodes(bytes);
      expect(ascii.contains('pass.json'), isTrue);
    });
  });
}
