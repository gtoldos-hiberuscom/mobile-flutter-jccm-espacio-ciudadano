import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';

Dio buildDioClient({
  required final AppConfig config,
  required final String? Function() tokenGetter,
  required final Future<bool> Function() refreshSession,
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

  dio.interceptors.add(AuthInterceptor(tokenGetter));
  dio.interceptors.add(AuthRefreshInterceptor(dio, tokenGetter, refreshSession));
  dio.interceptors.add(ErrorInterceptor());
  dio.interceptors.add(EmojiDioLogger());
  dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: kVerboseNetworkLogging));

  return dio;
}

CancelToken createCancelToken() => CancelToken();
