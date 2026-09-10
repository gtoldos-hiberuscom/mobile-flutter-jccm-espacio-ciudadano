//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:espacio_ciudadano_api/src/api_util.dart';
import 'package:espacio_ciudadano_api/src/model/dtquery.dart';
import 'package:espacio_ciudadano_api/src/model/dtselectbynifreq.dart';
import 'package:espacio_ciudadano_api/src/model/dtselectbynifv2_req.dart';
import 'package:espacio_ciudadano_api/src/model/my_publi_selec_by_nif_tipo_proc_registros_entrada_operation1200_response.dart';
import 'package:espacio_ciudadano_api/src/model/respuesta.dart';
import 'package:espacio_ciudadano_api/src/model/zcsrfcpubliselectbynif_response.dart';
import 'package:espacio_ciudadano_api/src/model/zcsrfcpubliselectbynumexp.dart';
import 'package:espacio_ciudadano_api/src/model/zcsrfcpubliselectbynumreg.dart';

class PublicacionApi {

  final Dio _dio;

  final Serializers _serializers;

  const PublicacionApi(this._dio, this._serializers);

  /// Consultar el detalle de un tramite en cesar
  /// 
  ///
  /// Parameters:
  /// * [DTQUERY] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ZCSRFCPUBLISELECTBYNIFResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ZCSRFCPUBLISELECTBYNIFResponse>> miDetalleOperation({ 
    required DTQUERY dtqueryBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/servicio/midetalle';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(DTQUERY);
      _bodyData = _serializers.serialize(dtqueryBody, specifiedType: _type);

    } catch(error, stackTrace) {
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

    ZCSRFCPUBLISELECTBYNIFResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ZCSRFCPUBLISELECTBYNIFResponse),
      ) as ZCSRFCPUBLISELECTBYNIFResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ZCSRFCPUBLISELECTBYNIFResponse>(
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

  /// Consultar un expediente de publicación por número de registro
  /// Consulta el detalle de un expediente de publicación a partir del número de registro, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente, incluyendo datos identificativos, órgano gestor, estado de tramitación y relación de documentos asociados.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [idRegistro] 
  /// * [ZCSRFCPUBLISELECTBYNUMREG] - Cuerpo de la petición con el número de documento, número de registro y tipo de documento del ciudadano para localizar el expediente.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliNumRegOperation({ 
    required String idAgente,
    required String idRegistro,
    required ZCSRFCPUBLISELECTBYNUMREG zcsrfcpubliselectbynumregBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/publicacion/selectbynumreg'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString()).replaceAll('{' r'idRegistro' '}', encodeQueryParameter(_serializers, idRegistro, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(ZCSRFCPUBLISELECTBYNUMREG);
      _bodyData = _serializers.serialize(zcsrfcpubliselectbynumregBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar un expediente de publicación por número de registro
  /// Consulta el detalle de un expediente de publicación a partir del número de registro, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente, incluyendo datos identificativos, órgano gestor, estado de tramitación y relación de documentos asociados.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [idRegistro] 
  /// * [ZCSRFCPUBLISELECTBYNUMREG] - Cuerpo de la petición con el número de documento, número de registro y tipo de documento del ciudadano para localizar el expediente.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliNumRegOperation1({ 
    required String idAgente,
    required String idRegistro,
    required ZCSRFCPUBLISELECTBYNUMREG zcsrfcpubliselectbynumregBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/registros/{idRegistro}'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString()).replaceAll('{' r'idRegistro' '}', encodeQueryParameter(_serializers, idRegistro, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(ZCSRFCPUBLISELECTBYNUMREG);
      _bodyData = _serializers.serialize(zcsrfcpubliselectbynumregBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar expedientes y publicaciones asociados a un documento de identidad
  /// Consulta los expedientes de publicación asociados a un ciudadano mediante su tipo y número de documento. La respuesta devuelve la estructura completa con el resultado de la consulta, incluyendo los expedientes localizados, datos del interesado, estado de tramitación, órgano responsable y documentos asociados.
  ///
  /// Parameters:
  /// * [DTSELECTBYNIFREQ] - Cuerpo de la petición con el tipo y número de documento del ciudadano cuyos expedientes se desean consultar.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNifOperation({ 
    required DTSELECTBYNIFREQ dtselectbynifreqBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/publicacion/selectbynif';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(DTSELECTBYNIFREQ);
      _bodyData = _serializers.serialize(dtselectbynifreqBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar registros de entrada por documento del ciudadano
  /// Consulta la lista de registros de entrada asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento ENTRADA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [DTSELECTBYNIFV2REQ] - Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como ENTRADA.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNifTipoProcEntradaOperation({ 
    required String idAgente,
    required DTSELECTBYNIFV2REQ dtselectbynifv2reqBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/expedientes/listado-registro-entrada'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(DTSELECTBYNIFV2REQ);
      _bodyData = _serializers.serialize(dtselectbynifv2reqBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar registros de entrada por documento del ciudadano
  /// Consulta la lista de registros de entrada asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento ENTRADA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [DTSELECTBYNIFV2REQ] - Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como ENTRADA.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNifTipoProcEntradaOperation1({ 
    required String idAgente,
    required DTSELECTBYNIFV2REQ dtselectbynifv2reqBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/publicacion/selectbynifentrada'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(DTSELECTBYNIFV2REQ);
      _bodyData = _serializers.serialize(dtselectbynifv2reqBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar expedientes por documento del ciudadano
  /// Consulta la lista de expedientes asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento EXP y devuelve los expedientes localizados con información de tramitación, órgano responsable y documentos asociados.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [DTSELECTBYNIFV2REQ] - Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como EXP.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNifTipoProcExpOperation({ 
    required String idAgente,
    required DTSELECTBYNIFV2REQ dtselectbynifv2reqBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/publicacion/selectbynifexp'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(DTSELECTBYNIFV2REQ);
      _bodyData = _serializers.serialize(dtselectbynifv2reqBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar expedientes por documento del ciudadano
  /// Consulta la lista de expedientes asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento EXP y devuelve los expedientes localizados con información de tramitación, órgano responsable y documentos asociados.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [DTSELECTBYNIFV2REQ] - Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como EXP.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNifTipoProcExpOperation1({ 
    required String idAgente,
    required DTSELECTBYNIFV2REQ dtselectbynifv2reqBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/expedientes'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(DTSELECTBYNIFV2REQ);
      _bodyData = _serializers.serialize(dtselectbynifv2reqBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Busqueda de registros por tipo
  /// Devuelve los registros de tipo entrada para el NIF proporcionado. Se invoca mediante el mismo path con el parámetro query &#39;tipo&#x3D;entrada&#39;. Ejemplo: /ciudadanos/{idAgente}/registros?tipo&#x3D;entrada.
  ///
  /// Parameters:
  /// * [tipo] - Tipo de registros: entrada | salida
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [DTSELECTBYNIFV2REQ] - Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response>> myPubliSelecByNifTipoProcRegistrosEntradaOperation1({ 
    required String tipo,
    required String idAgente,
    required DTSELECTBYNIFV2REQ dtselectbynifv2reqBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/registros'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'tipo': encodeQueryParameter(_serializers, tipo, const FullType(String)),
    };

    dynamic _bodyData;

    try {
      const _type = FullType(DTSELECTBYNIFV2REQ);
      _bodyData = _serializers.serialize(dtselectbynifv2reqBody, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
          queryParameters: _queryParameters,
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
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response),
      ) as MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response>(
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

  /// Consultar registros de salida por documento del ciudadano
  /// Consulta la lista de registros de salida asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento SALIDA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [DTSELECTBYNIFV2REQ] - Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNifTipoProcSalidaOperation({ 
    required String idAgente,
    required DTSELECTBYNIFV2REQ dtselectbynifv2reqBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/publicacion/selectbynifsalida'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(DTSELECTBYNIFV2REQ);
      _bodyData = _serializers.serialize(dtselectbynifv2reqBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar registros de salida por documento del ciudadano
  /// Consulta la lista de registros de salida asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento SALIDA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [DTSELECTBYNIFV2REQ] - Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNifTipoProcSalidaOperation1({ 
    required String idAgente,
    required DTSELECTBYNIFV2REQ dtselectbynifv2reqBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/expedientes/listado-registro-salida'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(DTSELECTBYNIFV2REQ);
      _bodyData = _serializers.serialize(dtselectbynifv2reqBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar un expediente de publicación por número de expediente
  /// Consulta el detalle de un expediente de publicación a partir del número de expediente, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente con datos identificativos, estado, órgano gestor y documentos asociados.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [idExpediente] 
  /// * [ZCSRFCPUBLISELECTBYNUMEXP] - Cuerpo de la petición con número de documento, número de expediente y tipo de documento del ciudadano para localizar el expediente.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNumExpOperation({ 
    required String idAgente,
    required String idExpediente,
    required ZCSRFCPUBLISELECTBYNUMEXP zcsrfcpubliselectbynumexpBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente}'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString()).replaceAll('{' r'idExpediente' '}', encodeQueryParameter(_serializers, idExpediente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(ZCSRFCPUBLISELECTBYNUMEXP);
      _bodyData = _serializers.serialize(zcsrfcpubliselectbynumexpBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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

  /// Consultar un expediente de publicación por número de expediente
  /// Consulta el detalle de un expediente de publicación a partir del número de expediente, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente con datos identificativos, estado, órgano gestor y documentos asociados.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [idExpediente] 
  /// * [ZCSRFCPUBLISELECTBYNUMEXP] - Cuerpo de la petición con número de documento, número de expediente y tipo de documento del ciudadano para localizar el expediente.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> myPubliSelecByNumExpOperation1({ 
    required String idAgente,
    required String idExpediente,
    required ZCSRFCPUBLISELECTBYNUMEXP zcsrfcpubliselectbynumexpBody,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/publicacion/selectbynumexp'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString()).replaceAll('{' r'idExpediente' '}', encodeQueryParameter(_serializers, idExpediente, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
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
      const _type = FullType(ZCSRFCPUBLISELECTBYNUMEXP);
      _bodyData = _serializers.serialize(zcsrfcpubliselectbynumexpBody, specifiedType: _type);

    } catch(error, stackTrace) {
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
      _responseData = rawResponse == null ? null : _serializers.deserialize(
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
