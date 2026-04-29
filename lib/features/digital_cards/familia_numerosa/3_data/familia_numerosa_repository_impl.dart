/// Familia numerosa carnet (EPIC-7 / STORY-49) — data.
///
/// Mock repository returning a deterministic carnet snapshot plus
/// minimally valid magic-byte payloads for QR / PDF / PKPass so the
/// shared `BinaryArtifactResolver` length checks and
/// `BinaryArtifact.validateMagic()` succeed end-to-end.
///
/// // TODO(future-sprint): wire /carnet-digital/familia-numerosa/{dni},
///   /carnet-digital/familia-numerosa-pkpass/{dni},
///   /carnet-digital/qr/{dni}, /carnet-digital/pdf/{dni},
///   /carnet-digital/pkpass/{dni}.
library;

import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_categoria.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_member.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/1_domain/familia_numerosa_repository.dart';

/// Stable URL embedded in the QR payload (deterministic — derived from
/// the mock card number so tests can assert it byte-for-byte).
const String _kMockQrUrl = 'https://carnet.jccm.es/familia-numerosa/FN-0451-78';
const String _kMockCardNumber = 'FN-0451-78';
const String _kMockHolder = 'María García López';

/// Stable origin endpoint slugs used to seed the deterministic file
/// name in `WalletActionController.persistAndAct`.
const String _kQrEndpoint = '/carnet-digital/qr/{dni}';
const String _kPdfEndpoint = '/carnet-digital/pdf/{dni}';
const String _kPkpassEndpoint = '/carnet-digital/familia-numerosa-pkpass/{dni}';

const String _kFileNameBase = 'familia-numerosa';

/// In-memory mock implementation of [FamiliaNumerosaRepository].
final class FamiliaNumerosaRepositoryImpl implements FamiliaNumerosaRepository {
  const FamiliaNumerosaRepositoryImpl();

  @override
  Future<FamiliaNumerosaCard> loadCard() async {
    final now = DateTime.now();
    // 18 months in the future — DateTime normalises overflow months
    // (e.g. 2026-04 + 18 → 2027-10).
    final expiry = DateTime(now.year, now.month + 18, now.day);
    return FamiliaNumerosaCard(
      id: 'familia-numerosa-mock',
      holderName: _kMockHolder,
      cardNumber: _kMockCardNumber,
      categoria: FamiliaNumerosaCategoria.especial,
      status: DigitalCardStatus.available,
      expiryDate: expiry,
      members: <FamiliaNumerosaMember>[
        FamiliaNumerosaMember(
          name: _kMockHolder,
          parentesco: 'titular',
          dni: '00000000T',
          fechaNacimiento: DateTime(1985, 3, 12),
        ),
        FamiliaNumerosaMember(
          name: 'Javier Martínez Ruiz',
          parentesco: 'conyuge',
          dni: '00000000R',
          fechaNacimiento: DateTime(1984, 7, 4),
        ),
        FamiliaNumerosaMember(
          name: 'Lucía Martínez García',
          parentesco: 'hija',
          fechaNacimiento: DateTime(2014, 9, 21),
        ),
        FamiliaNumerosaMember(
          name: 'Mateo Martínez García',
          parentesco: 'hijo',
          fechaNacimiento: DateTime(2017, 1, 30),
        ),
      ],
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
  // ASCII header + minimalist xref/trailer envelope so the byte stream
  // looks plausible to defensive PDF tooling.
  const header =
      '%PDF-1.4\n'
      '%mock-familia-numerosa\n'
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
