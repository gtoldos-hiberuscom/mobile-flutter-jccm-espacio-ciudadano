# espacio_ciudadano_api.api.IneApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDatosResidencia**](IneApi.md#getdatosresidencia) | **POST** /api/v1/ine/datos-residencia/{numDocumento} | Obtener datos de residencia (INE)
[**getDatosResidencia1**](IneApi.md#getdatosresidencia1) | **POST** /api/v1/ciudadanos/{numDocumento}/vivienda/datos-residencia | Obtener datos de residencia (INE)


# **getDatosResidencia**
> Respuesta getDatosResidencia(numDocumento, DTINECDRFREQ, authorization)

Obtener datos de residencia (INE)

Consulta los datos de residencia del ciudadano en el servicio INE. El documento del cuerpo se valida frente al token y al parámetro de ruta.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIneApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTINECDRFREQ DTINECDRFREQ = {"tipodoc":"NIF","docu":"99999999R"}; // DTINECDRFREQ | Datos de entrada para la consulta de residencia.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

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
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTINECDRFREQ** | [**DTINECDRFREQ**](DTINECDRFREQ.md)| Datos de entrada para la consulta de residencia. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDatosResidencia1**
> Respuesta getDatosResidencia1(numDocumento, DTINECDRFREQ, authorization)

Obtener datos de residencia (INE)

Consulta los datos de residencia del ciudadano en el servicio INE. El documento del cuerpo se valida frente al token y al parámetro de ruta.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIneApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTINECDRFREQ DTINECDRFREQ = {"tipodoc":"NIF","docu":"99999999R"}; // DTINECDRFREQ | Datos de entrada para la consulta de residencia.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getDatosResidencia1(numDocumento, DTINECDRFREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IneApi->getDatosResidencia1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTINECDRFREQ** | [**DTINECDRFREQ**](DTINECDRFREQ.md)| Datos de entrada para la consulta de residencia. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

