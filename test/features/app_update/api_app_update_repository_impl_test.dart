import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_decision.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/data.dart';

void main() {
  late _StubAdapter adapter;

  ApiAppUpdateRepositoryImpl build(final StorePlatform platform) {
    final dio = Dio(BaseOptions(baseUrl: 'https://gateway.example.es'))..httpClientAdapter = adapter;
    return ApiAppUpdateRepositoryImpl(api: AppVersionApi(dio), platform: platform);
  }

  Future<AppUpdateDecision> fetch(final StorePlatform platform) => build(platform).fetchDecision(applicationId: 'es.jccm.espaciociudadano', installedVersion: const AppVersion(0, 1, 9));

  group('ApiAppUpdateRepositoryImpl', () {
    test('pide GET al endpoint del contrato con plataforma, id y versión', () async {
      adapter = _StubAdapter.json({
        'body': {'accion': 'NINGUNA', 'versionPublicada': null, 'mensaje': null},
      });

      await fetch(StorePlatform.android);

      final request = adapter.request!;
      expect(request.method, 'GET');
      expect(request.uri.host, 'gateway.example.es');
      expect(request.uri.path, '/api/v1/app-movil/actualizacion');
      expect(request.uri.queryParameters, {'plataforma': 'ANDROID', 'idAplicacion': 'es.jccm.espaciociudadano', 'version': '0.1.9'});
      expect(request.headers.containsKey('Authorization'), isFalse);
    });

    test('en iOS manda plataforma IOS', () async {
      adapter = _StubAdapter.json({
        'body': {'accion': 'NINGUNA'},
      });
      await fetch(StorePlatform.ios);
      expect(adapter.request!.uri.queryParameters['plataforma'], 'IOS');
    });

    test('devuelve la decisión del servidor', () async {
      adapter = _StubAdapter.json({
        'body': {'accion': 'FORZADA', 'versionPublicada': '0.2.0', 'mensaje': 'Versión retirada.'},
      });
      expect(
        await fetch(StorePlatform.android),
        const AppUpdateDecision(policy: UpdatePolicy.forced, publishedVersion: AppVersion(0, 2, 0), message: 'Versión retirada.'),
      );
    });

    test('un error HTTP se propaga (el use case no bloquea)', () async {
      adapter = _StubAdapter.json({'codigo-respuesta': '500'}, statusCode: 500);
      await expectLater(fetch(StorePlatform.android), throwsA(isA<DioException>()));
    });

    test('una respuesta fuera de contrato se propaga como FormatException', () async {
      adapter = _StubAdapter.json({
        'body': {'accion': 'OTRA'},
      });
      await expectLater(fetch(StorePlatform.android), throwsFormatException);
    });
  });

  group('MockAppUpdateRepositoryImpl', () {
    Future<AppUpdateDecision> fetchMock(final AppUpdateMockScenario scenario) => MockAppUpdateRepositoryImpl(scenario).fetchDecision(applicationId: 'x', installedVersion: const AppVersion(0, 1, 9));

    test('cada escenario responde según el contrato', () async {
      expect(await fetchMock(AppUpdateMockScenario.none), const AppUpdateDecision.none());
      expect(await fetchMock(AppUpdateMockScenario.recommended), const AppUpdateDecision(policy: UpdatePolicy.recommended, publishedVersion: AppVersion(99, 0, 0)));
      expect(await fetchMock(AppUpdateMockScenario.forced), const AppUpdateDecision(policy: UpdatePolicy.forced, publishedVersion: AppVersion(99, 0, 0)));
    });
  });
}

final class _StubAdapter implements HttpClientAdapter {
  _StubAdapter.json(final Object body, {this.statusCode = 200}) : _body = jsonEncode(body);

  final String _body;
  final int statusCode;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      _body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
