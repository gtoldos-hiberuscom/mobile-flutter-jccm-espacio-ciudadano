import 'dart:convert';

import 'package:dio/dio.dart';

const generatedApiRawResponseDataExtraKey = 'generated_api.raw_response_data';
const generatedApiRequestDataExtraKey = 'generated_api.request_data';
const generatedApiDecodeStringResponseExtraKey = 'generated_api.decode_string_response';
const generatedApiUnwrapBodyExtraKey = 'generated_api.unwrap_body';
const generatedApiNormalizeSingletonCollectionsExtraKey = 'generated_api.normalize_singleton_collections';

Dio withGeneratedApiCompat(final Dio dio) {
  if (dio.interceptors.any((final interceptor) => interceptor is GeneratedApiCompatInterceptor)) {
    return dio;
  }
  dio.interceptors.insert(0, const GeneratedApiCompatInterceptor());
  return dio;
}

final class GeneratedApiCompatInterceptor extends Interceptor {
  const GeneratedApiCompatInterceptor();

  @override
  void onRequest(final RequestOptions options, final RequestInterceptorHandler handler) {
    final requestData = options.extra[generatedApiRequestDataExtraKey];
    if (requestData is Map<String, dynamic>) {
      options.data = requestData;
    }
    handler.next(options);
  }

  @override
  void onResponse(final Response<dynamic> response, final ResponseInterceptorHandler handler) {
    _normalizeResponse(response);
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    final response = err.response;
    if (response != null) {
      _normalizeResponse(response);
    }
    handler.next(err);
  }

  void _normalizeResponse(final Response<dynamic> response) {
    response.extra.putIfAbsent(generatedApiRawResponseDataExtraKey, () => response.data);

    Object? data = response.data;
    final extra = response.requestOptions.extra;

    if (extra[generatedApiDecodeStringResponseExtraKey] == true) {
      data = _decodeStringPayload(data);
    }

    if (extra[generatedApiUnwrapBodyExtraKey] == true) {
      data = _unwrapBody(data);
    }

    final singletonPaths = extra[generatedApiNormalizeSingletonCollectionsExtraKey];
    if (singletonPaths is List) {
      data = _normalizeSingletonCollections(data, singletonPaths.whereType<String>());
    }

    response.data = data;
  }

  Object? _decodeStringPayload(final Object? data) {
    Object? current = data;
    for (var i = 0; i < 3; i++) {
      if (current is! String) {
        return current;
      }
      final trimmed = current.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      try {
        current = jsonDecode(trimmed);
      } on FormatException {
        return current;
      }
    }
    return current;
  }

  Object? _unwrapBody(final Object? data) {
    if (data is! Map) {
      return data;
    }
    return data['body'] ?? data;
  }

  Object? _normalizeSingletonCollections(final Object? data, final Iterable<String> paths) {
    if (data is! Map) {
      return data;
    }
    for (final path in paths) {
      _normalizeSingletonCollection(data, path.split('.'));
    }
    return data;
  }

  void _normalizeSingletonCollection(final Object? data, final List<String> path) {
    if (data is! Map || path.isEmpty) {
      return;
    }

    Map<Object?, Object?>? current = data;
    for (var i = 0; i < path.length - 1; i++) {
      final next = current?[path[i]];
      if (next is! Map) {
        return;
      }
      current = next;
    }

    final lastKey = path.last;
    final value = current?[lastKey];
    if (value is Map) {
      current?[lastKey] = [value];
    }
  }
}
