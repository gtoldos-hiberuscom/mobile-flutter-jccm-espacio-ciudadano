/// Tolerant SESCAM payload parser scaffold (TASK-32, Sprint 4).
///
/// See `documentation/discovery/TASK-32-sescam-payload-strategy.md` for the
/// full decision rationale. The three SESCAM operations contracted in the
/// JCCM façade (`/sescam/citas`, `/sescam/citas-pasadas`, `/sescam/cip`)
/// return their body as `string`. The exact shape is unknown until
/// preproduction access is granted (R1).
///
/// Pure Dart, no Flutter, no Riverpod, no DTO imports — fits inside
/// `3_data/` per the architecture canon §11.
library;

import 'dart:convert';

/// Master kill-switch for live SESCAM parsing. Defaults to `false` until
/// at least one real preproduction sample is captured.
const bool kSescamLiveParsingEnabled = false;

// ── Models ───────────────────────────────────────────────────────────────

final class SescamCita {
  const SescamCita({
    required this.id,
    this.fecha,
    this.hora,
    this.centro,
    this.servicio,
    this.profesional,
    this.tipo,
    this.ubicacion,
    this.justificante,
  });

  final String id;
  final DateTime? fecha;
  final String? hora;
  final String? centro;
  final String? servicio;
  final String? profesional;
  final String? tipo;
  final String? ubicacion;
  final SescamJustificante? justificante;
}

final class SescamJustificante {
  const SescamJustificante({required this.url, this.mime});
  final String url;
  final String? mime;
}

final class SescamCitasPayload {
  const SescamCitasPayload({
    required this.citas,
    this.estado,
    this.mensaje,
  });
  final List<SescamCita> citas;
  final String? estado;
  final String? mensaje;
}

final class SescamCipPayload {
  const SescamCipPayload({
    required this.cip,
    this.titular,
    this.fechaNacimiento,
    this.centroSalud,
    this.regionSanitaria,
  });
  final String cip;
  final String? titular;
  final DateTime? fechaNacimiento;
  final String? centroSalud;
  final String? regionSanitaria;
}

// ── Errors ───────────────────────────────────────────────────────────────

enum SescamParseErrorKind {
  empty,
  unknownShape,
  partial,
  serverEnvelopeKo,
}

final class SescamParseError {
  const SescamParseError({
    required this.kind,
    this.reason,
    this.rawPreview,
  });

  final SescamParseErrorKind kind;
  final String? reason;
  final String? rawPreview;

  factory SescamParseError.empty() => const SescamParseError(kind: SescamParseErrorKind.empty);

  factory SescamParseError.unknownShape(final String raw) => SescamParseError(
    kind: SescamParseErrorKind.unknownShape,
    reason: 'unknown_shape',
    rawPreview: raw.length > 256 ? raw.substring(0, 256) : raw,
  );

  factory SescamParseError.partial(final String reason) => SescamParseError(kind: SescamParseErrorKind.partial, reason: reason);

  factory SescamParseError.serverKo(final String? mensaje) => SescamParseError(
    kind: SescamParseErrorKind.serverEnvelopeKo,
    reason: mensaje,
  );
}

// ── Result ───────────────────────────────────────────────────────────────

final class SescamParseResult<T> {
  const SescamParseResult._({this.value, this.error});

  final T? value;
  final SescamParseError? error;

  bool get isOk => error == null;

  factory SescamParseResult.ok(final T value) => SescamParseResult<T>._(value: value);
  factory SescamParseResult.err(final SescamParseError error) => SescamParseResult<T>._(error: error);
}

// ── Parsers ──────────────────────────────────────────────────────────────

class SescamCitasParser {
  const SescamCitasParser();

  SescamParseResult<SescamCitasPayload> parse(final String? raw) {
    final payload = (raw ?? '').trim();
    if (payload.isEmpty) {
      return SescamParseResult.err(SescamParseError.empty());
    }

    final fromJsonObject = _tryJsonObject(payload);
    if (fromJsonObject != null) {
      return fromJsonObject;
    }

    final fromJsonArray = _tryJsonArray(payload);
    if (fromJsonArray != null) {
      return fromJsonArray;
    }

    final fromLines = _tryLineSeparated(payload);
    if (fromLines != null) {
      return fromLines;
    }

    final fromBase64 = _tryBase64(payload);
    if (fromBase64 != null) {
      return fromBase64;
    }

    return SescamParseResult.err(SescamParseError.unknownShape(payload));
  }

