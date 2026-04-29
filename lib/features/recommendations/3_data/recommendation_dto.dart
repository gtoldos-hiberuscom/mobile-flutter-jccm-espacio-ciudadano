import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';

/// Tolerant DTO + parser for the recommendations endpoints (TASK-58 §D2,
/// §D6). Every field is parsed best-effort: missing keys, wrong types
/// and malformed dates degrade to `null` instead of throwing, so a
/// single corrupt entry never breaks the whole list.
final class RecommendationDto {
  RecommendationDto({
    required this.id,
    required this.title,
    required this.isImmediateProcessing,
    this.summary,
    this.lifeEventId,
    this.lifeEventLabel,
    this.responsibleUnit,
    this.deadlineLabel,
    this.publishedAt,
    this.detailUri,
  });

  final String id;
  final String title;
  final String? summary;
  final String? lifeEventId;
  final String? lifeEventLabel;
  final String? responsibleUnit;
  final String? deadlineLabel;
  final DateTime? publishedAt;
  final bool isImmediateProcessing;
  final Uri? detailUri;

  /// Returns `null` when [json] is unusable (not a Map, missing both id
  /// and title, etc). Callers are expected to filter `null`s out.
  static RecommendationDto? fromJson(final Object? json) {
    if (json is! Map) {
      return null;
    }
    final map = json;
    final id = _asString(map['id']) ?? _asString(map['idTramite']);
    final title = _asString(map['title']) ?? _asString(map['nombreTramite']);
    if (id == null || title == null) {
      return null;
    }
    return RecommendationDto(
      id: id,
      title: title,
      summary: _asString(map['summary']) ?? _asString(map['descripcion']),
      lifeEventId: _asString(map['lifeEventId']) ?? _asString(map['idHecho']),
      lifeEventLabel:
          _asString(map['lifeEventLabel']) ?? _asString(map['nombreHecho']),
      responsibleUnit: _asString(map['responsibleUnit']) ??
          _asString(map['nombreUnidadResponsable']),
      deadlineLabel: _asString(map['deadlineLabel']) ?? _asString(map['plazo']),
      publishedAt: _asDate(map['publishedAt']) ?? _asDate(map['fechaPublicacion']),
      isImmediateProcessing:
          _asBool(map['isImmediateProcessing']) ?? _asBool(map['inmediato']) ?? false,
      detailUri: _asUri(map['detailUri']) ?? _asUri(map['urlDetalle']),
    );
  }

  Recommendation toEntity() => Recommendation(
    id: id,
    title: title,
    summary: summary,
    lifeEventId: lifeEventId,
    lifeEventLabel: lifeEventLabel,
    responsibleUnit: responsibleUnit,
    deadlineLabel: deadlineLabel,
    publishedAt: publishedAt,
    isImmediateProcessing: isImmediateProcessing,
    detailUri: detailUri,
  );

  // ── Tolerant primitive coercion ──────────────────────────────────────────

  static String? _asString(final Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is String) {
      return raw.isEmpty ? null : raw;
    }
    if (raw is num || raw is bool) {
      return raw.toString();
    }
    return null;
  }

  static bool? _asBool(final Object? raw) {
    if (raw is bool) {
      return raw;
    }
    if (raw is num) {
      return raw != 0;
    }
    if (raw is String) {
      final v = raw.toLowerCase().trim();
      if (v == 'true' || v == '1' || v == 's' || v == 'si' || v == 'yes') {
        return true;
      }
      if (v == 'false' || v == '0' || v == 'n' || v == 'no') {
        return false;
      }
    }
    return null;
  }

  static DateTime? _asDate(final Object? raw) {
    if (raw is DateTime) {
      return raw;
    }
    if (raw is String && raw.isNotEmpty) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  static Uri? _asUri(final Object? raw) {
    final s = _asString(raw);
    if (s == null) {
      return null;
    }
    return Uri.tryParse(s);
  }
}

/// Tolerant top-level parser. Accepts:
/// - `null` → empty list.
/// - a [List] of maps → parsed item by item, dropping `null`s.
/// - a single [Map] → parsed as one entry.
/// - a [Map] with a `data` / `items` / `tramites` array → unwraps and
///   recurses.
/// Anything else collapses to an empty list. Never throws.
List<Recommendation> parseRecommendations(final Object? raw) {
  if (raw == null) {
    return const <Recommendation>[];
  }
  if (raw is List) {
    final result = <Recommendation>[];
    for (final entry in raw) {
      final dto = RecommendationDto.fromJson(entry);
      if (dto != null) {
        result.add(dto.toEntity());
      }
    }
    return result;
  }
  if (raw is Map) {
    for (final key in const ['data', 'items', 'tramites', 'recommendations']) {
      if (raw.containsKey(key)) {
        return parseRecommendations(raw[key]);
      }
    }
    final dto = RecommendationDto.fromJson(raw);
    return dto == null ? const <Recommendation>[] : <Recommendation>[dto.toEntity()];
  }
  return const <Recommendation>[];
}
