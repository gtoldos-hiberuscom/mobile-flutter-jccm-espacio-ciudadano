import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/3_data/recommendations_repository_impl.dart';

void main() {
  group('RecommendationsRepositoryImpl', () {
    test('loads recommendations for selected life events', () async {
      final adapter = _RecommendationsAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(dio: dio);

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10, 20],
      );

      expect(adapter.method, 'GET');
      expect(adapter.path, '/api/v1/hechos-vitales/servicios/agent-123');
      expect(adapter.queryParameters, isEmpty);
      expect(recommendations, hasLength(1));
      expect(recommendations.single.title, 'Ayuda para alquiler joven');
      expect(recommendations.single.lifeEventId, 10);
      expect(recommendations.single.lifeEventName, 'Busco vivienda');
      expect(recommendations.single.responsibleUnit, 'Vivienda');
      expect(recommendations.single.badge, RecommendationBadge.immediate);
    });

    test('returns empty list when backend reports no matching results', () async {
      final adapter = _RecommendationsAdapter(responseKind: _RecommendationsResponseKind.noResults);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(dio: dio);

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10],
      );

      expect(recommendations, isEmpty);
    });

    test('returns empty list when backend cannot register recommendations support', () async {
      final adapter = _RecommendationsAdapter(responseKind: _RecommendationsResponseKind.supportUnavailable);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(dio: dio);

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10],
      );

      expect(recommendations, isEmpty);
    });
  });
}

enum _RecommendationsResponseKind {
  recommendations,
  noResults,
  supportUnavailable,
}

final class _RecommendationsAdapter implements HttpClientAdapter {
  _RecommendationsAdapter({this.responseKind = _RecommendationsResponseKind.recommendations});

  final _RecommendationsResponseKind responseKind;
  String? method;
  String? path;
  Map<String, dynamic> queryParameters = const {};

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    method = options.method;
    path = options.path;
    queryParameters = options.queryParameters;

    return ResponseBody.fromString(
      jsonEncode(_payload()),
      _statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}

  int get _statusCode {
    return switch (responseKind) {
      _RecommendationsResponseKind.recommendations => 200,
      _RecommendationsResponseKind.noResults => 404,
      _RecommendationsResponseKind.supportUnavailable => 403,
    };
  }

  Map<String, dynamic> _payload() {
    return switch (responseKind) {
      _RecommendationsResponseKind.recommendations => _recommendationsPayload(),
      _RecommendationsResponseKind.noResults => _noResultsPayload(),
      _RecommendationsResponseKind.supportUnavailable => _supportUnavailablePayload(),
    };
  }

  Map<String, dynamic> _recommendationsPayload() => <String, dynamic>{
    'body': <String, dynamic>{
      'listaTramitesPorHechos': [
        {
          'idHecho': 10,
          'nombreHecho': 'Busco vivienda',
          'tramites': [
            {
              'idTramite': 100,
              'nombreTramite': 'Ayuda para alquiler joven',
              'nombreUnidadResponsable': 'Vivienda',
              'fechaPresentacionIni': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
              'fechaPresentacionFin': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
            },
          ],
        },
      ],
    },
  };

  Map<String, dynamic> _noResultsPayload() => <String, dynamic>{
    'body': null,
    'mensaje-respuesta': 'No se obtuvieron resultados para los criterios indicados',
    'codigo-respuesta': '404.01',
  };

  Map<String, dynamic> _supportUnavailablePayload() => <String, dynamic>{
    'body': null,
    'mensaje-respuesta': 'No se pudo dar de alta el soporte. Cuando autorizas a que Espacio Ciudadano muestre los datos que las Administraciones Publicas tienen sobre ti, te mostramos esta informacion para tu consulta.',
    'codigo-respuesta': '412.00',
  };
}
