import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/logger/log_redaction.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';

/// Marks a request that must never use or refresh an authenticated session.
const anonymousRequestExtraKey = 'auth.anonymous_request';

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
    if (options.extra[anonymousRequestExtraKey] == true) {
      options.headers.removeWhere(
        (final key, final value) => key.toLowerCase() == HttpHeaders.authorizationHeader,
      );
      handler.next(options);
      return;
    }
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
  final Future<bool> Function({bool force}) _refreshSession;

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    if (response?.statusCode != HttpStatus.unauthorized || err.requestOptions.extra[_authRetryKey] == true || err.requestOptions.extra[anonymousRequestExtraKey] == true) {
      handler.next(err);
      return;
    }

    final staleToken = _bearerOf(err.requestOptions.headers);
    var refreshed = await _refreshSession(force: false);
    var token = _tokenGetter();
    // If the refresh short-circuited on a peer's still-valid token, the token
    // is the very one the server just rejected (revoked session, clock skew,
    // facade rejection). Retrying with it would only earn a second 401; force a
    // real refresh so a definitive rejection ends in a clean logout instead of
    // a wasted retry.
    if (refreshed && token != null && token.isNotEmpty && token == staleToken) {
      refreshed = await _refreshSession(force: true);
      token = _tokenGetter();
    }
    if (!refreshed || token == null || token.isEmpty) {
      handler.next(err);
      return;
    }

    // Retry on a secondary Dio that shares the transport (options + adapter)
    // but NOT this QueuedInterceptor: retrying on the primary Dio would route
    // the retry's error back into this interceptor's error queue, which is
    // still blocked on the current onError, deadlocking it permanently and
    // poisoning the queue for every later failure. The retry error surfaces
    // via handler.next to the primary chain's ErrorInterceptor, which maps it
    // to an AppError.
    // The secondary Dio carries only GeneratedApiCompatInterceptor — the
    // retried response must be normalized (decode/unwrap/singletons) exactly
    // like a first-attempt one, because handler.resolve() skips the primary
    // chain's response interceptors — and the logger, so the retry is still
    // visible in the `[DIO]` logs. Both are plain Interceptors, so neither
    // touches the queue.
    final retryDio = Dio(_dio.options)
      ..httpClientAdapter = _dio.httpClientAdapter
      ..interceptors.add(const GeneratedApiCompatInterceptor())
      ..interceptors.add(EmojiDioLogger());
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
      final retryResponse = await retryDio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } on DioException catch (retryError) {
      handler.next(retryError);
    } on Object {
      // e.g. a StateError from re-sending an already-finalized FormData
      // (/api/v1/ciudadanos/soporte, /api/v1/soporte). Surface the
      // original 401 rather than letting it escape the handler and hang the
      // request.
      handler.next(err);
    }
  }

  /// Returns the raw bearer token from an Authorization header (case-insensitive
  /// key, `Bearer ` prefix stripped), or null when absent.
  String? _bearerOf(final Map<String, dynamic> headers) {
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == HttpHeaders.authorizationHeader) {
        final value = entry.value?.toString() ?? '';
        const prefix = 'Bearer ';
        return value.startsWith(prefix) ? value.substring(prefix.length) : value;
      }
    }
    return null;
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
  /// [verboseBodies] activa el volcado de cabeceras y cuerpos completos. Lo
  /// decide `buildDioClient` (`kDebugMode && config.debugMode`): nunca en una
  /// build de release o profile, y nunca con la configuración de producción.
  EmojiDioLogger({this.verboseBodies = false});

  final bool verboseBodies;

  final String dioNote = '[DIO]';
  @override
  void onRequest(final RequestOptions options, final RequestInterceptorHandler handler) {
    logger.d('$dioNote 📑 Request: ${options.method} ${options.uri}');
    final requestData = options.data;
    // Bajo el mismo gate que el resto de cuerpos: el nombre del fichero que
    // adjunta el ciudadano es dato suyo, y esta traza no lo pasa por el
    // redactor. Sigue disponible en desarrollo, que es donde hace falta para
    // diagnosticar el envío de incidencias.
    if (verboseBodies && options.path.endsWith('/soporte') && requestData is FormData) {
      final formData = requestData;
      final attachments = formData.files
          .where((final entry) => entry.key == 'adjunto')
          .map(
            (final entry) => {
              'filename': entry.value.filename,
              'contentType': entry.value.contentType.toString(),
              'length': entry.value.length,
            },
          )
          .toList(growable: false);
      logger.d('$dioNote 📎 Support attachments: $attachments');
    }
    if (verboseBodies) {
      if (options.headers.isNotEmpty) {
        logger.d('$dioNote 📑 Headers: ${redactForLog(options.headers)}');
      }
      if (options.data != null) {
        logger.d('$dioNote 📑 Body: ${redactForLog(options.data)}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(final Response<dynamic> response, final ResponseInterceptorHandler handler) {
    logger.d('$dioNote 📦 Response: ${response.statusCode} ${response.requestOptions.uri}');
    // Sin excepciones por ruta: la lista de cuatro endpoints que había aquí
    // (termalismo, dependencia, familia numerosa, eventos de agenda) volcaba su
    // cuerpo aunque `verboseBodies` fuese falso, es decir también en un debug
    // con la configuración de producción — justo lo que el gate
    // `kDebugMode && config.debugMode` decide. Con la config de desarrollo ya
    // se volcaban por `verboseBodies`, así que no se pierde nada.
    if (verboseBodies) {
      logger.d('$dioNote 📦 Response Data: ${redactForLog(response.data)}');
    }
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    logger
      ..e('$dioNote 💥 Error: ${err.type} ${err.message}')
      ..e('$dioNote 💥 Request: ${request.method} ${request.uri} — status ${err.response?.statusCode ?? 'unavailable'}');
    if (err.response != null) {
      logger.e('$dioNote 💥 Error Response: ${redactForLog(err.response?.data)}');
    }
    handler.next(err);
  }
}
