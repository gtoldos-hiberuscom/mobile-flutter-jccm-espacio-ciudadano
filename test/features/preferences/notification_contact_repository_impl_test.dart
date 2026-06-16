import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/3_data/notification_contact_repository_impl.dart';

void main() {
  group('NotificationContactRepositoryImpl', () {
    test('does not create contact when loading existing contact is forbidden', () async {
      final adapter = _SequenceAdapter([
        const _AdapterResponse(statusCode: 403, body: <String, dynamic>{}),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      await expectLater(
        repository.saveContact(
          citizenId: 'agent-123',
          dni: '12345678Z',
          contact: const NotificationContact(phone: '640559754'),
        ),
        throwsA(isA<DioException>()),
      );

      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/agent-123/contacto');
    });

    test('creates contact when loading existing contact returns not found', () async {
      final adapter = _SequenceAdapter([
        const _AdapterResponse(statusCode: 404, body: <String, dynamic>{}),
        const _AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'body': {
              'telefono': 640559754,
              'email': null,
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      final result = await repository.saveContact(
        citizenId: 'agent-123',
        dni: '12345678Z',
        contact: const NotificationContact(phone: '640559754'),
      );

      expect(result.phone, '640559754');
      expect(adapter.requests.map((final request) => request.method), ['GET', 'POST']);
      expect(
        adapter.requests.last.jsonBody,
        <String, dynamic>{
          'dni': '12345678Z',
          'email': null,
          'telefono': 640559754,
        },
      );
    });
  });
}

final class _AdapterResponse {
  const _AdapterResponse({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final Map<String, dynamic> body;
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

final class _SequenceAdapter implements HttpClientAdapter {
  _SequenceAdapter(this._responses);

  final List<_AdapterResponse> _responses;
  final requests = <_CapturedRequest>[];

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
    requests.add(
      _CapturedRequest(
        method: options.method,
        path: options.path,
        jsonBody: bodyBytes.isEmpty ? null : jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>,
      ),
    );

    final response = _responses.removeAt(0);
    return ResponseBody.fromString(
      jsonEncode(response.body),
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
