# espacio_ciudadano_api.api.SepeApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDemandanteEmpleoFechaActual**](SepeApi.md#getdemandanteempleofechaactual) | **POST** /api/v1/sepe/demandante-empleo-fecha-actual/{numDocumento} | Consultar situacion de demandante de empleo a fecha actual


# **getDemandanteEmpleoFechaActual**
> Respuesta getDemandanteEmpleoFechaActual(numDocumento, DTSEPESVDIDEFAREQ, authorization)

Consultar situacion de demandante de empleo a fecha actual

Consulta en el servicio SEPE si el ciudadano figura como demandante de empleo en la fecha actual y devuelve el resultado de la tramitacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSepeApi();
final String numDocumento = 12345678Z; // String | Documento identificativo del ciudadano.
final DTSEPESVDIDEFAREQ DTSEPESVDIDEFAREQ = {"tipodoc":"DNI","docu":"92920000T","nombretitular":"JUAN","apellido1TITULAR":"Perez","apellido2TITULAR":"Sanchez"}; // DTSEPESVDIDEFAREQ | Datos de entrada para la consulta SEPE. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getDemandanteEmpleoFechaActual(numDocumento, DTSEPESVDIDEFAREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SepeApi->getDemandanteEmpleoFechaActual: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano. | 
 **DTSEPESVDIDEFAREQ** | [**DTSEPESVDIDEFAREQ**](DTSEPESVDIDEFAREQ.md)| Datos de entrada para la consulta SEPE. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

