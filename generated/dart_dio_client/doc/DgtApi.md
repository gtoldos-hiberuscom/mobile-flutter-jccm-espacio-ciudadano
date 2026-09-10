# espacio_ciudadano_api.api.DgtApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getListaVehiculos**](DgtApi.md#getlistavehiculos) | **POST** /api/v1/dgt/lista-vehiculos/{numDocumento} | Consultar listado de vehiculos de un ciudadano
[**getListaVehiculos1**](DgtApi.md#getlistavehiculos1) | **POST** /api/v1/ciudadanos/{numDocumento}/vehiculos | Consultar listado de vehiculos de un ciudadano


# **getListaVehiculos**
> Respuesta getListaVehiculos(numDocumento, DTDGTLISTADOVEHICULOSREQ, authorization)

Consultar listado de vehiculos de un ciudadano

Consulta en el servicio DGT el listado de vehiculos asociados a un ciudadano identificado por NIF y devuelve el resultado completo de la tramitacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getDgtApi();
final String numDocumento = 12345678Z; // String | Documento identificativo del ciudadano.
final DTDGTLISTADOVEHICULOSREQ DTDGTLISTADOVEHICULOSREQ = {"tipodoc":"NIF","docu":"92920000T"}; // DTDGTLISTADOVEHICULOSREQ | Datos de entrada para la consulta DGT. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getListaVehiculos(numDocumento, DTDGTLISTADOVEHICULOSREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DgtApi->getListaVehiculos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano. | 
 **DTDGTLISTADOVEHICULOSREQ** | [**DTDGTLISTADOVEHICULOSREQ**](DTDGTLISTADOVEHICULOSREQ.md)| Datos de entrada para la consulta DGT. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getListaVehiculos1**
> Respuesta getListaVehiculos1(numDocumento, DTDGTLISTADOVEHICULOSREQ, authorization)

Consultar listado de vehiculos de un ciudadano

Consulta en el servicio DGT el listado de vehiculos asociados a un ciudadano identificado por NIF y devuelve el resultado completo de la tramitacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getDgtApi();
final String numDocumento = 12345678Z; // String | Documento identificativo del ciudadano.
final DTDGTLISTADOVEHICULOSREQ DTDGTLISTADOVEHICULOSREQ = {"tipodoc":"NIF","docu":"92920000T"}; // DTDGTLISTADOVEHICULOSREQ | Datos de entrada para la consulta DGT. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getListaVehiculos1(numDocumento, DTDGTLISTADOVEHICULOSREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DgtApi->getListaVehiculos1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano. | 
 **DTDGTLISTADOVEHICULOSREQ** | [**DTDGTLISTADOVEHICULOSREQ**](DTDGTLISTADOVEHICULOSREQ.md)| Datos de entrada para la consulta DGT. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

