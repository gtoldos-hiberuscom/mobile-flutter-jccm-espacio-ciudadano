# espacio_ciudadano_api.api.HechosVitalesApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**actualizarClausulas**](HechosVitalesApi.md#actualizarclausulas) | **PATCH** /api/v1/hechos-vitales/clausulas | Actualizar las cláusulas de consentimiento de un agente
[**actualizarListaHechos**](HechosVitalesApi.md#actualizarlistahechos) | **PATCH** /api/v1/hechos-vitales/hechos | Actualizar los hechos vitales seleccionados por un agente
[**eliminarPreferencias**](HechosVitalesApi.md#eliminarpreferencias) | **DELETE** /api/v1/hechos-vitales/preferencias/{idAgente} | Eliminar preferencias y configuración de hechos vitales de un agente
[**enviarClausulas**](HechosVitalesApi.md#enviarclausulas) | **POST** /api/v1/hechos-vitales/clausulas | Dar de alta las cláusulas de consentimiento de un agente
[**getServicios**](HechosVitalesApi.md#getservicios) | **GET** /api/v1/hechos-vitales/servicios/{idAgente} | Obtener servicios recomendados agrupados por hecho vital
[**getServiciosSegmentados**](HechosVitalesApi.md#getserviciossegmentados) | **GET** /api/v1/hechos-vitales/servicios/segmentacion/{idAgente} | Obtener servicios segmentados por hechos vitales
[**obtenerClausulasPorAgente**](HechosVitalesApi.md#obtenerclausulasporagente) | **GET** /api/v1/hechos-vitales/clausulas/{idAgente} | Obtener cláusulas de consentimiento asociadas a un agente
[**obtenerListaHechosByIdAgente**](HechosVitalesApi.md#obtenerlistahechosbyidagente) | **GET** /api/v1/hechos-vitales/hechos/{idAgente} | Obtener lista de hechos vitales por agente


# **actualizarClausulas**
> Respuesta actualizarClausulas(clausulasAgente, authorization)

Actualizar las cláusulas de consentimiento de un agente

Actualiza el estado de aceptación de las cláusulas de consentimiento ya registradas para el ciudadano. A diferencia del alta (POST), este endpoint modifica cláusulas existentes. Recibe el identificador del agente y la lista completa de cláusulas con su versión y nuevo estado de selección. Devuelve true si la actualización se realizó correctamente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final ClausulasAgente clausulasAgente = {"idAgente":"PER9999927","clausulas":[{"idClausula":"001","version":1,"seleccionado":true},{"idClausula":"002","version":1,"seleccionado":true},{"idClausula":"003","version":1,"seleccionado":true},{"idClausula":"004","version":1,"seleccionado":false}]}; // ClausulasAgente | Cuerpo de la petición con el identificador del agente y la lista de cláusulas a actualizar. Cada cláusula incluye su identificador, versión y nuevo estado de selección (true=aceptada, false=rechazada).
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.actualizarClausulas(clausulasAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->actualizarClausulas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clausulasAgente** | [**ClausulasAgente**](ClausulasAgente.md)| Cuerpo de la petición con el identificador del agente y la lista de cláusulas a actualizar. Cada cláusula incluye su identificador, versión y nuevo estado de selección (true=aceptada, false=rechazada). | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **actualizarListaHechos**
> Respuesta actualizarListaHechos(listaHechosAgente, authorization)

Actualizar los hechos vitales seleccionados por un agente

Actualiza la lista de hechos vitales seleccionados por el ciudadano. Recibe el identificador del agente y la lista completa de hechos vitales con su estado de selección. Solo los hechos con seleccionado=true quedarán activos para el agente. Devuelve true si la actualización se realizó correctamente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final ListaHechosAgente listaHechosAgente = {"idAgente":"PER9999927","listaHechos":[{"idHecho":1,"seleccionado":true},{"idHecho":3,"seleccionado":true},{"idHecho":17,"seleccionado":true},{"idHecho":19,"seleccionado":true}]}; // ListaHechosAgente | Cuerpo de la petición con el identificador del agente y la lista de hechos vitales a actualizar. Cada hecho incluye su identificador y el estado de selección (true=activo, false=inactivo).
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

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
 **listaHechosAgente** | [**ListaHechosAgente**](ListaHechosAgente.md)| Cuerpo de la petición con el identificador del agente y la lista de hechos vitales a actualizar. Cada hecho incluye su identificador y el estado de selección (true=activo, false=inactivo). | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

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

Eliminar preferencias y configuración de hechos vitales de un agente

Elimina las preferencias del ciudadano asociadas al módulo de hechos vitales (hechos seleccionados y configuración relacionada). Tras la operación, el agente queda sin preferencias guardadas y puede volver a configurarlas desde cero. Devuelve true si la eliminación se realiza correctamente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = PER9999927; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

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
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **enviarClausulas**
> Respuesta enviarClausulas(clausulasAgente, authorization)

Dar de alta las cláusulas de consentimiento de un agente

Registra por primera vez (alta inicial) las cláusulas de consentimiento seleccionadas por el ciudadano. Recibe el identificador del agente y la lista de cláusulas con su versión y estado de aceptación. Devuelve true si el registro se ha realizado correctamente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final ClausulasAgente clausulasAgente = {"idAgente":"PER9999927","clausulas":[{"idClausula":"001","version":1,"seleccionado":true},{"idClausula":"002","version":1,"seleccionado":false},{"idClausula":"003","version":1,"seleccionado":true},{"idClausula":"004","version":1,"seleccionado":false}]}; // ClausulasAgente | Cuerpo de la petición con el identificador del agente y la lista de cláusulas a registrar. Cada cláusula incluye su identificador, versión y estado de selección (true=aceptada, false=rechazada).
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

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
 **clausulasAgente** | [**ClausulasAgente**](ClausulasAgente.md)| Cuerpo de la petición con el identificador del agente y la lista de cláusulas a registrar. Cada cláusula incluye su identificador, versión y estado de selección (true=aceptada, false=rechazada). | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getServicios**
> Respuesta getServicios(idAgente, authorization)

Obtener servicios recomendados agrupados por hecho vital

Recupera los trámites y servicios disponibles para el ciudadano agrupados por cada hecho vital que tiene seleccionado. Por cada hecho vital activo del agente, devuelve la lista de trámites relacionados con información del trámite, unidad orgánica responsable y periodo de presentación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = PER9999927; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

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
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getServiciosSegmentados**
> Respuesta getServiciosSegmentados(idAgente, operacion, size, page, ultimosDias, hechosvitales, authorization)

Obtener servicios segmentados por hechos vitales

Recupera los trámites y servicios disponibles segmentados según los hechos vitales seleccionados por el ciudadano. Permite filtrar por operación, paginación (size y page), rango de días recientes (ultimosDias) y una lista de identificadores de hechos vitales. Devuelve únicamente los trámites cuyo periodo de presentación esté activo o abierto permanentemente y que correspondan a los hechos vitales indicados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = PER9999927; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String operacion = todo; // String | Tipo de operación a realizar. Ejemplo: 'todo' para recuperar todos los trámites.
final String size = 10; // String | Número máximo de resultados por página. Ejemplo: 10
final String page = 0; // String | Número de página a recuperar (base 0). Ejemplo: 0
final String ultimosDias = 30; // String | Filtro de trámites publicados en los últimos N días. Ejemplo: 30
final BuiltList<int> hechosvitales = 1; // BuiltList<int> | Lista de identificadores de hechos vitales por los que filtrar los trámites. Ejemplo: [1]
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getServiciosSegmentados(idAgente, operacion, size, page, ultimosDias, hechosvitales, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->getServiciosSegmentados: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **operacion** | **String**| Tipo de operación a realizar. Ejemplo: 'todo' para recuperar todos los trámites. | [optional] 
 **size** | **String**| Número máximo de resultados por página. Ejemplo: 10 | [optional] 
 **page** | **String**| Número de página a recuperar (base 0). Ejemplo: 0 | [optional] 
 **ultimosDias** | **String**| Filtro de trámites publicados en los últimos N días. Ejemplo: 30 | [optional] 
 **hechosvitales** | [**BuiltList&lt;int&gt;**](int.md)| Lista de identificadores de hechos vitales por los que filtrar los trámites. Ejemplo: [1] | [optional] 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerClausulasPorAgente**
> Respuesta obtenerClausulasPorAgente(idAgente, authorization)

Obtener cláusulas de consentimiento asociadas a un agente

Recupera todas las cláusulas de consentimiento y preferencias asociadas a un agente (ciudadano). Devuelve una estructura con el identificador del agente, estado de cláusulas pendientes y un listado detallado de todas las cláusulas disponibles incluyendo su descripción, textos (breve y ampliado en HTML), versión y estado de selección actual.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = PER9998001; // String | Identificador único del agente (ciudadano) para el cual se recuperarán las cláusulas de consentimiento.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerClausulasPorAgente(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HechosVitalesApi->obtenerClausulasPorAgente: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano) para el cual se recuperarán las cláusulas de consentimiento. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerListaHechosByIdAgente**
> Respuesta obtenerListaHechosByIdAgente(idAgente, authorization)

Obtener lista de hechos vitales por agente

Recupera la lista completa de hechos vitales (situaciones de vida) disponibles en el sistema para un agente específico (ciudadano). Los hechos vitales representan diferentes situaciones o circunstancias de la vida del ciudadano (tener hijos, buscar trabajo, jubilación, etc.). La respuesta incluye todos los hechos disponibles con su identificador, nombre descriptivo y estado de selección actual.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getHechosVitalesApi();
final String idAgente = PER9998003; // String | Identificador único del agente (ciudadano) para el cual se recuperará la lista de hechos vitales.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

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
 **idAgente** | **String**| Identificador único del agente (ciudadano) para el cual se recuperará la lista de hechos vitales. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

