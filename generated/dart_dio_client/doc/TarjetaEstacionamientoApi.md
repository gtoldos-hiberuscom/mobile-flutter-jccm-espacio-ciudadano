# espacio_ciudadano_api.api.TarjetaEstacionamientoApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerDatosTarjetaEstacionamientoIntermediacion**](TarjetaEstacionamientoApi.md#obtenerdatostarjetaestacionamientointermediacion) | **POST** /api/v1/intermediacion/tarjeta-estacionamiento/datos | Obtener datos de la tarjeta de estacionamiento


# **obtenerDatosTarjetaEstacionamientoIntermediacion**
> RespuestaFachadaInterm obtenerDatosTarjetaEstacionamientoIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de la tarjeta de estacionamiento

Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla La Mancha.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getTarjetaEstacionamientoApi();
final BaseRequestIntermediacion baseRequestIntermediacion = ; // BaseRequestIntermediacion | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosTarjetaEstacionamientoIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TarjetaEstacionamientoApi->obtenerDatosTarjetaEstacionamientoIntermediacion: $e\n');
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

