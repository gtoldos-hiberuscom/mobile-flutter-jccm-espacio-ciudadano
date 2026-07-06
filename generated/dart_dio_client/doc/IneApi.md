# espacio_ciudadano_api.api.IneApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDatosResidencia**](IneApi.md#getdatosresidencia) | **POST** /api/v1/ine/datos-residencia/{numDocumento} | Servicio para obtener los datos de residencia


# **getDatosResidencia**
> DTINECDRFRES getDatosResidencia(numDocumento, DTINECDRFREQ, authorization)

Servicio para obtener los datos de residencia

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIneApi();
final String numDocumento = numDocumento_example; // String | 
final DTINECDRFREQ DTINECDRFREQ = ; // DTINECDRFREQ | 
final String authorization = authorization_example; // String | 

try {
    final response = api.getDatosResidencia(numDocumento, DTINECDRFREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IneApi->getDatosResidencia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**|  | 
 **DTINECDRFREQ** | [**DTINECDRFREQ**](DTINECDRFREQ.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**DTINECDRFRES**](DTINECDRFRES.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

