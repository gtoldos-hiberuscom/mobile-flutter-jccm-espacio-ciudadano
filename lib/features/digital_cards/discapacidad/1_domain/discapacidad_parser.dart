/// Carnet Discapacidad (EPIC-7 / STORY-51) — payload parser.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §12).
///
/// The reconocimiento de grado backend is documented to return either
/// a structured map or a free-form string ("Grado 65 - Vigente"); this
/// parser tolerates both shapes and degrades gracefully so the UI can
/// always render an explicit state instead of an opaque error.
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/0_entity/discapacidad_card.dart';

/// Regex used to extract the grado (an integer 1..3 digits) from a
/// free-form string payload.
final RegExp _kGradoRegex = RegExp(r'(\d{1,3})');

/// Tokens (lower-cased) that mark the carnet as no vigente / caducado.
const List<String> _kNoVigenteTokens = <String>[
  'no vigente',
  'caducado',
  'caducada',
  'no valido',
  'no válido',
];

/// Pure parsing utility for `/carnet-digital/grado-discapacidad/{dni}`
/// payloads.
///
/// All entry points are static and side-effect free so they can be
/// unit-tested in isolation and reused from both the live datasource
/// (once wired) and the mock implementation.
abstract final class DiscapacidadParser {
  /// Parses [raw] into a [DiscapacidadCard].
  ///
  /// Tolerated shapes:
  ///   * `Map<String, dynamic>` with optional keys `grado`,
  ///     `holderName`, `vigente`, `expiryDate`, `payloadString`.
  ///   * Bare `String` containing something like `"Grado 65 - Vigente"`.
  ///   * Anything else → returns an entity with
  ///     `status = notAvailable`, `gradoLabel = null` and
  ///     `parseFailure = payloadUnparseable`.
  static DiscapacidadCard parsePayload(final Object? raw, {final String id = 'discapacidad'}) {
    if (raw is Map) {
      return _parseMap(raw, id: id);
    }
    if (raw is String) {
      return _parseString(raw, id: id);
    }
    return DiscapacidadCard(
      id: id,
      status: DigitalCardStatus.notAvailable,
      parseFailure: DiscapacidadParseFailure.payloadUnparseable,
    );
  }

  static DiscapacidadCard _parseMap(final Map<dynamic, dynamic> raw, {required final String id}) {
    final holderRaw = raw['holderName'];
    final holderName = holderRaw is String && holderRaw.trim().isNotEmpty ? holderRaw.trim() : null;

    final expiryRaw = raw['expiryDate'];
    final expiryDate = _coerceDate(expiryRaw);

    final vigenteRaw = raw['vigente'];

    final gradoResult = _coerceGrado(raw['grado']);

    // If the structured payload also includes a payloadString, fall
    // back to the string parser when grado was not parseable from the
    // structured fields.
    final payloadString = raw['payloadString'];
    if (gradoResult.grado == null && payloadString is String) {
      final fromString = _parseString(payloadString, id: id);
      // Preserve any structured holder/expiry/vigente flag we already had.
      return DiscapacidadCard(
        id: id,
        holderName: holderName ?? fromString.holderName,
        grado: fromString.grado,
        gradoLabel: fromString.gradoLabel,
        expiryDate: expiryDate ?? fromString.expiryDate,
        status: _resolveStatus(
          vigenteFlag: vigenteRaw,
          grado: fromString.grado,
          gradoLabel: fromString.gradoLabel,
          fallback: fromString.status,
        ),
        parseFailure: fromString.parseFailure,
      );
    }

    final status = _resolveStatus(
      vigenteFlag: vigenteRaw,
      grado: gradoResult.grado,
      gradoLabel: null,
      fallback: gradoResult.grado != null ? DigitalCardStatus.available : DigitalCardStatus.notAvailable,
    );

    DiscapacidadParseFailure? failure;
    if (gradoResult.grado == null) {
      failure = gradoResult.failure ?? DiscapacidadParseFailure.missingGrado;
    }

    return DiscapacidadCard(
      id: id,
      holderName: holderName,
      grado: gradoResult.grado,
      expiryDate: expiryDate,
      status: status,
      parseFailure: failure,
    );
  }

  static DiscapacidadCard _parseString(final String raw, {required final String id}) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return DiscapacidadCard(
        id: id,
        status: DigitalCardStatus.notAvailable,
        parseFailure: DiscapacidadParseFailure.payloadUnparseable,
      );
    }

    final lower = trimmed.toLowerCase();
    final isNoVigente = _kNoVigenteTokens.any(lower.contains);

    final match = _kGradoRegex.firstMatch(trimmed);
    int? grado;
    DiscapacidadParseFailure? failure;
    if (match != null) {
      final parsed = int.tryParse(match.group(1)!);
      if (parsed != null && parsed >= 1 && parsed <= 100) {
        grado = parsed;
      } else {
        failure = DiscapacidadParseFailure.malformedGrado;
      }
    } else {
      failure = DiscapacidadParseFailure.missingGrado;
    }

    final DigitalCardStatus status;
    if (grado == null) {
      // Without a recognisable grado we cannot honour even a "vigente"
      // claim — surface the empty-data fallback.
      status = DigitalCardStatus.notAvailable;
    } else if (isNoVigente) {
      status = DigitalCardStatus.notValid;
    } else {
      status = DigitalCardStatus.available;
    }

    return DiscapacidadCard(
      id: id,
      grado: grado,
      gradoLabel: trimmed,
      status: status,
      parseFailure: failure,
    );
  }

  static _GradoResult _coerceGrado(final Object? raw) {
    if (raw == null) {
      return const _GradoResult(grado: null, failure: DiscapacidadParseFailure.missingGrado);
    }
    if (raw is int) {
      if (raw >= 1 && raw <= 100) {
        return _GradoResult(grado: raw, failure: null);
      }
      return const _GradoResult(grado: null, failure: DiscapacidadParseFailure.malformedGrado);
    }
    if (raw is num) {
      final asInt = raw.toInt();
      if (asInt >= 1 && asInt <= 100) {
        return _GradoResult(grado: asInt, failure: null);
      }
      return const _GradoResult(grado: null, failure: DiscapacidadParseFailure.malformedGrado);
    }
    if (raw is String) {
      final match = _kGradoRegex.firstMatch(raw);
      if (match != null) {
        final parsed = int.tryParse(match.group(1)!);
        if (parsed != null && parsed >= 1 && parsed <= 100) {
          return _GradoResult(grado: parsed, failure: null);
        }
      }
      return const _GradoResult(grado: null, failure: DiscapacidadParseFailure.malformedGrado);
    }
    return const _GradoResult(grado: null, failure: DiscapacidadParseFailure.malformedGrado);
  }

  static DateTime? _coerceDate(final Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is DateTime) {
      return raw;
    }
    if (raw is String) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  static DigitalCardStatus _resolveStatus({
    required final Object? vigenteFlag,
    required final int? grado,
    required final String? gradoLabel,
    required final DigitalCardStatus fallback,
  }) {
    if (vigenteFlag is bool) {
      if (!vigenteFlag) {
        return DigitalCardStatus.notValid;
      }
      if (grado == null && gradoLabel == null) {
        return DigitalCardStatus.notAvailable;
      }
      return DigitalCardStatus.available;
    }
    return fallback;
  }
}

class _GradoResult {
  const _GradoResult({required this.grado, required this.failure});
  final int? grado;
  final DiscapacidadParseFailure? failure;
}
