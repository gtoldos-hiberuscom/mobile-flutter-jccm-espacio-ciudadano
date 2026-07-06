# espacio_ciudadano_api.api.IntermediacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerDatosAtencionDependenciaIntermediacion**](IntermediacionApi.md#obtenerdatosatenciondependenciaintermediacion) | **POST** /api/v1/intermediacion/atencion-dependencia/datos | Obtener datos de atención a la dependencia
[**obtenerDatosDiscapacidadIntermediacion**](IntermediacionApi.md#obtenerdatosdiscapacidadintermediacion) | **POST** /api/v1/intermediacion/discapacidad/datos | Obtener datos del carné de discapacidad
[**obtenerDatosFamiliaNumerosaIntermediacion**](IntermediacionApi.md#obtenerdatosfamilianumerosaintermediacion) | **POST** /api/v1/intermediacion/familia-numerosa/datos | Obtener datos del carné de familia numerosa
[**obtenerDatosTarjetaEstacionamientoIntermediacion**](IntermediacionApi.md#obtenerdatostarjetaestacionamientointermediacion) | **POST** /api/v1/intermediacion/tarjeta-estacionamiento/datos | Obtener datos de la tarjeta de estacionamiento
[**obtenerDatosTermalismoIntermediacion**](IntermediacionApi.md#obtenerdatostermalismointermediacion) | **POST** /api/v1/intermediacion/termalismo/datos | Obtener datos de termalismo
[**obtenerOfertasEmpleoInscritas**](IntermediacionApi.md#obtenerofertasempleoinscritas) | **POST** /api/v1/intermediacion/empleo/ofertas-inscritas | Consulta las ofertas de empleo inscritas por un ciudadano en la Consejería de Empleo.
[**obtenerTitulosNoUniversitariosIntermediacion**](IntermediacionApi.md#obtenertitulosnouniversitariosintermediacion) | **POST** /api/v1/intermediacion/titulos-no-universitarios/datos | Obtener títulos no universitarios


# **obtenerDatosAtencionDependenciaIntermediacion**
> RespuestaFachadaInterm obtenerDatosAtencionDependenciaIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de atención a la dependencia

Consulta la situación actual de las prestaciones en ayuda a la dependencia.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosAtencionDependenciaIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosAtencionDependenciaIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**RespuestaFachadaInterm**](RespuestaFachadaInterm.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosDiscapacidadIntermediacion**
> RespuestaFachadaInterm obtenerDatosDiscapacidadIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos del carné de discapacidad

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosDiscapacidadIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosDiscapacidadIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**RespuestaFachadaInterm**](RespuestaFachadaInterm.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosaIntermediacion**
> RespuestaFachadaInterm obtenerDatosFamiliaNumerosaIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos del carné de familia numerosa

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosFamiliaNumerosaIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosFamiliaNumerosaIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**RespuestaFachadaInterm**](RespuestaFachadaInterm.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosTarjetaEstacionamientoIntermediacion**
> RespuestaFachadaInterm obtenerDatosTarjetaEstacionamientoIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de la tarjeta de estacionamiento

Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla La Mancha.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosTarjetaEstacionamientoIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosTarjetaEstacionamientoIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**RespuestaFachadaInterm**](RespuestaFachadaInterm.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosTermalismoIntermediacion**
> RespuestaFachadaInterm obtenerDatosTermalismoIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de termalismo

Consulta el último balneario adjudicado del programa de termalismo.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosTermalismoIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosTermalismoIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**RespuestaFachadaInterm**](RespuestaFachadaInterm.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerOfertasEmpleoInscritas**
> RespuestaFachadaInterm obtenerOfertasEmpleoInscritas(baseRequestIntermediacion, authorization)

Consulta las ofertas de empleo inscritas por un ciudadano en la Consejería de Empleo.

Consulta las ofertas de empleo inscritas por un ciudadano en la Consejería de Empleo.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerOfertasEmpleoInscritas(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerOfertasEmpleoInscritas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**RespuestaFachadaInterm**](RespuestaFachadaInterm.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerTitulosNoUniversitariosIntermediacion**
> RespuestaFachadaInterm obtenerTitulosNoUniversitariosIntermediacion(baseRequestIntermediacion, authorization)

Obtener títulos no universitarios

Consulta los títulos no universitarios de un ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerTitulosNoUniversitariosIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerTitulosNoUniversitariosIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**RespuestaFachadaInterm**](RespuestaFachadaInterm.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

