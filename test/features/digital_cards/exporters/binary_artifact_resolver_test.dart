import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/binary_artifact_resolver.dart';

Uint8List _padTo(final List<int> head, final int size) {
  final out = Uint8List(size);
  for (var i = 0; i < head.length; i++) {
    out[i] = head[i];
  }
  return out;
}

void main() {
  group('BinaryArtifact.validateMagic', () {
    test('PDF with %PDF- header and >= 1 KiB → null (valid)', () {
      final bytes = _padTo(<int>[0x25, 0x50, 0x44, 0x46, 0x2D], 2048);
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.pdf,
        source: BinaryArtifactSource.bytes(bytes),
        suggestedFileNameBase: 'familia-numerosa',
        originEndpoint: '/carnet-digital/pdf/x',
      );
      expect(validateBinaryArtifact(artifact), isNull);
    });

    test('PDF with wrong magic → invalidMagic', () {
      final bytes = _padTo(<int>[0x00, 0x00, 0x00, 0x00, 0x00], 2048);
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.pdf,
        source: BinaryArtifactSource.bytes(bytes),
        suggestedFileNameBase: 'joven',
        originEndpoint: '/carnet-digital/pdf/x',
      );
      expect(
        validateBinaryArtifact(artifact),
        BinaryArtifactValidationFailure.invalidMagic,
      );
    });

    test('PNG with full signature and >= 256 B → null (valid)', () {
      final bytes = _padTo(
        <int>[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A],
        512,
      );
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.png,
        source: BinaryArtifactSource.bytes(bytes),
        suggestedFileNameBase: 'qr',
        originEndpoint: '/carnet-digital/qr/x',
      );
      expect(validateBinaryArtifact(artifact), isNull);
    });

    test('PNG with broken signature → invalidMagic', () {
      final bytes = _padTo(<int>[0x89, 0x50, 0x4E, 0x00], 512);
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.png,
        source: BinaryArtifactSource.bytes(bytes),
        suggestedFileNameBase: 'qr',
        originEndpoint: '/carnet-digital/qr/x',
      );
      expect(
        validateBinaryArtifact(artifact),
        BinaryArtifactValidationFailure.invalidMagic,
      );
    });

    test('PKPass with ZIP magic + pass.json + >= 4 KiB → null (valid)', () {
      final builder = BytesBuilder()
        ..add(<int>[0x50, 0x4B, 0x03, 0x04])
        ..add(List<int>.filled(2048, 0x20))
        ..add('pass.json'.codeUnits)
        ..add(List<int>.filled(2048, 0x20));
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.pkpass,
        source: BinaryArtifactSource.bytes(builder.toBytes()),
        suggestedFileNameBase: 'familia-numerosa',
        originEndpoint: '/carnet-digital/familia-numerosa-pkpass/x',
      );
      expect(validateBinaryArtifact(artifact), isNull);
    });

    test('PKPass without pass.json entry → invalidMagic', () {
      final bytes = _padTo(<int>[0x50, 0x4B, 0x03, 0x04], 8192);
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.pkpass,
        source: BinaryArtifactSource.bytes(bytes),
        suggestedFileNameBase: 'discapacidad',
        originEndpoint: '/carnet-digital/discapacidad-pkpass/x',
      );
      expect(
        validateBinaryArtifact(artifact),
        BinaryArtifactValidationFailure.invalidMagic,
      );
    });

    test('Base64 source decoded transparently', () {
      final bytes = _padTo(<int>[0x25, 0x50, 0x44, 0x46, 0x2D], 2048);
      final encoded = base64.encode(bytes);
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.pdf,
        source: BinaryArtifactSource.base64(encoded),
        suggestedFileNameBase: 'joven',
        originEndpoint: '/carnet-digital/pdf/x',
      );
      expect(validateBinaryArtifact(artifact), isNull);
    });

    test('Unavailable source → unsupportedSource', () {
      const artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.pdf,
        source: BinaryArtifactSource.unavailable('codError=99'),
        suggestedFileNameBase: 'joven',
        originEndpoint: '/carnet-digital/pdf/x',
      );
      expect(
        validateBinaryArtifact(artifact),
        BinaryArtifactValidationFailure.unsupportedSource,
      );
    });

    test('QR text within capacity → null', () {
      const artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.qrText,
        source: BinaryArtifactSource.text('https://carpeta.jccm.es/x'),
        suggestedFileNameBase: 'qr',
        originEndpoint: '/carnet-digital/qr/x',
      );
      expect(validateBinaryArtifact(artifact), isNull);
    });

    test('QR text over 2953 chars → tooLarge', () {
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.qrText,
        source: BinaryArtifactSource.text('a' * 3000),
        suggestedFileNameBase: 'qr',
        originEndpoint: '/carnet-digital/qr/x',
      );
      expect(
        validateBinaryArtifact(artifact),
        BinaryArtifactValidationFailure.tooLarge,
      );
    });

    test('Empty bytes → empty', () {
      final artifact = BinaryArtifact(
        sourceKind: BinaryArtifactKind.pdf,
        source: BinaryArtifactSource.bytes(Uint8List(0)),
        suggestedFileNameBase: 'joven',
        originEndpoint: '/carnet-digital/pdf/x',
      );
      expect(
        validateBinaryArtifact(artifact),
        BinaryArtifactValidationFailure.empty,
      );
    });
  });

  group('deterministicFileName', () {
    final fixedNow = DateTime.utc(2026, 4, 21, 10, 30, 15, 250);

    test('shape matches the TASK-53 contract', () {
      final name = deterministicFileName(
        cardKind: 'familia-numerosa',
        format: BinaryArtifactKind.pdf,
        endpoint: '/carnet-digital/pdf/123',
        dniHashSeed: '12345678Z',
        now: fixedNow,
      );
      expect(
        name,
        matches(RegExp(r'^familia-numerosa-pdf-20260421-[0-9a-f]{8}\.pdf$')),
      );
    });

    test('idempotent for the same inputs', () {
      final a = deterministicFileName(
        cardKind: 'joven',
        format: BinaryArtifactKind.png,
        endpoint: '/carnet-digital/qr/x',
        dniHashSeed: '12345678Z',
        now: fixedNow,
      );
      final b = deterministicFileName(
        cardKind: 'joven',
        format: BinaryArtifactKind.png,
        endpoint: '/carnet-digital/qr/x',
        dniHashSeed: '12345678Z',
        now: fixedNow,
      );
      expect(a, b);
    });

    test('changes when the DNI seed changes (uniqueness)', () {
      final a = deterministicFileName(
        cardKind: 'joven',
        format: BinaryArtifactKind.png,
        endpoint: '/carnet-digital/qr/x',
        dniHashSeed: '11111111H',
        now: fixedNow,
      );
      final b = deterministicFileName(
        cardKind: 'joven',
        format: BinaryArtifactKind.png,
        endpoint: '/carnet-digital/qr/x',
        dniHashSeed: '22222222J',
        now: fixedNow,
      );
      expect(a, isNot(b));
    });

    test('DNI is never embedded in the filename', () {
      const dni = '12345678Z';
      final name = deterministicFileName(
        cardKind: 'familia-numerosa',
        format: BinaryArtifactKind.pkpass,
        endpoint: '/carnet-digital/familia-numerosa-pkpass/x',
        dniHashSeed: dni,
        now: fixedNow,
      );
      expect(name.contains(dni), isFalse);
      expect(name.toLowerCase().contains(dni.toLowerCase()), isFalse);
    });

    test('PNG kind produces -qr- format slug per TASK-53', () {
      final name = deterministicFileName(
        cardKind: 'joven',
        format: BinaryArtifactKind.png,
        endpoint: '/carnet-digital/qr/x',
        dniHashSeed: '00000000T',
        now: fixedNow,
      );
      expect(name.contains('-qr-'), isTrue);
      expect(name.endsWith('.png'), isTrue);
    });
  });
}
