# espacio_ciudadano_api.api.ProcedimientoApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**hashAdjuntoaOperation**](ProcedimientoApi.md#hashadjuntoaoperation) | **POST** /api/v1/procedimiento/obtenerhashdeadjunto | Servicio que permite generar el hash de un documento codificado en base64 sin firma
[**miConfirmarProcOperation**](ProcedimientoApi.md#miconfirmarprocoperation) | **POST** /api/v1/procedimiento/miconfirmarproc | Servicio para realizar la escritura de un procedimiento en cesar
[**miIniProcOperation**](ProcedimientoApi.md#miiniprocoperation) | **POST** /api/v1/procedimiento/inicproc | Servicio para realizar la validacion de un procedimiento en cesar
[**miObtenerRespuestaOperation**](ProcedimientoApi.md#miobtenerrespuestaoperation) | **POST** /api/v1/procedimiento/miobtenerres | Consultar la respuesta de un expediente en cesar
[**miSubirAdjuntoOperation**](ProcedimientoApi.md#misubiradjuntooperation) | **POST** /api/v1/procedimiento/subiradjunto | Servicio que permite subir al buzon de tramitacion un documento codificado en base64 firmado
[**miSubirAdjuntoSinFirmaOperation**](ProcedimientoApi.md#misubiradjuntosinfirmaoperation) | **POST** /api/v1/procedimiento/subiradjuntosinfirma | Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma


# **hashAdjuntoaOperation**
> RESULTADOPROCEDIMIENTO hashAdjuntoaOperation(aDJUNTOBody)

Servicio que permite generar el hash de un documento codificado en base64 sin firma

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final ADJUNTO aDJUNTOBody = ; // ADJUNTO | 

try {
    final response = api.hashAdjuntoaOperation(aDJUNTOBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->hashAdjuntoaOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aDJUNTOBody** | [**ADJUNTO**](ADJUNTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miConfirmarProcOperation**
> RESULTADOPROCEDIMIENTO miConfirmarProcOperation(cONFIRMARPROCEDIMIENTOBody)

Servicio para realizar la escritura de un procedimiento en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final CONFIRMARPROCEDIMIENTO cONFIRMARPROCEDIMIENTOBody = ; // CONFIRMARPROCEDIMIENTO | 

try {
    final response = api.miConfirmarProcOperation(cONFIRMARPROCEDIMIENTOBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->miConfirmarProcOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cONFIRMARPROCEDIMIENTOBody** | [**CONFIRMARPROCEDIMIENTO**](CONFIRMARPROCEDIMIENTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miIniProcOperation**
> RESULTADOPROCEDIMIENTO miIniProcOperation(dTProcedimiento)

Servicio para realizar la validacion de un procedimiento en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final DTProcedimiento dTProcedimiento = ; // DTProcedimiento | 

try {
    final response = api.miIniProcOperation(dTProcedimiento);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->miIniProcOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dTProcedimiento** | [**DTProcedimiento**](DTProcedimiento.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miObtenerRespuestaOperation**
> ZCSRMOBTRESPUESTAEXPResponse miObtenerRespuestaOperation(zCSRMOBTRESPUESTAEXPBody)

Consultar la respuesta de un expediente en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final ZCSRMOBTRESPUESTAEXP zCSRMOBTRESPUESTAEXPBody = ; // ZCSRMOBTRESPUESTAEXP | 

try {
    final response = api.miObtenerRespuestaOperation(zCSRMOBTRESPUESTAEXPBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->miObtenerRespuestaOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **zCSRMOBTRESPUESTAEXPBody** | [**ZCSRMOBTRESPUESTAEXP**](ZCSRMOBTRESPUESTAEXP.md)|  | 

### Return type

[**ZCSRMOBTRESPUESTAEXPResponse**](ZCSRMOBTRESPUESTAEXPResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miSubirAdjuntoOperation**
> RESULTADOPROCEDIMIENTO miSubirAdjuntoOperation(aDJUNTOBody)

Servicio que permite subir al buzon de tramitacion un documento codificado en base64 firmado

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final ADJUNTO aDJUNTOBody = ; // ADJUNTO | 

try {
    final response = api.miSubirAdjuntoOperation(aDJUNTOBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->miSubirAdjuntoOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aDJUNTOBody** | [**ADJUNTO**](ADJUNTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miSubirAdjuntoSinFirmaOperation**
> RESULTADOPROCEDIMIENTO miSubirAdjuntoSinFirmaOperation(aDJUNTOBody)

Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getProcedimientoApi();
final ADJUNTO aDJUNTOBody = ; // ADJUNTO | 

try {
    final response = api.miSubirAdjuntoSinFirmaOperation(aDJUNTOBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProcedimientoApi->miSubirAdjuntoSinFirmaOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aDJUNTOBody** | [**ADJUNTO**](ADJUNTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

