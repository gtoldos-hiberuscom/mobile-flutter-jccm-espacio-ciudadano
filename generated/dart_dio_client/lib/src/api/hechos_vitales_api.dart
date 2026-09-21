//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/api_util.dart';
import 'package:espacio_ciudadano_api/src/model/clausulas_agente.dart';
import 'package:espacio_ciudadano_api/src/model/lista_hechos_agente.dart';
import 'package:espacio_ciudadano_api/src/model/respuesta.dart';

class HechosVitalesApi {

  final Dio _dio;

  final Serializers _serializers;

  const HechosVitalesApi(this._dio, this._serializers);

  /// Actualizar las cláusulas de consentimiento de un agente
  /// Actualiza el estado de aceptación de las cláusulas de consentimiento ya registradas para el ciudadano. A diferencia del alta (POST), este endpoint modifica cláusulas existentes. Recibe el identificador del agente y la lista completa de cláusulas con su versión y nuevo estado de selección. Devuelve true si la actualización se realizó correctamente.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [clausulasAgente] - Cuerpo de la petición con el identificador del agente y la lista de cláusulas a actualizar. Cada cláusula incluye su identificador, versión y nuevo estado de selección (true=aceptada, false=rechazada).
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> actualizarClausulas({ 
    required String idAgente,
    required ClausulasAgente clausulasAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/clausulas'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'PATCH',
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
      const _type = FullType(ClausulasAgente);
      _bodyData = _serializers.serialize(clausulasAgente, specifiedType: _type);

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

  /// Actualizar las cláusulas de consentimiento de un agente
  /// Actualiza el estado de aceptación de las cláusulas de consentimiento ya registradas para el ciudadano. A diferencia del alta (POST), este endpoint modifica cláusulas existentes. Recibe el identificador del agente y la lista completa de cláusulas con su versión y nuevo estado de selección. Devuelve true si la actualización se realizó correctamente.
  ///
  /// Parameters:
  /// * [clausulasAgente] - Cuerpo de la petición con el identificador del agente y la lista de cláusulas a actualizar. Cada cláusula incluye su identificador, versión y nuevo estado de selección (true=aceptada, false=rechazada).
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> actualizarClausulas1({ 
    required ClausulasAgente clausulasAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/hechos-vitales/clausulas';
    final _options = Options(
      method: r'PATCH',
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
      const _type = FullType(ClausulasAgente);
      _bodyData = _serializers.serialize(clausulasAgente, specifiedType: _type);

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

  /// Actualizar los hechos vitales seleccionados por un agente
  /// Actualiza la lista de hechos vitales seleccionados por el ciudadano. Recibe el identificador del agente y la lista completa de hechos vitales con su estado de selección. Solo los hechos con seleccionado&#x3D;true quedarán activos para el agente. Devuelve true si la actualización se realizó correctamente.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [listaHechosAgente] - Cuerpo de la petición con el identificador del agente y la lista de hechos vitales a actualizar. Cada hecho incluye su identificador y el estado de selección (true=activo, false=inactivo).
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> actualizarListaHechos({ 
    required String idAgente,
    required ListaHechosAgente listaHechosAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/hechos'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'PATCH',
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
      const _type = FullType(ListaHechosAgente);
      _bodyData = _serializers.serialize(listaHechosAgente, specifiedType: _type);

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

  /// Actualizar los hechos vitales seleccionados por un agente
  /// Actualiza la lista de hechos vitales seleccionados por el ciudadano. Recibe el identificador del agente y la lista completa de hechos vitales con su estado de selección. Solo los hechos con seleccionado&#x3D;true quedarán activos para el agente. Devuelve true si la actualización se realizó correctamente.
  ///
  /// Parameters:
  /// * [listaHechosAgente] - Cuerpo de la petición con el identificador del agente y la lista de hechos vitales a actualizar. Cada hecho incluye su identificador y el estado de selección (true=activo, false=inactivo).
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> actualizarListaHechos1({ 
    required ListaHechosAgente listaHechosAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/hechos-vitales/hechos';
    final _options = Options(
      method: r'PATCH',
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
      const _type = FullType(ListaHechosAgente);
      _bodyData = _serializers.serialize(listaHechosAgente, specifiedType: _type);

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

  /// Eliminar preferencias y configuración de hechos vitales de un agente
  /// Elimina las preferencias del ciudadano asociadas al módulo de hechos vitales (hechos seleccionados y configuración relacionada). Tras la operación, el agente queda sin preferencias guardadas y puede volver a configurarlas desde cero. Devuelve true si la eliminación se realiza correctamente.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> eliminarPreferencias({ 
    required String idAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/hechos-vitales/preferencias/{idAgente}'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'DELETE',
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

  /// Eliminar preferencias y configuración de hechos vitales de un agente
  /// Elimina las preferencias del ciudadano asociadas al módulo de hechos vitales (hechos seleccionados y configuración relacionada). Tras la operación, el agente queda sin preferencias guardadas y puede volver a configurarlas desde cero. Devuelve true si la eliminación se realiza correctamente.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> eliminarPreferencias1({ 
    required String idAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/preferencias'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
    final _options = Options(
      method: r'DELETE',
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

  /// Dar de alta las cláusulas de consentimiento de un agente
  /// Registra por primera vez (alta inicial) las cláusulas de consentimiento seleccionadas por el ciudadano. Recibe el identificador del agente y la lista de cláusulas con su versión y estado de aceptación. Devuelve true si el registro se ha realizado correctamente.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [clausulasAgente] - Cuerpo de la petición con el identificador del agente y la lista de cláusulas a registrar. Cada cláusula incluye su identificador, versión y estado de selección (true=aceptada, false=rechazada).
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> enviarClausulas({ 
    required String idAgente,
    required ClausulasAgente clausulasAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/clausulas'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
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
      const _type = FullType(ClausulasAgente);
      _bodyData = _serializers.serialize(clausulasAgente, specifiedType: _type);

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

  /// Dar de alta las cláusulas de consentimiento de un agente
  /// Registra por primera vez (alta inicial) las cláusulas de consentimiento seleccionadas por el ciudadano. Recibe el identificador del agente y la lista de cláusulas con su versión y estado de aceptación. Devuelve true si el registro se ha realizado correctamente.
  ///
  /// Parameters:
  /// * [clausulasAgente] - Cuerpo de la petición con el identificador del agente y la lista de cláusulas a registrar. Cada cláusula incluye su identificador, versión y estado de selección (true=aceptada, false=rechazada).
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> enviarClausulas1({ 
    required ClausulasAgente clausulasAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/hechos-vitales/clausulas';
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
      const _type = FullType(ClausulasAgente);
      _bodyData = _serializers.serialize(clausulasAgente, specifiedType: _type);

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

  /// Obtener servicios recomendados agrupados por hecho vital
  /// Recupera los trámites y servicios disponibles para el ciudadano agrupados por cada hecho vital que tiene seleccionado. Por cada hecho vital activo del agente, devuelve la lista de trámites relacionados con información del trámite, unidad orgánica responsable y periodo de presentación.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> getServicios({ 
    required String idAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/hechos-vitales/servicios/{idAgente}'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
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

  /// Obtener servicios segmentados por hechos vitales
  /// Recupera los trámites y servicios disponibles segmentados según los hechos vitales seleccionados por el ciudadano. Permite filtrar por operación, paginación (size y page), rango de días recientes (ultimosDias) y una lista de identificadores de hechos vitales. Devuelve únicamente los trámites cuyo periodo de presentación esté activo o abierto permanentemente y que correspondan a los hechos vitales indicados.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [operacion] - Tipo de operación a realizar. Ejemplo: 'todo' para recuperar todos los trámites.
  /// * [size] - Número máximo de resultados por página. Ejemplo: 10
  /// * [page] - Número de página a recuperar (base 0). Ejemplo: 0
  /// * [ultimosDias] - Filtro de trámites publicados en los últimos N días. Ejemplo: 30
  /// * [hechosvitales] - Lista de identificadores de hechos vitales por los que filtrar los trámites. Ejemplo: [1]
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> getServiciosSegmentados({ 
    required String idAgente,
    String? operacion,
    String? size,
    String? page,
    String? ultimosDias,
    BuiltList<int>? hechosvitales,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/hechos-vitales/servicios/segmentacion/{idAgente}'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
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
      if (operacion != null) r'operacion': encodeQueryParameter(_serializers, operacion, const FullType(String)),
      if (size != null) r'size': encodeQueryParameter(_serializers, size, const FullType(String)),
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(String)),
      if (ultimosDias != null) r'ultimosDias': encodeQueryParameter(_serializers, ultimosDias, const FullType(String)),
      if (hechosvitales != null) r'hechosvitales': encodeCollectionQueryParameter<int>(_serializers, hechosvitales, const FullType(BuiltList, [FullType(int)]), format: ListFormat.multi,),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
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

  /// Obtener servicios segmentados por hechos vitales
  /// Recupera los trámites y servicios disponibles segmentados según los hechos vitales seleccionados por el ciudadano. Permite filtrar por operación, paginación (size y page), rango de días recientes (ultimosDias) y una lista de identificadores de hechos vitales. Devuelve únicamente los trámites cuyo periodo de presentación esté activo o abierto permanentemente y que correspondan a los hechos vitales indicados.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano). Ejemplo: PER9999927
  /// * [operacion] - Tipo de operación a realizar. Ejemplo: 'todo' para recuperar todos los trámites.
  /// * [size] - Número máximo de resultados por página. Ejemplo: 10
  /// * [page] - Número de página a recuperar (base 0). Ejemplo: 0
  /// * [ultimosDias] - Filtro de trámites publicados en los últimos N días. Ejemplo: 30
  /// * [hechosvitales] - Lista de identificadores de hechos vitales por los que filtrar los trámites. Ejemplo: [1]
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> getServiciosSegmentados1({ 
    required String idAgente,
    String? operacion,
    String? size,
    String? page,
    String? ultimosDias,
    BuiltList<int>? hechosvitales,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/recomendaciones'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
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
      if (operacion != null) r'operacion': encodeQueryParameter(_serializers, operacion, const FullType(String)),
      if (size != null) r'size': encodeQueryParameter(_serializers, size, const FullType(String)),
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(String)),
      if (ultimosDias != null) r'ultimosDias': encodeQueryParameter(_serializers, ultimosDias, const FullType(String)),
      if (hechosvitales != null) r'hechosvitales': encodeCollectionQueryParameter<int>(_serializers, hechosvitales, const FullType(BuiltList, [FullType(int)]), format: ListFormat.multi,),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
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

  /// Obtener cláusulas de consentimiento asociadas a un agente
  /// Recupera todas las cláusulas de consentimiento y preferencias asociadas a un agente (ciudadano). Devuelve una estructura con el identificador del agente, estado de cláusulas pendientes y un listado detallado de todas las cláusulas disponibles incluyendo su descripción, textos (breve y ampliado en HTML), versión y estado de selección actual.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano) para el cual se recuperarán las cláusulas de consentimiento.
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> obtenerClausulasPorAgente({ 
    required String idAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/clausulas'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
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

  /// Obtener cláusulas de consentimiento asociadas a un agente
  /// Recupera todas las cláusulas de consentimiento y preferencias asociadas a un agente (ciudadano). Devuelve una estructura con el identificador del agente, estado de cláusulas pendientes y un listado detallado de todas las cláusulas disponibles incluyendo su descripción, textos (breve y ampliado en HTML), versión y estado de selección actual.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano) para el cual se recuperarán las cláusulas de consentimiento.
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> obtenerClausulasPorAgente1({ 
    required String idAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/hechos-vitales/clausulas/{idAgente}'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
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

  /// Obtener lista de hechos vitales por agente
  /// Recupera la lista completa de hechos vitales (situaciones de vida) disponibles en el sistema para un agente específico (ciudadano). Los hechos vitales representan diferentes situaciones o circunstancias de la vida del ciudadano (tener hijos, buscar trabajo, jubilación, etc.). La respuesta incluye todos los hechos disponibles con su identificador, nombre descriptivo y estado de selección actual.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano) para el cual se recuperará la lista de hechos vitales.
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> obtenerListaHechosByIdAgente({ 
    required String idAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/ciudadanos/{idAgente}/hechos'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
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

  /// Obtener lista de hechos vitales por agente
  /// Recupera la lista completa de hechos vitales (situaciones de vida) disponibles en el sistema para un agente específico (ciudadano). Los hechos vitales representan diferentes situaciones o circunstancias de la vida del ciudadano (tener hijos, buscar trabajo, jubilación, etc.). La respuesta incluye todos los hechos disponibles con su identificador, nombre descriptivo y estado de selección actual.
  ///
  /// Parameters:
  /// * [idAgente] - Identificador único del agente (ciudadano) para el cual se recuperará la lista de hechos vitales.
  /// * [authorization] - Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Respuesta] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Respuesta>> obtenerListaHechosByIdAgente1({ 
    required String idAgente,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/hechos-vitales/hechos/{idAgente}'.replaceAll('{' r'idAgente' '}', encodeQueryParameter(_serializers, idAgente, const FullType(String)).toString());
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
