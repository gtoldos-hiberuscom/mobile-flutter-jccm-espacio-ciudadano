# espacio_ciudadano_api.api.CiudadanosApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**descargarDocumento**](CiudadanosApi.md#descargardocumento) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/documentos/{orden} | Descargar documento de una notificación
[**descargarJustificante**](CiudadanosApi.md#descargarjustificante) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/justificante | Descargar justificante de una notificación
[**modificarCiudadano**](CiudadanosApi.md#modificarciudadano) | **PUT** /api/v1/ciudadanos/{id}/contacto | Modificar el contacto de un ciudadano en Notifica
[**obtenerCiudadano**](CiudadanosApi.md#obtenerciudadano) | **GET** /api/v1/ciudadanos/{id}/contacto | Obtener contacto de un ciudadano registrado en Notifica
[**obtenerNotificacion**](CiudadanosApi.md#obtenernotificacion) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId} | Obtener una notificación concreta de un ciudadano
[**obtenerNotificacionesCiudadano**](CiudadanosApi.md#obtenernotificacionesciudadano) | **GET** /api/v1/ciudadanos/{id}/notificaciones | Obtener notificaciones de un ciudadano
[**registrarCiudadano**](CiudadanosApi.md#registrarciudadano) | **POST** /api/v1/ciudadanos/{id}/contacto | Registrar el contacto de un ciudadano en Notifica
[**transicionNotificacion**](CiudadanosApi.md#transicionnotificacion) | **POST** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/transiciones | Realizar una transición sobre una notificación


# **descargarDocumento**
> Uint8List descargarDocumento(id, notificacionId, orden, authorization, sisOrigen)

Descargar documento de una notificación

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | 
final int notificacionId = 789; // int | 
final int orden = 56; // int | 
final String authorization = authorization_example; // String | 
final String sisOrigen = sisOrigen_example; // String | 

try {
    final response = api.descargarDocumento(id, notificacionId, orden, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->descargarDocumento: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **notificacionId** | **int**|  | 
 **orden** | **int**|  | 
 **authorization** | **String**|  | [optional] 
 **sisOrigen** | **String**|  | [optional] 

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

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | 
final int notificacionId = 789; // int | 
final String authorization = authorization_example; // String | 
final String sisOrigen = sisOrigen_example; // String | 

try {
    final response = api.descargarJustificante(id, notificacionId, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->descargarJustificante: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **notificacionId** | **int**|  | 
 **authorization** | **String**|  | [optional] 
 **sisOrigen** | **String**|  | [optional] 

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

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | 
final TerceroN2Dto terceroN2Dto = ; // TerceroN2Dto | 
final String authorization = authorization_example; // String | 
final String sisOrigen = sisOrigen_example; // String | 

try {
    final response = api.modificarCiudadano(id, terceroN2Dto, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->modificarCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **terceroN2Dto** | [**TerceroN2Dto**](TerceroN2Dto.md)|  | 
 **authorization** | **String**|  | [optional] 
 **sisOrigen** | **String**|  | [optional] 

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

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | 
final String authorization = authorization_example; // String | 
final String sisOrigen = sisOrigen_example; // String | 

try {
    final response = api.obtenerCiudadano(id, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **authorization** | **String**|  | [optional] 
 **sisOrigen** | **String**|  | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerNotificacion**
> NotificacionDto obtenerNotificacion(id, notificacionId, authorization, sisOrigen)

Obtener una notificación concreta de un ciudadano

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | 
final int notificacionId = 789; // int | 
final String authorization = authorization_example; // String | 
final String sisOrigen = sisOrigen_example; // String | 

try {
    final response = api.obtenerNotificacion(id, notificacionId, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerNotificacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **notificacionId** | **int**|  | 
 **authorization** | **String**|  | [optional] 
 **sisOrigen** | **String**|  | [optional] 

### Return type

[**NotificacionDto**](NotificacionDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerNotificacionesCiudadano**
> BuiltList<NotificacionIndexaDto> obtenerNotificacionesCiudadano(id, authorization, estado, page, size)

Obtener notificaciones de un ciudadano

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | 
final String authorization = authorization_example; // String | 
final String estado = estado_example; // String | Estado de la notificación
final int page = 56; // int | 
final int size = 56; // int | 

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
 **id** | **String**|  | 
 **authorization** | **String**|  | [optional] 
 **estado** | **String**| Estado de la notificación | [optional] 
 **page** | **int**|  | [optional] 
 **size** | **int**|  | [optional] 

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

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | 
final TerceroN2Dto terceroN2Dto = ; // TerceroN2Dto | 
final String authorization = authorization_example; // String | 
final String sisOrigen = sisOrigen_example; // String | 

try {
    final response = api.registrarCiudadano(id, terceroN2Dto, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->registrarCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **terceroN2Dto** | [**TerceroN2Dto**](TerceroN2Dto.md)|  | 
 **authorization** | **String**|  | [optional] 
 **sisOrigen** | **String**|  | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transicionNotificacion**
> NotificacionDto transicionNotificacion(id, notificacionId, transicionDto, authorization, sisOrigen)

Realizar una transición sobre una notificación

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = id_example; // String | 
final int notificacionId = 789; // int | 
final TransicionDto transicionDto = ; // TransicionDto | 
final String authorization = authorization_example; // String | 
final String sisOrigen = sisOrigen_example; // String | 

try {
    final response = api.transicionNotificacion(id, notificacionId, transicionDto, authorization, sisOrigen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->transicionNotificacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **notificacionId** | **int**|  | 
 **transicionDto** | [**TransicionDto**](TransicionDto.md)|  | 
 **authorization** | **String**|  | [optional] 
 **sisOrigen** | **String**|  | [optional] 

### Return type

[**NotificacionDto**](NotificacionDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

