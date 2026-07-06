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
> String obtenerEventosAgenda(idAgente, periodo, authorization)

Obtener eventos de la Agenda

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getAgendaApi();
final String idAgente = idAgente_example; // String | 
final String periodo = periodo_example; // String | 
final String authorization = authorization_example; // String | 

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
 **idAgente** | **String**|  | 
 **periodo** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refrescarAgendaEvents**
> String refrescarAgendaEvents(idAgente, authorization)

Refrescar eventos de la Agenda por idAgente

Refresca los eventos de la agenda usando idAgente

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getAgendaApi();
final String idAgente = idAgente_example; // String | 
final String authorization = authorization_example; // String | 

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
 **idAgente** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

