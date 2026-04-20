//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:espacio_ciudadano_api/src/api_util.dart';
import 'package:espacio_ciudadano_api/src/model/dtdgtlistadovehiculosreq.dart';
import 'package:espacio_ciudadano_api/src/model/dtdgtlistadovehiculosres.dart';

class DgtApi {
  final Dio _dio;

  final Serializers _serializers;

  const DgtApi(this._dio, this._serializers);

  /// Servicio para consultar el listado de vehiculos
  ///
  ///
  /// Parameters:
  /// * [numDocumento]
  /// * [dTDGTLISTADOVEHICULOSREQBody]
  /// * [authorization]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DTDGTLISTADOVEHICULOSRES] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DTDGTLISTADOVEHICULOSRES>> getListaVehiculos({
    required String numDocumento,
    required DTDGTLISTADOVEHICULOSREQ dTDGTLISTADOVEHICULOSREQBody,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/dgt/lista-vehiculos/{numDocumento}'.replaceAll(
        '{' r'numDocumento' '}',
        encodeQueryParameter(_serializers, numDocumento, const FullType(String))
            .toString());
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
      _bodyData = _serializers.serialize(dTDGTLISTADOVEHICULOSREQBody,
          specifiedType: _type);
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

    DTDGTLISTADOVEHICULOSRES? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(DTDGTLISTADOVEHICULOSRES),
            ) as DTDGTLISTADOVEHICULOSRES;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DTDGTLISTADOVEHICULOSRES>(
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
