import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';

/// Cliente del servidor de versiones (`GET /api/v1/app-movil/actualizacion`,
/// contrato en `documentation/api/app-version-api.yaml`).
final class AppVersionApi {
  AppVersionApi(this._dio);

  /// Dio propio y no el cliente de la app: la consulta se hace al arrancar,
  /// antes del login, así que no lleva el interceptor de autenticación (que
  /// además podría refrescar o cerrar sesión ante un 401) ni el de errores (el
  /// `DioException` crudo lo convierte el use case en «no bloquear»). Solo el
  /// logger, que no vuelca cuerpos.
  factory AppVersionApi.standalone({required final String baseUrl}) => AppVersionApi(
    Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: timeout, receiveTimeout: timeout, sendTimeout: timeout))..interceptors.add(EmojiDioLogger()),
  );

  /// Corto a propósito: la comprobación corre en cada arranque y vuelta de
  /// segundo plano y no debe retrasar nada; si tarda, se da por no disponible.
  static const Duration timeout = Duration(seconds: 5);

  static const String path = '/api/v1/app-movil/actualizacion';

  final Dio _dio;

  /// Cuerpo de la respuesta ya decodificado; el DTO valida su forma.
  Future<Object?> checkUpdate({
    required final String platform,
    required final String applicationId,
    required final String version,
  }) async {
    final response = await _dio.get<Object?>(
      path,
      queryParameters: {'plataforma': platform, 'idAplicacion': applicationId, 'version': version},
    );
    return response.data;
  }
}
