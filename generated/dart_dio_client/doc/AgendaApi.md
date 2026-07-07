# espacio_ciudadano_api.api.AgendaApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerEventosAgenda**](AgendaApi.md#obtenereventosagenda) | **GET** /api/v1/agenda/{idAgente}/eventos/{periodo} | Obtener eventos de la Agenda
[**refrescarAgendaEvents**](AgendaApi.md#refrescaragendaevents) | **GET** /api/v1/agenda/{idAgente}/eventos/refrescar | Refrescar eventos de la Agenda por idAgente


# **obtenerEventosAgenda**
> Respuesta obtenerEventosAgenda(idAgente, periodo, authorization)

Obtener eventos de la Agenda

Obtiene los eventos de agenda de un agente para un periodo determinado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getAgendaApi();
final String idAgente = PER9998003; // String | Identificador del agente/ciudadano sobre el que se consultan los eventos de agenda. Debe coincidir con el identificado en el token de seguridad.
final String periodo = TODOS, SEMANA, MES, ANIO; // String | Periodo de consulta de eventos de agenda enviado al servicio externo.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerEventosAgenda(idAgente, periodo, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgendaApi->obtenerEventosAgenda: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador del agente/ciudadano sobre el que se consultan los eventos de agenda. Debe coincidir con el identificado en el token de seguridad. | 
 **periodo** | **String**| Periodo de consulta de eventos de agenda enviado al servicio externo. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refrescarAgendaEvents**
> Respuesta refrescarAgendaEvents(idAgente, authorization)

Refrescar eventos de la Agenda por idAgente

Refresca los eventos de agenda del agente y devuelve el resumen del proceso.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getAgendaApi();
final String idAgente = PER9998003; // String | Identificador del agente/ciudadano para el que se ejecuta el refresco de eventos de agenda.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.refrescarAgendaEvents(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AgendaApi->refrescarAgendaEvents: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador del agente/ciudadano para el que se ejecuta el refresco de eventos de agenda. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

