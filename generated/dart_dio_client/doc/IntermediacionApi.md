# espacio_ciudadano_api.api.IntermediacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerDatosAtencionDependenciaIntermediacion**](IntermediacionApi.md#obtenerdatosatenciondependenciaintermediacion) | **POST** /api/v1/intermediacion/atencion-dependencia/datos | Obtener datos de atencion a la dependencia
[**obtenerDatosDiscapacidadIntermediacion**](IntermediacionApi.md#obtenerdatosdiscapacidadintermediacion) | **POST** /api/v1/intermediacion/discapacidad/datos | Obtener datos de discapacidad por intermediación
[**obtenerDatosFamiliaNumerosaIntermediacion**](IntermediacionApi.md#obtenerdatosfamilianumerosaintermediacion) | **POST** /api/v1/intermediacion/familia-numerosa/datos | Obtener datos de familia numerosa por intermediación
[**obtenerDatosTarjetaEstacionamientoIntermediacion**](IntermediacionApi.md#obtenerdatostarjetaestacionamientointermediacion) | **POST** /api/v1/intermediacion/tarjeta-estacionamiento/datos | Obtener datos de la tarjeta de estacionamiento para personas con discapacidad
[**obtenerDatosTermalismoIntermediacion**](IntermediacionApi.md#obtenerdatostermalismointermediacion) | **POST** /api/v1/intermediacion/termalismo/datos | Obtener datos del último balneario adjudicado del programa de termalismo
[**obtenerOfertasEmpleoInscritas**](IntermediacionApi.md#obtenerofertasempleoinscritas) | **POST** /api/v1/intermediacion/empleo/ofertas-inscritas | Obtener ofertas de empleo inscritas
[**obtenerTitulosNoUniversitariosIntermediacion**](IntermediacionApi.md#obtenertitulosnouniversitariosintermediacion) | **POST** /api/v1/intermediacion/titulos-no-universitarios/datos | Obtener títulos no universitarios del ciudadano


# **obtenerDatosAtencionDependenciaIntermediacion**
> Respuesta obtenerDatosAtencionDependenciaIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de atencion a la dependencia

Consulta la situacion actual del expediente y prestaciones de dependencia del ciudadano. La respuesta se muestra con la estructura completa Respuesta y el detalle interno de datos especificos.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de peticion para consultar datos de atencion a la dependencia por intermediacion.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosAtencionDependenciaIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosAtencionDependenciaIntermediacion: $e\n');
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
> Respuesta obtenerDatosDiscapacidadIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de discapacidad por intermediación

Consulta el servicio de intermediación para recuperar los datos del certificado de discapacidad del ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de discapacidad por intermediación.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosDiscapacidadIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosDiscapacidadIntermediacion: $e\n');
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
> Respuesta obtenerDatosFamiliaNumerosaIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos de familia numerosa por intermediación

Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosFamiliaNumerosaIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosFamiliaNumerosaIntermediacion: $e\n');
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

# **obtenerDatosTermalismoIntermediacion**
> Respuesta obtenerDatosTermalismoIntermediacion(baseRequestIntermediacion, authorization)

Obtener datos del último balneario adjudicado del programa de termalismo

Consulta el último balneario adjudicado en el programa de termalismo de Castilla-La Mancha para el ciudadano especificado. La respuesta incluye información detallada del balneario incluyendo su nombre, localidad, fechas de estancia programadas y otros datos de la adjudicación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de termalismo por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosTermalismoIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerDatosTermalismoIntermediacion: $e\n');
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

# **obtenerTitulosNoUniversitariosIntermediacion**
> Respuesta obtenerTitulosNoUniversitariosIntermediacion(baseRequestIntermediacion, authorization)

Obtener títulos no universitarios del ciudadano

Consulta los títulos no universitarios (Ciclos Formativos de Grado Superior y Grado Medio) registrados para el ciudadano. La respuesta incluye información detallada de cada título obtenido como denominación, tipo de ciclo (CFGS/CFGM), centro educativo, localidad y fechas de obtención y expedición del título.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getIntermediacionApi();
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar títulos no universitarios por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerTitulosNoUniversitariosIntermediacion(baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling IntermediacionApi->obtenerTitulosNoUniversitariosIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar títulos no universitarios por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

