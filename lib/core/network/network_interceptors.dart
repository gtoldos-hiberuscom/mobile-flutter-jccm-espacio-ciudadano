import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';

// ─── Auth interceptor ────────────────────────────────────────────────────────

/// Reads the stored access token from [SecureStorage] and appends it as a
/// `Bearer` `Authorization` header on every outgoing request.
///
/// If no token is stored the request is forwarded unchanged, letting the
/// server respond with 401 which is then handled by [ErrorInterceptor].
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    final hasAuthorizationHeader = options.headers.keys.any(
      (final key) => key.toLowerCase() == HttpHeaders.authorizationHeader,
    );
    if (hasAuthorizationHeader) {
      handler.next(options);
      return;
    }

    final token = await _storage.read(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    handler.next(options);
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

// ─── Logging interceptor ─────────────────────────────────────────────────────

/// Logs request/response details to the console.
///
/// Enabled only when the app runs in the development environment
/// (see `AppConfig.environment`).
final class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    // ignore: avoid_print
    print('[HTTP] → ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    final Response<dynamic> response,
    final ResponseInterceptorHandler handler,
  ) {
    // ignore: avoid_print
    print(
      '[HTTP] ← ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) {
    // ignore: avoid_print
    print('[HTTP] ✗ ${err.type.name} ${err.requestOptions.uri}: ${err.message}');
    handler.next(err);
  }
}
