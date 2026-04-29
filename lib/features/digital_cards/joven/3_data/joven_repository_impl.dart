/// Carnet Joven (EPIC-7 / STORY-50) — data.
///
/// Mock repository returning a deterministic carnet snapshot plus
/// minimally valid magic-byte payloads for QR / PDF / PKPass so the
/// shared `BinaryArtifactResolver` length checks and
/// `BinaryArtifact.validateMagic()` succeed end-to-end.
///
/// // TODO(future-sprint): wire /carnet-digital/joven/{dni},
///   /carnet-digital/qr/{dni}, /carnet-digital/pdf/{dni},
///   /carnet-digital/pkpass/{dni}.
library;

import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/0_entity/joven_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/1_domain/joven_repository.dart';

/// Stable values embedded in the mock payloads (deterministic — derived
/// from the mock codigo so tests can assert byte-for-byte).
const String _kMockCodigo = 'CJ-2025-088771';
const String _kMockHolder = 'Lucía Fernández Ruiz';
const String _kMockQrUrl = 'https://carnet.jccm.es/joven/$_kMockCodigo';

/// Stable origin endpoint slugs used to seed the deterministic file
/// name in `WalletActionController.persistAndAct`.
const String _kQrEndpoint = '/carnet-digital/qr/{dni}';
const String _kPdfEndpoint = '/carnet-digital/pdf/{dni}';
const String _kPkpassEndpoint = '/carnet-digital/pkpass/{dni}';

const String _kFileNameBase = 'joven';

/// In-memory mock implementation of [JovenRepository].
final class JovenRepositoryImpl implements JovenRepository {
  const JovenRepositoryImpl();

  @override
  Future<JovenCard> loadCard() async {
    final now = DateTime.now();
    // 24 months in the future — DateTime normalises overflow months.
    final expiry = DateTime(now.year, now.month + 24, now.day);
    return JovenCard(
      id: 'joven-mock',
      holderName: _kMockHolder,
      codigo: _kMockCodigo,
      status: DigitalCardStatus.available,
      expiryDate: expiry,
    );
  }

  @override
  Future<BinaryArtifact> requestQr() async => const BinaryArtifact(
    sourceKind: BinaryArtifactKind.qrText,
    source: BinaryArtifactSource.text(_kMockQrUrl),
    suggestedFileNameBase: _kFileNameBase,
    originEndpoint: _kQrEndpoint,
  );

  @override
  Future<BinaryArtifact> requestPdf() async => BinaryArtifact(
    sourceKind: BinaryArtifactKind.pdf,
    source: BinaryArtifactSource.bytes(_buildMockPdfBytes()),
    suggestedFileNameBase: _kFileNameBase,
    originEndpoint: _kPdfEndpoint,
  );

  @override
  Future<BinaryArtifact> requestPkpass() async => BinaryArtifact(
    sourceKind: BinaryArtifactKind.pkpass,
    source: BinaryArtifactSource.bytes(_buildMockPkpassBytes()),
    suggestedFileNameBase: _kFileNameBase,
    originEndpoint: _kPkpassEndpoint,
  );
}

/// Synthesises a minimally valid PDF payload (≥ 1024 bytes, starts
/// with `%PDF-`). The body is ASCII filler — never rendered, only used
/// to satisfy `BinaryArtifact.validateMagic()` until the real backend
/// payload is wired (see TODO at top of file).
Uint8List _buildMockPdfBytes() {
  const header =
      '%PDF-1.4\n'
      '%mock-joven\n'
      '1 0 obj <<>> endobj\n'
      'xref\n0 1\n0000000000 65535 f \n'
      'trailer <<>>\nstartxref\n0\n%%EOF\n';
  const footer = '\n%%EOF\n';
  // Pad with ASCII space until ≥ 1024 bytes (we target a deterministic
  // size of 1100 to leave a small margin above the threshold).
  const targetSize = 1100;
  final headerBytes = header.codeUnits;
  final footerBytes = footer.codeUnits;
  final padLen = targetSize - headerBytes.length - footerBytes.length;
  assert(padLen > 0, 'PDF mock template too large for target size');
  final pad = List<int>.filled(padLen, 0x20); // ' '
  final all = <int>[...headerBytes, ...pad, ...footerBytes];
  return Uint8List.fromList(all);
}

/// Synthesises a minimally valid PKPass payload: starts with the ZIP
/// local-file-header magic `PK\x03\x04`, embeds the literal bytes
/// `pass.json`, and is ≥ 4096 bytes long. Real PKPass parsing happens
/// in PassKit on the device; this satisfies the resolver pre-checks
/// only.
Uint8List _buildMockPkpassBytes() {
  const targetSize = 4200;
  final bytes = <int>[
    0x50, 0x4B, 0x03, 0x04, // ZIP local file header magic
    0x14, 0x00, // version needed
    0x00, 0x00, // general purpose flag
    0x00, 0x00, // compression method (stored)
    0x00, 0x00, 0x00, 0x00, // mod time / date
    0x00, 0x00, 0x00, 0x00, // crc32
    0x00, 0x00, 0x00, 0x00, // compressed size
    0x00, 0x00, 0x00, 0x00, // uncompressed size
    0x09, 0x00, // file name length = 9
    0x00, 0x00, // extra length
    // file name "pass.json"
    0x70, 0x61, 0x73, 0x73, 0x2E, 0x6A, 0x73, 0x6F, 0x6E,
  ];
  // Pad with zero bytes to the target size.
  while (bytes.length < targetSize) {
    bytes.add(0x00);
  }
  return Uint8List.fromList(bytes);
}
