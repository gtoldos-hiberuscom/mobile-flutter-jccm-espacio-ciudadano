# espacio_ciudadano_api.api.PublicacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**miDetalleOperation**](PublicacionApi.md#midetalleoperation) | **POST** /api/v1/servicio/midetalle | Consultar el detalle de un tramite en cesar
[**myPubliNumRegOperation**](PublicacionApi.md#mypublinumregoperation) | **POST** /api/v1/publicacion/selectbynumreg | Consultar un expediente de publicación por número de registro
[**myPubliNumRegOperation1**](PublicacionApi.md#mypublinumregoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/registros/{idRegistro} | Consultar un expediente de publicación por número de registro
[**myPubliSelecByNifOperation**](PublicacionApi.md#mypubliselecbynifoperation) | **POST** /api/v1/publicacion/selectbynif | Consultar expedientes y publicaciones asociados a un documento de identidad
[**myPubliSelecByNifTipoProcEntradaOperation**](PublicacionApi.md#mypubliselecbyniftipoprocentradaoperation) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/listado-registro-entrada | Consultar registros de entrada por documento del ciudadano
[**myPubliSelecByNifTipoProcEntradaOperation1**](PublicacionApi.md#mypubliselecbyniftipoprocentradaoperation1) | **POST** /api/v1/publicacion/selectbynifentrada | Consultar registros de entrada por documento del ciudadano
[**myPubliSelecByNifTipoProcExpOperation**](PublicacionApi.md#mypubliselecbyniftipoprocexpoperation) | **POST** /api/v1/publicacion/selectbynifexp | Consultar expedientes por documento del ciudadano
[**myPubliSelecByNifTipoProcExpOperation1**](PublicacionApi.md#mypubliselecbyniftipoprocexpoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes | Consultar expedientes por documento del ciudadano
[**myPubliSelecByNifTipoProcRegistrosEntradaOperation1**](PublicacionApi.md#mypubliselecbyniftipoprocregistrosentradaoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/registros | Busqueda de registros por tipo
[**myPubliSelecByNifTipoProcSalidaOperation**](PublicacionApi.md#mypubliselecbyniftipoprocsalidaoperation) | **POST** /api/v1/publicacion/selectbynifsalida | Consultar registros de salida por documento del ciudadano
[**myPubliSelecByNifTipoProcSalidaOperation1**](PublicacionApi.md#mypubliselecbyniftipoprocsalidaoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/listado-registro-salida | Consultar registros de salida por documento del ciudadano
[**myPubliSelecByNumExpOperation**](PublicacionApi.md#mypubliselecbynumexpoperation) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente} | Consultar un expediente de publicación por número de expediente
[**myPubliSelecByNumExpOperation1**](PublicacionApi.md#mypubliselecbynumexpoperation1) | **POST** /api/v1/publicacion/selectbynumexp | Consultar un expediente de publicación por número de expediente


# **miDetalleOperation**
> ZCSRFCPUBLISELECTBYNIFResponse miDetalleOperation(DTQUERY)

Consultar el detalle de un tramite en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTQUERY DTQUERY = ; // DTQUERY | 

try {
    final response = api.miDetalleOperation(DTQUERY);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->miDetalleOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **DTQUERY** | [**DTQUERY**](DTQUERY.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNIFResponse**](ZCSRFCPUBLISELECTBYNIFResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliNumRegOperation**
> Respuesta myPubliNumRegOperation(ZCSRFCPUBLISELECTBYNUMREG)

Consultar un expediente de publicación por número de registro

Consulta el detalle de un expediente de publicación a partir del número de registro, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente, incluyendo datos identificativos, órgano gestor, estado de tramitación y relación de documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final ZCSRFCPUBLISELECTBYNUMREG ZCSRFCPUBLISELECTBYNUMREG = {"pnumdoc":"99999999R","pregistro":"1103488/2024","ptipodoc":"NIF"}; // ZCSRFCPUBLISELECTBYNUMREG | Cuerpo de la petición con el número de documento, número de registro y tipo de documento del ciudadano para localizar el expediente.

try {
    final response = api.myPubliNumRegOperation(ZCSRFCPUBLISELECTBYNUMREG);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliNumRegOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ZCSRFCPUBLISELECTBYNUMREG** | [**ZCSRFCPUBLISELECTBYNUMREG**](ZCSRFCPUBLISELECTBYNUMREG.md)| Cuerpo de la petición con el número de documento, número de registro y tipo de documento del ciudadano para localizar el expediente. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliNumRegOperation1**
> Respuesta myPubliNumRegOperation1(idAgente, idRegistro, ZCSRFCPUBLISELECTBYNUMREG)

Consultar un expediente de publicación por número de registro

Consulta el detalle de un expediente de publicación a partir del número de registro, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente, incluyendo datos identificativos, órgano gestor, estado de tramitación y relación de documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idRegistro = idRegistro_example; // String | 
final ZCSRFCPUBLISELECTBYNUMREG ZCSRFCPUBLISELECTBYNUMREG = {"pnumdoc":"99999999R","pregistro":"1103488/2024","ptipodoc":"NIF"}; // ZCSRFCPUBLISELECTBYNUMREG | Cuerpo de la petición con el número de documento, número de registro y tipo de documento del ciudadano para localizar el expediente.

try {
    final response = api.myPubliNumRegOperation1(idAgente, idRegistro, ZCSRFCPUBLISELECTBYNUMREG);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliNumRegOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idRegistro** | **String**|  | 
 **ZCSRFCPUBLISELECTBYNUMREG** | [**ZCSRFCPUBLISELECTBYNUMREG**](ZCSRFCPUBLISELECTBYNUMREG.md)| Cuerpo de la petición con el número de documento, número de registro y tipo de documento del ciudadano para localizar el expediente. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifOperation**
> Respuesta myPubliSelecByNifOperation(DTSELECTBYNIFREQ)

Consultar expedientes y publicaciones asociados a un documento de identidad

Consulta los expedientes de publicación asociados a un ciudadano mediante su tipo y número de documento. La respuesta devuelve la estructura completa con el resultado de la consulta, incluyendo los expedientes localizados, datos del interesado, estado de tramitación, órgano responsable y documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTSELECTBYNIFREQ DTSELECTBYNIFREQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFREQ | Cuerpo de la petición con el tipo y número de documento del ciudadano cuyos expedientes se desean consultar.

try {
    final response = api.myPubliSelecByNifOperation(DTSELECTBYNIFREQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **DTSELECTBYNIFREQ** | [**DTSELECTBYNIFREQ**](DTSELECTBYNIFREQ.md)| Cuerpo de la petición con el tipo y número de documento del ciudadano cuyos expedientes se desean consultar. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcEntradaOperation**
> Respuesta myPubliSelecByNifTipoProcEntradaOperation(idAgente, DTSELECTBYNIFV2REQ)

Consultar registros de entrada por documento del ciudadano

Consulta la lista de registros de entrada asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento ENTRADA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como ENTRADA.

try {
    final response = api.myPubliSelecByNifTipoProcEntradaOperation(idAgente, DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcEntradaOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como ENTRADA. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcEntradaOperation1**
> Respuesta myPubliSelecByNifTipoProcEntradaOperation1(DTSELECTBYNIFV2REQ)

Consultar registros de entrada por documento del ciudadano

Consulta la lista de registros de entrada asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento ENTRADA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como ENTRADA.

try {
    final response = api.myPubliSelecByNifTipoProcEntradaOperation1(DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcEntradaOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como ENTRADA. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcExpOperation**
> Respuesta myPubliSelecByNifTipoProcExpOperation(DTSELECTBYNIFV2REQ)

Consultar expedientes por documento del ciudadano

Consulta la lista de expedientes asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento EXP y devuelve los expedientes localizados con información de tramitación, órgano responsable y documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como EXP.

try {
    final response = api.myPubliSelecByNifTipoProcExpOperation(DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcExpOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como EXP. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcExpOperation1**
> Respuesta myPubliSelecByNifTipoProcExpOperation1(idAgente, DTSELECTBYNIFV2REQ)

Consultar expedientes por documento del ciudadano

Consulta la lista de expedientes asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento EXP y devuelve los expedientes localizados con información de tramitación, órgano responsable y documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como EXP.

try {
    final response = api.myPubliSelecByNifTipoProcExpOperation1(idAgente, DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcExpOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como EXP. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcRegistrosEntradaOperation1**
> MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response myPubliSelecByNifTipoProcRegistrosEntradaOperation1(tipo, idAgente, DTSELECTBYNIFV2REQ)

Busqueda de registros por tipo

Devuelve los registros de tipo entrada para el NIF proporcionado. Se invoca mediante el mismo path con el parámetro query 'tipo=entrada'. Ejemplo: /ciudadanos/{idAgente}/registros?tipo=entrada.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final String tipo = entrada; // String | Tipo de registros: entrada | salida
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA.

try {
    final response = api.myPubliSelecByNifTipoProcRegistrosEntradaOperation1(tipo, idAgente, DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcRegistrosEntradaOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tipo** | **String**| Tipo de registros: entrada | salida | 
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA. | 

### Return type

[**MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response**](MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcSalidaOperation**
> Respuesta myPubliSelecByNifTipoProcSalidaOperation(DTSELECTBYNIFV2REQ)

Consultar registros de salida por documento del ciudadano

Consulta la lista de registros de salida asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento SALIDA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA.

try {
    final response = api.myPubliSelecByNifTipoProcSalidaOperation(DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcSalidaOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcSalidaOperation1**
> Respuesta myPubliSelecByNifTipoProcSalidaOperation1(idAgente, DTSELECTBYNIFV2REQ)

Consultar registros de salida por documento del ciudadano

Consulta la lista de registros de salida asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento SALIDA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA.

try {
    final response = api.myPubliSelecByNifTipoProcSalidaOperation1(idAgente, DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcSalidaOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNumExpOperation**
> Respuesta myPubliSelecByNumExpOperation(idAgente, idExpediente, ZCSRFCPUBLISELECTBYNUMEXP)

Consultar un expediente de publicación por número de expediente

Consulta el detalle de un expediente de publicación a partir del número de expediente, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente con datos identificativos, estado, órgano gestor y documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final ZCSRFCPUBLISELECTBYNUMEXP ZCSRFCPUBLISELECTBYNUMEXP = {"pnumdoc":"03874761C","pnumexp":"S020/2024/0001-PR","ptipodoc":"NIF"}; // ZCSRFCPUBLISELECTBYNUMEXP | Cuerpo de la petición con número de documento, número de expediente y tipo de documento del ciudadano para localizar el expediente.

try {
    final response = api.myPubliSelecByNumExpOperation(idAgente, idExpediente, ZCSRFCPUBLISELECTBYNUMEXP);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNumExpOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **ZCSRFCPUBLISELECTBYNUMEXP** | [**ZCSRFCPUBLISELECTBYNUMEXP**](ZCSRFCPUBLISELECTBYNUMEXP.md)| Cuerpo de la petición con número de documento, número de expediente y tipo de documento del ciudadano para localizar el expediente. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNumExpOperation1**
> Respuesta myPubliSelecByNumExpOperation1(ZCSRFCPUBLISELECTBYNUMEXP)

Consultar un expediente de publicación por número de expediente

Consulta el detalle de un expediente de publicación a partir del número de expediente, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente con datos identificativos, estado, órgano gestor y documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final ZCSRFCPUBLISELECTBYNUMEXP ZCSRFCPUBLISELECTBYNUMEXP = {"pnumdoc":"03874761C","pnumexp":"S020/2024/0001-PR","ptipodoc":"NIF"}; // ZCSRFCPUBLISELECTBYNUMEXP | Cuerpo de la petición con número de documento, número de expediente y tipo de documento del ciudadano para localizar el expediente.

try {
    final response = api.myPubliSelecByNumExpOperation1(ZCSRFCPUBLISELECTBYNUMEXP);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNumExpOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ZCSRFCPUBLISELECTBYNUMEXP** | [**ZCSRFCPUBLISELECTBYNUMEXP**](ZCSRFCPUBLISELECTBYNUMEXP.md)| Cuerpo de la petición con número de documento, número de expediente y tipo de documento del ciudadano para localizar el expediente. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

