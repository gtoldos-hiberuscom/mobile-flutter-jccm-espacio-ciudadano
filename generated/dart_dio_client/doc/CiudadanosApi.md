# espacio_ciudadano_api.api.CiudadanosApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**actualizarContactoRegistroPoblacional**](CiudadanosApi.md#actualizarcontactoregistropoblacional) | **PATCH** /api/v1/ciudadanos/{id}/contacto-registro-poblacional | Actualizar datos de contacto del ciudadano en Registro Poblacional
[**citasHospitalariasPasadas**](CiudadanosApi.md#citashospitalariaspasadas) | **GET** /api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-pasadas | Consultar citas hospitalarias pasadas del ciudadano
[**citasHospitalariasPasadas1**](CiudadanosApi.md#citashospitalariaspasadas1) | **GET** /api/v1/ciudadanos/{idAgente}/citas-hospitalarias-pasadas | Consultar citas hospitalarias pasadas del ciudadano
[**citasHospitalariasPendientes**](CiudadanosApi.md#citashospitalariaspendientes) | **GET** /api/v1/ciudadanos/{idAgente}/citas-hospitalarias-pendientes | Consultar citas hospitalarias pendientes del ciudadano
[**citasHospitalariasPendientes1**](CiudadanosApi.md#citashospitalariaspendientes1) | **GET** /api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-pendientes | Consultar citas hospitalarias pendientes del ciudadano
[**descargarDocumento**](CiudadanosApi.md#descargardocumento) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/documentos/{orden} | Descargar documento de una notificación
[**descargarJustificante**](CiudadanosApi.md#descargarjustificante) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/justificante | Descargar justificante de una notificación
[**modificarCiudadano**](CiudadanosApi.md#modificarciudadano) | **PUT** /api/v1/ciudadanos/{id}/contacto | Modificar el contacto de un ciudadano en Notifica
[**obtenerCiudadano**](CiudadanosApi.md#obtenerciudadano) | **GET** /api/v1/ciudadanos/{id}/contacto | Obtener contacto de un ciudadano registrado en Notifica
[**obtenerContactoRegistroPoblacional**](CiudadanosApi.md#obtenercontactoregistropoblacional) | **GET** /api/v1/ciudadanos/{id}/contacto-registro-poblacional | Consultar datos de contacto del ciudadano en Registro Poblacional
[**obtenerNotificacion**](CiudadanosApi.md#obtenernotificacion) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId} | Obtener una notificación concreta de un ciudadano
[**obtenerNotificacionesCiudadano**](CiudadanosApi.md#obtenernotificacionesciudadano) | **GET** /api/v1/ciudadanos/{id}/notificaciones | Obtener notificaciones de un ciudadano
[**registrarCiudadano**](CiudadanosApi.md#registrarciudadano) | **POST** /api/v1/ciudadanos/{id}/contacto | Registrar el contacto de un ciudadano en Notifica
[**transicionNotificacion**](CiudadanosApi.md#transicionnotificacion) | **POST** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/comparecer | Realizar una transición sobre una notificación


# **actualizarContactoRegistroPoblacional**
> Respuesta actualizarContactoRegistroPoblacional(id, contactoRegistroPoblacionalRequestDto, authorization)

Actualizar datos de contacto del ciudadano en Registro Poblacional

Actualiza los datos de contacto (correo y/o teléfono) del ciudadano en el Registro Poblacional. El body debe contener los campos a actualizar. Requiere autenticación mediante token JWT y que el NIF del token coincida con el ciudadano a modificar. Si el servicio externo devuelve un error, se propagará el mismo código y mensaje en la respuesta.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | Documento de identificación del ciudadano
final ContactoRegistroPoblacionalRequestDto contactoRegistroPoblacionalRequestDto = {"correo":"correo_nuevo@gmail.com","telefono":"655342212"}; // ContactoRegistroPoblacionalRequestDto | Datos de contacto a actualizar
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login

try {
    final response = api.actualizarContactoRegistroPoblacional(id, contactoRegistroPoblacionalRequestDto, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->actualizarContactoRegistroPoblacional: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano | 
 **contactoRegistroPoblacionalRequestDto** | [**ContactoRegistroPoblacionalRequestDto**](ContactoRegistroPoblacionalRequestDto.md)| Datos de contacto a actualizar | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasHospitalariasPasadas**
> Respuesta citasHospitalariasPasadas(idAgente, authorization)

Consultar citas hospitalarias pasadas del ciudadano

Obtiene el listado de citas hospitalarias pasadas de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = 12345678A; // String | Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE).
final String authorization = authorization_example; // String | Token de autorización Bearer para autenticar la petición.

try {
    final response = api.citasHospitalariasPasadas(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasHospitalariasPasadas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE). | 
 **authorization** | **String**| Token de autorización Bearer para autenticar la petición. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasHospitalariasPasadas1**
> Respuesta citasHospitalariasPasadas1(idAgente, authorization)

Consultar citas hospitalarias pasadas del ciudadano

Obtiene el listado de citas hospitalarias pasadas de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = 12345678A; // String | Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE).
final String authorization = authorization_example; // String | Token de autorización Bearer para autenticar la petición.

try {
    final response = api.citasHospitalariasPasadas1(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasHospitalariasPasadas1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE). | 
 **authorization** | **String**| Token de autorización Bearer para autenticar la petición. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasHospitalariasPendientes**
> Respuesta citasHospitalariasPendientes(idAgente, authorization)

Consultar citas hospitalarias pendientes del ciudadano

Obtiene el listado de citas hospitalarias pendientes de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = 12345678A; // String | Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE).
final String authorization = authorization_example; // String | Token de autorización Bearer para autenticar la petición.

try {
    final response = api.citasHospitalariasPendientes(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasHospitalariasPendientes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE). | 
 **authorization** | **String**| Token de autorización Bearer para autenticar la petición. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasHospitalariasPendientes1**
> Respuesta citasHospitalariasPendientes1(idAgente, authorization)

Consultar citas hospitalarias pendientes del ciudadano

Obtiene el listado de citas hospitalarias pendientes de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = 12345678A; // String | Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE).
final String authorization = authorization_example; // String | Token de autorización Bearer para autenticar la petición.

try {
    final response = api.citasHospitalariasPendientes1(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasHospitalariasPendientes1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE). | 
 **authorization** | **String**| Token de autorización Bearer para autenticar la petición. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **descargarDocumento**
> Uint8List descargarDocumento(id, notificacionId, orden, authorization, sisOrigen, origen)

Descargar documento de una notificación

Descarga un documento adjunto específico de una notificación electrónica identificado por su orden. Los documentos pueden ser resoluciones, anexos o cualquier contenido notificado al ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final int orden = 1; // int | Número de orden del documento dentro de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.descargarDocumento(id, notificacionId, orden, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->descargarDocumento: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **orden** | **int**| Número de orden del documento dentro de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **descargarJustificante**
> Uint8List descargarJustificante(id, notificacionId, authorization, sisOrigen, origen)

Descargar justificante de una notificación

Descarga el documento PDF que acredita el puesta a disposición, acceso o rechazo de una notificación electrónica. El justificante tiene valor probatorio conforme a la normativa de notificaciones electrónicas.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.descargarJustificante(id, notificacionId, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->descargarJustificante: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **modificarCiudadano**
> TerceroN2Dto modificarCiudadano(id, terceroN2Dto, authorization, sisOrigen, origen)

Modificar el contacto de un ciudadano en Notifica

Actualiza los datos de contacto (email, teléfono) de un tercero previamente registrado en Notifica. El ciudadano debe existir en el sistema. Requiere que el NIF del token coincida con el NIF a modificar.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final TerceroN2Dto terceroN2Dto = ; // TerceroN2Dto | Datos de contacto actualizados del ciudadano
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.modificarCiudadano(id, terceroN2Dto, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->modificarCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **terceroN2Dto** | [**TerceroN2Dto**](TerceroN2Dto.md)| Datos de contacto actualizados del ciudadano | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerCiudadano**
> TerceroN2Dto obtenerCiudadano(id, authorization, sisOrigen, origen)

Obtener contacto de un ciudadano registrado en Notifica

Consulta los datos de contacto (email, teléfono) de un tercero previamente registrado en el sistema Notifica. Devuelve 404 si el ciudadano no está registrado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.obtenerCiudadano(id, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerContactoRegistroPoblacional**
> Respuesta obtenerContactoRegistroPoblacional(id, authorization)

Consultar datos de contacto del ciudadano en Registro Poblacional

Recupera los datos de contacto (correo electrónico y teléfono) y datos parciales de dirección del ciudadano en el Registro Poblacional identificado por su NIF/NIE. Requiere autenticación mediante token JWT y validación del NIF del token. En caso de error del servicio externo, la respuesta conservará el código y el mensaje proporcionado por dicho servicio.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | Documento de identificación del ciudadano
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login

try {
    final response = api.obtenerContactoRegistroPoblacional(id, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerContactoRegistroPoblacional: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerNotificacion**
> Respuesta obtenerNotificacion(id, notificacionId, authorization, sisOrigen, origen)

Obtener una notificación concreta de un ciudadano

Recupera el detalle completo de una notificación electrónica específica, incluyendo documentos adjuntos, histórico de estados e interesados. Aplica control de acceso para verificar que el ciudadano autenticado es interesado en la notificación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.obtenerNotificacion(id, notificacionId, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerNotificacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

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

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String estado = estado_example; // String | Estado de las notificaciones a filtrar
final int page = 0; // int | Número de página para paginación (base 0)
final int size = 10; // int | Tamaño de página para paginación

try {
    final response = api.obtenerNotificacionesCiudadano(id, authorization, estado, page, size);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerNotificacionesCiudadano: $e\n');
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
> TerceroN2Dto registrarCiudadano(id, terceroN2Dto, authorization, sisOrigen, origen)

Registrar el contacto de un ciudadano en Notifica

Crea un nuevo registro de contacto (tercero) en el sistema Notifica para recibir notificaciones electrónicas. El NIF del ciudadano debe coincidir con el del token de autenticación. Requiere aceptación previa de la cláusula de consentimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final TerceroN2Dto terceroN2Dto = ; // TerceroN2Dto | Datos de contacto del ciudadano a registrar en Notifica
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.registrarCiudadano(id, terceroN2Dto, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->registrarCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **terceroN2Dto** | [**TerceroN2Dto**](TerceroN2Dto.md)| Datos de contacto del ciudadano a registrar en Notifica | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transicionNotificacion**
> Respuesta transicionNotificacion(id, notificacionId, authorization, sisOrigen, origen)

Realizar una transición sobre una notificación

Ejecuta una transición de estado sobre una notificación (por ejemplo: comparecer, aceptar, rechazar). La transición modifica el estado de la notificación según las reglas de negocio del sistema Notifica. Puede requerir justificación según el tipo de transición.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.transicionNotificacion(id, notificacionId, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->transicionNotificacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

