import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';

import '../../test_support/sequence_http_client_adapter.dart';

/// Regression tests for [AuthRefreshInterceptor].
///
/// Before the fix, retrying the failed request on the *same* Dio routed the
/// retry's error back into this `QueuedInterceptor`'s error queue — which was
/// still blocked on the in-flight `onError` — deadlocking it permanently
/// (F-04). The retry now runs on a bare secondary Dio, so a failed retry
/// surfaces to the caller instead of hanging. F-05 covers the case where the
/// refresh returns the same token the server just rejected. N-01 covers the
/// retry response going through [GeneratedApiCompatInterceptor]: the secondary
/// Dio must normalize the gateway envelope exactly like the primary one, or
/// the first request that survives a 401+refresh hands the raw envelope to the
/// generated deserializers.
void main() {
  Dio buildDio(
    final SequenceHttpClientAdapter adapter, {
    required final String? Function() tokenGetter,
    required final Future<bool> Function({bool force}) refreshSession,
  }) {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
    dio.interceptors.add(AuthRefreshInterceptor(dio, tokenGetter, refreshSession));
    dio.interceptors.add(ErrorInterceptor());
    return dio;
  }

  group('AuthRefreshInterceptor F-04 (no deadlock on retry failure)', () {
    test('a failing retry surfaces to the caller instead of hanging', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 401, body: <String, dynamic>{}),
        const AdapterResponse(statusCode: 500, body: <String, dynamic>{}),
      ]);
      final dio = buildDio(
        adapter,
        tokenGetter: () => 'tok',
        refreshSession: ({final bool force = false}) async => true,
      );

      // Pre-fix this would deadlock: `.timeout` would fire a TimeoutException
      // and the `isA<DioException>` matcher would fail.
      await expectLater(
        dio.get<dynamic>('/x').timeout(const Duration(seconds: 2)),
        throwsA(isA<DioException>()),
      );
      // Original request + retry both reached the shared transport.
      expect(adapter.requests.length, 2);
    });

    test('a second failing request does not hang (error queue not poisoned)', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 401, body: <String, dynamic>{}),
        const AdapterResponse(statusCode: 500, body: <String, dynamic>{}),
        const AdapterResponse(statusCode: 401, body: <String, dynamic>{}),
        const AdapterResponse(statusCode: 500, body: <String, dynamic>{}),
      ]);
      final dio = buildDio(
        adapter,
        tokenGetter: () => 'tok',
        refreshSession: ({final bool force = false}) async => true,
      );

      await expectLater(
        dio.get<dynamic>('/first').timeout(const Duration(seconds: 2)),
        throwsA(isA<DioException>()),
      );
      await expectLater(
        dio.get<dynamic>('/second').timeout(const Duration(seconds: 2)),
        throwsA(isA<DioException>()),
      );
    });

    test('a successful retry resolves with the retried response', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 401, body: <String, dynamic>{}),
        const AdapterResponse(statusCode: 200, body: {'ok': true}),
      ]);
      final dio = buildDio(
        adapter,
        tokenGetter: () => 'tok',
        refreshSession: ({final bool force = false}) async => true,
      );

      final response = await dio.get<dynamic>('/x').timeout(const Duration(seconds: 2));

      expect(response.statusCode, 200);
      expect(adapter.requests.length, 2);
    });
  });

  group('AuthRefreshInterceptor F-05 (stale token → forced refresh)', () {
    test('a refresh that returns the rejected token escalates to force:true', () async {
      var token = 'stale';
      var forced = false;
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 401, body: <String, dynamic>{}),
        const AdapterResponse(statusCode: 200, body: {'ok': true}),
      ]);
      final dio = buildDio(
        adapter,
        tokenGetter: () => token,
        refreshSession: ({final bool force = false}) async {
          // Simulates the peer short-circuit: a non-forced refresh is a no-op
          // (returns the same token the server rejected); only a forced refresh
          // actually rotates it.
          if (force) {
            token = 'fresh';
            forced = true;
          }
          return true;
        },
      );

      final response = await dio
          .get<dynamic>(
            '/x',
            options: Options(headers: {'authorization': 'Bearer stale'}),
          )
          .timeout(const Duration(seconds: 2));

      expect(forced, isTrue, reason: 'the unchanged token must trigger a forced refresh');
      expect(response.statusCode, 200);
    });

    test('when the forced refresh also fails, the caller gets the 401', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 401, body: <String, dynamic>{}),
      ]);
      final dio = buildDio(
        adapter,
        tokenGetter: () => 'stale',
        // Both attempts return the same rejected token, then the forced refresh
        // "fails" (session revoked) by leaving the token unchanged; the
        // interceptor gives up and forwards the original error.
        refreshSession: ({final bool force = false}) async => !force,
      );

      await expectLater(
        dio
            .get<dynamic>(
              '/x',
              options: Options(headers: {'authorization': 'Bearer stale'}),
            )
            .timeout(const Duration(seconds: 2)),
        throwsA(isA<DioException>()),
      );
      // Only the original request hit the transport — no retry was attempted.
      expect(adapter.requests.length, 1);
    });
  });

  group('AuthRefreshInterceptor N-01 (retry response passes generated-api compat)', () {
    test('the retried response is normalized like a first-attempt response', () async {
      // The gateway double-encodes: a JSON string literal whose content is the
      // `{body: …}` envelope. On the primary Dio, GeneratedApiCompatInterceptor
      // (installed at index 0 by `withGeneratedApiCompat`) decodes and unwraps
      // it before any repository sees the data; the retry after a 401+refresh
      // must behave identically.
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 401, body: <String, dynamic>{}),
        AdapterResponse(statusCode: 200, body: jsonEncode('{"body": {"resultado": "ok"}}')),
      ]);
      final dio = withGeneratedApiCompat(
        buildDio(
          adapter,
          tokenGetter: () => 'fresh',
          refreshSession: ({final bool force = false}) async => true,
        ),
      );

      final response = await dio
          .get<dynamic>(
            '/x',
            options: Options(
              extra: {
                generatedApiDecodeStringResponseExtraKey: true,
                generatedApiUnwrapBodyExtraKey: true,
              },
            ),
          )
          .timeout(const Duration(seconds: 2));

      expect(response.statusCode, 200);
      expect(adapter.requests.length, 2, reason: 'original request + retry');
      expect(
        response.data,
        {'resultado': 'ok'},
        reason: 'the retry response must arrive decoded and unwrapped, not as the raw envelope',
      );
    });

    test('a retry that fails with an enveloped error body is normalized before surfacing', () async {
      // A 500 whose body is the double-encoded envelope: the compat interceptor
      // on the retry Dio must normalize `err.response` so the primary chain's
      // ErrorInterceptor (and any salvage logic upstream) sees the same shape
      // as on a first attempt.
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 401, body: <String, dynamic>{}),
        AdapterResponse(statusCode: 500, body: jsonEncode('{"body": {"codigo-respuesta": "500.00"}}')),
      ]);
      final dio = withGeneratedApiCompat(
        buildDio(
          adapter,
          tokenGetter: () => 'fresh',
          refreshSession: ({final bool force = false}) async => true,
        ),
      );

      Object? surfacedData;
      try {
        await dio
            .get<dynamic>(
              '/x',
              options: Options(
                extra: {
                  generatedApiDecodeStringResponseExtraKey: true,
                  generatedApiUnwrapBodyExtraKey: true,
                },
              ),
            )
            .timeout(const Duration(seconds: 2));
        fail('expected the retried 500 to surface as a DioException');
      } on DioException catch (error) {
        surfacedData = error.response?.data;
      }

      expect(adapter.requests.length, 2, reason: 'original request + retry');
      expect(
        surfacedData,
        {'codigo-respuesta': '500.00'},
        reason: 'the retry error body must arrive decoded and unwrapped, not as the raw envelope',
      );
    });

  });
}
