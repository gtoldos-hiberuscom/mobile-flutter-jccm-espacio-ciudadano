# espacio_ciudadano_api.api.TermalismoApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerDatosTermalismoIntermediacion**](TermalismoApi.md#obtenerdatostermalismointermediacion) | **POST** /api/v1/intermediacion/termalismo/datos | Obtener datos de termalismo


# **obtenerDatosTermalismoIntermediacion**
> RespuestaFachadaInterm obtenerDatosTermalismoIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de termalismo

Consulta el último balneario adjudicado del programa de termalismo.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getTermalismoApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosTermalismoIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TermalismoApi->obtenerDatosTermalismoIntermediacion: $e\n');
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

