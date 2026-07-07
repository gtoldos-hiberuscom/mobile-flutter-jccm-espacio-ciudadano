//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:espacio_ciudadano_api/src/api_util.dart';

class DgtApi {
  final Dio _dio;

  final Serializers _serializers;

  const DgtApi(this._dio, this._serializers);

  /// Consultar listado de vehiculos de un ciudadano
  /// Consulta en el servicio DGT el listado de vehiculos asociados a un ciudadano identificado por NIF y devuelve el resultado completo de la tramitacion.
  ///
  /// Parameters:
  /// * [numDocumento] - Documento identificativo del ciudadano.
  /// * [DTDGTLISTADOVEHICULOSREQ] - Datos de entrada para la consulta DGT. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano.
  /// * [authorization] - Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> getListaVehiculos({
    required String numDocumento,
    required DTDGTLISTADOVEHICULOSREQ dtdgtlistadovehiculosreqBody,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/dgt/lista-vehiculos/{numDocumento}'.replaceAll('{' r'numDocumento' '}',
        encodeQueryParameter(_serializers, numDocumento, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(DTDGTLISTADOVEHICULOSREQ);
      _bodyData = _serializers.serialize(dtdgtlistadovehiculosreqBody, specifiedType: _type);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Respuesta? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(Respuesta),
            ) as Respuesta;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Respuesta>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }
}