  SescamParseResult<SescamCitasPayload>? _tryJsonObject(final String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      final estado = decoded['estado']?.toString();
      final mensaje = decoded['mensaje']?.toString();
      if (estado != null && estado.toUpperCase() == 'KO') {
        return SescamParseResult.err(SescamParseError.serverKo(mensaje));
      }
      final rawCitas = decoded['citas'];
      final citas = rawCitas is List ? rawCitas.whereType<Map<String, dynamic>>().map(_decodeCita).whereType<SescamCita>().toList(growable: false) : const <SescamCita>[];
      return SescamParseResult.ok(
        SescamCitasPayload(citas: citas, estado: estado, mensaje: mensaje),
      );
    } on FormatException {
      return null;
    }
  }

  SescamParseResult<SescamCitasPayload>? _tryJsonArray(final String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return null;
      }
      final citas = decoded.whereType<Map<String, dynamic>>().map(_decodeCita).whereType<SescamCita>().toList(growable: false);
      return SescamParseResult.ok(SescamCitasPayload(citas: citas));
    } on FormatException {
      return null;
    }
  }

  SescamParseResult<SescamCitasPayload>? _tryLineSeparated(final String raw) {
    final lines = raw.split(RegExp(r'\r?\n')).where((final l) => l.trim().isNotEmpty).toList(growable: false);
    if (lines.isEmpty) {
      return null;
    }
    if (!lines.any((final l) => l.contains(';') || l.contains('|'))) {
      return null;
    }
    final citas = <SescamCita>[];
    for (var i = 0; i < lines.length; i++) {
      final cells = lines[i].split(RegExp('[;|]'));
      if (cells.isEmpty) {
        continue;
      }
      citas.add(
        SescamCita(
          id: 'cita-line-$i',
          fecha: cells.isNotEmpty ? _parseDate(cells[0]) : null,
          hora: cells.length > 1 ? cells[1].trim() : null,
          centro: cells.length > 2 ? cells[2].trim() : null,
          servicio: cells.length > 3 ? cells[3].trim() : null,
          profesional: cells.length > 4 ? cells[4].trim() : null,
        ),
      );
    }
    return SescamParseResult.ok(SescamCitasPayload(citas: citas));
  }

  SescamParseResult<SescamCitasPayload>? _tryBase64(final String raw) {
    if (!_looksLikeBase64(raw)) {
      return null;
    }
    try {
      final decoded = utf8.decode(base64.decode(raw));
      final inner = parse(decoded);
      if (inner.isOk) {
        return inner;
      }
      return null;
    } on FormatException {
      return null;
    }
  }

  SescamCita? _decodeCita(final Map<String, dynamic> raw) {
    final id = raw['id']?.toString() ?? raw['idCita']?.toString();
    SescamJustificante? justificante;
    final rawJust = raw['justificante'];
    if (rawJust is Map<String, dynamic> && rawJust['url'] is String) {
      justificante = SescamJustificante(
        url: rawJust['url'] as String,
        mime: rawJust['mime']?.toString(),
      );
    }
    return SescamCita(
      id: id ?? 'cita-${raw.hashCode}',
      fecha: _parseDate(raw['fecha']?.toString()),
      hora: raw['hora']?.toString(),
      centro: raw['centro']?.toString(),
      servicio: raw['servicio']?.toString(),
      profesional: raw['profesional']?.toString(),
      tipo: raw['tipo']?.toString(),
      ubicacion: raw['ubicacion']?.toString(),
      justificante: justificante,
    );
  }
}

class SescamCipParser {
  const SescamCipParser();

  static final _cipRegex = RegExp(r'^[A-Z0-9]{8,16}$');

  SescamParseResult<SescamCipPayload> parse(final String? raw) {
    final payload = (raw ?? '').trim();
    if (payload.isEmpty) {
      return SescamParseResult.err(SescamParseError.empty());
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        final estado = decoded['estado']?.toString();
        if (estado != null && estado.toUpperCase() == 'KO') {
          return SescamParseResult.err(
            SescamParseError.serverKo(decoded['mensaje']?.toString()),
          );
        }
        final cip = decoded['cip']?.toString();
        if (cip != null && cip.isNotEmpty) {
          return SescamParseResult.ok(
            SescamCipPayload(
              cip: cip,
              titular: decoded['titular']?.toString(),
              fechaNacimiento: _parseDate(decoded['fechaNacimiento']?.toString()),
              centroSalud: decoded['centroSalud']?.toString(),
              regionSanitaria: decoded['regionSanitaria']?.toString(),
            ),
          );
        }
      }
    } on FormatException {
      // fall through
    }

    final upper = payload.toUpperCase();
    if (_cipRegex.hasMatch(upper)) {
      return SescamParseResult.ok(SescamCipPayload(cip: upper));
    }

    if (_looksLikeBase64(payload)) {
      try {
        final decoded = utf8.decode(base64.decode(payload));
        final inner = parse(decoded);
        if (inner.isOk) {
          return inner;
        }
      } on FormatException {
        // ignore
      }
    }

    return SescamParseResult.err(SescamParseError.unknownShape(payload));
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────

DateTime? _parseDate(final String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final iso = DateTime.tryParse(raw);
  if (iso != null) {
    return iso;
  }
  final m = RegExp(r'^(\d{2})[/-](\d{2})[/-](\d{4})$').firstMatch(raw);
  if (m != null) {
    final dd = int.parse(m.group(1)!);
    final mm = int.parse(m.group(2)!);
    final yyyy = int.parse(m.group(3)!);
    try {
      return DateTime(yyyy, mm, dd);
    } catch (_) {
      return null;
    }
  }
  return null;
}

bool _looksLikeBase64(final String raw) {
  if (raw.length < 8 || raw.length % 4 != 0) {
    return false;
  }
  return RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(raw);
}
