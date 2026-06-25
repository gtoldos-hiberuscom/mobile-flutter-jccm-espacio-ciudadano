# espacio_ciudadano_api.api.EmpleoOfertasInscritasApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerOfertasEmpleoInscritas**](EmpleoOfertasInscritasApi.md#obtenerofertasempleoinscritas) | **POST** /api/v1/intermediacion/empleo/ofertas-inscritas | Consulta las ofertas de empleo inscritas por un ciudadano en la Consejería de Empleo.


# **obtenerOfertasEmpleoInscritas**
> RespuestaFachadaInterm obtenerOfertasEmpleoInscritas(baseRequestIntermediacion, authorization)

Consulta las ofertas de empleo inscritas por un ciudadano en la Consejería de Empleo.

Consulta las ofertas de empleo inscritas por un ciudadano en la Consejería de Empleo.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getEmpleoOfertasInscritasApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerOfertasEmpleoInscritas(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmpleoOfertasInscritasApi->obtenerOfertasEmpleoInscritas: $e\n');
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

