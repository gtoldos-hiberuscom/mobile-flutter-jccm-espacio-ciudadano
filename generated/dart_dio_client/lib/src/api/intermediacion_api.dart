//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

class IntermediacionApi {
  final Dio _dio;

  final Serializers _serializers;

  const IntermediacionApi(this._dio, this._serializers);

  /// Obtener datos de atencion a la dependencia
  /// Consulta la situacion actual del expediente y prestaciones de dependencia del ciudadano. La respuesta se muestra con la estructura completa Respuesta y el detalle interno de datos especificos.
  ///
  /// Parameters:
  /// * [baseRequestIntermediacion] - Cuerpo de peticion para consultar datos de atencion a la dependencia por intermediacion.
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
  Future<Response<Respuesta>> obtenerDatosAtencionDependenciaIntermediacion({
    required BaseRequestIntermediacion baseRequestIntermediacion,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/intermediacion/atencion-dependencia/datos';
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
      const _type = FullType(BaseRequestIntermediacion);
      _bodyData = _serializers.serialize(baseRequestIntermediacion, specifiedType: _type);
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

  /// Obtener datos de discapacidad por intermediación
  /// Consulta el servicio de intermediación para recuperar los datos del certificado de discapacidad del ciudadano.
  ///
  /// Parameters:
  /// * [baseRequestIntermediacion] - Cuerpo de petición para consultar datos de discapacidad por intermediación.
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
  Future<Response<Respuesta>> obtenerDatosDiscapacidadIntermediacion({
    required BaseRequestIntermediacion baseRequestIntermediacion,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/intermediacion/discapacidad/datos';
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
      const _type = FullType(BaseRequestIntermediacion);
      _bodyData = _serializers.serialize(baseRequestIntermediacion, specifiedType: _type);
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

  /// Obtener datos de familia numerosa por intermediación
  /// Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.
  ///
  /// Parameters:
  /// * [baseRequestIntermediacion] - Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
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
  Future<Response<Respuesta>> obtenerDatosFamiliaNumerosaIntermediacion({
    required BaseRequestIntermediacion baseRequestIntermediacion,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/intermediacion/familia-numerosa/datos';
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
      const _type = FullType(BaseRequestIntermediacion);
      _bodyData = _serializers.serialize(baseRequestIntermediacion, specifiedType: _type);
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

  /// Obtener datos de la tarjeta de estacionamiento para personas con discapacidad
  /// Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla-La Mancha. La respuesta incluye el identificador de la tarjeta, modalidad (Persona con Discapacidad o Movilidad Reducida), fechas de vigencia de inicio y fin, y demás datos asociados a la tarjeta.
  ///
  /// Parameters:
  /// * [baseRequestIntermediacion] - Cuerpo de petición para consultar datos de tarjeta de estacionamiento por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
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
  Future<Response<Respuesta>> obtenerDatosTarjetaEstacionamientoIntermediacion({
    required BaseRequestIntermediacion baseRequestIntermediacion,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/intermediacion/tarjeta-estacionamiento/datos';
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
      const _type = FullType(BaseRequestIntermediacion);
      _bodyData = _serializers.serialize(baseRequestIntermediacion, specifiedType: _type);
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

  /// Obtener datos del último balneario adjudicado del programa de termalismo
  /// Consulta el último balneario adjudicado en el programa de termalismo de Castilla-La Mancha para el ciudadano especificado. La respuesta incluye información detallada del balneario incluyendo su nombre, localidad, fechas de estancia programadas y otros datos de la adjudicación.
  ///
  /// Parameters:
  /// * [baseRequestIntermediacion] - Cuerpo de petición para consultar datos de termalismo por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
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
  Future<Response<Respuesta>> obtenerDatosTermalismoIntermediacion({
    required BaseRequestIntermediacion baseRequestIntermediacion,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/intermediacion/termalismo/datos';
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
      const _type = FullType(BaseRequestIntermediacion);
      _bodyData = _serializers.serialize(baseRequestIntermediacion, specifiedType: _type);
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

  /// Obtener ofertas de empleo inscritas
  /// Consulta las ofertas de empleo en las que el ciudadano figura inscrito. La respuesta se muestra con la estructura completa Respuesta y el listado de ofertas en datosespecificos.
  ///
  /// Parameters:
  /// * [baseRequestIntermediacion] - Cuerpo de peticion para consultar ofertas de empleo inscritas por intermediacion.
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
  Future<Response<Respuesta>> obtenerOfertasEmpleoInscritas({
    required BaseRequestIntermediacion baseRequestIntermediacion,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/intermediacion/empleo/ofertas-inscritas';
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
      const _type = FullType(BaseRequestIntermediacion);
      _bodyData = _serializers.serialize(baseRequestIntermediacion, specifiedType: _type);
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

  /// Obtener títulos no universitarios del ciudadano
  /// Consulta los títulos no universitarios (Ciclos Formativos de Grado Superior y Grado Medio) registrados para el ciudadano. La respuesta incluye información detallada de cada título obtenido como denominación, tipo de ciclo (CFGS/CFGM), centro educativo, localidad y fechas de obtención y expedición del título.
  ///
  /// Parameters:
  /// * [baseRequestIntermediacion] - Cuerpo de petición para consultar títulos no universitarios por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
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
  Future<Response<Respuesta>> obtenerTitulosNoUniversitariosIntermediacion({
    required BaseRequestIntermediacion baseRequestIntermediacion,
    String? authorization,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/intermediacion/titulos-no-universitarios/datos';
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
      const _type = FullType(BaseRequestIntermediacion);
      _bodyData = _serializers.serialize(baseRequestIntermediacion, specifiedType: _type);
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
