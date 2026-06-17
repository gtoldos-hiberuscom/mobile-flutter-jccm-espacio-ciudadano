import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/3_data/support_repository_impl.dart';

void main() {
  group('SupportRepositoryImpl', () {
    test('submits the support form to consulta API', () async {
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
      expect(adapter.request?.jsonBody, <String, dynamic>{
        'idatos': <String, dynamic>{
          'subfam': 'SOPORTE_TECNICO',
        },
        'returns': <String, dynamic>{},
        'tfaq': <String, dynamic>{
          'item': <Map<String, String>>[
            <String, String>{'numseq': '001', 'textlinea': 'nombre', 'textarea': 'María Pérez'},
            <String, String>{'numseq': '002', 'textlinea': 'email', 'textarea': 'maria@example.es'},
            <String, String>{'numseq': '003', 'textlinea': 'asunto', 'textarea': 'No puedo acceder'},
            <String, String>{'numseq': '004', 'textlinea': 'mensaje', 'textarea': 'La app no carga mis expedientes.'},
            <String, String>{'numseq': '005', 'textlinea': 'proteccion_datos', 'textarea': 'S'},
            <String, String>{'numseq': '006', 'textlinea': 'adjunto_nombre', 'textarea': 'captura.png'},
            <String, String>{'numseq': '007', 'textlinea': 'adjunto_base64', 'textarea': 'AQID'},
          ],
        },
      });
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
    request = _CapturedRequest(
      method: options.method,
      path: options.path,
      jsonBody: bodyBytes.isEmpty ? null : jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>,
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
