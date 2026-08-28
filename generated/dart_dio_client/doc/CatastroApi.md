# espacio_ciudadano_api.api.CatastroApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDatosCatastrales**](CatastroApi.md#getdatoscatastrales) | **POST** /api/v1/catastro/datos-catastrales/{numDocumento} | Obtener datos catastrales
[**getDatosCatastrales1**](CatastroApi.md#getdatoscatastrales1) | **POST** /api/v1/ciudadanos/{numDocumento}/vivienda/datos-catastrales | Obtener datos catastrales


# **getDatosCatastrales**
> Respuesta getDatosCatastrales(numDocumento, DTCTROCDATREQ, authorization)

Obtener datos catastrales

Consulta los datos catastrales del ciudadano en el servicio de Catastro.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCatastroApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTCTROCDATREQ DTCTROCDATREQ = {"tipdoc":"NIF","docu":"99999999R"}; // DTCTROCDATREQ | Datos de entrada para la consulta catastral.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getDatosCatastrales(numDocumento, DTCTROCDATREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatastroApi->getDatosCatastrales: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTCTROCDATREQ** | [**DTCTROCDATREQ**](DTCTROCDATREQ.md)| Datos de entrada para la consulta catastral. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDatosCatastrales1**
> Respuesta getDatosCatastrales1(numDocumento, DTCTROCDATREQ, authorization)

Obtener datos catastrales

Consulta los datos catastrales del ciudadano en el servicio de Catastro.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCatastroApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTCTROCDATREQ DTCTROCDATREQ = {"tipdoc":"NIF","docu":"99999999R"}; // DTCTROCDATREQ | Datos de entrada para la consulta catastral.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getDatosCatastrales1(numDocumento, DTCTROCDATREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatastroApi->getDatosCatastrales1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTCTROCDATREQ** | [**DTCTROCDATREQ**](DTCTROCDATREQ.md)| Datos de entrada para la consulta catastral. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

