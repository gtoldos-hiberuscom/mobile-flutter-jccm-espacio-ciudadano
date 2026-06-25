# espacio_ciudadano_api.api.SescamApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**citasFuturas**](SescamApi.md#citasfuturas) | **GET** /api/v1/sescam/citas/{numDocumento} | Consultar citas futuras del SESCAM
[**citasPasadas**](SescamApi.md#citaspasadas) | **GET** /api/v1/sescam/citas-pasadas/{numDocumento} | Consultar historial de citas pasadas del SESCAM
[**getCipFromNif**](SescamApi.md#getcipfromnif) | **GET** /api/v1/sescam/cip/{numDocumento} | Obtener CIP a partir del NIF


# **citasFuturas**
> Respuesta citasFuturas(numDocumento, authorization)

Consultar citas futuras del SESCAM

Obtiene el listado de citas médicas futuras programadas en el Servicio de Salud de Castilla-La Mancha (SESCAM) para el ciudadano identificado por su número de documento. Las citas están ordenadas por fecha y hora ascendente.(Mas cercana a mas lejana en el futuro)Requiere que el usuario tenga marcada la cláusula de consentimiento correspondiente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSescamApi();
final String numDocumento = 12345678Z; // String | Número de documento de identidad del ciudadano (NIF/NIE)
final String authorization = Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...; // String | Token de autorización Bearer JWT

try {
    final response = api.citasFuturas(numDocumento, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SescamApi->citasFuturas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Número de documento de identidad del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token de autorización Bearer JWT | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasPasadas**
> Respuesta citasPasadas(numDocumento, pagina, authorization)

Consultar historial de citas pasadas del SESCAM

Obtiene el historial paginado de citas médicas pasadas en el Servicio de Salud de Castilla-La Mancha (SESCAM) para el ciudadano identificado por su número de documento. Las citas están ordenadas por fecha y hora descendente. (Mas cercana a mas lejana en el pasado)Permite consultar el histórico de visitas médicas realizadas con soporte de paginación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSescamApi();
final String numDocumento = 12345678Z; // String | Número de documento de identidad del ciudadano (NIF/NIE)
final int pagina = 0; // int | Número de página para la paginación de resultados (comienza en 0)
final String authorization = Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...; // String | Token de autorización Bearer JWT

try {
    final response = api.citasPasadas(numDocumento, pagina, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SescamApi->citasPasadas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Número de documento de identidad del ciudadano (NIF/NIE) | 
 **pagina** | **int**| Número de página para la paginación de resultados (comienza en 0) | [optional] [default to 0]
 **authorization** | **String**| Token de autorización Bearer JWT | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCipFromNif**
> Respuesta getCipFromNif(numDocumento, authorization)

Obtener CIP a partir del NIF

Servicio traductor que obtiene el Código de Identificación Personal (CIP) del SESCAM a partir del número de documento de identidad (NIF/NIE) del ciudadano. El CIP es el identificador único del paciente en el sistema sanitario de Castilla-La Mancha.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSescamApi();
final String numDocumento = 12345678Z; // String | Número de documento de identidad del ciudadano (NIF/NIE)
final String authorization = Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...; // String | Token de autorización Bearer JWT

try {
    final response = api.getCipFromNif(numDocumento, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SescamApi->getCipFromNif: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Número de documento de identidad del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token de autorización Bearer JWT | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

