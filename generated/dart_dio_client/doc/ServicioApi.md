# espacio_ciudadano_api.api.ServicioApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**miDetalleOperation**](ServicioApi.md#midetalleoperation) | **POST** /api/v1/servicio/midetalle | Consultar el detalle de un tramite en cesar


# **miDetalleOperation**
> ZCSRFCPUBLISELECTBYNIFResponse miDetalleOperation(dTQUERYBody)

Consultar el detalle de un tramite en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getServicioApi();
final DTQUERY dTQUERYBody = ; // DTQUERY | 

try {
    final response = api.miDetalleOperation(dTQUERYBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ServicioApi->miDetalleOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dTQUERYBody** | [**DTQUERY**](DTQUERY.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNIFResponse**](ZCSRFCPUBLISELECTBYNIFResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

