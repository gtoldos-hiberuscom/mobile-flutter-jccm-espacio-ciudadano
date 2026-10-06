import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';

/// Cliente de la búsqueda de iTunes (`GET /lookup`), la única API pública de
/// App Store: devuelve la ficha publicada de una app a partir de su bundle id,
/// sin autenticación.
final class ItunesLookupApi {
  ItunesLookupApi(this._dio);

  /// Dio propio y no el cliente de la app: sin interceptores de autenticación
  /// (es otro host) ni de errores (el `DioException` crudo lo convierte el use
  /// case en «no bloquear»). Solo el logger, que no vuelca cuerpos.
  factory ItunesLookupApi.standalone() => ItunesLookupApi(
    Dio(BaseOptions(connectTimeout: timeout, receiveTimeout: timeout, sendTimeout: timeout))..interceptors.add(EmojiDioLogger()),
  );

  /// Corto a propósito: la comprobación corre en cada arranque y vuelta de
  /// segundo plano y no debe retrasar nada; si tarda, se da por no disponible.
  static const Duration timeout = Duration(seconds: 5);

  /// URL absoluta: Dio la respeta aunque la instancia tenga `baseUrl`.
  static const String endpointUrl = 'https://itunes.apple.com/lookup';

  final Dio _dio;

  /// Cuerpo crudo de la respuesta.
  ///
  /// iTunes contesta con `Content-Type: text/javascript`, que Dio no decodifica
  /// como JSON; el DTO se encarga.
  Future<String> lookup({required final String bundleId, required final String country}) async {
    final response = await _dio.get<String>(
      endpointUrl,
      queryParameters: {'bundleId': bundleId, 'country': country},
      options: Options(responseType: ResponseType.plain),
    );
    return response.data ?? '';
  }
}
