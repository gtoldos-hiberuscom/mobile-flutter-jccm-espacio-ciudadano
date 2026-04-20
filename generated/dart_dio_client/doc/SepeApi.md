# espacio_ciudadano_api.api.SepeApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDemandanteEmpleoFechaActual**](SepeApi.md#getdemandanteempleofechaactual) | **POST** /api/v1/sepe/demandante-empleo-fecha-actual/{numDocumento} | Servicio para obtener los datos de demandante de empleo a Fecha Actual


# **getDemandanteEmpleoFechaActual**
> DTSEPESVDIDEFARES getDemandanteEmpleoFechaActual(numDocumento, dTSEPESVDIDEFAREQBody, authorization)

Servicio para obtener los datos de demandante de empleo a Fecha Actual

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSepeApi();
final String numDocumento = numDocumento_example; // String | 
final DTSEPESVDIDEFAREQ dTSEPESVDIDEFAREQBody = ; // DTSEPESVDIDEFAREQ | 
final String authorization = authorization_example; // String | 

try {
    final response = api.getDemandanteEmpleoFechaActual(numDocumento, dTSEPESVDIDEFAREQBody, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SepeApi->getDemandanteEmpleoFechaActual: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**|  | 
 **dTSEPESVDIDEFAREQBody** | [**DTSEPESVDIDEFAREQ**](DTSEPESVDIDEFAREQ.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**DTSEPESVDIDEFARES**](DTSEPESVDIDEFARES.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

