import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';

// ─── Auth interceptor ────────────────────────────────────────────────────────

/// Attaches a Bearer Authorization header to every outgoing request.
///
/// The token is resolved lazily via the token getter at request time, so the
/// interceptor never holds a stale reference and no circular dependency is
/// introduced between Dio construction and the auth state providers.
///
/// If the token getter returns null or an empty string the request is forwarded
/// unchanged, letting the server respond with 401.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenGetter);

  /// Returns the current access token, or null when the user is not logged in.
  final String? Function() _tokenGetter;

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    final hasAuthorizationHeader = options.headers.keys.any(
      (final key) => key.toLowerCase() == HttpHeaders.authorizationHeader,
    );
    if (!hasAuthorizationHeader) {
      final token = _tokenGetter();
      if (token != null && token.isNotEmpty) {
        options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

final class AuthRefreshInterceptor extends QueuedInterceptor {
  AuthRefreshInterceptor(
    this._dio,
    this._tokenGetter,
    this._refreshSession,
  );

  static const _authRetryKey = 'auth_retry';

  final Dio _dio;
  final String? Function() _tokenGetter;
  final Future<bool> Function() _refreshSession;

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    if (response?.statusCode != HttpStatus.unauthorized || err.requestOptions.extra[_authRetryKey] == true) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshSession();
    final token = _tokenGetter();
    if (!refreshed || token == null || token.isEmpty) {
      handler.next(err);
      return;
    }

    try {
      final requestOptions = err.requestOptions;
      final headers = Map<String, dynamic>.from(requestOptions.headers)..[HttpHeaders.authorizationHeader] = 'Bearer $token';
      final retryOptions = requestOptions.copyWith(
        headers: headers,
        extra: {
          ...requestOptions.extra,
          _authRetryKey: true,
        },
      );
      final retryResponse = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}

// ─── Error interceptor ───────────────────────────────────────────────────────

/// Converts [DioException] values into typed [AppError] subtypes so that
/// upper layers never depend on Dio internals.
final class ErrorInterceptor extends Interceptor {
  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    final appError = _mapDioException(err);
    // Wrap the AppError inside the DioException so the caller can retrieve
    // it via `e.error` when they catch DioException, or we propagate it.
    handler.next(
      err.copyWith(
        error: appError,
        message: appError.message,
      ),
    );
  }

  AppError _mapDioException(final DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionTimeout:
        return NetworkError(
          message: 'Connection problem: ${err.message ?? err.type.name}',
        );

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        return switch (statusCode) {
          401 => const UnauthorizedError(),
          404 => NotFoundError(
            message: 'Resource not found (404): ${err.requestOptions.path}',
          ),
          _ => NetworkError(
            message: 'Server error ${statusCode ?? 'unknown'}: ${err.message ?? ''}',
            statusCode: statusCode,
          ),
        };

      case DioExceptionType.cancel:
        return const UnknownError(message: 'Request was cancelled');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return UnknownError(
          message: err.message ?? 'An unexpected error occurred',
        );
    }
  }
}

// ─── Emoji Dio Logger ───────────────────────────────────────────────────────

class EmojiDioLogger extends Interceptor {
  final String dioNote = '[DIO]';
  @override
  void onRequest(final RequestOptions options, final RequestInterceptorHandler handler) {
    logger.d('$dioNote 📑 Request: ${options.method} ${options.uri}');
    if (options.headers.isNotEmpty) {
      logger.d('$dioNote 📑 Headers: ${_redact(options.headers)}');
    }
    if (options.data != null) {
      logger.d('$dioNote 📑 Body: ${_redact(options.data)}');
    }
    handler.next(options);
  }

  @override
  void onResponse(final Response<dynamic> response, final ResponseInterceptorHandler handler) {
    logger
      ..d('$dioNote 📦 Response: ${response.statusCode} ${response.requestOptions.uri}')
      ..d('$dioNote 📦 Response Data: ${_redact(response.data)}');
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    if (_isHandledBusinessResponse(err.response?.data)) {
      handler.next(err);
      return;
    }

    final request = err.requestOptions;
    logger
      ..e('$dioNote 💥 Error: ${err.type} ${err.message}')
      ..e('$dioNote 💥 Request: ${request.method} ${request.uri} — status ${err.response?.statusCode ?? 'unavailable'}');
    if (err.response != null) {
      logger.e('$dioNote 💥 Error Response: ${_redact(err.response?.data)}');
    }
    handler.next(err);
  }

  bool _isHandledBusinessResponse(final Object? data) {
    if (data is! Map) {
      return false;
    }
    final responseCode = data['codigo-respuesta']?.toString();
    final message = data['mensaje-respuesta']?.toString().toLowerCase() ?? '';
    return responseCode == '412.00' && message.contains('no se pudo dar de alta el soporte');
  }

  Object? _redact(final Object? value) {
    if (value is Map) {
      return value.map((final key, final nestedValue) {
        final keyText = key.toString().toLowerCase();
        if (_sensitiveKeyFragments.any(keyText.contains)) {
          return MapEntry(key, '***');
        }
        return MapEntry(key, _redact(nestedValue));
      });
    }
    if (value is Iterable) {
      return value.map(_redact).toList(growable: false);
    }
    return value;
  }

  static const _sensitiveKeyFragments = [
    'authorization',
    'token',
    'dni',
    'nif',
    'email',
    'telefono',
    'phone',
  ];
}
