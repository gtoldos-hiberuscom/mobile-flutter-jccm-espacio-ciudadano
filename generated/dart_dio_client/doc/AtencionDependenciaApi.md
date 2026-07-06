# espacio_ciudadano_api.api.AtencionDependenciaApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerDatosAtencionDependenciaIntermediacion**](AtencionDependenciaApi.md#obtenerdatosatenciondependenciaintermediacion) | **POST** /api/v1/intermediacion/atencion-dependencia/datos | Obtener datos de atención a la dependencia


# **obtenerDatosAtencionDependenciaIntermediacion**
> RespuestaFachadaInterm obtenerDatosAtencionDependenciaIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de atención a la dependencia

Consulta la situación actual de las prestaciones en ayuda a la dependencia.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getAtencionDependenciaApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosAtencionDependenciaIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AtencionDependenciaApi->obtenerDatosAtencionDependenciaIntermediacion: $e\n');
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

