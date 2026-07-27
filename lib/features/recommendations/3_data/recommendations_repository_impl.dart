import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';

final class RecommendationsRepositoryImpl implements RecommendationsRepository {
  RecommendationsRepositoryImpl({required final Dio dio, required this.sedeBaseUrl}) : _api = HechosVitalesApi(withGeneratedApiCompat(dio), standardSerializers);

  final HechosVitalesApi _api;
  final Uri sedeBaseUrl;

  @override
  Future<List<Recommendation>> loadRecommendations({
    required final String idAgente,
    required final List<int> lifeEventIds,
  }) async {
    if (lifeEventIds.isEmpty) {
      return const [];
    }

    Object? payload;
    try {
      final response = await _api.getServicios(
        idAgente: idAgente,
        extra: const {
          generatedApiDecodeStringResponseExtraKey: true,
        },
      );
      payload = response.extra[generatedApiRawResponseDataExtraKey] ?? response.data;
    } on DioException catch (error) {
      final rawData = error.response?.extra[generatedApiRawResponseDataExtraKey] ?? error.response?.data;
      if (_isNoResultsResponse(rawData)) {
        return const [];
      }
      if (rawData != null) {
        payload = rawData;
      } else {
        rethrow;
      }
    }

    final badgeIds = await _loadBadgeIds(
      idAgente: idAgente,
      lifeEventIds: lifeEventIds,
    );
    final groups = _extractGroups(payload);
    return [
      for (final group in groups) ..._mapGroup(group, badgeIds),
    ];
  }

  Future<Map<int, Set<RecommendationBadge>>?> _loadBadgeIds({
    required final String idAgente,
    required final List<int> lifeEventIds,
  }) async {
    final segments = await Future.wait([
      _loadSegmentIds(
        idAgente: idAgente,
        lifeEventIds: lifeEventIds,
        operation: 'ultimos_dias',
      ),
      _loadSegmentIds(
        idAgente: idAgente,
        lifeEventIds: lifeEventIds,
        operation: 'novedades',
      ),
      _loadSegmentIds(
        idAgente: idAgente,
        lifeEventIds: lifeEventIds,
        operation: 'inmediatos',
      ),
    ]);
    if (segments.any((final segment) => !segment.available)) {
      return null;
    }
    final result = <int, Set<RecommendationBadge>>{};
    const badges = [
      RecommendationBadge.recent,
      RecommendationBadge.news,
      RecommendationBadge.immediate,
    ];
    for (var index = 0; index < segments.length; index++) {
      for (final id in segments[index].ids) {
        result.putIfAbsent(id, () => <RecommendationBadge>{}).add(badges[index]);
      }
    }
    return result;
  }

  Future<({bool available, Set<int> ids})> _loadSegmentIds({
    required final String idAgente,
    required final List<int> lifeEventIds,
    required final String operation,
  }) async {
    final Object? payload;
    try {
      final response = await _api.getServiciosSegmentados(
        idAgente: idAgente,
        operacion: operation,
        hechosvitales: BuiltList<int>(lifeEventIds),
        extra: const {
          generatedApiDecodeStringResponseExtraKey: true,
        },
      );
      payload = response.extra[generatedApiRawResponseDataExtraKey] ?? response.data;
    } on DioException catch (error) {
      final rawData = error.response?.extra[generatedApiRawResponseDataExtraKey] ?? error.response?.data;
      if (_isNoResultsResponse(rawData)) {
        return (available: true, ids: const <int>{});
      }
      if (error.response?.statusCode == 404) {
        return (available: false, ids: const <int>{});
      }
      rethrow;
    }
    return (available: true, ids: _extractProcedureIds(payload));
  }

  Set<int> _extractProcedureIds(final Object? data) {
    final root = _asStringMap(data);
    final body = root?['body'] ?? data;
    final ids = <int>{};

    void addProcedure(final Object? value) {
      final procedure = _asStringMap(value);
      final id = _int(
        procedure?['idTramite'] ?? procedure?['idServicio'] ?? procedure?['id'],
      );
      if (id != null) {
        ids.add(id);
      }
    }

    if (body is List) {
      body.forEach(addProcedure);
      return ids;
    }
    for (final group in _extractGroups(data)) {
      final procedures = group['tramites'] ?? group['listaTramites'] ?? group['servicios'] ?? group['listaServicios'];
      if (procedures is List) {
        procedures.forEach(addProcedure);
      }
    }
    return ids;
  }

  List<Map<String, dynamic>> _extractGroups(final Object? data) {
    final root = _asStringMap(data) ?? const <String, dynamic>{};
    final body = root['body'];
    final payload = body is Map<String, dynamic> || body is List ? body : root;

    if (payload is List) {
      return _normaliseGroups(payload);
    }

    if (payload is! Map<String, dynamic>) {
      return const [];
    }

    final rawGroups = payload['listaTramitesPorHechos'] ?? payload['tramitesPorHechos'] ?? payload['listaServiciosPorHechos'] ?? payload['serviciosPorHechos'] ?? payload['content'] ?? payload['items'];

    if (rawGroups is List) {
      return _normaliseGroups(rawGroups);
    }

    if (payload.containsKey('tramites') || payload.containsKey('listaTramites') || payload.containsKey('servicios')) {
      return [payload];
    }

    return const [];
  }

