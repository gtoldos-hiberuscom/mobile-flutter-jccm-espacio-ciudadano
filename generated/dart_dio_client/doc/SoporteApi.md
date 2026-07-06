# espacio_ciudadano_api.api.SoporteApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**crearTareaSoporte**](SoporteApi.md#creartareasoporte) | **POST** /api/v1/soporte | Crear tarea de soporte/incidencia


# **crearTareaSoporte**
> Respuesta crearTareaSoporte(datos, adjunto)

Crear tarea de soporte/incidencia

Crea una nueva tarea de soporte o incidencia en el sistema SIGUE. Permite adjuntar un archivo opcional (captura, documento, etc.). El campo 'datos' debe ser un JSON con los datos de la incidencia.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getSoporteApi();
final String datos = datos_example; // String | Campo obligatorio. JSON con los datos de la incidencia: asunto, descripcion, email, nombreApellidos (opcional). Ejemplo: {\\\"asunto\\\":\\\"Error al descargar documento\\\",\\\"descripcion\\\":\\\"Al intentar descargar el documento adjunto de mi expediente DRG-TO/2024/000123, aparece un error 500.\\\",\\\"email\\\":\\\"ciudadano@ejemplo.com\\\",\\\"nombreApellidos\\\":\\\"Juan García López\\\"}
final MultipartFile adjunto = BINARY_DATA_HERE; // MultipartFile | Archivo adjunto opcional (imagen, PDF, etc.)

try {
    final response = api.crearTareaSoporte(datos, adjunto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SoporteApi->crearTareaSoporte: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **datos** | **String**| Campo obligatorio. JSON con los datos de la incidencia: asunto, descripcion, email, nombreApellidos (opcional). Ejemplo: {\\\"asunto\\\":\\\"Error al descargar documento\\\",\\\"descripcion\\\":\\\"Al intentar descargar el documento adjunto de mi expediente DRG-TO/2024/000123, aparece un error 500.\\\",\\\"email\\\":\\\"ciudadano@ejemplo.com\\\",\\\"nombreApellidos\\\":\\\"Juan García López\\\"} | 
 **adjunto** | **MultipartFile**| Archivo adjunto opcional (imagen, PDF, etc.) | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

