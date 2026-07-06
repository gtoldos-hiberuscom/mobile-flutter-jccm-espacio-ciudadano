# espacio_ciudadano_api.api.ConsultaTitulosNoUniversitariosApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerTitulosNoUniversitariosIntermediacion**](ConsultaTitulosNoUniversitariosApi.md#obtenertitulosnouniversitariosintermediacion) | **POST** /api/v1/intermediacion/titulos-no-universitarios/datos | Obtener títulos no universitarios


# **obtenerTitulosNoUniversitariosIntermediacion**
> RespuestaFachadaInterm obtenerTitulosNoUniversitariosIntermediacion(baseRequestIntermediacion, authorization)

Obtener títulos no universitarios

Consulta los títulos no universitarios de un ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getConsultaTitulosNoUniversitariosApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerTitulosNoUniversitariosIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConsultaTitulosNoUniversitariosApi->obtenerTitulosNoUniversitariosIntermediacion: $e\n');
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

