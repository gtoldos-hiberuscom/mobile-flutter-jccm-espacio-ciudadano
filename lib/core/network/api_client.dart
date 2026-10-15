import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';

Dio buildDioClient({
  required final AppConfig config,
  required final String? Function() tokenGetter,
  required final Future<bool> Function({bool force}) refreshSession,
}) {
  final dio = _baseDio(
    config: config,
    timeout: Duration(seconds: config.timeout),
  );
  dio.interceptors.add(AuthInterceptor(tokenGetter));
  dio.interceptors.add(AuthRefreshInterceptor(dio, tokenGetter, refreshSession));
  dio.interceptors.add(ErrorInterceptor());
  _addNetworkLogging(dio, config: config);
  return dio;
}

/// Cliente para peticiones **sin sesión** al mismo host (`config.baseUrl`):
/// mismas cabeceras y mismas trazas de red que [buildDioClient], pero sin los
/// interceptores de autenticación (no hay token, y un 401 no debe refrescar ni
/// cerrar sesión) ni el de errores (quien lo usa recibe el `DioException`
/// crudo). Lo usa, por ejemplo, la comprobación de versión al arrancar.
Dio buildPublicDioClient({
  required final AppConfig config,
  required final Duration timeout,
}) {
  final dio = _baseDio(config: config, timeout: timeout);
  _addNetworkLogging(dio, config: config);
  return dio;
}

Dio _baseDio({required final AppConfig config, required final Duration timeout}) => Dio(
  BaseOptions(
    baseUrl: config.baseUrl,
    connectTimeout: timeout,
    receiveTimeout: timeout,
    sendTimeout: timeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ),
);

void _addNetworkLogging(final Dio dio, {required final AppConfig config}) {
  // Trazas de red completas solo en desarrollo: en release/profile no se
  // emiten (el `logger` va con DevelopmentFilter, que solo escribe bajo
  // `assert`) y con la configuración de producción tampoco en debug.
  final verboseNetworkLogging = kDebugMode && config.debugMode;
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
}

CancelToken createCancelToken() => CancelToken();
