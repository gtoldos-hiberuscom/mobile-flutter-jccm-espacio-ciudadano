import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';

/// A Dio interceptor that logs requests, responses, and errors using SimpleEmojiPrinter
class EmojiDioLogger extends Interceptor {
  final String dioNote = '[DIO]';
  @override
  void onRequest(final RequestOptions options, final RequestInterceptorHandler handler) {
    logger.d('$dioNote 📑 Request: ${options.method} ${options.uri}');
    if (options.headers.isNotEmpty) {
      logger.d('$dioNote 📑 Headers: ${options.headers}');
    }
    if (options.data != null) {
      logger.d('$dioNote 📑 Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(final Response<dynamic> response, final ResponseInterceptorHandler handler) {
    logger
      ..d('$dioNote 📦 Response: ${response.statusCode} ${response.requestOptions.uri}')
      ..d('$dioNote 📦 Response Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    logger.e('$dioNote 💥 Error: ${err.type} ${err.message}');
    if (err.response != null) {
      logger.e('$dioNote 💥 Error Response: ${err.response?.data}');
    }
    handler.next(err);
  }
}
