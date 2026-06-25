# espacio_ciudadano_api.api.CatastroApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDatosCatastrales**](CatastroApi.md#getdatoscatastrales) | **POST** /api/v1/catastro/datos-catastrales/{numDocumento} | Servicio para obtener los datos catastrales


# **getDatosCatastrales**
> Respuesta getDatosCatastrales(numDocumento, DTCTROCDATREQ, authorization)

Servicio para obtener los datos catastrales

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCatastroApi();
final String numDocumento = numDocumento_example; // String | 
final DTCTROCDATREQ DTCTROCDATREQ = ; // DTCTROCDATREQ | 
final String authorization = authorization_example; // String | 

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
 **numDocumento** | **String**|  | 
 **DTCTROCDATREQ** | [**DTCTROCDATREQ**](DTCTROCDATREQ.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

