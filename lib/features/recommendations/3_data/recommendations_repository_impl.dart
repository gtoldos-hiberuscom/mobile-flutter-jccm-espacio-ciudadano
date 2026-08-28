import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/api/recomendaciones_api.dart';

final class RecommendationsRepositoryImpl implements RecommendationsRepository {
  RecommendationsRepositoryImpl({required final Dio dio, required this.sedeBaseUrl}) : _api = RecomendacionesApi(dio);

  final RecomendacionesApi _api;
  final Uri sedeBaseUrl;

  @override
  Future<List<Recommendation>> loadRecommendations({
    required final String idAgente,
    required final List<int> lifeEventIds,
    required final RecommendationsSegment segment,
  }) async {
    // Sin hechos configurados no hay nada que recomendar: se corta la llamada.
    // La lista no viaja en la petición (ver RecomendacionesApi.obtener).
    if (lifeEventIds.isEmpty) {
      return const [];
    }

    final isAll = segment == RecommendationsSegment.all;

    Object? payload;
    try {
      payload = await _api.obtener(
        citizenId: idAgente,
        operacion: _operationFor(segment),
        size: isAll ? null : '10',
        page: isAll ? null : '0',
        ultimosDias: segment == RecommendationsSegment.recent ? '30' : null,
      );
    } on DioException catch (error) {
      final rawData = error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey];
      _logEnvelope(segment, rawData);
      if (_isNoResultsResponse(rawData)) {
        return const [];
      }
      if (rawData != null) {
        payload = rawData;
      } else {
        rethrow;
      }
    }

    _logEnvelope(segment, payload);
    if (_isNoResultsResponse(payload)) {
      return const [];
    }

    final groups = _extractGroups(payload);
    return [
      for (final group in groups)
        ..._mapGroup(
          group,
          segment == RecommendationsSegment.all ? null : _badgeFor(segment),
        ),
    ];
  }

  /// Valor del query `operacion` para cada segmento.
  ///
  /// "Todos" era una ruta aparte (`hechos-vitales/servicios/{idAgente}`) y ahora
  /// es el mismo endpoint con `operacion=todo` (el valor que cita el OpenAPI
  /// 1.86). Omitir el parámetro —que el contrato declara opcional— devuelve
  /// vacío contra el gateway UAT, así que se envía siempre.
  String _operationFor(final RecommendationsSegment segment) => switch (segment) {
    RecommendationsSegment.all => 'todo',
    RecommendationsSegment.recent => 'ut',
    RecommendationsSegment.news => 'no',
    RecommendationsSegment.immediate => 'ti',
  };

  RecommendationBadge _badgeFor(final RecommendationsSegment segment) => switch (segment) {
    RecommendationsSegment.all => throw ArgumentError.value(segment),
    RecommendationsSegment.recent => RecommendationBadge.recent,
    RecommendationsSegment.news => RecommendationBadge.news,
    RecommendationsSegment.immediate => RecommendationBadge.immediate,
  };

  /// Registra los campos de diagnóstico del sobre de respuesta del backend.
  /// Esta pantalla traduce los errores de negocio (`404.01`, `412.00`, sobres
  /// 4xx no reconocidos) a listado vacío en silencio; esta traza hace visible
  /// qué contestó realmente el backend cuando la lista sale vacía.
  void _logEnvelope(final RecommendationsSegment segment, final Object? raw) {
    final map = _asStringMap(raw);
    final body = map?['body'];
    final bodySummary = switch (body) {
      final List<dynamic> list => 'lista(${list.length})',
      final Map<dynamic, dynamic> _ => 'objeto',
      null => 'null',
      _ => body.runtimeType.toString(),
    };
    logger.d(
      '[recomendaciones/$segment] envelope codigo-respuesta=${map?['codigo-respuesta']} '
      'mensaje=${map?['mensaje-respuesta']} body=$bodySummary',
    );
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
    final RecommendationBadge? segmentBadge,
  ) sync* {
    final groupLifeEventId = _int(group['idHecho']);
    final groupLifeEventName = _string(group['nombreHecho']);
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

      final procedureLifeEvents = (rawProcedure['hechosVitales'] as List?)?.map(_asStringMap).whereType<Map<String, dynamic>>().toList(growable: false) ?? const [];
      final lifeEventId = groupLifeEventId ?? (procedureLifeEvents.isEmpty ? 0 : _int(procedureLifeEvents.first['idHechoVital'] ?? procedureLifeEvents.first['idHecho'])) ?? 0;
      final lifeEventName = groupLifeEventName.isNotEmpty ? groupLifeEventName : procedureLifeEvents.map((final event) => _string(event['nombreHechoVital'] ?? event['nombreHecho'])).where((final name) => name.isNotEmpty).join(', ');

      final startDate = _date(rawProcedure['fechaPresentacionIni'] ?? rawProcedure['fechaPresentacion'] ?? rawProcedure['fechaInicio']);
      final endDate = _date(rawProcedure['fechaPresentacionFin'] ?? rawProcedure['fechaFin']);
      final rawSubmissionStatus = rawProcedure['fechaPresentacion'];
      final submissionStatusText = _date(rawSubmissionStatus) == null ? _stringOrNull(rawSubmissionStatus) : null;

      yield Recommendation(
        id: '$lifeEventId-$procedureId',
        title: title,
        lifeEventId: lifeEventId,
        lifeEventName: lifeEventName,
        badges: segmentBadge == null ? const {} : {segmentBadge},
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
