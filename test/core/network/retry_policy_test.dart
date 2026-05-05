import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/network/retry_policy.dart';

class _CountingAdapter implements HttpClientAdapter {
  _CountingAdapter(this._statusSequence);

  final List<int> _statusSequence;
  int callCount = 0;

  @override
  void close({final bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<List<int>>? requestStream,
    final Future<dynamic>? cancelFuture,
  ) async {
    final status = _statusSequence[callCount.clamp(0, _statusSequence.length - 1)];
    callCount += 1;
    return ResponseBody.fromString(
      '{}',
      status,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }
}

Dio _dioWith(final HttpClientAdapter adapter, final Dio dio, final RetryInterceptor Function(Dio) retryFactory) {
  dio
    ..options.baseUrl = 'https://example.test'
    ..httpClientAdapter = adapter
    ..interceptors.add(retryFactory(dio));
  return dio;
}

void main() {
  group('RetryInterceptor', () {
    test('retries GET on 503 up to maxRetries then succeeds', () async {
      final adapter = _CountingAdapter([503, 503, 200]);
      final dio = _dioWith(
        adapter,
        Dio(),
        (final d) => RetryInterceptor(
          dio: d,
          baseDelay: const Duration(milliseconds: 1),
          maxDelay: const Duration(milliseconds: 2),
          random: Random(0),
        ),
      );
      final res = await dio.get<dynamic>('/x');
      expect(res.statusCode, 200);
      // Initial call + 2 retries = 3
      expect(adapter.callCount, 3);
    });

    test('does not retry POST', () async {
      final adapter = _CountingAdapter([503]);
      final dio = _dioWith(
        adapter,
        Dio(),
        (final d) => RetryInterceptor(
          dio: d,
          baseDelay: const Duration(milliseconds: 1),
          maxDelay: const Duration(milliseconds: 2),
          random: Random(0),
        ),
      );
      await expectLater(
        dio.post<dynamic>('/x'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.callCount, 1);
    });

    test('does not retry on 400 (non-transient)', () async {
      final adapter = _CountingAdapter([400]);
      final dio = _dioWith(
        adapter,
        Dio(),
        (final d) => RetryInterceptor(
          dio: d,
          baseDelay: const Duration(milliseconds: 1),
          maxDelay: const Duration(milliseconds: 2),
          random: Random(0),
        ),
      );
      await expectLater(
        dio.get<dynamic>('/x'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.callCount, 1);
    });

    test('gives up after maxRetries on persistent failure', () async {
      final adapter = _CountingAdapter([503, 503, 503, 503, 503]);
      final dio = _dioWith(
        adapter,
        Dio(),
        (final d) => RetryInterceptor(
          dio: d,
          maxRetries: 2,
          baseDelay: const Duration(milliseconds: 1),
          maxDelay: const Duration(milliseconds: 2),
          random: Random(0),
        ),
      );
      await expectLater(
        dio.get<dynamic>('/x'),
        throwsA(isA<DioException>()),
      );
      // Initial + 2 retries = 3
      expect(adapter.callCount, 3);
    });
  });
}
