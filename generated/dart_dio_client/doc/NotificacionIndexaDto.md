# espacio_ciudadano_api.model.NotificacionIndexaDto

## Load the model package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**concepto** | **String** | Concepto o asunto de la notificación | [optional] 
**fechaCaducidad** | [**DateTime**](DateTime.md) | Fecha límite para acceder a la notificación antes de que expire | [optional] 
**idNotificacion** | **int** | Identificador único de la notificación | [optional] 
**procedimientoAdministrativo** | [**ProcedimientoAdministrativoIndexaDto**](ProcedimientoAdministrativoIndexaDto.md) |  | [optional] 
**sistemaOrigen** | **String** | Código del sistema origen que generó la notificación | [optional] 
**unidadOrganica** | [**UnidadOrganicaIndexaDto**](UnidadOrganicaIndexaDto.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


