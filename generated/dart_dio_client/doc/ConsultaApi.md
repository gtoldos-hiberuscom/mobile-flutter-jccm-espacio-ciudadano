# espacio_ciudadano_api.api.ConsultaApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**miConsultafaqOperation**](ConsultaApi.md#miconsultafaqoperation) | **POST** /api/v1/consulta/miconsultareq | Consultar el servicio para obtener el texto de la consulta o reclamacion y la respuesta


# **miConsultafaqOperation**
> ZCSRFCCONSULTAFAQResponse miConsultafaqOperation(zCSRFCCONSULTAFAQBody)

Consultar el servicio para obtener el texto de la consulta o reclamacion y la respuesta

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getConsultaApi();
final ZCSRFCCONSULTAFAQ zCSRFCCONSULTAFAQBody = ; // ZCSRFCCONSULTAFAQ | 

try {
    final response = api.miConsultafaqOperation(zCSRFCCONSULTAFAQBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ConsultaApi->miConsultafaqOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **zCSRFCCONSULTAFAQBody** | [**ZCSRFCCONSULTAFAQ**](ZCSRFCCONSULTAFAQ.md)|  | 

### Return type

[**ZCSRFCCONSULTAFAQResponse**](ZCSRFCCONSULTAFAQResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

