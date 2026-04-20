# espacio_ciudadano_api.api.DocumentacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**registrarFicheroOperation**](DocumentacionApi.md#registrarficherooperation) | **POST** /api/v1/documentacion/registrarfichero | Permite realizar el registro de un fichero obteniendo el justificante como resultado


# **registrarFicheroOperation**
> Uint8List registrarFicheroOperation(registrarFicheroRequest)

Permite realizar el registro de un fichero obteniendo el justificante como resultado

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getDocumentacionApi();
final RegistrarFicheroRequest registrarFicheroRequest = ; // RegistrarFicheroRequest | 

try {
    final response = api.registrarFicheroOperation(registrarFicheroRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentacionApi->registrarFicheroOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registrarFicheroRequest** | [**RegistrarFicheroRequest**](RegistrarFicheroRequest.md)|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