  List<Map<String, dynamic>> _normaliseGroups(final List<dynamic> values) {
    final maps = values.whereType<Map<String, dynamic>>().toList(growable: false);
    if (maps.isEmpty) {
      return const [];
    }
    final hasGroupShape = maps.any(_looksLikeGroup);
    if (hasGroupShape) {
      return maps;
    }
    return [
      <String, dynamic>{'tramites': maps},
    ];
  }

  bool _looksLikeGroup(final Map<String, dynamic> value) {
    return value.containsKey('idHecho') || value.containsKey('nombreHecho') || value.containsKey('tramites') || value.containsKey('listaTramites') || value.containsKey('servicios') || value.containsKey('listaServicios');
  }

  bool _isNoResultsResponse(final Object? data) {
    final map = _asStringMap(data);
    if (map == null) {
      return false;
    }
    final responseCode = map['codigo-respuesta']?.toString();
    if (responseCode == '404.01' || responseCode == '412.00') {
      return true;
    }
    final message = map['mensaje-respuesta']?.toString().toLowerCase() ?? '';
    return message.contains('no se obtuvieron resultados') || message.contains('no se pudo dar de alta el soporte');
  }

  Map<String, dynamic>? _asStringMap(final Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return {
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  Iterable<Recommendation> _mapGroup(
    final Map<String, dynamic> group,
    final Map<int, Set<RecommendationBadge>>? badgeIds,
  ) sync* {
    final lifeEventId = _int(group['idHecho']) ?? 0;
    final lifeEventName = _string(group['nombreHecho']);
    final rawProcedures = group['tramites'] ?? group['listaTramites'] ?? group['servicios'] ?? group['listaServicios'];
    if (rawProcedures is! List) {
      return;
    }

    for (final rawProcedure in rawProcedures.whereType<Map<String, dynamic>>()) {
      final procedureId = _int(rawProcedure['idTramite'] ?? rawProcedure['idServicio'] ?? rawProcedure['id']);
      final title = _string(rawProcedure['nombreTramite'] ?? rawProcedure['nombreServicio'] ?? rawProcedure['nombre'] ?? rawProcedure['descripcion']);
      if (procedureId == null || title.isEmpty) {
        continue;
      }

      final startDate = _date(rawProcedure['fechaPresentacionIni'] ?? rawProcedure['fechaPresentacion'] ?? rawProcedure['fechaInicio']);
      final endDate = _date(rawProcedure['fechaPresentacionFin'] ?? rawProcedure['fechaFin']);
      final rawSubmissionStatus = rawProcedure['fechaPresentacion'];
      final submissionStatusText = _date(rawSubmissionStatus) == null ? _stringOrNull(rawSubmissionStatus) : null;

      yield Recommendation(
        id: '$lifeEventId-$procedureId',
        title: title,
        lifeEventId: lifeEventId,
        lifeEventName: lifeEventName,
        badges: Set.unmodifiable(
          badgeIds?[procedureId] ??
              _fallbackBadges(
                rawStartDate: rawProcedure['fechaPresentacionIni'] ?? rawProcedure['fechaPresentacion'] ?? rawProcedure['fechaInicio'],
                startDate: startDate,
                endDate: endDate,
              ),
        ),
        responsibleUnit: _stringOrNull(
          rawProcedure['nombreUnidadOrganicaResponsable'] ?? rawProcedure['nombreUnidadResponsable'] ?? rawProcedure['unidadResponsable'],
        ),
        submissionStartDate: startDate,
        submissionEndDate: endDate,
        submissionStatusText: submissionStatusText,
        detailUrl: sedeBaseUrl.resolve('tramites/$procedureId'),
      );
    }
  }

  Set<RecommendationBadge> _fallbackBadges({
    required final Object? rawStartDate,
    required final DateTime? startDate,
    required final DateTime? endDate,
  }) {
    final now = DateTime.now();
    final startText = _stringOrNull(rawStartDate)?.toLowerCase();
    final isPermanentlyOpen = startText?.contains('abierto permanentemente') ?? false;
    final isActive = startDate != null && !startDate.isAfter(now) && (endDate == null || !endDate.isBefore(now));
    if (isPermanentlyOpen || isActive) {
      return const {RecommendationBadge.immediate};
    }
    if (startDate != null && !startDate.isAfter(now) && !startDate.isBefore(now.subtract(const Duration(days: 7)))) {
      return const {RecommendationBadge.recent};
    }
    return const {};
  }

  String _string(final Object? value) => _stringOrNull(value) ?? '';

  String? _stringOrNull(final Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  int? _int(final Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }

  DateTime? _date(final Object? value) {
    final text = _stringOrNull(value);
    if (text == null) {
      return null;
    }
    final isoDate = DateTime.tryParse(text);
    if (isoDate != null) {
      return isoDate;
    }
    final javaDate = RegExp(
      r'^\w{3} (\w{3}) (\d{1,2}) \d{2}:\d{2}:\d{2} \w+ (\d{4})$',
    ).firstMatch(text);
    if (javaDate != null) {
      final month = _monthNumber(javaDate.group(1)!);
      final day = int.tryParse(javaDate.group(2)!);
      final year = int.tryParse(javaDate.group(3)!);
      if (month != null && day != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    final parts = text.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  int? _monthNumber(final String month) => const {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  }[month];
}
