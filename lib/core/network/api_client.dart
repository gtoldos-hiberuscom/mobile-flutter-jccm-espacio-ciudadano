import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/feature_flags/resilience_flag.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/emoji_dio_logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';
import 'package:jccm_espacio_ciudadano/core/network/retry_policy.dart';

/// Builds and returns a fully configured [Dio] instance.
///
/// The [Dio] client is configured with:
/// - Base URL and timeouts from [AppConfig].
/// - Default JSON `Content-Type` and `Accept` headers.
/// - [AuthInterceptor] — attaches the Bearer access token to every request.
/// - [ErrorInterceptor] — maps `DioException` to typed `AppError` subtypes.
/// - [LoggingInterceptor] — enabled only for development environment.
///
/// Use [createCancelToken] to obtain a [CancelToken] that can be passed to
/// individual requests and cancelled (e.g., on widget/notifier disposal).
Dio buildDioClient({
  required final AppConfig config,
  required final String? Function() tokenGetter,
  required final AppLogger logger,
}) {
  final timeoutDuration = Duration(seconds: config.timeout);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: timeoutDuration,
      receiveTimeout: timeoutDuration,
      sendTimeout: timeoutDuration,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Order matters: logging → auth → retry → error
  dio.interceptors.add(EmojiDioLogger());
  dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));

  dio.interceptors.add(AuthInterceptor(tokenGetter));
  // STORY-65 — opt-in retry for idempotent methods only.
  if (kResilienceLayerEnabled) {
    dio.interceptors.add(RetryInterceptor(dio: dio));
  }
  dio.interceptors.add(ErrorInterceptor());


  return dio;
}

/// Returns a fresh [CancelToken].
///
/// Pass the token to Dio request methods (e.g., `dio.get('/path', cancelToken: token)`)
/// and call `token.cancel()` when the requesting component is disposed.
CancelToken createCancelToken() => CancelToken();
