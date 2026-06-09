import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';

final class RecommendationsRepositoryImpl implements RecommendationsRepository {
  const RecommendationsRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<Recommendation>> loadRecommendations({
    required final String idAgente,
    required final List<int> lifeEventIds,
  }) async {
    if (lifeEventIds.isEmpty) {
      return const [];
    }

    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/hechos-vitales/servicios/segmentacion/$idAgente',
        options: Options(listFormat: ListFormat.multi),
        queryParameters: <String, dynamic>{
          'page': '0',
          'size': '50',
          'hechosvitales': lifeEventIds,
        },
      );
    } on DioException catch (error) {
      if (_isNoResultsResponse(error.response?.data)) {
        return const [];
      }
      rethrow;
    }

    final groups = _extractGroups(response.data);
    return [
      for (final group in groups) ..._mapGroup(group),
    ];
  }

  List<Map<String, dynamic>> _extractGroups(final Map<String, dynamic>? data) {
    final root = data ?? const <String, dynamic>{};
    final body = root['body'];
    final payload = body is Map<String, dynamic> ? body : root;

    final rawGroups = payload['listaTramitesPorHechos'] ?? payload['tramitesPorHechos'] ?? payload['listaServiciosPorHechos'] ?? payload['servicios'];

    if (rawGroups is List) {
      return rawGroups.whereType<Map<String, dynamic>>().toList(growable: false);
    }
    return const [];
  }

  bool _isNoResultsResponse(final Object? data) {
    if (data is! Map<String, dynamic>) {
      return false;
    }
    final responseCode = data['codigo-respuesta']?.toString();
    if (responseCode == '404.01') {
      return true;
    }
    final message = data['mensaje-respuesta']?.toString().toLowerCase() ?? '';
    return message.contains('no se obtuvieron resultados');
  }

  Iterable<Recommendation> _mapGroup(final Map<String, dynamic> group) sync* {
    final lifeEventId = _int(group['idHecho']) ?? 0;
    final lifeEventName = _string(group['nombreHecho']);
    final rawProcedures = group['tramites'];
    if (rawProcedures is! List) {
      return;
    }

    for (final rawProcedure in rawProcedures.whereType<Map<String, dynamic>>()) {
      final procedureId = _int(rawProcedure['idTramite']);
      final title = _string(rawProcedure['nombreTramite']);
      if (procedureId == null || title.isEmpty) {
        continue;
      }

      final startDate = _date(rawProcedure['fechaPresentacionIni']);
      final endDate = _date(rawProcedure['fechaPresentacionFin']);

      yield Recommendation(
        id: '$lifeEventId-$procedureId',
        title: title,
        lifeEventId: lifeEventId,
        lifeEventName: lifeEventName,
        badge: _badge(startDate: startDate, endDate: endDate),
        responsibleUnit: _stringOrNull(rawProcedure['nombreUnidadResponsable']),
        submissionStartDate: startDate,
        submissionEndDate: endDate,
      );
    }
  }

  RecommendationBadge _badge({
    required final DateTime? startDate,
    required final DateTime? endDate,
  }) {
    final now = DateTime.now();
    if (startDate != null && !startDate.isAfter(now) && (endDate == null || !endDate.isBefore(now))) {
      return RecommendationBadge.immediate;
    }
    if (startDate != null && !startDate.isBefore(now.subtract(const Duration(days: 7)))) {
      return RecommendationBadge.news;
    }
    return RecommendationBadge.recent;
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
    return DateTime.tryParse(text);
  }
}
