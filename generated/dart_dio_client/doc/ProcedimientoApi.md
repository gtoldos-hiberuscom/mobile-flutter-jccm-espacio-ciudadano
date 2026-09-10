# espacio_ciudadano_api.api.ProcedimientoApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getIniProc**](ProcedimientoApi.md#getiniproc) | **POST** /api/v1/procedimiento/inicproc | Iniciar procedimiento administrativo
[**getIniProc1**](ProcedimientoApi.md#getiniproc1) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente}/ficheros/iniciar | Iniciar procedimiento administrativo
[**hashAdjuntoaOperation**](ProcedimientoApi.md#hashadjuntoaoperation) | **POST** /api/v1/procedimiento/obtenerhashdeadjunto | Servicio que permite generar el hash de un documento codificado en base64 sin firma
[**miSubirAdjuntoOperation**](ProcedimientoApi.md#misubiradjuntooperation) | **POST** /api/v1/procedimiento/subiradjunto | Servicio que permite subir al buzon de tramitacion un documento codificado en base64 firmado
[**miSubirAdjuntoSinFirmaOperation**](ProcedimientoApi.md#misubiradjuntosinfirmaoperation) | **POST** /api/v1/procedimiento/subiradjuntosinfirma | Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma
[**miSubirAdjuntoSinFirmaOperation1**](ProcedimientoApi.md#misubiradjuntosinfirmaoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente}/ficheros | Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma


# **getIniProc**
> Respuesta getIniProc(idAgente, idExpediente, dTProcedimiento)

Iniciar procedimiento administrativo

Inicia un nuevo procedimiento administrativo en el sistema CESAR. Valida los datos del procedimiento y crea el registro correspondiente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final DTProcedimiento dTProcedimiento = {"idunico":"03874761C_171447919011019","tipoprocedimiento":"020","unidadorganica":"012848","consejeria":"001952","provincia":"","noexpediente":"EXP-2024-00789","registro":{"noregistro":null,"fecha":null},"identificacion":{"category":"NIF","nifcif":"99999999R"},"asunto":"","asudescripcion":"","source":"TRAM","datossolicitante":{"apellido1":"García","apellido2":"López","nombre":"Juan","codigopostal":"45000","domicilio":"Calle Mayor","entidad":"","numero":"1","poblacion":"Toledo","provincia":"Toledo"},"datospago":{},"adjuntos":{}}; // DTProcedimiento | Datos del procedimiento a iniciar. Incluye identificación del ciudadano, datos del solicitante y referencias administrativas.

try {
    final response = api.getIniProc(idAgente, idExpediente, dTProcedimiento);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->getIniProc: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **dTProcedimiento** | [**DTProcedimiento**](DTProcedimiento.md)| Datos del procedimiento a iniciar. Incluye identificación del ciudadano, datos del solicitante y referencias administrativas. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getIniProc1**
> Respuesta getIniProc1(idAgente, idExpediente, dTProcedimiento)

Iniciar procedimiento administrativo

Inicia un nuevo procedimiento administrativo en el sistema CESAR. Valida los datos del procedimiento y crea el registro correspondiente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final DTProcedimiento dTProcedimiento = {"idunico":"03874761C_171447919011019","tipoprocedimiento":"020","unidadorganica":"012848","consejeria":"001952","provincia":"","noexpediente":"EXP-2024-00789","registro":{"noregistro":null,"fecha":null},"identificacion":{"category":"NIF","nifcif":"99999999R"},"asunto":"","asudescripcion":"","source":"TRAM","datossolicitante":{"apellido1":"García","apellido2":"López","nombre":"Juan","codigopostal":"45000","domicilio":"Calle Mayor","entidad":"","numero":"1","poblacion":"Toledo","provincia":"Toledo"},"datospago":{},"adjuntos":{}}; // DTProcedimiento | Datos del procedimiento a iniciar. Incluye identificación del ciudadano, datos del solicitante y referencias administrativas.

try {
    final response = api.getIniProc1(idAgente, idExpediente, dTProcedimiento);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->getIniProc1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **dTProcedimiento** | [**DTProcedimiento**](DTProcedimiento.md)| Datos del procedimiento a iniciar. Incluye identificación del ciudadano, datos del solicitante y referencias administrativas. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **hashAdjuntoaOperation**
> RESULTADOPROCEDIMIENTO hashAdjuntoaOperation(ADJUNTO)

Servicio que permite generar el hash de un documento codificado en base64 sin firma

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final ADJUNTO ADJUNTO = ; // ADJUNTO | 

try {
    final response = api.hashAdjuntoaOperation(ADJUNTO);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->hashAdjuntoaOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ADJUNTO** | [**ADJUNTO**](ADJUNTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miSubirAdjuntoOperation**
> RESULTADOPROCEDIMIENTO miSubirAdjuntoOperation(ADJUNTO)

Servicio que permite subir al buzon de tramitacion un documento codificado en base64 firmado

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final ADJUNTO ADJUNTO = ; // ADJUNTO | 

try {
    final response = api.miSubirAdjuntoOperation(ADJUNTO);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->miSubirAdjuntoOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ADJUNTO** | [**ADJUNTO**](ADJUNTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miSubirAdjuntoSinFirmaOperation**
> RESULTADOPROCEDIMIENTO miSubirAdjuntoSinFirmaOperation(idAgente, idExpediente, ADJUNTO)

Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final ADJUNTO ADJUNTO = ; // ADJUNTO | 

try {
    final response = api.miSubirAdjuntoSinFirmaOperation(idAgente, idExpediente, ADJUNTO);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->miSubirAdjuntoSinFirmaOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **ADJUNTO** | [**ADJUNTO**](ADJUNTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miSubirAdjuntoSinFirmaOperation1**
> RESULTADOPROCEDIMIENTO miSubirAdjuntoSinFirmaOperation1(idAgente, idExpediente, ADJUNTO)

Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final ADJUNTO ADJUNTO = ; // ADJUNTO | 

try {
    final response = api.miSubirAdjuntoSinFirmaOperation1(idAgente, idExpediente, ADJUNTO);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->miSubirAdjuntoSinFirmaOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **ADJUNTO** | [**ADJUNTO**](ADJUNTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

