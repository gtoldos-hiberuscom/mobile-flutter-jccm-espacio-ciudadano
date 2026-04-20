# espacio_ciudadano_api.api.CarnetDigitalApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**obtenerCarnetJoven**](CarnetDigitalApi.md#obtenercarnetjoven) | **GET** /api/v1/carnet-digital/joven/{dni} | Obtener carnet joven
[**obtenerDatosFamiliaNumerosa**](CarnetDigitalApi.md#obtenerdatosfamilianumerosa) | **POST** /api/v1/intermediacion/discapacidad/datos | Obtener datos del carné de familia numerosa
[**obtenerDatosFamiliaNumerosa1**](CarnetDigitalApi.md#obtenerdatosfamilianumerosa1) | **GET** /api/v1/carnet-digital/grado-discapacidad/{dni} | Obtener datos del carné de familia numerosa
[**obtenerDatosFamiliaNumerosa2**](CarnetDigitalApi.md#obtenerdatosfamilianumerosa2) | **GET** /api/v1/carnet-digital/familia-numerosa/{dni} | Obtener datos del carné de familia numerosa
[**obtenerPdf**](CarnetDigitalApi.md#obtenerpdf) | **POST** /api/v1/carnet-digital/pdf/{dni} | Obtener Pdf de un carné
[**obtenerPkPass**](CarnetDigitalApi.md#obtenerpkpass) | **POST** /api/v1/carnet-digital/pkpass/{dni} | Obtener PkPass de un carné
[**obtenerPkPassFamiliaNumerosa**](CarnetDigitalApi.md#obtenerpkpassfamilianumerosa) | **GET** /api/v1/carnet-digital/familia-numerosa-pkpass/{dni} | Obtener PkPass del carné de familia numerosa
[**obtenerPkPassFamiliaNumerosa1**](CarnetDigitalApi.md#obtenerpkpassfamilianumerosa1) | **GET** /api/v1/carnet-digital/discapacidad-pkpass/{dni} | Obtener PkPass del carné de familia numerosa
[**obtenerQr**](CarnetDigitalApi.md#obtenerqr) | **POST** /api/v1/carnet-digital/qr/{dni} | Obtener Qr de un carné


# **obtenerCarnetJoven**
> CarnetJoven obtenerCarnetJoven(dni, authorization)

Obtener carnet joven

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = dni_example; // String | 
final String authorization = authorization_example; // String | 

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
 **dni** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**CarnetJoven**](CarnetJoven.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosa**
> String obtenerDatosFamiliaNumerosa(requestFachadaDiscapacidadInterm, authorization)

Obtener datos del carné de familia numerosa

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final RequestFachadaDiscapacidadInterm requestFachadaDiscapacidadInterm = ; // RequestFachadaDiscapacidadInterm | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosFamiliaNumerosa(requestFachadaDiscapacidadInterm, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerDatosFamiliaNumerosa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestFachadaDiscapacidadInterm** | [**RequestFachadaDiscapacidadInterm**](RequestFachadaDiscapacidadInterm.md)|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosa1**
> String obtenerDatosFamiliaNumerosa1(dni, authorization)

Obtener datos del carné de familia numerosa

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = dni_example; // String | 
final String authorization = authorization_example; // String | 

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
 **dni** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosa2**
> DatosFamiliaNumerosa obtenerDatosFamiliaNumerosa2(dni, authorization)

Obtener datos del carné de familia numerosa

(Método GET) Obtiene los datos de familia numerosa por DNI.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = dni_example; // String | 
final String authorization = authorization_example; // String | 

try {
    final response = api.obtenerDatosFamiliaNumerosa2(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CarnetDigitalApi->obtenerDatosFamiliaNumerosa2: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**DatosFamiliaNumerosa**](DatosFamiliaNumerosa.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPdf**
> String obtenerPdf(dni, authorization)

Obtener Pdf de un carné

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = dni_example; // String | 
final String authorization = authorization_example; // String | 

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
 **dni** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPass**
> String obtenerPkPass(dni, authorization)

Obtener PkPass de un carné

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = dni_example; // String | 
final String authorization = authorization_example; // String | 

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
 **dni** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPassFamiliaNumerosa**
> PkpassFamiliaNumerosa obtenerPkPassFamiliaNumerosa(dni, authorization)

Obtener PkPass del carné de familia numerosa

(Método GET) Obtiene el PKPASS de familia numerosa por DNI.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = dni_example; // String | 
final String authorization = authorization_example; // String | 

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
 **dni** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**PkpassFamiliaNumerosa**](PkpassFamiliaNumerosa.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPassFamiliaNumerosa1**
> String obtenerPkPassFamiliaNumerosa1(dni, authorization)

Obtener PkPass del carné de familia numerosa

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = dni_example; // String | 
final String authorization = authorization_example; // String | 

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
 **dni** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerQr**
> CarnetQr obtenerQr(dni, authorization)

Obtener Qr de un carné

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCarnetDigitalApi();
final String dni = dni_example; // String | 
final String authorization = authorization_example; // String | 

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
 **dni** | **String**|  | 
 **authorization** | **String**|  | [optional] 

### Return type

[**CarnetQr**](CarnetQr.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

