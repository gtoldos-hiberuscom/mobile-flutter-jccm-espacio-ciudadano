import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/binary_artifact_resolver.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_categoria.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/3_data/familia_numerosa_repository_impl.dart';

void main() {
  group('FamiliaNumerosaRepositoryImpl mock content', () {
    const repo = FamiliaNumerosaRepositoryImpl();

    test('loadCard returns the deterministic carnet snapshot', () async {
      final card = await repo.loadCard();
      expect(card.id, 'familia-numerosa-mock');
      expect(card.holderName, 'María García López');
      expect(card.cardNumber, 'FN-0451-78');
      expect(card.categoria, FamiliaNumerosaCategoria.especial);
      expect(card.status, DigitalCardStatus.available);
      expect(card.members, hasLength(4));
      expect(card.expiryDate, isNotNull);
      // Expiry must be roughly 18 months in the future.
      final now = DateTime.now();
      final expected = DateTime(now.year, now.month + 18, now.day);
      expect(card.expiryDate, expected);
      // First member is the titular and matches the holder.
      expect(card.members.first.parentesco, 'titular');
      expect(card.members.first.name, card.holderName);
      expect(card.actionsEnabled, isTrue);
    });

    test('requestQr returns a stable URL text artifact that validates', () async {
      final artifact = await repo.requestQr();
      expect(artifact.sourceKind, BinaryArtifactKind.qrText);
      expect(artifact.suggestedFileNameBase, 'familia-numerosa');
      expect(artifact.originEndpoint, '/carnet-digital/qr/{dni}');
      final source = artifact.source;
      expect(source, isA<BinaryArtifactSourceText>());
      expect((source as BinaryArtifactSourceText).value, 'https://carnet.jccm.es/familia-numerosa/FN-0451-78');
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
      expect(artifact.originEndpoint, '/carnet-digital/familia-numerosa-pkpass/{dni}');
      expect(artifact.validateMagic(), isNull);
      expect(validateBinaryArtifact(artifact), isNull);
      final bytes = artifact.tryDecodeBytes();
      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThanOrEqualTo(4096));
      // First four bytes are the ZIP local-file-header magic.
      expect(bytes.sublist(0, 4), <int>[0x50, 0x4B, 0x03, 0x04]);
    });
  });
}
