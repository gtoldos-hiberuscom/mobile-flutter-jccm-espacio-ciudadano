# espacio_ciudadano_api.api.AfirmaApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**miListarDocumentosReq**](AfirmaApi.md#milistardocumentosreq) | **POST** /api/v1/afirma/milistardocumentosreq | Consultar el listado de los tipos de documentos en cesar
[**miVecReq**](AfirmaApi.md#mivecreq) | **POST** /api/v1/afirma/mivecreq | Consultar el servicio para la validación de la firma en cesar


# **miListarDocumentosReq**
> ZCSVECResponse miListarDocumentosReq(zCSLISTARTIPOSDOCBody)

Consultar el listado de los tipos de documentos en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getAfirmaApi();
final ZCSLISTARTIPOSDOC zCSLISTARTIPOSDOCBody = ; // ZCSLISTARTIPOSDOC | 

try {
    final response = api.miListarDocumentosReq(zCSLISTARTIPOSDOCBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AfirmaApi->miListarDocumentosReq: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **zCSLISTARTIPOSDOCBody** | [**ZCSLISTARTIPOSDOC**](ZCSLISTARTIPOSDOC.md)|  | 

### Return type

[**ZCSVECResponse**](ZCSVECResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miVecReq**
> ZCSVECResponse miVecReq(zCSVECBody)

Consultar el servicio para la validación de la firma en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getAfirmaApi();
final ZCSVEC zCSVECBody = ; // ZCSVEC | 

try {
    final response = api.miVecReq(zCSVECBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AfirmaApi->miVecReq: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **zCSVECBody** | [**ZCSVEC**](ZCSVEC.md)|  | 

### Return type

[**ZCSVECResponse**](ZCSVECResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

