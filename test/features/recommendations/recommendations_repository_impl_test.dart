import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
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
        segment: RecommendationsSegment.all,
      );

      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.first.path, '/api/v1/ciudadanos/agent-123/recomendaciones');
      // El OpenAPI 1.86 documenta `operacion=todo` para recuperar todos los
      // trámites; omitir el parámetro devuelve vacío contra el gateway UAT.
      expect(adapter.requests.first.queryParameters['operacion'], 'todo');
      // `hechosvitales` no viaja en la petición: con él el backend devuelve
      // vacío; el filtrado por hechos se hace en presentación.
      expect(adapter.requests.first.queryParameters, isNot(contains('hechosvitales')));
      expect(adapter.requests.first.queryParameters, isNot(contains('size')));
      expect(adapter.requests.first.queryParameters, isNot(contains('page')));
      expect(recommendations, hasLength(1));
      expect(recommendations.single.title, 'Ayuda para alquiler joven');
      expect(recommendations.single.lifeEventId, 10);
      expect(recommendations.single.lifeEventName, 'Busco vivienda');
      expect(recommendations.single.responsibleUnit, 'Vivienda');
      expect(recommendations.single.badge, isNull);
      expect(recommendations.single.badges, isEmpty);
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
        segment: RecommendationsSegment.all,
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
        segment: RecommendationsSegment.all,
      );

      expect(recommendations, isEmpty);
    });

    test('uses the selected segmented endpoint', () async {
      final adapter = _RecommendationsAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(
        dio: dio,
        sedeBaseUrl: Uri.parse('https://sede-uat.cm-pre.jccm.es/'),
      );

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10],
        segment: RecommendationsSegment.immediate,
      );

      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/agent-123/recomendaciones');
      expect(adapter.requests.single.queryParameters['operacion'], 'ti');
      expect(adapter.requests.single.queryParameters['size'], '10');
      expect(adapter.requests.single.queryParameters['page'], '0');
      expect(adapter.requests.single.queryParameters, isNot(contains('hechosvitales')));
      expect(recommendations, hasLength(1));
      expect(
        recommendations.single.badges,
        {RecommendationBadge.immediate},
      );
      expect(recommendations.single.lifeEventId, 10);
      expect(recommendations.single.lifeEventName, 'Busco vivienda');
    });

    test('loads recent procedures using the ultimosDias filter', () async {
      final adapter = _RecommendationsAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(
        dio: dio,
        sedeBaseUrl: Uri.parse('https://sede-uat.cm-pre.jccm.es/'),
      );

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10],
        segment: RecommendationsSegment.recent,
      );

      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/agent-123/recomendaciones');
      expect(adapter.requests.single.queryParameters['operacion'], 'ut');
      expect(adapter.requests.single.queryParameters['size'], '10');
      expect(adapter.requests.single.queryParameters['page'], '0');
      expect(adapter.requests.single.queryParameters['ultimosDias'], '30');
      expect(recommendations.single.badges, {RecommendationBadge.recent});
      expect(recommendations.single.lifeEventId, 10);
      expect(recommendations.single.lifeEventName, 'Busco vivienda');
    });

    test('loads news procedures using the novedades operation', () async {
      final adapter = _RecommendationsAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = RecommendationsRepositoryImpl(
        dio: dio,
        sedeBaseUrl: Uri.parse('https://sede-uat.cm-pre.jccm.es/'),
      );

      final recommendations = await repository.loadRecommendations(
        idAgente: 'agent-123',
        lifeEventIds: const [10],
        segment: RecommendationsSegment.news,
      );

      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/agent-123/recomendaciones');
      expect(adapter.requests.single.queryParameters['operacion'], 'no');
      expect(adapter.requests.single.queryParameters['size'], '10');
      expect(adapter.requests.single.queryParameters['page'], '0');
      expect(adapter.requests.single.queryParameters, isNot(contains('ultimosDias')));
      expect(recommendations.single.badges, {RecommendationBadge.news});
      expect(recommendations.single.lifeEventId, 10);
      expect(recommendations.single.lifeEventName, 'Busco vivienda');
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
  });

  final _RecommendationsResponseKind responseKind;
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
    return switch (responseKind) {
      _RecommendationsResponseKind.recommendations => 200,
      _RecommendationsResponseKind.noResults => 404,
      _RecommendationsResponseKind.supportUnavailable => 403,
    };
  }

  /// Todas comparten ruta; "Todos" lleva `operacion=todo` y las segmentadas
  /// `ut`/`no`/`ti`.
  bool _isSegmented(final RequestOptions options) => options.queryParameters['operacion'] != 'todo';

  Map<String, dynamic> _payload(final RequestOptions options) {
    if (_isSegmented(options)) {
      final operation = options.queryParameters['operacion'];
      return <String, dynamic>{
        'body': operation == 'ti' || operation == 'no' || operation == 'ut'
            ? [
                {
                  'idTramite': 100,
                  'nombreTramite': 'Ayuda para alquiler joven',
                  'hechosVitales': [
                    {
                      'idHechoVital': 10,
                      'nombreHechoVital': 'Busco vivienda',
                    },
                  ],
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
