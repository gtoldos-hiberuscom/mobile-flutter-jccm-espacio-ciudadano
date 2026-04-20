//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:espacio_ciudadano_api/src/serializers.dart';
import 'package:espacio_ciudadano_api/src/auth/api_key_auth.dart';
import 'package:espacio_ciudadano_api/src/auth/basic_auth.dart';
import 'package:espacio_ciudadano_api/src/auth/bearer_auth.dart';
import 'package:espacio_ciudadano_api/src/auth/oauth.dart';
import 'package:espacio_ciudadano_api/src/api/afirma_api.dart';
import 'package:espacio_ciudadano_api/src/api/carnet_digital_api.dart';
import 'package:espacio_ciudadano_api/src/api/catastro_api.dart';
import 'package:espacio_ciudadano_api/src/api/ccaa_api.dart';
import 'package:espacio_ciudadano_api/src/api/consulta_api.dart';
import 'package:espacio_ciudadano_api/src/api/dgt_api.dart';
import 'package:espacio_ciudadano_api/src/api/documentacion_api.dart';
import 'package:espacio_ciudadano_api/src/api/educacion_api.dart';
import 'package:espacio_ciudadano_api/src/api/hechos_vitales_api.dart';
import 'package:espacio_ciudadano_api/src/api/ine_api.dart';
import 'package:espacio_ciudadano_api/src/api/intermediacion_api.dart';
import 'package:espacio_ciudadano_api/src/api/procedimiento_api.dart';
import 'package:espacio_ciudadano_api/src/api/publicacion_api.dart';
import 'package:espacio_ciudadano_api/src/api/sepe_api.dart';
import 'package:espacio_ciudadano_api/src/api/servicio_api.dart';
import 'package:espacio_ciudadano_api/src/api/sescam_api.dart';

class EspacioCiudadanoApi {
  static const String basePath = r'https://fachada-sede-api-pre.cm-pre.jccm.es';

  final Dio dio;
  final Serializers serializers;

  EspacioCiudadanoApi({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Get AfirmaApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AfirmaApi getAfirmaApi() {
    return AfirmaApi(dio, serializers);
  }

  /// Get CarnetDigitalApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CarnetDigitalApi getCarnetDigitalApi() {
    return CarnetDigitalApi(dio, serializers);
  }

  /// Get CatastroApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CatastroApi getCatastroApi() {
    return CatastroApi(dio, serializers);
  }

  /// Get CcaaApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CcaaApi getCcaaApi() {
    return CcaaApi(dio, serializers);
  }

  /// Get ConsultaApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ConsultaApi getConsultaApi() {
    return ConsultaApi(dio, serializers);
  }

  /// Get DgtApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DgtApi getDgtApi() {
    return DgtApi(dio, serializers);
  }

  /// Get DocumentacionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DocumentacionApi getDocumentacionApi() {
    return DocumentacionApi(dio, serializers);
  }

  /// Get EducacionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  EducacionApi getEducacionApi() {
    return EducacionApi(dio, serializers);
  }

  /// Get HechosVitalesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  HechosVitalesApi getHechosVitalesApi() {
    return HechosVitalesApi(dio, serializers);
  }

  /// Get IneApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  IneApi getIneApi() {
    return IneApi(dio, serializers);
  }

  /// Get IntermediacionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  IntermediacionApi getIntermediacionApi() {
    return IntermediacionApi(dio, serializers);
  }

  /// Get ProcedimientoApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ProcedimientoApi getProcedimientoApi() {
    return ProcedimientoApi(dio, serializers);
  }

  /// Get PublicacionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PublicacionApi getPublicacionApi() {
    return PublicacionApi(dio, serializers);
  }

  /// Get SepeApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SepeApi getSepeApi() {
    return SepeApi(dio, serializers);
  }

  /// Get ServicioApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ServicioApi getServicioApi() {
    return ServicioApi(dio, serializers);
  }

  /// Get SescamApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SescamApi getSescamApi() {
    return SescamApi(dio, serializers);
  }
}
