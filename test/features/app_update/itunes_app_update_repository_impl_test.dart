import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/api/itunes_lookup_api.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/itunes_app_update_repository_impl.dart';

import '../../test_support/keyed_http_client_adapter.dart';
import '../../test_support/sequence_http_client_adapter.dart';
import 'support/app_update_fakes.dart';

const _bundleId = 'es.jccm.espaciociudadano';
const _javascriptContentType = 'text/javascript; charset=utf-8';

const _publishedJson = '{"resultCount": 1, "results": [{"bundleId": "$_bundleId", "version": "0.1.9", "trackViewUrl": "https://apps.apple.com/es/app/espacio-ciudadano/id123456789?uo=4"}]}';
const _unpublishedJson = '{"resultCount": 0, "results": []}';

void main() {
  late FakeInstalledVersionRepository installed;

  setUp(() {
    installed = FakeInstalledVersionRepository(const AppVersion(0, 1, 8));
  });

  KeyedHttpClientAdapter adapterWith(final List<AdapterResponse> responses) => KeyedHttpClientAdapter(queryParameter: 'bundleId', responses: {_bundleId: responses});

  ItunesAppUpdateRepositoryImpl repoWith(final KeyedHttpClientAdapter adapter, {final Dio? dio}) {
    final client = (dio ?? Dio())..httpClientAdapter = adapter;
    return ItunesAppUpdateRepositoryImpl(api: ItunesLookupApi(client), installed: installed);
  }

  group('ItunesAppUpdateRepositoryImpl', () {
    test('pide la ficha por bundle id y storefront y devuelve el manifiesto aunque iTunes conteste text/javascript', () async {
      final adapter = adapterWith([const AdapterResponse(statusCode: 200, body: _publishedJson, contentType: _javascriptContentType)]);

      final manifest = await repoWith(adapter).fetchManifest();

      expect(manifest.latestVersion, const AppVersion(0, 1, 9));
      expect(manifest.displayVersion, '0.1.9');
      expect(manifest.storeUrl.host, 'apps.apple.com');
      final request = adapter.requests.single;
      expect(request.method, 'GET');
      expect(request.path, ItunesLookupApi.endpointUrl);
      expect(request.queryParameters['bundleId'], _bundleId);
      expect(request.queryParameters['country'], 'es');
    });

    test('el cliente propio lleva los plazos cortos', () async {
      final adapter = adapterWith([const AdapterResponse(statusCode: 200, body: _publishedJson, contentType: _javascriptContentType)]);
      final api = ItunesLookupApi.standalone();
      final dio = Dio(BaseOptions(connectTimeout: ItunesLookupApi.timeout, receiveTimeout: ItunesLookupApi.timeout, sendTimeout: ItunesLookupApi.timeout))..httpClientAdapter = adapter;

      await repoWith(adapter, dio: dio).fetchManifest();

      expect(adapter.requests.single.receiveTimeout, ItunesLookupApi.timeout);
      expect(adapter.requests.single.sendTimeout, ItunesLookupApi.timeout);
      expect(api, isA<ItunesLookupApi>());
    });

    test('sin resultados (app no publicada) lanza y no bloquea aguas arriba', () {
      final adapter = adapterWith([const AdapterResponse(statusCode: 200, body: _unpublishedJson, contentType: _javascriptContentType)]);
      expect(repoWith(adapter).fetchManifest(), throwsFormatException);
    });

    test('un error HTTP se propaga como DioException', () {
      final adapter = adapterWith([const AdapterResponse(statusCode: 503, body: 'Service Unavailable', contentType: 'text/plain')]);
      expect(repoWith(adapter).fetchManifest(), throwsA(isA<DioException>()));
    });

    test('si no se puede leer el bundle id no se hace ninguna petición', () async {
      installed.error = Exception('sin package info');
      final adapter = adapterWith([const AdapterResponse(statusCode: 200, body: _publishedJson, contentType: _javascriptContentType)]);

      await expectLater(repoWith(adapter).fetchManifest(), throwsException);

      expect(adapter.requests, isEmpty);
    });
  });
}
