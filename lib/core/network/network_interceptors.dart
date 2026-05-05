import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';

// ─── Auth interceptor ────────────────────────────────────────────────────────

/// Attaches a Bearer [Authorization] header to every outgoing request.
///
/// The token is resolved lazily via [tokenGetter] at request time, so the
/// interceptor never holds a stale reference and no circular dependency is
/// introduced between [Dio] construction and the auth state providers.
///
/// If [tokenGetter] returns null or an empty string the request is forwarded
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

