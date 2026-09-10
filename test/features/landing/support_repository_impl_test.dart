import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/3_data/support_repository_impl.dart';

void main() {
  group('SupportRepositoryImpl', () {
    test('submits the support form to support API', () async {
      final adapter = _RecordingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = SupportRepositoryImpl(dio: dio);

      await repository.submitSupportRequest(
        SupportRequest(
          name: 'María Pérez',
          email: 'maria@example.es',
          subject: 'No puedo acceder',
          message: 'La app no carga mis expedientes.',
          privacyConsentAccepted: true,
          attachment: SupportRequestAttachment(
            fileName: 'captura.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          ),
        ),
      );

      expect(adapter.request?.method, 'POST');
      expect(adapter.request?.path, SupportRepositoryImpl.endpoint);
      expect(adapter.request?.contentType, startsWith('multipart/form-data'));
      expect(jsonDecode(adapter.request!.fields['datos']!) as Map<String, dynamic>, <String, dynamic>{
        'asunto': 'No puedo acceder',
        'descripcion': 'La app no carga mis expedientes.',
        'email': 'maria@example.es',
        'nombreApellidos': 'María Pérez',
      });
      expect(adapter.request?.files.single.key, 'adjunto');
      expect(adapter.request?.files.single.filename, 'captura.png');
      expect(adapter.request?.files.single.length, 3);
    });

    test('submits to the citizen support route when a session idAgente is given', () async {
      final adapter = _RecordingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = SupportRepositoryImpl(dio: dio);

      await repository.submitSupportRequest(
        const SupportRequest(
          name: '',
          email: 'maria@example.es',
          subject: 'No puedo acceder',
          message: 'La app no carga mis expedientes.',
          privacyConsentAccepted: false,
        ),
        idAgente: 'PER9999927',
      );

      expect(adapter.request?.method, 'POST');
      expect(adapter.request?.path, '/api/v1/ciudadanos/PER9999927/soporte');
      expect(adapter.request?.path, SupportRepositoryImpl.citizenEndpoint('PER9999927'));
      expect(adapter.request?.contentType, startsWith('multipart/form-data'));
      expect(jsonDecode(adapter.request!.fields['datos']!) as Map<String, dynamic>, <String, dynamic>{
        'asunto': 'No puedo acceder',
        'descripcion': 'La app no carga mis expedientes.',
        'email': 'maria@example.es',
      });
      expect(adapter.request?.files, isEmpty);
    });

    test('falls back to the public support route when idAgente is empty', () async {
      final adapter = _RecordingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = SupportRepositoryImpl(dio: dio);

      await repository.submitSupportRequest(
        const SupportRequest(
          name: 'María Pérez',
          email: 'maria@example.es',
          subject: 'Asunto',
          message: 'Mensaje',
          privacyConsentAccepted: true,
        ),
        idAgente: '',
      );

      expect(adapter.request?.path, SupportRepositoryImpl.endpoint);
    });
  });
}

final class _CapturedRequest {
  const _CapturedRequest({
    required this.method,
    required this.path,
    required this.contentType,
    required this.fields,
    required this.files,
  });

  final String method;
  final String path;
  final String? contentType;
  final Map<String, String> fields;
  final List<_CapturedFile> files;
}

final class _CapturedFile {
  const _CapturedFile({
    required this.key,
    required this.filename,
    required this.length,
  });

  final String key;
  final String? filename;
  final int length;
}

final class _RecordingAdapter implements HttpClientAdapter {
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
    final data = options.data;
    final formData = data is FormData ? data : null;
    request = _CapturedRequest(
      method: options.method,
      path: options.path,
      contentType: options.contentType,
      fields: Map<String, String>.fromEntries(formData?.fields ?? const []),
      files: [
        for (final file in formData?.files ?? const <MapEntry<String, MultipartFile>>[])
          _CapturedFile(
            key: file.key,
            filename: file.value.filename,
            length: file.value.length,
          ),
      ],
    );

    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{'ok': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
