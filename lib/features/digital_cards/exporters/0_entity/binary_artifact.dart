/// Digital cards exporters (EPIC-7 / STORY-52) — pure-Dart entity.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_source.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_validation_failure.dart';

/// Magic header lengths used by [BinaryArtifact.validateMagic].
const int _kPdfMagicLen = 5;
const int _kPngMagicLen = 8;
const int _kZipMagicLen = 4;

/// Minimum decoded sizes (provisional, per TASK-53 discovery).
const int _kMinPdfBytes = 1024; // 1 KiB
const int _kMinPngBytes = 256;
const int _kMinPkpassBytes = 4096; // 4 KiB
const int _kMaxQrTextChars = 2953; // QR alphanumeric capacity ceiling.

/// Hard ceiling for in-memory payloads (4 MiB) — above this we refuse to
/// keep the bytes around regardless of magic.
const int _kMaxBytes = 4 * 1024 * 1024;

/// Value object describing a single artifact retrieved from the
/// `/carnet-digital/*` namespace before it is persisted to a temp file.
///
/// Pure Dart — no Flutter / Dio (canon §11). Magic / size validation is
/// performed by [validateMagic]; the domain layer additionally runs a
/// length check via the resolver.
final class BinaryArtifact {
  const BinaryArtifact({
    required this.sourceKind,
    required this.source,
    required this.suggestedFileNameBase,
    required this.originEndpoint,
  });

  /// Kind of artifact (PDF / PNG / PKPass / QR text).
  final BinaryArtifactKind sourceKind;

  /// Raw source as delivered by the backend.
  final BinaryArtifactSource source;

  /// Stable card-kind slug used by the deterministic file-name helper
  /// (e.g. `familia-numerosa`, `joven`, `discapacidad`).
  final String suggestedFileNameBase;

  /// Endpoint path that produced this artifact (used to seed the
  /// short hash in the deterministic filename — never logged with PII).
  final String originEndpoint;

  /// Returns the decoded bytes for binary kinds, or `null` for
  /// [BinaryArtifactKind.qrText] (which is text-only) or for unavailable
  /// / unsupported sources. Never throws.
  Uint8List? tryDecodeBytes() {
    final src = source;
    return switch (src) {
      BinaryArtifactSourceBytes() => src.bytes,
      BinaryArtifactSourceBase64() => _tryDecodeBase64(src.value),
      BinaryArtifactSourceText() => null,
      BinaryArtifactSourceUnavailable() => null,
    };
  }

  /// Returns the decoded text for [BinaryArtifactKind.qrText] sources,
  /// or `null` otherwise.
  String? tryDecodeText() {
    final src = source;
    if (src is BinaryArtifactSourceText) {
      return src.value;
    }
    return null;
  }

  /// Performs the magic-header check per kind. Returns `null` when the
  /// payload looks well-formed, or a [BinaryArtifactValidationFailure]
  /// otherwise. This method does **not** apply the length thresholds
  /// from the resolver — it only inspects the magic signature.
  BinaryArtifactValidationFailure? validateMagic() {
    final src = source;
    if (src is BinaryArtifactSourceUnavailable) {
      return BinaryArtifactValidationFailure.unsupportedSource;
    }
    if (sourceKind == BinaryArtifactKind.qrText) {
      final text = tryDecodeText();
      if (text == null) {
        return BinaryArtifactValidationFailure.unsupportedSource;
      }
      if (text.isEmpty) {
        return BinaryArtifactValidationFailure.empty;
      }
      if (text.length > _kMaxQrTextChars) {
        return BinaryArtifactValidationFailure.tooLarge;
      }
      return null;
    }
    final bytes = tryDecodeBytes();
    if (bytes == null) {
      return BinaryArtifactValidationFailure.unsupportedSource;
    }
    if (bytes.isEmpty) {
      return BinaryArtifactValidationFailure.empty;
    }
    if (bytes.length > _kMaxBytes) {
      return BinaryArtifactValidationFailure.tooLarge;
    }
    return switch (sourceKind) {
      BinaryArtifactKind.pdf => _checkPdf(bytes),
      BinaryArtifactKind.png => _checkPng(bytes),
      BinaryArtifactKind.pkpass => _checkPkpass(bytes),
      BinaryArtifactKind.qrText => null, // unreachable
    };
  }

  static BinaryArtifactValidationFailure? _checkPdf(final Uint8List b) {
    if (b.length < _kPdfMagicLen) {
      return BinaryArtifactValidationFailure.invalidMagic;
    }
    // %PDF-
    if (b[0] != 0x25 ||
        b[1] != 0x50 ||
        b[2] != 0x44 ||
        b[3] != 0x46 ||
        b[4] != 0x2D) {
      return BinaryArtifactValidationFailure.invalidMagic;
    }
    if (b.length < _kMinPdfBytes) {
      return BinaryArtifactValidationFailure.tooLarge; // truncated
    }
    return null;
  }

  static BinaryArtifactValidationFailure? _checkPng(final Uint8List b) {
    if (b.length < _kPngMagicLen) {
      return BinaryArtifactValidationFailure.invalidMagic;
    }
    const sig = <int>[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    for (var i = 0; i < sig.length; i++) {
      if (b[i] != sig[i]) {
        return BinaryArtifactValidationFailure.invalidMagic;
      }
    }
    if (b.length < _kMinPngBytes) {
      return BinaryArtifactValidationFailure.tooLarge; // truncated
    }
    return null;
  }

  static BinaryArtifactValidationFailure? _checkPkpass(final Uint8List b) {
    if (b.length < _kZipMagicLen) {
      return BinaryArtifactValidationFailure.invalidMagic;
    }
    // ZIP local file header: PK\x03\x04
    if (b[0] != 0x50 || b[1] != 0x4B || b[2] != 0x03 || b[3] != 0x04) {
      return BinaryArtifactValidationFailure.invalidMagic;
    }
    if (b.length < _kMinPkpassBytes) {
      return BinaryArtifactValidationFailure.tooLarge; // truncated
    }
    // Heuristic: pkpass archives must contain a `pass.json` entry. We
    // don't carry a full ZIP parser — searching for the literal filename
    // byte sequence is sufficient as a quick gate before handing the
    // file to PassKit (which performs full validation server-side).
    const needle = <int>[
      0x70, 0x61, 0x73, 0x73, 0x2E, 0x6A, 0x73, 0x6F, 0x6E, // "pass.json"
    ];
    if (!_containsSequence(b, needle)) {
      return BinaryArtifactValidationFailure.invalidMagic;
    }
    return null;
  }

  static bool _containsSequence(final Uint8List haystack, final List<int> needle) {
    if (needle.isEmpty || haystack.length < needle.length) {
      return false;
    }
    final last = haystack.length - needle.length;
    outer:
    for (var i = 0; i <= last; i++) {
      for (var j = 0; j < needle.length; j++) {
        if (haystack[i + j] != needle[j]) {
          continue outer;
        }
      }
      return true;
    }
    return false;
  }

  static Uint8List? _tryDecodeBase64(final String raw) {
    final stripped = _stripDataUriPrefix(raw).replaceAll(RegExp(r'\s'), '');
    if (stripped.isEmpty) {
      return Uint8List(0);
    }
    try {
      return base64.decode(stripped);
    } on FormatException {
      return null;
    }
  }

  static String _stripDataUriPrefix(final String raw) {
    const marker = ';base64,';
    if (raw.startsWith('data:')) {
      final idx = raw.indexOf(marker);
      if (idx >= 0) {
        return raw.substring(idx + marker.length);
      }
    }
    return raw;
  }
}
