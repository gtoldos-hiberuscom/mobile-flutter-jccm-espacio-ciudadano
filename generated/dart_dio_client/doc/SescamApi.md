# espacio_ciudadano_api.api.SescamApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**citasFuturas**](SescamApi.md#citasfuturas) | **GET** /api/v1/sescam/citas/{numDocumento} | Servicio para consultar las citas futuras
[**citasPasadas**](SescamApi.md#citaspasadas) | **GET** /api/v1/sescam/citas-pasadas/{numDocumento} | Servicio para consultar las citas pasadas
[**getCipFromNif**](SescamApi.md#getcipfromnif) | **GET** /api/v1/sescam/cip/{numDocumento} | Servicio para obtener el CIP de un NIF


# **citasFuturas**
> String citasFuturas(numDocumento, authorization)

Servicio para consultar las citas futuras

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSescamApi();
final String numDocumento = numDocumento_example; // String | 
final String authorization = authorization_example; // String | 

try {
    final response = api.citasFuturas(numDocumento, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SescamApi->citasFuturas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasPasadas**
> String citasPasadas(numDocumento, authorization)

Servicio para consultar las citas pasadas

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSescamApi();
final String numDocumento = numDocumento_example; // String | 
final String authorization = authorization_example; // String | 

try {
    final response = api.citasPasadas(numDocumento, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SescamApi->citasPasadas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCipFromNif**
> String getCipFromNif(numDocumento, authorization)

Servicio para obtener el CIP de un NIF

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSescamApi();
final String numDocumento = numDocumento_example; // String | 
final String authorization = authorization_example; // String | 

try {
    final response = api.getCipFromNif(numDocumento, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SescamApi->getCipFromNif: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

