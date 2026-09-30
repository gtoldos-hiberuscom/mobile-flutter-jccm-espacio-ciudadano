import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';

Dio buildDioClient({
  required final AppConfig config,
  required final String? Function() tokenGetter,
  required final Future<bool> Function({bool force}) refreshSession,
}) {
  final timeoutDuration = Duration(seconds: config.timeout);
  // Trazas de red completas solo en desarrollo: en release/profile no se
  // emiten (el `logger` va con DevelopmentFilter, que solo escribe bajo
  // `assert`) y con la configuración de producción tampoco en debug.
  final verboseNetworkLogging = kDebugMode && config.debugMode;

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
  dio.interceptors.add(EmojiDioLogger(verboseBodies: verboseNetworkLogging));
  if (verboseNetworkLogging) {
    // `CurlLoggerDioInterceptor` reconstruye el curl completo — cabecera
    // `Authorization: Bearer …` incluida — y lo escribe con
    // `dart:developer.log`, sin ninguna guarda de modo debug: en `onError` lo
    // hace SIEMPRE, ignorando `printOnSuccess`. Era lo único de esta pila que
    // seguía emitiendo en una build de release, así que ni se registra fuera
    // de desarrollo. La variante `BodySafe` respeta
    // `omitBodyFromLogsExtraKey`: sin ella, cada subida de adjuntos volcaba
    // el fichero entero en base64 y congelaba la pantalla.
    dio.interceptors.add(BodySafeCurlLoggerDioInterceptor());
  }

  return dio;
}

CancelToken createCancelToken() => CancelToken();
