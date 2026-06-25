# espacio_ciudadano_api.api.CcaaApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDatosFamiliaNumerosa**](CcaaApi.md#getdatosfamilianumerosa) | **POST** /api/v1/ccaa/familia-numerosa/{numDocumento} | Servicio para obtener los datos de familia numerosa


# **getDatosFamiliaNumerosa**
> DTMINHAFPCCCAFNRES getDatosFamiliaNumerosa(numDocumento, DTMINHAFPCCCAFNREQ, authorization)

Servicio para obtener los datos de familia numerosa

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCcaaApi();
final String numDocumento = numDocumento_example; // String | 
final DTMINHAFPCCCAFNREQ DTMINHAFPCCCAFNREQ = ; // DTMINHAFPCCCAFNREQ | 
final String authorization = authorization_example; // String | 

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
 **numDocumento** | **String**|  | 
 **DTMINHAFPCCCAFNREQ** | [**DTMINHAFPCCCAFNREQ**](DTMINHAFPCCCAFNREQ.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**DTMINHAFPCCCAFNRES**](DTMINHAFPCCCAFNRES.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

