import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_employment_repository_impl.dart';

void main() {
  group('MyDataEmploymentRepositoryImpl', () {
    test('loads current employment demand from SEPE endpoint', () async {
      final adapter = _EmploymentAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      final demand = await repository.loadDemand(documentNumber: '12345678A');

      expect(adapter.request?.method, 'POST');
      expect(adapter.request?.path, '/api/v1/sepe/demandante-empleo-fecha-actual/12345678A');
      expect(adapter.request?.jsonBody, {
        'docu': '12345678A',
        'tipodoc': 'NIF',
      });
      expect(demand?.status, 'Activa');
      expect(demand?.uninterruptedRegistrationDate, DateTime(2000, 7));
      expect(demand?.message, 'Tramitada');
    });

    test('returns null when employment demand is not found', () async {
      final adapter = _EmploymentAdapter(returnNotFound: true);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      final demand = await repository.loadDemand(documentNumber: '00000000T');

      expect(demand, isNull);
    });

    test('maps inactive employment demand to not registered status', () async {
      final adapter = _EmploymentAdapter(inscrito: 'N');
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataEmploymentRepositoryImpl(dio: dio);

      final demand = await repository.loadDemand(documentNumber: '12345678A');

      expect(demand?.status, 'No Inscrito');
    });
  });
}

final class _CapturedRequest {
  const _CapturedRequest({
    required this.method,
    required this.path,
    required this.jsonBody,
  });

  final String method;
  final String path;
  final Map<String, dynamic>? jsonBody;
}

final class _EmploymentAdapter implements HttpClientAdapter {
  _EmploymentAdapter({this.returnNotFound = false, this.inscrito = 'S'});

  final bool returnNotFound;
  final String inscrito;
  _CapturedRequest? request;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    final bodyBytes = <int>[];
    await for (final chunk in requestStream ?? const Stream<Uint8List>.empty()) {
      chunk.forEach(bodyBytes.add);
    }
    request = _CapturedRequest(
      method: options.method,
      path: options.path,
      jsonBody: bodyBytes.isEmpty ? null : jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>,
    );

    if (returnNotFound) {
      return ResponseBody.fromString('', 404);
    }

    return ResponseBody.fromString(
      jsonEncode({
        'inscrito': inscrito,
        'ultimainscrip': '20000701',
        'mensaje': 'Tramitada',
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
