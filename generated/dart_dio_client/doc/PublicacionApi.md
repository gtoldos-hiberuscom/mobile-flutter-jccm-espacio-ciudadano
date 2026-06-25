# espacio_ciudadano_api.api.PublicacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**miDetalleOperation**](PublicacionApi.md#midetalleoperation) | **POST** /api/v1/servicio/midetalle | Consultar el detalle de un tramite en cesar
[**miDocsfirmados**](PublicacionApi.md#midocsfirmados) | **POST** /api/v1/publicacion/midocfirmados | Servicio que permite consultar el documento de certificado de deuda en cesar
[**myPubliNumRegOperation**](PublicacionApi.md#mypublinumregoperation) | **POST** /api/v1/publicacion/selectbynumreg | Consulta un expediente especificado por número de registro
[**myPubliSelecByNifOperation**](PublicacionApi.md#mypubliselecbynifoperation) | **POST** /api/v1/publicacion/selectbynif | Consultar la lista de expedientes vinculados a un NIF o número de identificación
[**myPubliSelecByNifTipoProcOperation**](PublicacionApi.md#mypubliselecbyniftipoprocoperation) | **POST** /api/v1/publicacion/selectbynifsalida | Consultar la lista de salidas vinculados a un NIF o número de identificación
[**myPubliSelecByNifTipoProcOperation1**](PublicacionApi.md#mypubliselecbyniftipoprocoperation1) | **POST** /api/v1/publicacion/selectbynifexp | Consultar la lista de expedientes vinculados a un NIF o número de identificación
[**myPubliSelecByNifTipoProcOperation2**](PublicacionApi.md#mypubliselecbyniftipoprocoperation2) | **POST** /api/v1/publicacion/selectbynifentrada | Consultar la lista de entradas vinculados a un NIF o número de identificación
[**myPubliSelecByNumExpOperation**](PublicacionApi.md#mypubliselecbynumexpoperation) | **POST** /api/v1/publicacion/selectbynumexp | Consultar el expediente especificado por número de expediente
[**siMisExpedientesOperation**](PublicacionApi.md#simisexpedientesoperation) | **POST** /api/v1/publicacion/misexpedientes | Consultar listado de expedientes asociados a un número de documento


# **miDetalleOperation**
> ZCSRFCPUBLISELECTBYNIFResponse miDetalleOperation(DTQUERY)

Consultar el detalle de un tramite en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTQUERY DTQUERY = ; // DTQUERY | 

try {
    final response = api.miDetalleOperation(DTQUERY);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->miDetalleOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **DTQUERY** | [**DTQUERY**](DTQUERY.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNIFResponse**](ZCSRFCPUBLISELECTBYNIFResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miDocsfirmados**
> ZCSRFCDOCSFIRMADOSPFEXPTEResponse miDocsfirmados(ZCSRFCDOCSFIRMADOSPFEXPTE)

Servicio que permite consultar el documento de certificado de deuda en cesar

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final ZCSRFCDOCSFIRMADOSPFEXPTE ZCSRFCDOCSFIRMADOSPFEXPTE = ; // ZCSRFCDOCSFIRMADOSPFEXPTE | 

try {
    final response = api.miDocsfirmados(ZCSRFCDOCSFIRMADOSPFEXPTE);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->miDocsfirmados: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ZCSRFCDOCSFIRMADOSPFEXPTE** | [**ZCSRFCDOCSFIRMADOSPFEXPTE**](ZCSRFCDOCSFIRMADOSPFEXPTE.md)|  | 

### Return type

[**ZCSRFCDOCSFIRMADOSPFEXPTEResponse**](ZCSRFCDOCSFIRMADOSPFEXPTEResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliNumRegOperation**
> ZCSRFCPUBLISELECTBYNUMREGResponse myPubliNumRegOperation(ZCSRFCPUBLISELECTBYNUMREG)

Consulta un expediente especificado por número de registro

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final ZCSRFCPUBLISELECTBYNUMREG ZCSRFCPUBLISELECTBYNUMREG = ; // ZCSRFCPUBLISELECTBYNUMREG | 

try {
    final response = api.myPubliNumRegOperation(ZCSRFCPUBLISELECTBYNUMREG);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliNumRegOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ZCSRFCPUBLISELECTBYNUMREG** | [**ZCSRFCPUBLISELECTBYNUMREG**](ZCSRFCPUBLISELECTBYNUMREG.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNUMREGResponse**](ZCSRFCPUBLISELECTBYNUMREGResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifOperation**
> ZCSRFCPUBLISELECTBYNIFResponse myPubliSelecByNifOperation(DTSELECTBYNIFREQ)

Consultar la lista de expedientes vinculados a un NIF o número de identificación

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTSELECTBYNIFREQ DTSELECTBYNIFREQ = ; // DTSELECTBYNIFREQ | 

try {
    final response = api.myPubliSelecByNifOperation(DTSELECTBYNIFREQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **DTSELECTBYNIFREQ** | [**DTSELECTBYNIFREQ**](DTSELECTBYNIFREQ.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNIFResponse**](ZCSRFCPUBLISELECTBYNIFResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcOperation**
> ZCSRFCPUBLISELECTBYNIFResponse myPubliSelecByNifTipoProcOperation(dTSELECTBYNIFV2REQ)

Consultar la lista de salidas vinculados a un NIF o número de identificación

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTSELECTBYNIFV2REQ dTSELECTBYNIFV2REQ = ; // DTSELECTBYNIFV2REQ | 

try {
    final response = api.myPubliSelecByNifTipoProcOperation(dTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNIFResponse**](ZCSRFCPUBLISELECTBYNIFResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcOperation1**
> ZCSRFCPUBLISELECTBYNIFResponse myPubliSelecByNifTipoProcOperation1(dTSELECTBYNIFV2REQ)

Consultar la lista de expedientes vinculados a un NIF o número de identificación

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTSELECTBYNIFV2REQ dTSELECTBYNIFV2REQ = ; // DTSELECTBYNIFV2REQ | 

try {
    final response = api.myPubliSelecByNifTipoProcOperation1(dTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNIFResponse**](ZCSRFCPUBLISELECTBYNIFResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcOperation2**
> ZCSRFCPUBLISELECTBYNIFResponse myPubliSelecByNifTipoProcOperation2(dTSELECTBYNIFV2REQ)

Consultar la lista de entradas vinculados a un NIF o número de identificación

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final DTSELECTBYNIFV2REQ dTSELECTBYNIFV2REQ = ; // DTSELECTBYNIFV2REQ | 

try {
    final response = api.myPubliSelecByNifTipoProcOperation2(dTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNifTipoProcOperation2: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNIFResponse**](ZCSRFCPUBLISELECTBYNIFResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNumExpOperation**
> ZCSRFCPUBLISELECTBYNUMEXPResponse myPubliSelecByNumExpOperation(ZCSRFCPUBLISELECTBYNUMEXP)

Consultar el expediente especificado por número de expediente

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final ZCSRFCPUBLISELECTBYNUMEXP ZCSRFCPUBLISELECTBYNUMEXP = ; // ZCSRFCPUBLISELECTBYNUMEXP | 

try {
    final response = api.myPubliSelecByNumExpOperation(ZCSRFCPUBLISELECTBYNUMEXP);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->myPubliSelecByNumExpOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ZCSRFCPUBLISELECTBYNUMEXP** | [**ZCSRFCPUBLISELECTBYNUMEXP**](ZCSRFCPUBLISELECTBYNUMEXP.md)|  | 

### Return type

[**ZCSRFCPUBLISELECTBYNUMEXPResponse**](ZCSRFCPUBLISELECTBYNUMEXPResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **siMisExpedientesOperation**
> ZCSRFCMISEXPEDIENTESResponse siMisExpedientesOperation(ZCSRFCMISEXPEDIENTES)

Consultar listado de expedientes asociados a un número de documento

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getPublicacionApi();
final ZCSRFCMISEXPEDIENTES ZCSRFCMISEXPEDIENTES = ; // ZCSRFCMISEXPEDIENTES | 

try {
    final response = api.siMisExpedientesOperation(ZCSRFCMISEXPEDIENTES);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicacionApi->siMisExpedientesOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ZCSRFCMISEXPEDIENTES** | [**ZCSRFCMISEXPEDIENTES**](ZCSRFCMISEXPEDIENTES.md)|  | 

### Return type

[**ZCSRFCMISEXPEDIENTESResponse**](ZCSRFCMISEXPEDIENTESResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

