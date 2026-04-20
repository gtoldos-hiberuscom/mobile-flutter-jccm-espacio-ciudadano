# espacio_ciudadano_api.api.DgtApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getListaVehiculos**](DgtApi.md#getlistavehiculos) | **POST** /api/v1/dgt/lista-vehiculos/{numDocumento} | Servicio para consultar el listado de vehiculos


# **getListaVehiculos**
> DTDGTLISTADOVEHICULOSRES getListaVehiculos(numDocumento, dTDGTLISTADOVEHICULOSREQBody, authorization)

Servicio para consultar el listado de vehiculos

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getDgtApi();
final String numDocumento = numDocumento_example; // String | 
final DTDGTLISTADOVEHICULOSREQ dTDGTLISTADOVEHICULOSREQBody = ; // DTDGTLISTADOVEHICULOSREQ | 
final String authorization = authorization_example; // String | 

try {
    final response = api.getListaVehiculos(numDocumento, dTDGTLISTADOVEHICULOSREQBody, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DgtApi->getListaVehiculos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**|  | 
 **dTDGTLISTADOVEHICULOSREQBody** | [**DTDGTLISTADOVEHICULOSREQ**](DTDGTLISTADOVEHICULOSREQ.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**DTDGTLISTADOVEHICULOSRES**](DTDGTLISTADOVEHICULOSRES.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

