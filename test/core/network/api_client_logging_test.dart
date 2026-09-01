import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';

void main() {
  group('buildDioClient — trazas de red', () {
    test('no registra el logger curl con la configuración de producción', () {
      final dio = _buildDio(debugMode: false);

      // El interceptor curl imprime la cabecera `Authorization: Bearer …` con
      // `dart:developer.log` y en `onError` lo hace siempre, sin guarda de modo
      // debug: fuera de desarrollo no se registra.
      expect(dio.interceptors.whereType<CurlLoggerDioInterceptor>(), isEmpty);
      expect(dio.interceptors.whereType<EmojiDioLogger>().single.verboseBodies, isFalse);
    });

    test('registra las trazas completas en desarrollo', () {
      // Los tests corren en debug, así que DEBUG_MODE es lo que decide.
      final dio = _buildDio(debugMode: true);

      expect(dio.interceptors.whereType<CurlLoggerDioInterceptor>(), hasLength(1));
      expect(dio.interceptors.whereType<EmojiDioLogger>().single.verboseBodies, isTrue);
    });
  });
}

Dio _buildDio({required final bool debugMode}) => buildDioClient(
  config: AppConfig.fromMap({
    'APP_FLAVOR': debugMode ? 'development' : 'production',
    'APP_NAME': 'Espacio Ciudadano',
    'BASE_URL': 'https://example.test',
    'TIMEOUT': '20',
    'DEBUG_MODE': debugMode.toString(),
    'SSO_CLIENT_ID': 'client',
    'SSO_REDIRECT_URI': 'app://callback',
    'SSO_REALM': 'realm',
    'SSO_BASE_URL': 'https://sso.example.test',
  }),
  tokenGetter: () => null,
  refreshSession: ({final bool force = false}) async => false,
);
