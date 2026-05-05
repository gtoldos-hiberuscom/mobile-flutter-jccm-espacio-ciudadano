import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
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
/// - [EmojiDioLogger] — logs HTTP requests/responses with emoji formatting.
///
/// Use [createCancelToken] to obtain a [CancelToken] that can be passed to
/// individual requests and cancelled (e.g., on widget/notifier disposal).
Dio buildDioClient({
  required final AppConfig config,
  required final String? Function() tokenGetter,
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

  // Order matters: auth → retry → error - logging


  dio.interceptors.add(AuthInterceptor(tokenGetter));
  // STORY-65 — opt-in retry for idempotent methods only.
  dio.interceptors.add(ErrorInterceptor());
  dio.interceptors.add(EmojiDioLogger());
  dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));

  return dio;
}

/// Returns a fresh [CancelToken].
///
/// Pass the token to Dio request methods (e.g., `dio.get('/path', cancelToken: token)`)
/// and call `token.cancel()` when the requesting component is disposed.
CancelToken createCancelToken() => CancelToken();
