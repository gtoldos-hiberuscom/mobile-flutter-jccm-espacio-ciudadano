import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

/// Sprint 7 / STORY-65 — exponential-backoff + jitter retry interceptor.
///
/// Retries idempotent HTTP methods (GET / HEAD / OPTIONS) on transient
/// failures (timeouts, connection errors, 502/503/504). Non-idempotent
/// methods (POST/PUT/PATCH/DELETE) are NEVER retried automatically — the
/// citizen-facing app cannot assume server-side idempotency without an
/// explicit `Idempotency-Key` contract (see TASK-63 §4 for the upcoming
/// support endpoint design).
///
/// Backoff schedule: `min(maxDelay, base * 2^attempt) + jitter[0, base)`.
/// Defaults: 3 retries, base=300ms, max=4s, total worst-case ~7s.
///
/// Adoption: install via `dio.interceptors.add(RetryInterceptor(...))` from
/// `lib/core/network/api_client.dart` behind `kResilienceLayerEnabled`.
final class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required final Dio dio,
    final int maxRetries = 3,
    final Duration baseDelay = const Duration(milliseconds: 300),
    final Duration maxDelay = const Duration(seconds: 4),
    final Random? random,
  }) : _dio = dio,
       _maxRetries = maxRetries,
       _baseDelay = baseDelay,
       _maxDelay = maxDelay,
       _random = random ?? Random();

  static const String _attemptHeader = 'x-retry-attempt';
  static const Set<String> _idempotentMethods = <String>{
    'GET',
    'HEAD',
    'OPTIONS',
  };

  final Dio _dio;
  final int _maxRetries;
  final Duration _baseDelay;
  final Duration _maxDelay;
  final Random _random;

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final method = options.method.toUpperCase();
    if (!_idempotentMethods.contains(method)) {
      handler.next(err);
      return;
    }
    if (!_isTransient(err)) {
      handler.next(err);
      return;
    }

    final attempt = (options.extra[_attemptHeader] as int?) ?? 0;
    if (attempt >= _maxRetries) {
      handler.next(err);
      return;
    }

    final delay = _computeDelay(attempt);
    await Future<void>.delayed(delay);

    final nextOptions = options.copyWith(
      extra: <String, dynamic>{
        ...options.extra,
        _attemptHeader: attempt + 1,
      },
    );

    try {
      final response = await _dio.fetch<dynamic>(nextOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _isTransient(final DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return true;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        return status == 502 || status == 503 || status == 504;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return false;
    }
  }

  Duration _computeDelay(final int attempt) {
    final exp = _baseDelay.inMilliseconds * (1 << attempt);
    final capped = exp > _maxDelay.inMilliseconds ? _maxDelay.inMilliseconds : exp;
    final jitter = _random.nextInt(_baseDelay.inMilliseconds);
    return Duration(milliseconds: capped + jitter);
  }
}
