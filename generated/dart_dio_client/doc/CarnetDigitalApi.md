# espacio_ciudadano_api.api.CarnetDigitalApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerCarnetJoven**](CarnetDigitalApi.md#obtenercarnetjoven) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/joven | Obtener carné joven digital
[**obtenerCarnetJoven1**](CarnetDigitalApi.md#obtenercarnetjoven1) | **GET** /api/v1/carnet-digital/joven/{dni} | Obtener carné joven digital
[**obtenerDatosDiscapacidad**](CarnetDigitalApi.md#obtenerdatosdiscapacidad) | **GET** /api/v1/carnet-digital/grado-discapacidad/{dni} | Obtener datos del carné de discapacidad
[**obtenerDatosDiscapacidad1**](CarnetDigitalApi.md#obtenerdatosdiscapacidad1) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/discapacidad | Obtener datos del carné de discapacidad
[**obtenerDatosFamiliaNumerosa**](CarnetDigitalApi.md#obtenerdatosfamilianumerosa) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/familia-numerosa | Obtener datos del carné de familia numerosa
[**obtenerDatosFamiliaNumerosa1**](CarnetDigitalApi.md#obtenerdatosfamilianumerosa1) | **GET** /api/v1/carnet-digital/familia-numerosa/{dni} | Obtener datos del carné de familia numerosa
[**obtenerDatosFamiliaNumerosaIntermediacion**](CarnetDigitalApi.md#obtenerdatosfamilianumerosaintermediacion) | **POST** /api/v1/ciudadanos/{numDocumento}/bienestar-social/familia-numerosa | Obtener datos de familia numerosa por intermediación
[**obtenerDatosFamiliaNumerosaIntermediacion1**](CarnetDigitalApi.md#obtenerdatosfamilianumerosaintermediacion1) | **POST** /api/v1/intermediacion/familia-numerosa/datos | Obtener datos de familia numerosa por intermediación
[**obtenerPdf**](CarnetDigitalApi.md#obtenerpdf) | **POST** /api/v1/ciudadanos/{dni}/carnet-digital/joven/pdf | Obtener PDF del carné joven digital
[**obtenerPdf1**](CarnetDigitalApi.md#obtenerpdf1) | **POST** /api/v1/carnet-digital/pdf/{dni} | Obtener PDF del carné joven digital
[**obtenerPkPass**](CarnetDigitalApi.md#obtenerpkpass) | **POST** /api/v1/ciudadanos/{dni}/carnet-digital/joven/pkpass | Obtener PKPass del carné joven digital
[**obtenerPkPass1**](CarnetDigitalApi.md#obtenerpkpass1) | **POST** /api/v1/carnet-digital/pkpass/{dni} | Obtener PKPass del carné joven digital
[**obtenerPkPassDiscapacidad**](CarnetDigitalApi.md#obtenerpkpassdiscapacidad) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/discapacidad/pkpass | Obtener PKPass del carné de discapacidad
[**obtenerPkPassDiscapacidad1**](CarnetDigitalApi.md#obtenerpkpassdiscapacidad1) | **GET** /api/v1/carnet-digital/discapacidad-pkpass/{dni} | Obtener PKPass del carné de discapacidad
[**obtenerPkPassFamiliaNumerosa**](CarnetDigitalApi.md#obtenerpkpassfamilianumerosa) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/familia-numerosa/pkpass | Obtener PKPass del carné de familia numerosa
[**obtenerPkPassFamiliaNumerosa1**](CarnetDigitalApi.md#obtenerpkpassfamilianumerosa1) | **GET** /api/v1/carnet-digital/familia-numerosa-pkpass/{dni} | Obtener PKPass del carné de familia numerosa
[**obtenerQr**](CarnetDigitalApi.md#obtenerqr) | **POST** /api/v1/ciudadanos/{dni}/carnet-digital/joven/qr | Obtener QR del carné joven digital
[**obtenerQr1**](CarnetDigitalApi.md#obtenerqr1) | **POST** /api/v1/carnet-digital/qr/{dni} | Obtener QR del carné joven digital


# **obtenerCarnetJoven**
> Respuesta obtenerCarnetJoven(dni, authorization)

Obtener carné joven digital

Recupera los datos del carné joven digital asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerCarnetJoven(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerCarnetJoven: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerCarnetJoven1**
> Respuesta obtenerCarnetJoven1(dni, authorization)

Obtener carné joven digital

Recupera los datos del carné joven digital asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerCarnetJoven1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerCarnetJoven1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosDiscapacidad**
> Respuesta obtenerDatosDiscapacidad(dni, authorization)

Obtener datos del carné de discapacidad

Recupera los datos del carné digital de discapacidad asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de discapacidad.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosDiscapacidad(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerDatosDiscapacidad: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de discapacidad. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosDiscapacidad1**
> Respuesta obtenerDatosDiscapacidad1(dni, authorization)

Obtener datos del carné de discapacidad

Recupera los datos del carné digital de discapacidad asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de discapacidad.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosDiscapacidad1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerDatosDiscapacidad1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de discapacidad. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosa**
> Respuesta obtenerDatosFamiliaNumerosa(dni, authorization)

Obtener datos del carné de familia numerosa

Recupera los datos del carné digital de familia numerosa asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de familia numerosa.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosFamiliaNumerosa(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerDatosFamiliaNumerosa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de familia numerosa. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosa1**
> Respuesta obtenerDatosFamiliaNumerosa1(dni, authorization)

Obtener datos del carné de familia numerosa

Recupera los datos del carné digital de familia numerosa asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de familia numerosa.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosFamiliaNumerosa1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerDatosFamiliaNumerosa1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de familia numerosa. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosaIntermediacion**
> Respuesta obtenerDatosFamiliaNumerosaIntermediacion(numDocumento, baseRequestIntermediacion, authorization)

Obtener datos de familia numerosa por intermediación

Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String numDocumento = numDocumento_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{numDocumento}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosFamiliaNumerosaIntermediacion(numDocumento, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerDatosFamiliaNumerosaIntermediacion: $e\n');
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
> Respuesta obtenerDatosFamiliaNumerosaIntermediacion1(numDocumento, baseRequestIntermediacion, authorization)

Obtener datos de familia numerosa por intermediación

Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String numDocumento = numDocumento_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{numDocumento}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosFamiliaNumerosaIntermediacion1(numDocumento, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerDatosFamiliaNumerosaIntermediacion1: $e\n');
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

# **obtenerPdf**
> Respuesta obtenerPdf(dni, authorization)

Obtener PDF del carné joven digital

Genera el documento PDF del carné joven digital del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPdf(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerPdf: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPdf1**
> Respuesta obtenerPdf1(dni, authorization)

Obtener PDF del carné joven digital

Genera el documento PDF del carné joven digital del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPdf1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerPdf1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPass**
> Respuesta obtenerPkPass(dni, authorization)

Obtener PKPass del carné joven digital

Genera el fichero PKPass del carné joven digital del ciudadano autenticado para su uso en wallet compatible.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPass(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerPkPass: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPass1**
> Respuesta obtenerPkPass1(dni, authorization)

Obtener PKPass del carné joven digital

Genera el fichero PKPass del carné joven digital del ciudadano autenticado para su uso en wallet compatible.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPass1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerPkPass1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPassDiscapacidad**
> Respuesta obtenerPkPassDiscapacidad(dni, authorization)

Obtener PKPass del carné de discapacidad

Genera el fichero PKPass del carné digital de discapacidad del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de discapacidad.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPassDiscapacidad(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerPkPassDiscapacidad: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de discapacidad. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPassDiscapacidad1**
> Respuesta obtenerPkPassDiscapacidad1(dni, authorization)

Obtener PKPass del carné de discapacidad

Genera el fichero PKPass del carné digital de discapacidad del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de discapacidad.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPassDiscapacidad1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerPkPassDiscapacidad1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de discapacidad. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPassFamiliaNumerosa**
> Respuesta obtenerPkPassFamiliaNumerosa(dni, authorization)

Obtener PKPass del carné de familia numerosa

Genera el fichero PKPass del carné digital de familia numerosa del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de familia numerosa.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPassFamiliaNumerosa(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerPkPassFamiliaNumerosa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de familia numerosa. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPassFamiliaNumerosa1**
> Respuesta obtenerPkPassFamiliaNumerosa1(dni, authorization)

Obtener PKPass del carné de familia numerosa

Genera el fichero PKPass del carné digital de familia numerosa del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de familia numerosa.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPassFamiliaNumerosa1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerPkPassFamiliaNumerosa1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de familia numerosa. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerQr**
> Respuesta obtenerQr(dni, authorization)

Obtener QR del carné joven digital

Genera el código QR asociado al carné joven digital del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerQr(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerQr: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerQr1**
> Respuesta obtenerQr1(dni, authorization)

Obtener QR del carné joven digital

Genera el código QR asociado al carné joven digital del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerQr1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerQr1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

