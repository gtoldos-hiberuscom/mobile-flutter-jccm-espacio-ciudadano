//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:espacio_ciudadano_api/src/api_util.dart';

class CiudadanosApi {
  final Dio _dio;

  final Serializers _serializers;

  const CiudadanosApi(this._dio, this._serializers);

  /// Descargar documento de una notificación
  /// Descarga un documento adjunto específico de una notificación electrónica identificado por su orden. Los documentos pueden ser resoluciones, anexos o cualquier contenido notificado al ciudadano.
  ///
  /// Parameters:
  /// * [id] - Documento de identificación del ciudadano (NIF/NIE)
  /// * [notificacionId] - Identificador único de la notificación
  /// * [orden] - Número de orden del documento dentro de la notificación
  /// * [authorization] - Token JWT de autenticación del ciudadano obtenido tras el login
  /// * [sisOrigen] - Código del sistema origen que realiza la petición
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Uint8List] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Uint8List>> descargarDocumento({
    required String id,
    required int notificacionId,
    required int orden,
    String? authorization,
    String? sisOrigen,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/documentos/{orden}'
        .replaceAll('{' r'id' '}',
            encodeQueryParameter(_serializers, id, const FullType(String)).toString())
        .replaceAll('{' r'notificacionId' '}',
            encodeQueryParameter(_serializers, notificacionId, const FullType(int)).toString())
        .replaceAll('{' r'orden' '}',
            encodeQueryParameter(_serializers, orden, const FullType(int)).toString());
    final _options = Options(
      method: r'GET',
      responseType: ResponseType.bytes,
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        if (sisOrigen != null) r'sisOrigen': sisOrigen,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Uint8List? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : rawResponse as Uint8List;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Uint8List>(
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

  /// Descargar justificante de una notificación
  /// Descarga el documento PDF que acredita el puesta a disposición, acceso o rechazo de una notificación electrónica. El justificante tiene valor probatorio conforme a la normativa de notificaciones electrónicas.
  ///
  /// Parameters:
  /// * [id] - Documento de identificación del ciudadano (NIF/NIE)
  /// * [notificacionId] - Identificador único de la notificación
  /// * [authorization] - Token JWT de autenticación del ciudadano obtenido tras el login
  /// * [sisOrigen] - Código del sistema origen que realiza la petición
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Uint8List] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Uint8List>> descargarJustificante({
    required String id,
    required int notificacionId,
    String? authorization,
    String? sisOrigen,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/justificante'
        .replaceAll('{' r'id' '}',
            encodeQueryParameter(_serializers, id, const FullType(String)).toString())
        .replaceAll('{' r'notificacionId' '}',
            encodeQueryParameter(_serializers, notificacionId, const FullType(int)).toString());
    final _options = Options(
      method: r'GET',
      responseType: ResponseType.bytes,
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        if (sisOrigen != null) r'sisOrigen': sisOrigen,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Uint8List? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : rawResponse as Uint8List;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Uint8List>(
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

  /// Modificar el contacto de un ciudadano en Notifica
  /// Actualiza los datos de contacto (email, teléfono) de un tercero previamente registrado en Notifica. El ciudadano debe existir en el sistema. Requiere que el NIF del token coincida con el NIF a modificar.
  ///
  /// Parameters:
  /// * [id] - Documento de identificación del ciudadano (NIF/NIE)
  /// * [terceroN2Dto] - Datos de contacto actualizados del ciudadano
  /// * [authorization] - Token JWT de autenticación del ciudadano obtenido tras el login
  /// * [sisOrigen] - Código del sistema origen que realiza la petición
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TerceroN2Dto] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TerceroN2Dto>> modificarCiudadano({
    required String id,
    required TerceroN2Dto terceroN2Dto,
    String? authorization,
    String? sisOrigen,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{id}/contacto'.replaceAll(
        '{' r'id' '}', encodeQueryParameter(_serializers, id, const FullType(String)).toString());
    final _options = Options(
      method: r'PUT',
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        if (sisOrigen != null) r'sisOrigen': sisOrigen,
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
      const _type = FullType(TerceroN2Dto);
      _bodyData = _serializers.serialize(terceroN2Dto, specifiedType: _type);
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

    TerceroN2Dto? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(TerceroN2Dto),
            ) as TerceroN2Dto;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TerceroN2Dto>(
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

  /// Obtener contacto de un ciudadano registrado en Notifica
  /// Consulta los datos de contacto (email, teléfono) de un tercero previamente registrado en el sistema Notifica. Devuelve 404 si el ciudadano no está registrado.
  ///
  /// Parameters:
  /// * [id] - Documento de identificación del ciudadano (NIF/NIE)
  /// * [authorization] - Token JWT de autenticación del ciudadano obtenido tras el login
  /// * [sisOrigen] - Código del sistema origen que realiza la petición
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TerceroN2Dto] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TerceroN2Dto>> obtenerCiudadano({
    required String id,
    String? authorization,
    String? sisOrigen,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{id}/contacto'.replaceAll(
        '{' r'id' '}', encodeQueryParameter(_serializers, id, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        if (sisOrigen != null) r'sisOrigen': sisOrigen,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    TerceroN2Dto? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(TerceroN2Dto),
            ) as TerceroN2Dto;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TerceroN2Dto>(
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

  /// Obtener una notificación concreta de un ciudadano
  /// Recupera el detalle completo de una notificación electrónica específica, incluyendo documentos adjuntos, histórico de estados e interesados. Aplica control de acceso para verificar que el ciudadano autenticado es interesado en la notificación.
  ///
  /// Parameters:
  /// * [id] - Documento de identificación del ciudadano (NIF/NIE)
  /// * [notificacionId] - Identificador único de la notificación
  /// * [authorization] - Token JWT de autenticación del ciudadano obtenido tras el login
  /// * [sisOrigen] - Código del sistema origen que realiza la petición
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> obtenerNotificacion({
    required String id,
    required int notificacionId,
    String? authorization,
    String? sisOrigen,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{id}/notificaciones/{notificacionId}'
        .replaceAll('{' r'id' '}',
            encodeQueryParameter(_serializers, id, const FullType(String)).toString())
        .replaceAll('{' r'notificacionId' '}',
            encodeQueryParameter(_serializers, notificacionId, const FullType(int)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        if (sisOrigen != null) r'sisOrigen': sisOrigen,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
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

  /// Obtener notificaciones de un ciudadano
  /// Recupera el listado de notificaciones electrónicas asociadas a un ciudadano identificado por su NIF/NIE. Permite filtrar por estado y paginar los resultados. Requiere autenticación mediante token JWT y validación de la cláusula de consentimiento.
  ///
  /// Parameters:
  /// * [id] - Documento de identificación del ciudadano (NIF/NIE)
  /// * [authorization] - Token JWT de autenticación del ciudadano obtenido tras el login
  /// * [estado] - Estado de las notificaciones a filtrar
  /// * [page] - Número de página para paginación (base 0)
  /// * [size] - Tamaño de página para paginación
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [BuiltList<NotificacionIndexaDto>] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<BuiltList<NotificacionIndexaDto>>> obtenerNotificacionesCiudadano({
    required String id,
    String? authorization,
    String? estado,
    int? page,
    int? size,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{id}/notificaciones'.replaceAll(
        '{' r'id' '}', encodeQueryParameter(_serializers, id, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (estado != null)
        r'estado': encodeQueryParameter(_serializers, estado, const FullType(String)),
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(int)),
      if (size != null) r'size': encodeQueryParameter(_serializers, size, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    BuiltList<NotificacionIndexaDto>? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(BuiltList, [FullType(NotificacionIndexaDto)]),
            ) as BuiltList<NotificacionIndexaDto>;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<BuiltList<NotificacionIndexaDto>>(
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

  /// Registrar el contacto de un ciudadano en Notifica
  /// Crea un nuevo registro de contacto (tercero) en el sistema Notifica para recibir notificaciones electrónicas. El NIF del ciudadano debe coincidir con el del token de autenticación. Requiere aceptación previa de la cláusula de consentimiento.
  ///
  /// Parameters:
  /// * [id] - Documento de identificación del ciudadano (NIF/NIE)
  /// * [terceroN2Dto] - Datos de contacto del ciudadano a registrar en Notifica
  /// * [authorization] - Token JWT de autenticación del ciudadano obtenido tras el login
  /// * [sisOrigen] - Código del sistema origen que realiza la petición
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TerceroN2Dto] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TerceroN2Dto>> registrarCiudadano({
    required String id,
    required TerceroN2Dto terceroN2Dto,
    String? authorization,
    String? sisOrigen,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{id}/contacto'.replaceAll(
        '{' r'id' '}', encodeQueryParameter(_serializers, id, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        if (sisOrigen != null) r'sisOrigen': sisOrigen,
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
      const _type = FullType(TerceroN2Dto);
      _bodyData = _serializers.serialize(terceroN2Dto, specifiedType: _type);
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

    TerceroN2Dto? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(TerceroN2Dto),
            ) as TerceroN2Dto;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TerceroN2Dto>(
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

  /// Realizar una transición sobre una notificación
  /// Ejecuta una transición de estado sobre una notificación (por ejemplo: comparecer, aceptar, rechazar). La transición modifica el estado de la notificación según las reglas de negocio del sistema Notifica. Puede requerir justificación según el tipo de transición.
  ///
  /// Parameters:
  /// * [id] - Documento de identificación del ciudadano (NIF/NIE)
  /// * [notificacionId] - Identificador único de la notificación
  /// * [transicionDto] - Datos de la transición a realizar, incluyendo la acción y opcionalmente una justificación
  /// * [authorization] - Token JWT de autenticación del ciudadano obtenido tras el login
  /// * [sisOrigen] - Código del sistema origen que realiza la petición
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> transicionNotificacion({
    required String id,
    required int notificacionId,
    required TransicionDto transicionDto,
    String? authorization,
    String? sisOrigen,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/transiciones'
        .replaceAll('{' r'id' '}',
            encodeQueryParameter(_serializers, id, const FullType(String)).toString())
        .replaceAll('{' r'notificacionId' '}',
            encodeQueryParameter(_serializers, notificacionId, const FullType(int)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        if (authorization != null) r'Authorization': authorization,
        if (sisOrigen != null) r'sisOrigen': sisOrigen,
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
      const _type = FullType(TransicionDto);
      _bodyData = _serializers.serialize(transicionDto, specifiedType: _type);
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
