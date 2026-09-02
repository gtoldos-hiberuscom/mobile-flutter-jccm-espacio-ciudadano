import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

final class AdapterResponse {
  const AdapterResponse({
    required this.statusCode,
    required this.body,
    this.contentType = Headers.jsonContentType,
  });

  final int statusCode;
  final Object? body;
  final String contentType;
}

final class CapturedRequest {
  const CapturedRequest({
    required this.method,
    required this.path,
    required this.queryParameters,
    required this.jsonBody,
    this.sendTimeout,
    this.receiveTimeout,
  });

  final String method;
  final String path;
  final Map<String, dynamic> queryParameters;
  final Object? jsonBody;

  /// Plazos efectivos de la petición, ya resueltos con los de la instancia de
  /// Dio y con cualquier override por petición.
  final Duration? sendTimeout;
  final Duration? receiveTimeout;
}

final class SequenceHttpClientAdapter implements HttpClientAdapter {
  SequenceHttpClientAdapter(this._responses);

  final List<AdapterResponse> _responses;
  final requests = <CapturedRequest>[];

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
      CapturedRequest(
        method: options.method,
        path: options.path,
        queryParameters: Map<String, dynamic>.from(options.queryParameters),
        jsonBody: _decodeRequestBody(bodyBytes),
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
      ),
    );

    final response = _responses.removeAt(0);
    return ResponseBody.fromString(
      _encodeResponseBody(response.body),
      response.statusCode,
      headers: {
        Headers.contentTypeHeader: [response.contentType],
      },
    );
  }

  Object? _decodeRequestBody(final List<int> bodyBytes) {
    if (bodyBytes.isEmpty) {
      return null;
    }
    final text = utf8.decode(bodyBytes);
    return jsonDecode(text);
  }

  String _encodeResponseBody(final Object? body) {
    if (body is String) {
      return body;
    }
    return jsonEncode(body);
  }

  @override
  void close({final bool force = false}) {}
}
