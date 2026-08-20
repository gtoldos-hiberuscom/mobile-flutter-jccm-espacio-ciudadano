# espacio_ciudadano_api.api.EducacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getTitulosNoUniversitarios**](EducacionApi.md#gettitulosnouniversitarios) | **POST** /api/v1/educacion/titulos-no-universitarios/{numDocumento} | Obtener titulos no universitarios
[**getTitulosUniversitarios**](EducacionApi.md#gettitulosuniversitarios) | **POST** /api/v1/educacion/titulos-universitarios/{numDocumento} | Obtener titulos universitarios
[**getTitulosUniversitarios1**](EducacionApi.md#gettitulosuniversitarios1) | **POST** /api/v1/ciudadanos/{numDocumento}/educacion/titulos-universitarios | Obtener titulos universitarios


# **getTitulosNoUniversitarios**
> Respuesta getTitulosNoUniversitarios(numDocumento, DTEDUTNUREQ, authorization)

Obtener titulos no universitarios

Consulta los titulos no universitarios del ciudadano en el servicio de Educacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getEducacionApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTEDUTNUREQ DTEDUTNUREQ = {"tipodoc":"NIF","docu":"99999999R"}; // DTEDUTNUREQ | Datos de entrada para la consulta de titulos no universitarios.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getTitulosNoUniversitarios(numDocumento, DTEDUTNUREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EducacionApi->getTitulosNoUniversitarios: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTEDUTNUREQ** | [**DTEDUTNUREQ**](DTEDUTNUREQ.md)| Datos de entrada para la consulta de titulos no universitarios. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTitulosUniversitarios**
> Respuesta getTitulosUniversitarios(numDocumento, DTEDUTUOREQ, authorization)

Obtener titulos universitarios

Consulta los titulos universitarios del ciudadano en el servicio de Educacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getEducacionApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTEDUTUOREQ DTEDUTUOREQ = {"tipodoc":"NIF","docu":"99999999R"}; // DTEDUTUOREQ | Datos de entrada para la consulta de titulos universitarios.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getTitulosUniversitarios(numDocumento, DTEDUTUOREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EducacionApi->getTitulosUniversitarios: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTEDUTUOREQ** | [**DTEDUTUOREQ**](DTEDUTUOREQ.md)| Datos de entrada para la consulta de titulos universitarios. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTitulosUniversitarios1**
> Respuesta getTitulosUniversitarios1(numDocumento, DTEDUTUOREQ, authorization)

Obtener titulos universitarios

Consulta los titulos universitarios del ciudadano en el servicio de Educacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getEducacionApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTEDUTUOREQ DTEDUTUOREQ = {"tipodoc":"NIF","docu":"99999999R"}; // DTEDUTUOREQ | Datos de entrada para la consulta de titulos universitarios.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getTitulosUniversitarios1(numDocumento, DTEDUTUOREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EducacionApi->getTitulosUniversitarios1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTEDUTUOREQ** | [**DTEDUTUOREQ**](DTEDUTUOREQ.md)| Datos de entrada para la consulta de titulos universitarios. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

