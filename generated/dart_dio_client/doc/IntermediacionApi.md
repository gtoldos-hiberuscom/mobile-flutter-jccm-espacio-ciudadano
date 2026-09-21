# espacio_ciudadano_api.api.IntermediacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerDatosAtencionDependenciaIntermediacion**](IntermediacionApi.md#obtenerdatosatenciondependenciaintermediacion) | **POST** /api/v1/ciudadanos/{idAgente}/bienestar-social/atencion-dependencia | Obtener datos de atencion a la dependencia
[**obtenerDatosAtencionDependenciaIntermediacion1**](IntermediacionApi.md#obtenerdatosatenciondependenciaintermediacion1) | **POST** /api/v1/intermediacion/atencion-dependencia/datos | Obtener datos de atencion a la dependencia
[**obtenerDatosDiscapacidadIntermediacion**](IntermediacionApi.md#obtenerdatosdiscapacidadintermediacion) | **POST** /api/v1/ciudadanos/{id}/bienestar-social/discapacidad | Obtener datos de discapacidad por intermediación
[**obtenerDatosDiscapacidadIntermediacion1**](IntermediacionApi.md#obtenerdatosdiscapacidadintermediacion1) | **POST** /api/v1/intermediacion/discapacidad/datos | Obtener datos de discapacidad por intermediación
[**obtenerDatosFamiliaNumerosaIntermediacion**](IntermediacionApi.md#obtenerdatosfamilianumerosaintermediacion) | **POST** /api/v1/ciudadanos/{numDocumento}/bienestar-social/familia-numerosa | Obtener datos de familia numerosa por intermediación
[**obtenerDatosFamiliaNumerosaIntermediacion1**](IntermediacionApi.md#obtenerdatosfamilianumerosaintermediacion1) | **POST** /api/v1/intermediacion/familia-numerosa/datos | Obtener datos de familia numerosa por intermediación
[**obtenerDatosTarjetaEstacionamientoIntermediacion**](IntermediacionApi.md#obtenerdatostarjetaestacionamientointermediacion) | **POST** /api/v1/intermediacion/tarjeta-estacionamiento/datos | Obtener datos de la tarjeta de estacionamiento para personas con discapacidad
[**obtenerDatosTarjetaEstacionamientoIntermediacion1**](IntermediacionApi.md#obtenerdatostarjetaestacionamientointermediacion1) | **POST** /api/v1/ciudadanos/{idAgente}/bienestar-social/tarjeta-estacionamiento | Obtener datos de la tarjeta de estacionamiento para personas con discapacidad
[**obtenerDatosTermalismoIntermediacion**](IntermediacionApi.md#obtenerdatostermalismointermediacion) | **POST** /api/v1/ciudadanos/{idAgente}/bienestar-social/termalismo | Obtener datos del último balneario adjudicado del programa de termalismo
[**obtenerDatosTermalismoIntermediacion1**](IntermediacionApi.md#obtenerdatostermalismointermediacion1) | **POST** /api/v1/intermediacion/termalismo/datos | Obtener datos del último balneario adjudicado del programa de termalismo
[**obtenerOfertasEmpleoInscritas**](IntermediacionApi.md#obtenerofertasempleoinscritas) | **POST** /api/v1/intermediacion/empleo/ofertas-inscritas | Obtener ofertas de empleo inscritas
[**obtenerOfertasEmpleoInscritas1**](IntermediacionApi.md#obtenerofertasempleoinscritas1) | **POST** /api/v1/ciudadanos/{idAgente}/empleo/ofertas | Obtener ofertas de empleo inscritas


# **obtenerDatosAtencionDependenciaIntermediacion**
> Respuesta obtenerDatosAtencionDependenciaIntermediacion(idAgente, baseRequestIntermediacion, authorization)

Obtener datos de atencion a la dependencia

Consulta la situacion actual del expediente y prestaciones de dependencia del ciudadano. La respuesta se muestra con la estructura completa Respuesta y el detalle interno de datos especificos.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final String idAgente = idAgente_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de peticion para consultar datos de atencion a la dependencia por intermediacion.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosAtencionDependenciaIntermediacion(idAgente, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosAtencionDependenciaIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de peticion para consultar datos de atencion a la dependencia por intermediacion. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosAtencionDependenciaIntermediacion1**
> Respuesta obtenerDatosAtencionDependenciaIntermediacion1(baseRequestIntermediacion, authorization)

Obtener datos de atencion a la dependencia

Consulta la situacion actual del expediente y prestaciones de dependencia del ciudadano. La respuesta se muestra con la estructura completa Respuesta y el detalle interno de datos especificos.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de peticion para consultar datos de atencion a la dependencia por intermediacion.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosAtencionDependenciaIntermediacion1(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosAtencionDependenciaIntermediacion1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de peticion para consultar datos de atencion a la dependencia por intermediacion. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosDiscapacidadIntermediacion**
> Respuesta obtenerDatosDiscapacidadIntermediacion(id, baseRequestIntermediacion, authorization)

Obtener datos de discapacidad por intermediación

Consulta el servicio de intermediación para recuperar los datos del certificado de discapacidad del ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final String id = 12345678Z; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{id}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de discapacidad por intermediación.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosDiscapacidadIntermediacion(id, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosDiscapacidadIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{id}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de discapacidad por intermediación. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosDiscapacidadIntermediacion1**
> Respuesta obtenerDatosDiscapacidadIntermediacion1(baseRequestIntermediacion, authorization)

Obtener datos de discapacidad por intermediación

Consulta el servicio de intermediación para recuperar los datos del certificado de discapacidad del ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de discapacidad por intermediación.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosDiscapacidadIntermediacion1(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosDiscapacidadIntermediacion1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de discapacidad por intermediación. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosaIntermediacion**
> Respuesta obtenerDatosFamiliaNumerosaIntermediacion(numDocumento, baseRequestIntermediacion, authorization)

Obtener datos de familia numerosa por intermediación

Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final String numDocumento = numDocumento_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{numDocumento}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosFamiliaNumerosaIntermediacion(numDocumento, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosFamiliaNumerosaIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{numDocumento}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosaIntermediacion1**
> Respuesta obtenerDatosFamiliaNumerosaIntermediacion1(baseRequestIntermediacion, authorization)

Obtener datos de familia numerosa por intermediación

Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosFamiliaNumerosaIntermediacion1(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosFamiliaNumerosaIntermediacion1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosTarjetaEstacionamientoIntermediacion**
> Respuesta obtenerDatosTarjetaEstacionamientoIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de la tarjeta de estacionamiento para personas con discapacidad

Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla-La Mancha. La respuesta incluye el identificador de la tarjeta, modalidad (Persona con Discapacidad o Movilidad Reducida), fechas de vigencia de inicio y fin, y demás datos asociados a la tarjeta.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de tarjeta de estacionamiento por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosTarjetaEstacionamientoIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosTarjetaEstacionamientoIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de tarjeta de estacionamiento por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosTarjetaEstacionamientoIntermediacion1**
> Respuesta obtenerDatosTarjetaEstacionamientoIntermediacion1(idAgente, baseRequestIntermediacion, authorization)

Obtener datos de la tarjeta de estacionamiento para personas con discapacidad

Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla-La Mancha. La respuesta incluye el identificador de la tarjeta, modalidad (Persona con Discapacidad o Movilidad Reducida), fechas de vigencia de inicio y fin, y demás datos asociados a la tarjeta.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final String idAgente = idAgente_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de tarjeta de estacionamiento por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosTarjetaEstacionamientoIntermediacion1(idAgente, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosTarjetaEstacionamientoIntermediacion1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de tarjeta de estacionamiento por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosTermalismoIntermediacion**
> Respuesta obtenerDatosTermalismoIntermediacion(idAgente, baseRequestIntermediacion, authorization)

Obtener datos del último balneario adjudicado del programa de termalismo

Consulta el último balneario adjudicado en el programa de termalismo de Castilla-La Mancha para el ciudadano especificado. La respuesta incluye información detallada del balneario incluyendo su nombre, localidad, fechas de estancia programadas y otros datos de la adjudicación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final String idAgente = idAgente_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de termalismo por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosTermalismoIntermediacion(idAgente, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosTermalismoIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de termalismo por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosTermalismoIntermediacion1**
> Respuesta obtenerDatosTermalismoIntermediacion1(baseRequestIntermediacion, authorization)

Obtener datos del último balneario adjudicado del programa de termalismo

Consulta el último balneario adjudicado en el programa de termalismo de Castilla-La Mancha para el ciudadano especificado. La respuesta incluye información detallada del balneario incluyendo su nombre, localidad, fechas de estancia programadas y otros datos de la adjudicación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de termalismo por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosTermalismoIntermediacion1(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosTermalismoIntermediacion1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de termalismo por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerOfertasEmpleoInscritas**
> Respuesta obtenerOfertasEmpleoInscritas(baseRequestIntermediacion, authorization)

Obtener ofertas de empleo inscritas

Consulta las ofertas de empleo en las que el ciudadano figura inscrito. La respuesta se muestra con la estructura completa Respuesta y el listado de ofertas en datosespecificos.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de peticion para consultar ofertas de empleo inscritas por intermediacion.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerOfertasEmpleoInscritas(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerOfertasEmpleoInscritas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de peticion para consultar ofertas de empleo inscritas por intermediacion. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerOfertasEmpleoInscritas1**
> Respuesta obtenerOfertasEmpleoInscritas1(idAgente, baseRequestIntermediacion, authorization)

Obtener ofertas de empleo inscritas

Consulta las ofertas de empleo en las que el ciudadano figura inscrito. La respuesta se muestra con la estructura completa Respuesta y el listado de ofertas en datosespecificos.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final String idAgente = idAgente_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de peticion para consultar ofertas de empleo inscritas por intermediacion.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerOfertasEmpleoInscritas1(idAgente, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerOfertasEmpleoInscritas1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de peticion para consultar ofertas de empleo inscritas por intermediacion. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

