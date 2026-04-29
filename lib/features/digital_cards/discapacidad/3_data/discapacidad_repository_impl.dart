/// Carnet Discapacidad (EPIC-7 / STORY-51) — data.
///
/// Mock repository returning a deterministic carnet snapshot (default
/// `mockVariant.vigente`) plus a minimally valid PKPass payload that
/// satisfies `BinaryArtifact.validateMagic()`.
///
/// // TODO(future-sprint): wire /carnet-digital/grado-discapacidad/{dni}
///   and /carnet-digital/discapacidad-pkpass/{dni}.
library;

import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/0_entity/discapacidad_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_parser.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';

/// Stable values embedded in the mock payloads.
const String _kMockHolder = 'Antonio Pérez Soto';
const int _kMockGrado = 65;

/// Stable origin endpoint slug used by `WalletActionController` to
/// derive the deterministic file-name short-hash.
const String _kPkpassEndpoint = '/carnet-digital/discapacidad-pkpass/{dni}';

const String _kFileNameBase = 'discapacidad';

/// Mock branches the repository can return to drive the three explicit
/// states required by STORY-51 (vigente / no vigente / parse error).
enum DiscapacidadMockVariant {
  /// Default — happy path: grado 65, status available.
  vigente,

  /// Carnet found but no longer vigente — status `notValid`.
  noVigente,

  /// Backend payload could not be parsed at all — `loadCard` throws so
  /// the presentation surface degrades to the recoverable error state
  /// (with retry CTA) instead of the unavailable / no-data branch.
  parseError,
}

/// In-memory mock implementation of [DiscapacidadRepository].
///
/// The default variant is [DiscapacidadMockVariant.vigente]; tests
/// override the provider to drive the other two branches.
final class DiscapacidadRepositoryImpl implements DiscapacidadRepository {
  const DiscapacidadRepositoryImpl({
    this.mockVariant = DiscapacidadMockVariant.vigente,
  });

  final DiscapacidadMockVariant mockVariant;

  @override
  Future<DiscapacidadCard> loadCard() async {
    switch (mockVariant) {
      case DiscapacidadMockVariant.vigente:
        return _buildVigenteCard();
      case DiscapacidadMockVariant.noVigente:
        // Drive the parser through a free-form string so we exercise the
        // tolerant branch end-to-end (production endpoint may return a
        // bare `String`, not a structured map).
        return DiscapacidadParser.parsePayload(
          'Grado $_kMockGrado - Carnet caducado',
        );
      case DiscapacidadMockVariant.parseError:
        // Use a hard `Exception` (not [DiscapacidadUnavailable]) so the
        // presentation surface routes the failure to the recoverable
        // error widget with a retry CTA rather than the explicit
        // unavailable / no-data surface.
        throw Exception('discapacidad_payload_unparseable');
    }
  }

  DiscapacidadCard _buildVigenteCard() {
    final now = DateTime.now();
    // 30 months in the future — DateTime normalises overflow months.
    final expiry = DateTime(now.year, now.month + 30, now.day);
    return DiscapacidadCard(
      id: 'discapacidad-mock',
      holderName: _kMockHolder,
      grado: _kMockGrado,
      expiryDate: expiry,
      status: DigitalCardStatus.available,
    );
  }

  @override
  Future<BinaryArtifact> requestPkpass() async => BinaryArtifact(
    sourceKind: BinaryArtifactKind.pkpass,
    source: BinaryArtifactSource.bytes(_buildMockPkpassBytes()),
    suggestedFileNameBase: _kFileNameBase,
    originEndpoint: _kPkpassEndpoint,
  );
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
