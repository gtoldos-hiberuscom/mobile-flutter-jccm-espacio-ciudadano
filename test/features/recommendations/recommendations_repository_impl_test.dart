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
      final repository = RecommendationsRepositoryImpl(
        dio: dio,
        sedeBaseUrl: Uri.parse('https://sede-uat.cm-pre.jccm.es/'),
      );

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10, 20],
      );

      expect(adapter.requests, hasLength(4));
      expect(
        adapter.requests.first.path,
        '/api/v1/hechos-vitales/servicios/agent-123',
      );
      expect(adapter.requests.first.queryParameters, isEmpty);
      expect(
        adapter.requests.skip(1).map((final request) => request.queryParameters['operacion']),
        unorderedEquals(['ultimos_dias', 'novedades', 'inmediatos']),
      );
      expect(recommendations, hasLength(1));
      expect(recommendations.single.title, 'Ayuda para alquiler joven');
      expect(recommendations.single.lifeEventId, 10);
      expect(recommendations.single.lifeEventName, 'Busco vivienda');
      expect(recommendations.single.responsibleUnit, 'Vivienda');
      expect(recommendations.single.badge, RecommendationBadge.immediate);
      expect(
        recommendations.single.badges,
        {RecommendationBadge.immediate},
      );
      expect(recommendations.single.detailUrl, Uri.parse('https://sede-uat.cm-pre.jccm.es/tramites/100'));
    });

    test('returns empty list when backend reports no matching results', () async {
      final adapter = _RecommendationsAdapter(responseKind: _RecommendationsResponseKind.noResults);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(
        dio: dio,
        sedeBaseUrl: Uri.parse('https://sede-uat.cm-pre.jccm.es/'),
      );

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10],
      );

      expect(recommendations, isEmpty);
    });

    test('returns empty list when backend cannot register recommendations support', () async {
      final adapter = _RecommendationsAdapter(responseKind: _RecommendationsResponseKind.supportUnavailable);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(
        dio: dio,
        sedeBaseUrl: Uri.parse('https://sede-uat.cm-pre.jccm.es/'),
      );

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10],
      );

      expect(recommendations, isEmpty);
    });

    test('uses date fallback when segmentation endpoint is not deployed', () async {
      final adapter = _RecommendationsAdapter(segmentationUnavailable: true);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(
        dio: dio,
        sedeBaseUrl: Uri.parse('https://sede-uat.cm-pre.jccm.es/'),
      );

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10],
      );

      expect(recommendations, hasLength(1));
      expect(
        recommendations.single.badges,
        {RecommendationBadge.immediate},
      );
    });
  });
}

enum _RecommendationsResponseKind {
  recommendations,
  noResults,
  supportUnavailable,
}

final class _RecommendationsAdapter implements HttpClientAdapter {
  _RecommendationsAdapter({
    this.responseKind = _RecommendationsResponseKind.recommendations,
    this.segmentationUnavailable = false,
  });

  final _RecommendationsResponseKind responseKind;
  final bool segmentationUnavailable;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    requests.add(options);

    return ResponseBody.fromString(
      jsonEncode(_payload(options)),
      _statusCode(options),
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}

  int _statusCode(final RequestOptions options) {
    if (segmentationUnavailable && options.path.contains('/segmentacion/')) {
      return 404;
    }
    return switch (responseKind) {
      _RecommendationsResponseKind.recommendations => 200,
      _RecommendationsResponseKind.noResults => 404,
      _RecommendationsResponseKind.supportUnavailable => 403,
    };
  }

  Map<String, dynamic> _payload(final RequestOptions options) {
    if (options.path.contains('/segmentacion/')) {
      final operation = options.queryParameters['operacion'];
      return <String, dynamic>{
        'body': operation == 'inmediatos'
            ? [
                {
                  'idTramite': 100,
                  'nombreTramite': 'Ayuda para alquiler joven',
                },
              ]
            : <Map<String, dynamic>>[],
      };
    }
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
