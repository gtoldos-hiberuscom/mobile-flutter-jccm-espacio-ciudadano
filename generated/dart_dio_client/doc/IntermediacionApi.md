# espacio_ciudadano_api.api.IntermediacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerDatosFamiliaNumerosa**](IntermediacionApi.md#obtenerdatosfamilianumerosa) | **POST** /api/v1/intermediacion/discapacidad/datos | Obtener datos del carné de familia numerosa
[**obtenerDatosFamiliaNumerosaIntermediacion**](IntermediacionApi.md#obtenerdatosfamilianumerosaintermediacion) | **POST** /api/v1/intermediacion/familia-numerosa/datos | 


# **obtenerDatosFamiliaNumerosa**
> String obtenerDatosFamiliaNumerosa(requestFachadaDiscapacidadInterm, authorization)

Obtener datos del carné de familia numerosa

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final RequestFachadaDiscapacidadInterm requestFachadaDiscapacidadInterm = ; // RequestFachadaDiscapacidadInterm | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosFamiliaNumerosa(requestFachadaDiscapacidadInterm, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosFamiliaNumerosa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestFachadaDiscapacidadInterm** | [**RequestFachadaDiscapacidadInterm**](RequestFachadaDiscapacidadInterm.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosaIntermediacion**
> RespuestaRespuestaFachadaFamiliaNumerosaInterm obtenerDatosFamiliaNumerosaIntermediacion(requestFachadaFamiliaNumerosaInterm, authorization)



### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final RequestFachadaFamiliaNumerosaInterm requestFachadaFamiliaNumerosaInterm = ; // RequestFachadaFamiliaNumerosaInterm | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosFamiliaNumerosaIntermediacion(requestFachadaFamiliaNumerosaInterm, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosFamiliaNumerosaIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestFachadaFamiliaNumerosaInterm** | [**RequestFachadaFamiliaNumerosaInterm**](RequestFachadaFamiliaNumerosaInterm.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**RespuestaRespuestaFachadaFamiliaNumerosaInterm**](RespuestaRespuestaFachadaFamiliaNumerosaInterm.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

