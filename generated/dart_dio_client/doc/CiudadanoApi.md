# espacio_ciudadano_api.api.CiudadanoApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**descargarDocumento**](CiudadanoApi.md#descargardocumento) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/documentos/{orden} | Descargar documento de una notificación
[**descargarJustificante**](CiudadanoApi.md#descargarjustificante) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/justificante | Descargar justificante de una notificación
[**modificarCiudadano**](CiudadanoApi.md#modificarciudadano) | **PUT** /api/v1/ciudadanos/{id}/contacto | Modificar el contacto de un ciudadano en Notifica
[**obtenerCiudadano**](CiudadanoApi.md#obtenerciudadano) | **GET** /api/v1/ciudadanos/{id}/contacto | Obtener contacto de un ciudadano registrado en Notifica
[**obtenerNotificacion**](CiudadanoApi.md#obtenernotificacion) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId} | Obtener una notificación concreta de un ciudadano
[**obtenerNotificacionesCiudadano**](CiudadanoApi.md#obtenernotificacionesciudadano) | **GET** /api/v1/ciudadanos/{id}/notificaciones | Obtener notificaciones de un ciudadano
[**registrarCiudadano**](CiudadanoApi.md#registrarciudadano) | **POST** /api/v1/ciudadanos/{id}/contacto | Registrar el contacto de un ciudadano en Notifica
[**transicionNotificacion**](CiudadanoApi.md#transicionnotificacion) | **POST** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/transiciones | Realizar una transición sobre una notificación


# **descargarDocumento**
> Uint8List descargarDocumento(id, notificacionId, orden, authorization, sisOrigen)

Descargar documento de una notificación

Descarga un documento adjunto específico de una notificación electrónica identificado por su orden. Los documentos pueden ser resoluciones, anexos o cualquier contenido notificado al ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanoApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final int orden = 1; // int | Número de orden del documento dentro de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición

try {
    final response = api.descargarDocumento(id, notificacionId, orden, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanoApi->descargarDocumento: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **orden** | **int**| Número de orden del documento dentro de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **descargarJustificante**
> Uint8List descargarJustificante(id, notificacionId, authorization, sisOrigen)

Descargar justificante de una notificación

Descarga el documento PDF que acredita el puesta a disposición, acceso o rechazo de una notificación electrónica. El justificante tiene valor probatorio conforme a la normativa de notificaciones electrónicas.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanoApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición

try {
    final response = api.descargarJustificante(id, notificacionId, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanoApi->descargarJustificante: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **modificarCiudadano**
> TerceroN2Dto modificarCiudadano(id, terceroN2Dto, authorization, sisOrigen)

Modificar el contacto de un ciudadano en Notifica

Actualiza los datos de contacto (email, teléfono) de un tercero previamente registrado en Notifica. El ciudadano debe existir en el sistema. Requiere que el NIF del token coincida con el NIF a modificar.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanoApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final TerceroN2Dto terceroN2Dto = ; // TerceroN2Dto | Datos de contacto actualizados del ciudadano
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición

try {
    final response = api.modificarCiudadano(id, terceroN2Dto, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanoApi->modificarCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **terceroN2Dto** | [**TerceroN2Dto**](TerceroN2Dto.md)| Datos de contacto actualizados del ciudadano | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerCiudadano**
> TerceroN2Dto obtenerCiudadano(id, authorization, sisOrigen)

Obtener contacto de un ciudadano registrado en Notifica

Consulta los datos de contacto (email, teléfono) de un tercero previamente registrado en el sistema Notifica. Devuelve 404 si el ciudadano no está registrado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanoApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición

try {
    final response = api.obtenerCiudadano(id, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanoApi->obtenerCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerNotificacion**
> Respuesta obtenerNotificacion(id, notificacionId, authorization, sisOrigen)

Obtener una notificación concreta de un ciudadano

Recupera el detalle completo de una notificación electrónica específica, incluyendo documentos adjuntos, histórico de estados e interesados. Aplica control de acceso para verificar que el ciudadano autenticado es interesado en la notificación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanoApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición

try {
    final response = api.obtenerNotificacion(id, notificacionId, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanoApi->obtenerNotificacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerNotificacionesCiudadano**
> BuiltList<NotificacionIndexaDto> obtenerNotificacionesCiudadano(id, authorization, estado, page, size)

Obtener notificaciones de un ciudadano

Recupera el listado de notificaciones electrónicas asociadas a un ciudadano identificado por su NIF/NIE. Permite filtrar por estado y paginar los resultados. Requiere autenticación mediante token JWT y validación de la cláusula de consentimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanoApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String estado = estado_example; // String | Estado de las notificaciones a filtrar
final int page = 0; // int | Número de página para paginación (base 0)
final int size = 10; // int | Tamaño de página para paginación

try {
    final response = api.obtenerNotificacionesCiudadano(id, authorization, estado, page, size);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanoApi->obtenerNotificacionesCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **estado** | **String**| Estado de las notificaciones a filtrar | [optional] 
 **page** | **int**| Número de página para paginación (base 0) | [optional] 
 **size** | **int**| Tamaño de página para paginación | [optional] 

### Return type

[**BuiltList&lt;NotificacionIndexaDto&gt;**](NotificacionIndexaDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registrarCiudadano**
> TerceroN2Dto registrarCiudadano(id, terceroN2Dto, authorization, sisOrigen)

Registrar el contacto de un ciudadano en Notifica

Crea un nuevo registro de contacto (tercero) en el sistema Notifica para recibir notificaciones electrónicas. El NIF del ciudadano debe coincidir con el del token de autenticación. Requiere aceptación previa de la cláusula de consentimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanoApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final TerceroN2Dto terceroN2Dto = ; // TerceroN2Dto | Datos de contacto del ciudadano a registrar en Notifica
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición

try {
    final response = api.registrarCiudadano(id, terceroN2Dto, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanoApi->registrarCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **terceroN2Dto** | [**TerceroN2Dto**](TerceroN2Dto.md)| Datos de contacto del ciudadano a registrar en Notifica | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transicionNotificacion**
> Respuesta transicionNotificacion(id, notificacionId, transicionDto, authorization, sisOrigen)

Realizar una transición sobre una notificación

Ejecuta una transición de estado sobre una notificación (por ejemplo: comparecer, aceptar, rechazar). La transición modifica el estado de la notificación según las reglas de negocio del sistema Notifica. Puede requerir justificación según el tipo de transición.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanoApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final TransicionDto transicionDto = ; // TransicionDto | Datos de la transición a realizar, incluyendo la acción y opcionalmente una justificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición

try {
    final response = api.transicionNotificacion(id, notificacionId, transicionDto, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanoApi->transicionNotificacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **transicionDto** | [**TransicionDto**](TransicionDto.md)| Datos de la transición a realizar, incluyendo la acción y opcionalmente una justificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

