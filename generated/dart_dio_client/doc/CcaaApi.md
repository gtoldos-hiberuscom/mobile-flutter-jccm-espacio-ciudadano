# espacio_ciudadano_api.api.CcaaApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDatosFamiliaNumerosa**](CcaaApi.md#getdatosfamilianumerosa) | **POST** /api/v1/ccaa/familia-numerosa/{numDocumento} | Obtener datos de familia numerosa


# **getDatosFamiliaNumerosa**
> Respuesta getDatosFamiliaNumerosa(numDocumento, DTMINHAFPCCCAFNREQ, authorization)

Obtener datos de familia numerosa

Consulta los datos de familia numerosa del ciudadano en el servicio CCAA.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCcaaApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTMINHAFPCCCAFNREQ DTMINHAFPCCCAFNREQ = {"tipdoc":"NIF","docu":"99999999R"}; // DTMINHAFPCCCAFNREQ | Datos de entrada para la consulta de familia numerosa.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getDatosFamiliaNumerosa(numDocumento, DTMINHAFPCCCAFNREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CcaaApi->getDatosFamiliaNumerosa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTMINHAFPCCCAFNREQ** | [**DTMINHAFPCCCAFNREQ**](DTMINHAFPCCCAFNREQ.md)| Datos de entrada para la consulta de familia numerosa. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

