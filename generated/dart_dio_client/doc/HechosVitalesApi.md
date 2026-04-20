# espacio_ciudadano_api.api.HechosVitalesApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**actualizarListaHechos**](HechosVitalesApi.md#actualizarlistahechos) | **PATCH** /api/v1/hechos-vitales/hechos | Actualizar lista de hechos
[**eliminarPreferencias**](HechosVitalesApi.md#eliminarpreferencias) | **DELETE** /api/v1/hechos-vitales/preferencias/{idAgente} | Eliminar preferencias por idAgente
[**enviarClausulas**](HechosVitalesApi.md#enviarclausulas) | **POST** /api/v1/hechos-vitales/clausulas | Procesar las clausulas seleccionadas por un idAgente
[**enviarClausulas1**](HechosVitalesApi.md#enviarclausulas1) | **PATCH** /api/v1/hechos-vitales/clausulas | Procesar las clausulas seleccionadas por un idAgente
[**enviarClausulas2**](HechosVitalesApi.md#enviarclausulas2) | **GET** /api/v1/hechos-vitales/servicios/segmentacion/{idAgente} | Obtencion de servicios en los ultimos dias disponibles para tramitacion
[**getServicios**](HechosVitalesApi.md#getservicios) | **GET** /api/v1/hechos-vitales/servicios/{idAgente} | Obtener servicios
[**obtenerClausulas**](HechosVitalesApi.md#obtenerclausulas) | **GET** /api/v1/hechos-vitales/clausulas/{idAgente} | Obtener Clausulas asociadas a un Agente
[**obtenerListaHechosByIdAgente**](HechosVitalesApi.md#obtenerlistahechosbyidagente) | **GET** /api/v1/hechos-vitales/hechos/{idAgente} | Obtener lista de hechos vitales por idAgente


# **actualizarListaHechos**
> Respuesta actualizarListaHechos(listaHechosAgente, authorization)

Actualizar lista de hechos

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final ListaHechosAgente listaHechosAgente = ; // ListaHechosAgente | 
final String authorization = authorization_example; // String | 

try {
    final response = api.actualizarListaHechos(listaHechosAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->actualizarListaHechos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listaHechosAgente** | [**ListaHechosAgente**](ListaHechosAgente.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **eliminarPreferencias**
> Respuesta eliminarPreferencias(idAgente, authorization)

Eliminar preferencias por idAgente

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = idAgente_example; // String | 
final String authorization = authorization_example; // String | 

try {
    final response = api.eliminarPreferencias(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->eliminarPreferencias: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **enviarClausulas**
> Clausulas enviarClausulas(clausulasAgente, authorization)

Procesar las clausulas seleccionadas por un idAgente

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final ClausulasAgente clausulasAgente = ; // ClausulasAgente | 
final String authorization = authorization_example; // String | 

try {
    final response = api.enviarClausulas(clausulasAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->enviarClausulas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clausulasAgente** | [**ClausulasAgente**](ClausulasAgente.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**Clausulas**](Clausulas.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **enviarClausulas1**
> Clausulas enviarClausulas1(clausulasAgente, authorization)

Procesar las clausulas seleccionadas por un idAgente

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final ClausulasAgente clausulasAgente = ; // ClausulasAgente | 
final String authorization = authorization_example; // String | 

try {
    final response = api.enviarClausulas1(clausulasAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->enviarClausulas1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clausulasAgente** | [**ClausulasAgente**](ClausulasAgente.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**Clausulas**](Clausulas.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **enviarClausulas2**
> Clausulas enviarClausulas2(idAgente, operacion, size, page, ultimosDias, hechosvitales, authorization)

Obtencion de servicios en los ultimos dias disponibles para tramitacion

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = idAgente_example; // String | 
final String operacion = operacion_example; // String | 
final String size = size_example; // String | 
final String page = page_example; // String | 
final String ultimosDias = ultimosDias_example; // String | 
final BuiltList<int> hechosvitales = ; // BuiltList<int> | 
final String authorization = authorization_example; // String | 

try {
    final response = api.enviarClausulas2(idAgente, operacion, size, page, ultimosDias, hechosvitales, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->enviarClausulas2: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**|  | 
 **operacion** | **String**|  | [optional] 
 **size** | **String**|  | [optional] 
 **page** | **String**|  | [optional] 
 **ultimosDias** | **String**|  | [optional] 
 **hechosvitales** | [**BuiltList&lt;int&gt;**](int.md)|  | [optional] 
 **authorization** | **String**|  | [optional] 

### Return type

[**Clausulas**](Clausulas.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getServicios**
> ListaTramitesPorHechos getServicios(idAgente, authorization)

Obtener servicios

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = idAgente_example; // String | 
final String authorization = authorization_example; // String | 

try {
    final response = api.getServicios(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->getServicios: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**ListaTramitesPorHechos**](ListaTramitesPorHechos.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerClausulas**
> Respuesta obtenerClausulas(idAgente, authorization)

Obtener Clausulas asociadas a un Agente

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = idAgente_example; // String | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerClausulas(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->obtenerClausulas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerListaHechosByIdAgente**
> ListaHechos obtenerListaHechosByIdAgente(idAgente, authorization)

Obtener lista de hechos vitales por idAgente

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = idAgente_example; // String | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerListaHechosByIdAgente(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->obtenerListaHechosByIdAgente: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**ListaHechos**](ListaHechos.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

