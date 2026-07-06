# espacio_ciudadano_api.api.EducacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getTitulosNoUniversitarios**](EducacionApi.md#gettitulosnouniversitarios) | **POST** /api/v1/educacion/titulos-no-universitarios/{numDocumento} | Servicio para obtener los títulos no universitarios
[**getTitulosUniversitarios**](EducacionApi.md#gettitulosuniversitarios) | **POST** /api/v1/educacion/titulos-universitarios/{numDocumento} | Servicio para obtener los títulos universitarios


# **getTitulosNoUniversitarios**
> DTEDUTNURES getTitulosNoUniversitarios(numDocumento, DTEDUTNUREQ, authorization)

Servicio para obtener los títulos no universitarios

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getEducacionApi();
final String numDocumento = numDocumento_example; // String | 
final DTEDUTNUREQ DTEDUTNUREQ = ; // DTEDUTNUREQ | 
final String authorization = authorization_example; // String | 

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
 **numDocumento** | **String**|  | 
 **DTEDUTNUREQ** | [**DTEDUTNUREQ**](DTEDUTNUREQ.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**DTEDUTNURES**](DTEDUTNURES.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTitulosUniversitarios**
> DTEDUTUORES getTitulosUniversitarios(numDocumento, DTEDUTUOREQ, authorization)

Servicio para obtener los títulos universitarios

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getEducacionApi();
final String numDocumento = numDocumento_example; // String | 
final DTEDUTUOREQ DTEDUTUOREQ = ; // DTEDUTUOREQ | 
final String authorization = authorization_example; // String | 

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
 **numDocumento** | **String**|  | 
 **DTEDUTUOREQ** | [**DTEDUTUOREQ**](DTEDUTUOREQ.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**DTEDUTUORES**](DTEDUTUORES.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

