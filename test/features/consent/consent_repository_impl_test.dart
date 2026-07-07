import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/3_data/repositories/consent_repository_impl.dart';

void main() {
  group('ConsentRepositoryImpl', () {
    test('markConsentAccepted sends clauses as a JSON object', () async {
      final adapter = _CapturingAdapter();
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
      );

      await repository.markConsentAccepted(
        idAgente: 'PER9998003',
        clauses: const [
          Clause(id: 1, label: 'A', isSelected: true),
          Clause(id: 2, label: 'B', isSelected: false),
        ],
      );

      expect(adapter.methods, ['POST']);
      expect(adapter.paths, ['/api/v1/hechos-vitales/clausulas']);
      expect(
        adapter.jsonBodies.single,
        <String, dynamic>{
          'idAgente': 'PER9998003',
          'clausulas': [
            {
              'idClausula': 1,
              'seleccionado': true,
              'version': '1.0',
            },
            {
              'idClausula': 2,
              'seleccionado': false,
              'version': '1.0',
            },
          ],
        },
      );
    });

    test('markConsentAccepted retries with PATCH when initial POST is recoverable', () async {
      final adapter = _CapturingAdapter(firstStatusCode: 409);
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
      );

      await repository.markConsentAccepted(
        idAgente: 'PER9998003',
        clauses: const [
          Clause(id: 1, label: 'A', isSelected: true),
        ],
      );

      expect(adapter.methods, ['POST', 'PATCH']);
      expect(adapter.paths, [
        '/api/v1/hechos-vitales/clausulas',
        '/api/v1/hechos-vitales/clausulas',
      ]);
      expect(adapter.jsonBodies.first, adapter.jsonBodies.last);
    });
  });
}

Dio _dioWith(final HttpClientAdapter adapter) => Dio(
  BaseOptions(
    baseUrl: 'https://example.test',
    headers: const {
      Headers.contentTypeHeader: Headers.jsonContentType,
    },
  ),
)..httpClientAdapter = adapter;

final class _MemoryAppStorage implements AppStorage {
  final Map<String, Object> _values = {};

  @override
  T? read<T>(final String key) => _values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    _values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _values.clear();
    return true;
  }
}

final class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter({this.firstStatusCode = 200});

  final int firstStatusCode;
  final List<String> methods = [];
  final List<String> paths = [];
  final List<Map<String, dynamic>> jsonBodies = [];

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    methods.add(options.method);
    paths.add(options.path);

    final bodyBytes = <int>[];
    await (requestStream ?? const Stream<Uint8List>.empty()).forEach(bodyBytes.addAll);
    jsonBodies.add(jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>);

    final statusCode = methods.length == 1 ? firstStatusCode : 200;
    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{
        'body': true,
        'codigo-respuesta': statusCode == 200 ? '200.00' : '$statusCode.00',
        'mensaje-respuesta': statusCode == 200 ? 'Respuesta correcta' : 'Error',
        'info-error': null,
      }),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
