# espacio_ciudadano_api.api.DocumentacionApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**registrarFicheroOperation**](DocumentacionApi.md#registrarficherooperation) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente}/ficheros/registrar | Registrar fichero y obtener justificante
[**registrarFicheroOperation1**](DocumentacionApi.md#registrarficherooperation1) | **POST** /api/v1/documentacion/registrarfichero | Registrar fichero y obtener justificante


# **registrarFicheroOperation**
> Uint8List registrarFicheroOperation(idAgente, idExpediente, registrarFicheroRequest)

Registrar fichero y obtener justificante

Registra un fichero en el procedimiento administrativo indicado. Devuelve el justificante de registro como fichero PDF firmado o justificante de envío.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getDocumentacionApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final RegistrarFicheroRequest registrarFicheroRequest = {"confirmarProcedimiento":{"procedimiento":{"idunico":"03874761C_171447919011019","tipoprocedimiento":"020","unidadorganica":"999999","consejeria":"001003","provincia":"12","noexpediente":"EXP-2024-00123","registro":{},"identificacion":{"category":"NIF","nifcif":"99999999R"},"identificacionrep":{},"asunto":"S020","asudescripcion":"","source":"TRAM","datossolicitante":{"nombre":"Juan García","apellido1":"López","apellido2":"Martínez","entidad":"","domicilio":"Calle Mayor","numero":"1","poblacion":"Toledo","provincia":"Toledo","codigopostal":"45000"},"datosprocedimiento":null,"datospago":{},"adjuntos":{"adjunto":[]},"firma":""},"pdatos":{"asuid":"SIM2","descrip":"CREACION Y REGULACION DEL REGISTRO DE INSTALACIONES DE DISTRIBUCION AL POR MENOR DE CARBURANTES Y COMBUSTIBLES PETROLIFEROS","uniorg":"010036","numdoc":"99999999R","nombre":"Juan García","apellido1":"López","apellido2":"Martínez","idunico":"03874761C_171447919011019"}},"oficinaTramitadora":"Oficina1","consejeriaTramitadora":"UAT-Consejeria de Medio ambiente","procedimiento":"Procedimiento1","fechaInicioTramitacion":"2022-01-01 22:30","fechaCierreTramitacion":"2022-01-31 21:15","estadoTramitacion":"En curso","documentos":[{"nombre":"testfile.pdf","algoritmo":"SHA-512","hash":"3452345235rtert45dfadfadfa43342y365u65u96ijhuu8iuu","fileSize":"80kb"}],"xmlRegistro":{"xmlClave":"xmlClave"},"esPorContraste":true,"datosRepresentante":{"nombre":"Tercero","apellido1":"TER-APE1","apellido2":"TER-APE2","nifcif":"05915863X","tipodoc":"NIF"}}; // RegistrarFicheroRequest | Datos del procedimiento y documentos a registrar. Incluye información del procedimiento, solicitante, documentos adjuntos y datos de firma.

try {
    final response = api.registrarFicheroOperation(idAgente, idExpediente, registrarFicheroRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentacionApi->registrarFicheroOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **registrarFicheroRequest** | [**RegistrarFicheroRequest**](RegistrarFicheroRequest.md)| Datos del procedimiento y documentos a registrar. Incluye información del procedimiento, solicitante, documentos adjuntos y datos de firma. | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registrarFicheroOperation1**
> Uint8List registrarFicheroOperation1(idAgente, idExpediente, registrarFicheroRequest)

Registrar fichero y obtener justificante

Registra un fichero en el procedimiento administrativo indicado. Devuelve el justificante de registro como fichero PDF firmado o justificante de envío.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getDocumentacionApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final RegistrarFicheroRequest registrarFicheroRequest = {"confirmarProcedimiento":{"procedimiento":{"idunico":"03874761C_171447919011019","tipoprocedimiento":"020","unidadorganica":"999999","consejeria":"001003","provincia":"12","noexpediente":"EXP-2024-00123","registro":{},"identificacion":{"category":"NIF","nifcif":"99999999R"},"identificacionrep":{},"asunto":"S020","asudescripcion":"","source":"TRAM","datossolicitante":{"nombre":"Juan García","apellido1":"López","apellido2":"Martínez","entidad":"","domicilio":"Calle Mayor","numero":"1","poblacion":"Toledo","provincia":"Toledo","codigopostal":"45000"},"datosprocedimiento":null,"datospago":{},"adjuntos":{"adjunto":[]},"firma":""},"pdatos":{"asuid":"SIM2","descrip":"CREACION Y REGULACION DEL REGISTRO DE INSTALACIONES DE DISTRIBUCION AL POR MENOR DE CARBURANTES Y COMBUSTIBLES PETROLIFEROS","uniorg":"010036","numdoc":"99999999R","nombre":"Juan García","apellido1":"López","apellido2":"Martínez","idunico":"03874761C_171447919011019"}},"oficinaTramitadora":"Oficina1","consejeriaTramitadora":"UAT-Consejeria de Medio ambiente","procedimiento":"Procedimiento1","fechaInicioTramitacion":"2022-01-01 22:30","fechaCierreTramitacion":"2022-01-31 21:15","estadoTramitacion":"En curso","documentos":[{"nombre":"testfile.pdf","algoritmo":"SHA-512","hash":"3452345235rtert45dfadfadfa43342y365u65u96ijhuu8iuu","fileSize":"80kb"}],"xmlRegistro":{"xmlClave":"xmlClave"},"esPorContraste":true,"datosRepresentante":{"nombre":"Tercero","apellido1":"TER-APE1","apellido2":"TER-APE2","nifcif":"05915863X","tipodoc":"NIF"}}; // RegistrarFicheroRequest | Datos del procedimiento y documentos a registrar. Incluye información del procedimiento, solicitante, documentos adjuntos y datos de firma.

try {
    final response = api.registrarFicheroOperation1(idAgente, idExpediente, registrarFicheroRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DocumentacionApi->registrarFicheroOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **registrarFicheroRequest** | [**RegistrarFicheroRequest**](RegistrarFicheroRequest.md)| Datos del procedimiento y documentos a registrar. Incluye información del procedimiento, solicitante, documentos adjuntos y datos de firma. | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

