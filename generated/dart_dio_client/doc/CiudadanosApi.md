# espacio_ciudadano_api.api.CiudadanosApi

## Load the API package
```dart
import 'package:espacio_ciudadano_api/api.dart';
```

All URIs are relative to *https://fachada-sede-api-pre.cm-pre.jccm.es*

Method | HTTP request | Description
------------- | ------------- | -------------
[**actualizarClausulas**](CiudadanosApi.md#actualizarclausulas) | **PATCH** /api/v1/ciudadanos/{idAgente}/clausulas | Actualizar las cláusulas de consentimiento de un agente
[**actualizarContactoRegistroPoblacional**](CiudadanosApi.md#actualizarcontactoregistropoblacional) | **PATCH** /api/v1/ciudadanos/{id}/contacto-registro-poblacional | Actualizar datos de contacto del ciudadano en Registro Poblacional
[**actualizarListaHechos**](CiudadanosApi.md#actualizarlistahechos) | **PATCH** /api/v1/ciudadanos/{idAgente}/hechos | Actualizar los hechos vitales seleccionados por un agente
[**citasFuturas1**](CiudadanosApi.md#citasfuturas1) | **GET** /api/v1/ciudadanos/{numDocumento}/salud/primaria-citas-pendientes | Consultar citas futuras del SESCAM
[**citasHospitalariasPasadas**](CiudadanosApi.md#citashospitalariaspasadas) | **GET** /api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-pasadas | Consultar citas hospitalarias pasadas del ciudadano
[**citasHospitalariasPasadas1**](CiudadanosApi.md#citashospitalariaspasadas1) | **GET** /api/v1/ciudadanos/{idAgente}/citas-hospitalarias-pasadas | Consultar citas hospitalarias pasadas del ciudadano
[**citasHospitalariasPendientes**](CiudadanosApi.md#citashospitalariaspendientes) | **GET** /api/v1/ciudadanos/{idAgente}/citas-hospitalarias-pendientes | Consultar citas hospitalarias pendientes del ciudadano
[**citasHospitalariasPendientes1**](CiudadanosApi.md#citashospitalariaspendientes1) | **GET** /api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-pendientes | Consultar citas hospitalarias pendientes del ciudadano
[**citasPasadas**](CiudadanosApi.md#citaspasadas) | **GET** /api/v1/ciudadanos/{numDocumento}/salud/primaria-citas-pasadas | Consultar historial de citas pasadas del SESCAM
[**crearTareaSoporte1**](CiudadanosApi.md#creartareasoporte1) | **POST** /api/v1/ciudadanos/{idAgente}/soporte | Crear tarea de soporte/incidencia
[**descargarDocumento**](CiudadanosApi.md#descargardocumento) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/documentos/{orden} | Descargar documento de una notificación
[**descargarJustificante**](CiudadanosApi.md#descargarjustificante) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/justificante | Descargar justificante de una notificación
[**eliminarPreferencias1**](CiudadanosApi.md#eliminarpreferencias1) | **DELETE** /api/v1/ciudadanos/{idAgente}/preferencias | Eliminar preferencias y configuración de hechos vitales de un agente
[**enviarClausulas**](CiudadanosApi.md#enviarclausulas) | **POST** /api/v1/ciudadanos/{idAgente}/clausulas | Dar de alta las cláusulas de consentimiento de un agente
[**getCipFromNif1**](CiudadanosApi.md#getcipfromnif1) | **GET** /api/v1/ciudadanos/{numDocumento}/salud/cip | Obtener CIP a partir del NIF
[**getDatosCatastrales1**](CiudadanosApi.md#getdatoscatastrales1) | **POST** /api/v1/ciudadanos/{numDocumento}/vivienda/datos-catastrales | Obtener datos catastrales
[**getDatosResidencia1**](CiudadanosApi.md#getdatosresidencia1) | **POST** /api/v1/ciudadanos/{numDocumento}/vivienda/datos-residencia | Obtener datos de residencia (INE)
[**getDemandanteEmpleoFechaActual1**](CiudadanosApi.md#getdemandanteempleofechaactual1) | **POST** /api/v1/ciudadanos/{numDocumento}/empleo/demandante-empleo-fecha-actual | Consultar situacion de demandante de empleo a fecha actual
[**getIniProc1**](CiudadanosApi.md#getiniproc1) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente}/ficheros/iniciar | Iniciar procedimiento administrativo
[**getListaVehiculos1**](CiudadanosApi.md#getlistavehiculos1) | **POST** /api/v1/ciudadanos/{numDocumento}/vehiculos | Consultar listado de vehiculos de un ciudadano
[**getServiciosSegmentados1**](CiudadanosApi.md#getserviciossegmentados1) | **GET** /api/v1/ciudadanos/{idAgente}/recomendaciones | Obtener servicios segmentados por hechos vitales
[**getTitulosNoUniversitarios1**](CiudadanosApi.md#gettitulosnouniversitarios1) | **POST** /api/v1/ciudadanos/{numDocumento}/educacion/titulos-no-universitarios | Obtener titulos no universitarios
[**getTitulosUniversitarios1**](CiudadanosApi.md#gettitulosuniversitarios1) | **POST** /api/v1/ciudadanos/{numDocumento}/educacion/titulos-universitarios | Obtener titulos universitarios
[**miSubirAdjuntoSinFirmaOperation1**](CiudadanosApi.md#misubiradjuntosinfirmaoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente}/ficheros | Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma
[**modificarCiudadano**](CiudadanosApi.md#modificarciudadano) | **PUT** /api/v1/ciudadanos/{id}/contacto | Modificar el contacto de un ciudadano en Notifica
[**myPubliNumRegOperation1**](CiudadanosApi.md#mypublinumregoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/registros/{idRegistro} | Consultar un expediente de publicación por número de registro
[**myPubliSelecByNifTipoProcEntradaOperation**](CiudadanosApi.md#mypubliselecbyniftipoprocentradaoperation) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/listado-registro-entrada | Consultar registros de entrada por documento del ciudadano
[**myPubliSelecByNifTipoProcExpOperation1**](CiudadanosApi.md#mypubliselecbyniftipoprocexpoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes | Consultar expedientes por documento del ciudadano
[**myPubliSelecByNifTipoProcRegistrosEntradaOperation1**](CiudadanosApi.md#mypubliselecbyniftipoprocregistrosentradaoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/registros | Busqueda de registros por tipo
[**myPubliSelecByNifTipoProcSalidaOperation1**](CiudadanosApi.md#mypubliselecbyniftipoprocsalidaoperation1) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/listado-registro-salida | Consultar registros de salida por documento del ciudadano
[**myPubliSelecByNumExpOperation**](CiudadanosApi.md#mypubliselecbynumexpoperation) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente} | Consultar un expediente de publicación por número de expediente
[**obtenerCarnetJoven**](CiudadanosApi.md#obtenercarnetjoven) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/joven | Obtener carné joven digital
[**obtenerCiudadano**](CiudadanosApi.md#obtenerciudadano) | **GET** /api/v1/ciudadanos/{id}/contacto | Obtener contacto de un ciudadano registrado en Notifica
[**obtenerClausulasPorAgente**](CiudadanosApi.md#obtenerclausulasporagente) | **GET** /api/v1/ciudadanos/{idAgente}/clausulas | Obtener cláusulas de consentimiento asociadas a un agente
[**obtenerContactoRegistroPoblacional**](CiudadanosApi.md#obtenercontactoregistropoblacional) | **GET** /api/v1/ciudadanos/{id}/contacto-registro-poblacional | Consultar datos de contacto del ciudadano en Registro Poblacional
[**obtenerDatosAtencionDependenciaIntermediacion**](CiudadanosApi.md#obtenerdatosatenciondependenciaintermediacion) | **POST** /api/v1/ciudadanos/{idAgente}/bienestar-social/atencion-dependencia | Obtener datos de atencion a la dependencia
[**obtenerDatosDiscapacidad1**](CiudadanosApi.md#obtenerdatosdiscapacidad1) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/discapacidad | Obtener datos del carné de discapacidad
[**obtenerDatosDiscapacidadIntermediacion**](CiudadanosApi.md#obtenerdatosdiscapacidadintermediacion) | **POST** /api/v1/ciudadanos/{id}/bienestar-social/discapacidad | Obtener datos de discapacidad por intermediación
[**obtenerDatosFamiliaNumerosa**](CiudadanosApi.md#obtenerdatosfamilianumerosa) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/familia-numerosa | Obtener datos del carné de familia numerosa
[**obtenerDatosFamiliaNumerosaIntermediacion**](CiudadanosApi.md#obtenerdatosfamilianumerosaintermediacion) | **POST** /api/v1/ciudadanos/{numDocumento}/bienestar-social/familia-numerosa | Obtener datos de familia numerosa por intermediación
[**obtenerDatosTarjetaEstacionamientoIntermediacion1**](CiudadanosApi.md#obtenerdatostarjetaestacionamientointermediacion1) | **POST** /api/v1/ciudadanos/{idAgente}/bienestar-social/tarjeta-estacionamiento | Obtener datos de la tarjeta de estacionamiento para personas con discapacidad
[**obtenerDatosTermalismoIntermediacion**](CiudadanosApi.md#obtenerdatostermalismointermediacion) | **POST** /api/v1/ciudadanos/{idAgente}/bienestar-social/termalismo | Obtener datos del último balneario adjudicado del programa de termalismo
[**obtenerEventosAgenda1**](CiudadanosApi.md#obtenereventosagenda1) | **GET** /api/v1/ciudadanos/{idAgente}/eventos/{periodo} | Obtener eventos de la Agenda
[**obtenerListaHechosByIdAgente**](CiudadanosApi.md#obtenerlistahechosbyidagente) | **GET** /api/v1/ciudadanos/{idAgente}/hechos | Obtener lista de hechos vitales por agente
[**obtenerNotificacion**](CiudadanosApi.md#obtenernotificacion) | **GET** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId} | Obtener una notificación concreta de un ciudadano
[**obtenerNotificacionesCiudadano**](CiudadanosApi.md#obtenernotificacionesciudadano) | **GET** /api/v1/ciudadanos/{id}/notificaciones | Obtener notificaciones de un ciudadano
[**obtenerOfertasEmpleoInscritas1**](CiudadanosApi.md#obtenerofertasempleoinscritas1) | **POST** /api/v1/ciudadanos/{idAgente}/empleo/ofertas | Obtener ofertas de empleo inscritas
[**obtenerPdf**](CiudadanosApi.md#obtenerpdf) | **POST** /api/v1/ciudadanos/{dni}/carnet-digital/joven/pdf | Obtener PDF del carné joven digital
[**obtenerPkPass**](CiudadanosApi.md#obtenerpkpass) | **POST** /api/v1/ciudadanos/{dni}/carnet-digital/joven/pkpass | Obtener PKPass del carné joven digital
[**obtenerPkPassDiscapacidad**](CiudadanosApi.md#obtenerpkpassdiscapacidad) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/discapacidad/pkpass | Obtener PKPass del carné de discapacidad
[**obtenerPkPassFamiliaNumerosa**](CiudadanosApi.md#obtenerpkpassfamilianumerosa) | **GET** /api/v1/ciudadanos/{dni}/carnet-digital/familia-numerosa/pkpass | Obtener PKPass del carné de familia numerosa
[**obtenerQr**](CiudadanosApi.md#obtenerqr) | **POST** /api/v1/ciudadanos/{dni}/carnet-digital/joven/qr | Obtener QR del carné joven digital
[**refrescarAgendaEvents1**](CiudadanosApi.md#refrescaragendaevents1) | **GET** /api/v1/ciudadanos/{idAgente}/eventos/refrescar | Refrescar eventos de la Agenda por idAgente
[**registrarCiudadano**](CiudadanosApi.md#registrarciudadano) | **POST** /api/v1/ciudadanos/{id}/contacto | Registrar el contacto de un ciudadano en Notifica
[**registrarFicheroOperation**](CiudadanosApi.md#registrarficherooperation) | **POST** /api/v1/ciudadanos/{idAgente}/expedientes/{idExpediente}/ficheros/registrar | Registrar fichero y obtener justificante
[**transicionNotificacion**](CiudadanosApi.md#transicionnotificacion) | **POST** /api/v1/ciudadanos/{id}/notificaciones/{notificacionId}/comparecer | Realizar una transición sobre una notificación


# **actualizarClausulas**
> Respuesta actualizarClausulas(idAgente, clausulasAgente, authorization)

Actualizar las cláusulas de consentimiento de un agente

Actualiza el estado de aceptación de las cláusulas de consentimiento ya registradas para el ciudadano. A diferencia del alta (POST), este endpoint modifica cláusulas existentes. Recibe el identificador del agente y la lista completa de cláusulas con su versión y nuevo estado de selección. Devuelve true si la actualización se realizó correctamente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final ClausulasAgente clausulasAgente = {"idAgente":"PER9999927","clausulas":[{"idClausula":"001","version":1,"seleccionado":true},{"idClausula":"002","version":1,"seleccionado":true},{"idClausula":"003","version":1,"seleccionado":true},{"idClausula":"004","version":1,"seleccionado":false}]}; // ClausulasAgente | Cuerpo de la petición con el identificador del agente y la lista de cláusulas a actualizar. Cada cláusula incluye su identificador, versión y nuevo estado de selección (true=aceptada, false=rechazada).
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.actualizarClausulas(idAgente, clausulasAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->actualizarClausulas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **clausulasAgente** | [**ClausulasAgente**](ClausulasAgente.md)| Cuerpo de la petición con el identificador del agente y la lista de cláusulas a actualizar. Cada cláusula incluye su identificador, versión y nuevo estado de selección (true=aceptada, false=rechazada). | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **actualizarContactoRegistroPoblacional**
> Respuesta actualizarContactoRegistroPoblacional(id, contactoRegistroPoblacionalRequestDto, authorization)

Actualizar datos de contacto del ciudadano en Registro Poblacional

Actualiza los datos de contacto (correo y/o teléfono) del ciudadano en el Registro Poblacional. El body debe contener los campos a actualizar. Requiere autenticación mediante token JWT y que el NIF del token coincida con el ciudadano a modificar. Si el servicio externo devuelve un error, se propagará el mismo código y mensaje en la respuesta.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano
final ContactoRegistroPoblacionalRequestDto contactoRegistroPoblacionalRequestDto = {"correo":"correo_nuevo@gmail.com","telefono":"655342212"}; // ContactoRegistroPoblacionalRequestDto | Datos de contacto a actualizar
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login

try {
    final response = api.actualizarContactoRegistroPoblacional(id, contactoRegistroPoblacionalRequestDto, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->actualizarContactoRegistroPoblacional: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano | 
 **contactoRegistroPoblacionalRequestDto** | [**ContactoRegistroPoblacionalRequestDto**](ContactoRegistroPoblacionalRequestDto.md)| Datos de contacto a actualizar | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **actualizarListaHechos**
> Respuesta actualizarListaHechos(idAgente, listaHechosAgente, authorization)

Actualizar los hechos vitales seleccionados por un agente

Actualiza la lista de hechos vitales seleccionados por el ciudadano. Recibe el identificador del agente y la lista completa de hechos vitales con su estado de selección. Solo los hechos con seleccionado=true quedarán activos para el agente. Devuelve true si la actualización se realizó correctamente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final ListaHechosAgente listaHechosAgente = {"idAgente":"PER9999927","listaHechos":[{"idHecho":1,"seleccionado":true},{"idHecho":3,"seleccionado":true},{"idHecho":17,"seleccionado":true},{"idHecho":19,"seleccionado":true}]}; // ListaHechosAgente | Cuerpo de la petición con el identificador del agente y la lista de hechos vitales a actualizar. Cada hecho incluye su identificador y el estado de selección (true=activo, false=inactivo).
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.actualizarListaHechos(idAgente, listaHechosAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->actualizarListaHechos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **listaHechosAgente** | [**ListaHechosAgente**](ListaHechosAgente.md)| Cuerpo de la petición con el identificador del agente y la lista de hechos vitales a actualizar. Cada hecho incluye su identificador y el estado de selección (true=activo, false=inactivo). | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasFuturas1**
> Respuesta citasFuturas1(numDocumento, authorization)

Consultar citas futuras del SESCAM

Obtiene el listado de citas médicas futuras programadas en el Servicio de Salud de Castilla-La Mancha (SESCAM) para el ciudadano identificado por su número de documento. Las citas están ordenadas por fecha y hora ascendente.(Mas cercana a mas lejana en el futuro)Requiere que el usuario tenga marcada la cláusula de consentimiento correspondiente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 12345678Z; // String | Número de documento de identidad del ciudadano (NIF/NIE)
final String authorization = Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...; // String | Token de autorización Bearer JWT

try {
    final response = api.citasFuturas1(numDocumento, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasFuturas1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Número de documento de identidad del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token de autorización Bearer JWT | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasHospitalariasPasadas**
> Respuesta citasHospitalariasPasadas(idAgente, authorization)

Consultar citas hospitalarias pasadas del ciudadano

Obtiene el listado de citas hospitalarias pasadas de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = 12345678A; // String | Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE).
final String authorization = authorization_example; // String | Token de autorización Bearer para autenticar la petición.

try {
    final response = api.citasHospitalariasPasadas(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasHospitalariasPasadas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE). | 
 **authorization** | **String**| Token de autorización Bearer para autenticar la petición. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasHospitalariasPasadas1**
> Respuesta citasHospitalariasPasadas1(idAgente, authorization)

Consultar citas hospitalarias pasadas del ciudadano

Obtiene el listado de citas hospitalarias pasadas de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = 12345678A; // String | Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE).
final String authorization = authorization_example; // String | Token de autorización Bearer para autenticar la petición.

try {
    final response = api.citasHospitalariasPasadas1(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasHospitalariasPasadas1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE). | 
 **authorization** | **String**| Token de autorización Bearer para autenticar la petición. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasHospitalariasPendientes**
> Respuesta citasHospitalariasPendientes(idAgente, authorization)

Consultar citas hospitalarias pendientes del ciudadano

Obtiene el listado de citas hospitalarias pendientes de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = 12345678A; // String | Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE).
final String authorization = authorization_example; // String | Token de autorización Bearer para autenticar la petición.

try {
    final response = api.citasHospitalariasPendientes(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasHospitalariasPendientes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE). | 
 **authorization** | **String**| Token de autorización Bearer para autenticar la petición. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasHospitalariasPendientes1**
> Respuesta citasHospitalariasPendientes1(idAgente, authorization)

Consultar citas hospitalarias pendientes del ciudadano

Obtiene el listado de citas hospitalarias pendientes de un ciudadano identificado por su NIF/NIE. Requiere que el ciudadano tenga marcada la cláusula de consentimiento para acceso a datos sanitarios (SESCAM).

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = 12345678A; // String | Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE).
final String authorization = authorization_example; // String | Token de autorización Bearer para autenticar la petición.

try {
    final response = api.citasHospitalariasPendientes1(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasHospitalariasPendientes1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Número de documento de identidad del ciudadano (NIF o NIE). Formato: 8 dígitos + letra (NIF) o letra + 7 dígitos + letra (NIE). | 
 **authorization** | **String**| Token de autorización Bearer para autenticar la petición. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **citasPasadas**
> Respuesta citasPasadas(numDocumento, pagina, authorization)

Consultar historial de citas pasadas del SESCAM

Obtiene el historial paginado de citas médicas pasadas en el Servicio de Salud de Castilla-La Mancha (SESCAM) para el ciudadano identificado por su número de documento. Las citas están ordenadas por fecha y hora descendente. (Mas cercana a mas lejana en el pasado)Permite consultar el histórico de visitas médicas realizadas con soporte de paginación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 12345678Z; // String | Número de documento de identidad del ciudadano (NIF/NIE)
final int pagina = 0; // int | Número de página para la paginación de resultados (comienza en 0)
final String authorization = Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...; // String | Token de autorización Bearer JWT

try {
    final response = api.citasPasadas(numDocumento, pagina, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->citasPasadas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Número de documento de identidad del ciudadano (NIF/NIE) | 
 **pagina** | **int**| Número de página para la paginación de resultados (comienza en 0) | [optional] [default to 0]
 **authorization** | **String**| Token de autorización Bearer JWT | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **crearTareaSoporte1**
> Respuesta crearTareaSoporte1(idAgente, datos, adjunto)

Crear tarea de soporte/incidencia

Crea una nueva tarea de soporte o incidencia en el sistema SIGUE. Permite adjuntar un archivo opcional (captura, documento, etc.). El campo 'datos' debe ser un JSON con los datos de la incidencia.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String datos = datos_example; // String | Campo obligatorio. JSON con los datos de la incidencia: asunto, descripcion, email, nombreApellidos (opcional). Ejemplo: {\\\"asunto\\\":\\\"Error al descargar documento\\\",\\\"descripcion\\\":\\\"Al intentar descargar el documento adjunto de mi expediente DRG-TO/2024/000123, aparece un error 500.\\\",\\\"email\\\":\\\"ciudadano@ejemplo.com\\\",\\\"nombreApellidos\\\":\\\"Juan García López\\\"}
final MultipartFile adjunto = BINARY_DATA_HERE; // MultipartFile | Archivo adjunto opcional (imagen, PDF, etc.)

try {
    final response = api.crearTareaSoporte1(idAgente, datos, adjunto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->crearTareaSoporte1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
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

# **descargarDocumento**
> Uint8List descargarDocumento(id, notificacionId, orden, authorization, sisOrigen, origen)

Descargar documento de una notificación

Descarga un documento adjunto específico de una notificación electrónica identificado por su orden. Los documentos pueden ser resoluciones, anexos o cualquier contenido notificado al ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final int orden = 1; // int | Número de orden del documento dentro de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.descargarDocumento(id, notificacionId, orden, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->descargarDocumento: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **orden** | **int**| Número de orden del documento dentro de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **descargarJustificante**
> Uint8List descargarJustificante(id, notificacionId, authorization, sisOrigen, origen)

Descargar justificante de una notificación

Descarga el documento PDF que acredita el puesta a disposición, acceso o rechazo de una notificación electrónica. El justificante tiene valor probatorio conforme a la normativa de notificaciones electrónicas.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.descargarJustificante(id, notificacionId, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->descargarJustificante: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **eliminarPreferencias1**
> Respuesta eliminarPreferencias1(idAgente, authorization)

Eliminar preferencias y configuración de hechos vitales de un agente

Elimina las preferencias del ciudadano asociadas al módulo de hechos vitales (hechos seleccionados y configuración relacionada). Tras la operación, el agente queda sin preferencias guardadas y puede volver a configurarlas desde cero. Devuelve true si la eliminación se realiza correctamente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = PER9999927; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.eliminarPreferencias1(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->eliminarPreferencias1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **enviarClausulas**
> Respuesta enviarClausulas(idAgente, clausulasAgente, authorization)

Dar de alta las cláusulas de consentimiento de un agente

Registra por primera vez (alta inicial) las cláusulas de consentimiento seleccionadas por el ciudadano. Recibe el identificador del agente y la lista de cláusulas con su versión y estado de aceptación. Devuelve true si el registro se ha realizado correctamente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final ClausulasAgente clausulasAgente = {"idAgente":"PER9999927","clausulas":[{"idClausula":"001","version":1,"seleccionado":true},{"idClausula":"002","version":1,"seleccionado":false},{"idClausula":"003","version":1,"seleccionado":true},{"idClausula":"004","version":1,"seleccionado":false}]}; // ClausulasAgente | Cuerpo de la petición con el identificador del agente y la lista de cláusulas a registrar. Cada cláusula incluye su identificador, versión y estado de selección (true=aceptada, false=rechazada).
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.enviarClausulas(idAgente, clausulasAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->enviarClausulas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **clausulasAgente** | [**ClausulasAgente**](ClausulasAgente.md)| Cuerpo de la petición con el identificador del agente y la lista de cláusulas a registrar. Cada cláusula incluye su identificador, versión y estado de selección (true=aceptada, false=rechazada). | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCipFromNif1**
> Respuesta getCipFromNif1(numDocumento, authorization)

Obtener CIP a partir del NIF

Servicio traductor que obtiene el Código de Identificación Personal (CIP) del SESCAM a partir del número de documento de identidad (NIF/NIE) del ciudadano. El CIP es el identificador único del paciente en el sistema sanitario de Castilla-La Mancha.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 12345678Z; // String | Número de documento de identidad del ciudadano (NIF/NIE)
final String authorization = Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...; // String | Token de autorización Bearer JWT

try {
    final response = api.getCipFromNif1(numDocumento, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getCipFromNif1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Número de documento de identidad del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token de autorización Bearer JWT | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDatosCatastrales1**
> Respuesta getDatosCatastrales1(numDocumento, DTCTROCDATREQ, authorization)

Obtener datos catastrales

Consulta los datos catastrales del ciudadano en el servicio de Catastro.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTCTROCDATREQ DTCTROCDATREQ = {"tipdoc":"NIF","docu":"99999999R"}; // DTCTROCDATREQ | Datos de entrada para la consulta catastral.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getDatosCatastrales1(numDocumento, DTCTROCDATREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getDatosCatastrales1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTCTROCDATREQ** | [**DTCTROCDATREQ**](DTCTROCDATREQ.md)| Datos de entrada para la consulta catastral. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDatosResidencia1**
> Respuesta getDatosResidencia1(numDocumento, DTINECDRFREQ, authorization)

Obtener datos de residencia (INE)

Consulta los datos de residencia del ciudadano en el servicio INE. El documento del cuerpo se valida frente al token y al parámetro de ruta.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTINECDRFREQ DTINECDRFREQ = {"tipodoc":"NIF","docu":"99999999R"}; // DTINECDRFREQ | Datos de entrada para la consulta de residencia.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getDatosResidencia1(numDocumento, DTINECDRFREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getDatosResidencia1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTINECDRFREQ** | [**DTINECDRFREQ**](DTINECDRFREQ.md)| Datos de entrada para la consulta de residencia. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDemandanteEmpleoFechaActual1**
> Respuesta getDemandanteEmpleoFechaActual1(numDocumento, DTSEPESVDIDEFAREQ, authorization)

Consultar situacion de demandante de empleo a fecha actual

Consulta en el servicio SEPE si el ciudadano figura como demandante de empleo en la fecha actual y devuelve el resultado de la tramitacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 12345678Z; // String | Documento identificativo del ciudadano.
final DTSEPESVDIDEFAREQ DTSEPESVDIDEFAREQ = {"tipodoc":"DNI","docu":"92920000T","nombretitular":"JUAN","apellido1TITULAR":"Perez","apellido2TITULAR":"Sanchez"}; // DTSEPESVDIDEFAREQ | Datos de entrada para la consulta SEPE. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getDemandanteEmpleoFechaActual1(numDocumento, DTSEPESVDIDEFAREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getDemandanteEmpleoFechaActual1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano. | 
 **DTSEPESVDIDEFAREQ** | [**DTSEPESVDIDEFAREQ**](DTSEPESVDIDEFAREQ.md)| Datos de entrada para la consulta SEPE. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getIniProc1**
> Respuesta getIniProc1(idAgente, idExpediente, dTProcedimiento)

Iniciar procedimiento administrativo

Inicia un nuevo procedimiento administrativo en el sistema CESAR. Valida los datos del procedimiento y crea el registro correspondiente.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final DTProcedimiento dTProcedimiento = {"idunico":"03874761C_171447919011019","tipoprocedimiento":"020","unidadorganica":"012848","consejeria":"001952","provincia":"","noexpediente":"EXP-2024-00789","registro":{"noregistro":null,"fecha":null},"identificacion":{"category":"NIF","nifcif":"99999999R"},"asunto":"","asudescripcion":"","source":"TRAM","datossolicitante":{"apellido1":"García","apellido2":"López","nombre":"Juan","codigopostal":"45000","domicilio":"Calle Mayor","entidad":"","numero":"1","poblacion":"Toledo","provincia":"Toledo"},"datospago":{},"adjuntos":{}}; // DTProcedimiento | Datos del procedimiento a iniciar. Incluye identificación del ciudadano, datos del solicitante y referencias administrativas.

try {
    final response = api.getIniProc1(idAgente, idExpediente, dTProcedimiento);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getIniProc1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **dTProcedimiento** | [**DTProcedimiento**](DTProcedimiento.md)| Datos del procedimiento a iniciar. Incluye identificación del ciudadano, datos del solicitante y referencias administrativas. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getListaVehiculos1**
> Respuesta getListaVehiculos1(numDocumento, DTDGTLISTADOVEHICULOSREQ, authorization)

Consultar listado de vehiculos de un ciudadano

Consulta en el servicio DGT el listado de vehiculos asociados a un ciudadano identificado por NIF y devuelve el resultado completo de la tramitacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 12345678Z; // String | Documento identificativo del ciudadano.
final DTDGTLISTADOVEHICULOSREQ DTDGTLISTADOVEHICULOSREQ = {"tipodoc":"NIF","docu":"92920000T"}; // DTDGTLISTADOVEHICULOSREQ | Datos de entrada para la consulta DGT. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getListaVehiculos1(numDocumento, DTDGTLISTADOVEHICULOSREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getListaVehiculos1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano. | 
 **DTDGTLISTADOVEHICULOSREQ** | [**DTDGTLISTADOVEHICULOSREQ**](DTDGTLISTADOVEHICULOSREQ.md)| Datos de entrada para la consulta DGT. El campo DOCU se resuelve internamente a partir del token de seguridad del ciudadano. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getServiciosSegmentados1**
> Respuesta getServiciosSegmentados1(idAgente, operacion, size, page, ultimosDias, hechosvitales, authorization)

Obtener servicios segmentados por hechos vitales

Recupera los trámites y servicios disponibles segmentados según los hechos vitales seleccionados por el ciudadano. Permite filtrar por operación, paginación (size y page), rango de días recientes (ultimosDias) y una lista de identificadores de hechos vitales. Devuelve únicamente los trámites cuyo periodo de presentación esté activo o abierto permanentemente y que correspondan a los hechos vitales indicados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = PER9999927; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String operacion = todo; // String | Tipo de operación a realizar. Ejemplo: 'todo' para recuperar todos los trámites.
final String size = 10; // String | Número máximo de resultados por página. Ejemplo: 10
final String page = 0; // String | Número de página a recuperar (base 0). Ejemplo: 0
final String ultimosDias = 30; // String | Filtro de trámites publicados en los últimos N días. Ejemplo: 30
final BuiltList<int> hechosvitales = 1; // BuiltList<int> | Lista de identificadores de hechos vitales por los que filtrar los trámites. Ejemplo: [1]
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getServiciosSegmentados1(idAgente, operacion, size, page, ultimosDias, hechosvitales, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getServiciosSegmentados1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **operacion** | **String**| Tipo de operación a realizar. Ejemplo: 'todo' para recuperar todos los trámites. | [optional] 
 **size** | **String**| Número máximo de resultados por página. Ejemplo: 10 | [optional] 
 **page** | **String**| Número de página a recuperar (base 0). Ejemplo: 0 | [optional] 
 **ultimosDias** | **String**| Filtro de trámites publicados en los últimos N días. Ejemplo: 30 | [optional] 
 **hechosvitales** | [**BuiltList&lt;int&gt;**](int.md)| Lista de identificadores de hechos vitales por los que filtrar los trámites. Ejemplo: [1] | [optional] 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTitulosNoUniversitarios1**
> Respuesta getTitulosNoUniversitarios1(numDocumento, DTEDUTNUREQ, authorization)

Obtener titulos no universitarios

Consulta los titulos no universitarios del ciudadano en el servicio de Educacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTEDUTNUREQ DTEDUTNUREQ = {"tipodoc":"NIF","docu":"99999999R"}; // DTEDUTNUREQ | Datos de entrada para la consulta de titulos no universitarios.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getTitulosNoUniversitarios1(numDocumento, DTEDUTNUREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getTitulosNoUniversitarios1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTEDUTNUREQ** | [**DTEDUTNUREQ**](DTEDUTNUREQ.md)| Datos de entrada para la consulta de titulos no universitarios. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTitulosUniversitarios1**
> Respuesta getTitulosUniversitarios1(numDocumento, DTEDUTUOREQ, authorization)

Obtener titulos universitarios

Consulta los titulos universitarios del ciudadano en el servicio de Educacion.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = 99999999R; // String | Documento identificativo del ciudadano a consultar.
final DTEDUTUOREQ DTEDUTUOREQ = {"tipodoc":"NIF","docu":"99999999R"}; // DTEDUTUOREQ | Datos de entrada para la consulta de titulos universitarios.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.getTitulosUniversitarios1(numDocumento, DTEDUTUOREQ, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->getTitulosUniversitarios1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Documento identificativo del ciudadano a consultar. | 
 **DTEDUTUOREQ** | [**DTEDUTUOREQ**](DTEDUTUOREQ.md)| Datos de entrada para la consulta de titulos universitarios. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **miSubirAdjuntoSinFirmaOperation1**
> RESULTADOPROCEDIMIENTO miSubirAdjuntoSinFirmaOperation1(idAgente, idExpediente, ADJUNTO)

Servicio que permite subir al buzon de tramitacion un documento codificado en base64 sin firma

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final ADJUNTO ADJUNTO = ; // ADJUNTO | 

try {
    final response = api.miSubirAdjuntoSinFirmaOperation1(idAgente, idExpediente, ADJUNTO);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->miSubirAdjuntoSinFirmaOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **ADJUNTO** | [**ADJUNTO**](ADJUNTO.md)|  | 

### Return type

[**RESULTADOPROCEDIMIENTO**](RESULTADOPROCEDIMIENTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **modificarCiudadano**
> TerceroN2Dto modificarCiudadano(id, terceroN2Dto, authorization, sisOrigen, origen)

Modificar el contacto de un ciudadano en Notifica

Actualiza los datos de contacto (email, teléfono) de un tercero previamente registrado en Notifica. El ciudadano debe existir en el sistema. Requiere que el NIF del token coincida con el NIF a modificar.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final TerceroN2Dto terceroN2Dto = ; // TerceroN2Dto | Datos de contacto actualizados del ciudadano
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.modificarCiudadano(id, terceroN2Dto, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->modificarCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **terceroN2Dto** | [**TerceroN2Dto**](TerceroN2Dto.md)| Datos de contacto actualizados del ciudadano | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliNumRegOperation1**
> Respuesta myPubliNumRegOperation1(idAgente, idRegistro, ZCSRFCPUBLISELECTBYNUMREG)

Consultar un expediente de publicación por número de registro

Consulta el detalle de un expediente de publicación a partir del número de registro, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente, incluyendo datos identificativos, órgano gestor, estado de tramitación y relación de documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idRegistro = idRegistro_example; // String | 
final ZCSRFCPUBLISELECTBYNUMREG ZCSRFCPUBLISELECTBYNUMREG = {"pnumdoc":"99999999R","pregistro":"1103488/2024","ptipodoc":"NIF"}; // ZCSRFCPUBLISELECTBYNUMREG | Cuerpo de la petición con el número de documento, número de registro y tipo de documento del ciudadano para localizar el expediente.

try {
    final response = api.myPubliNumRegOperation1(idAgente, idRegistro, ZCSRFCPUBLISELECTBYNUMREG);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->myPubliNumRegOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idRegistro** | **String**|  | 
 **ZCSRFCPUBLISELECTBYNUMREG** | [**ZCSRFCPUBLISELECTBYNUMREG**](ZCSRFCPUBLISELECTBYNUMREG.md)| Cuerpo de la petición con el número de documento, número de registro y tipo de documento del ciudadano para localizar el expediente. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcEntradaOperation**
> Respuesta myPubliSelecByNifTipoProcEntradaOperation(idAgente, DTSELECTBYNIFV2REQ)

Consultar registros de entrada por documento del ciudadano

Consulta la lista de registros de entrada asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento ENTRADA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como ENTRADA.

try {
    final response = api.myPubliSelecByNifTipoProcEntradaOperation(idAgente, DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->myPubliSelecByNifTipoProcEntradaOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como ENTRADA. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcExpOperation1**
> Respuesta myPubliSelecByNifTipoProcExpOperation1(idAgente, DTSELECTBYNIFV2REQ)

Consultar expedientes por documento del ciudadano

Consulta la lista de expedientes asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento EXP y devuelve los expedientes localizados con información de tramitación, órgano responsable y documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como EXP.

try {
    final response = api.myPubliSelecByNifTipoProcExpOperation1(idAgente, DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->myPubliSelecByNifTipoProcExpOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como EXP. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcRegistrosEntradaOperation1**
> MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response myPubliSelecByNifTipoProcRegistrosEntradaOperation1(tipo, idAgente, DTSELECTBYNIFV2REQ)

Busqueda de registros por tipo

Devuelve los registros de tipo entrada para el NIF proporcionado. Se invoca mediante el mismo path con el parámetro query 'tipo=entrada'. Ejemplo: /ciudadanos/{idAgente}/registros?tipo=entrada.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String tipo = entrada; // String | Tipo de registros: entrada | salida
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA.

try {
    final response = api.myPubliSelecByNifTipoProcRegistrosEntradaOperation1(tipo, idAgente, DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->myPubliSelecByNifTipoProcRegistrosEntradaOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tipo** | **String**| Tipo de registros: entrada | salida | 
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA. | 

### Return type

[**MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response**](MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNifTipoProcSalidaOperation1**
> Respuesta myPubliSelecByNifTipoProcSalidaOperation1(idAgente, DTSELECTBYNIFV2REQ)

Consultar registros de salida por documento del ciudadano

Consulta la lista de registros de salida asociados al ciudadano según su tipo y número de documento. El endpoint fuerza internamente el tipo de procedimiento SALIDA y devuelve el listado de anotaciones del Registro Único con su información de tramitación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final DTSELECTBYNIFV2REQ DTSELECTBYNIFV2REQ = {"tipodocumento":"NIF","numerodocumento":"99999999R"}; // DTSELECTBYNIFV2REQ | Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA.

try {
    final response = api.myPubliSelecByNifTipoProcSalidaOperation1(idAgente, DTSELECTBYNIFV2REQ);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->myPubliSelecByNifTipoProcSalidaOperation1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **DTSELECTBYNIFV2REQ** | [**DTSELECTBYNIFV2REQ**](DTSELECTBYNIFV2REQ.md)| Cuerpo de la petición con tipo y número de documento del ciudadano. El tipo de procedimiento se establece internamente como SALIDA. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **myPubliSelecByNumExpOperation**
> Respuesta myPubliSelecByNumExpOperation(idAgente, idExpediente, ZCSRFCPUBLISELECTBYNUMEXP)

Consultar un expediente de publicación por número de expediente

Consulta el detalle de un expediente de publicación a partir del número de expediente, el tipo de documento y el número de documento del ciudadano. La respuesta devuelve la estructura completa del expediente con datos identificativos, estado, órgano gestor y documentos asociados.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final ZCSRFCPUBLISELECTBYNUMEXP ZCSRFCPUBLISELECTBYNUMEXP = {"pnumdoc":"03874761C","pnumexp":"S020/2024/0001-PR","ptipodoc":"NIF"}; // ZCSRFCPUBLISELECTBYNUMEXP | Cuerpo de la petición con número de documento, número de expediente y tipo de documento del ciudadano para localizar el expediente.

try {
    final response = api.myPubliSelecByNumExpOperation(idAgente, idExpediente, ZCSRFCPUBLISELECTBYNUMEXP);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->myPubliSelecByNumExpOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano). Ejemplo: PER9999927 | 
 **idExpediente** | **String**|  | 
 **ZCSRFCPUBLISELECTBYNUMEXP** | [**ZCSRFCPUBLISELECTBYNUMEXP**](ZCSRFCPUBLISELECTBYNUMEXP.md)| Cuerpo de la petición con número de documento, número de expediente y tipo de documento del ciudadano para localizar el expediente. | 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerCarnetJoven**
> Respuesta obtenerCarnetJoven(dni, authorization)

Obtener carné joven digital

Recupera los datos del carné joven digital asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerCarnetJoven(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerCarnetJoven: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerCiudadano**
> TerceroN2Dto obtenerCiudadano(id, authorization, sisOrigen, origen)

Obtener contacto de un ciudadano registrado en Notifica

Consulta los datos de contacto (email, teléfono) de un tercero previamente registrado en el sistema Notifica. Devuelve 404 si el ciudadano no está registrado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.obtenerCiudadano(id, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerClausulasPorAgente**
> Respuesta obtenerClausulasPorAgente(idAgente, authorization)

Obtener cláusulas de consentimiento asociadas a un agente

Recupera todas las cláusulas de consentimiento y preferencias asociadas a un agente (ciudadano). Devuelve una estructura con el identificador del agente, estado de cláusulas pendientes y un listado detallado de todas las cláusulas disponibles incluyendo su descripción, textos (breve y ampliado en HTML), versión y estado de selección actual.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = PER9998001; // String | Identificador único del agente (ciudadano) para el cual se recuperarán las cláusulas de consentimiento.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerClausulasPorAgente(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerClausulasPorAgente: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano) para el cual se recuperarán las cláusulas de consentimiento. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerContactoRegistroPoblacional**
> Respuesta obtenerContactoRegistroPoblacional(id, authorization)

Consultar datos de contacto del ciudadano en Registro Poblacional

Recupera los datos de contacto (correo electrónico y teléfono) y datos parciales de dirección del ciudadano en el Registro Poblacional identificado por su NIF/NIE. Requiere autenticación mediante token JWT y validación del NIF del token. En caso de error del servicio externo, la respuesta conservará el código y el mensaje proporcionado por dicho servicio.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login

try {
    final response = api.obtenerContactoRegistroPoblacional(id, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerContactoRegistroPoblacional: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosAtencionDependenciaIntermediacion**
> Respuesta obtenerDatosAtencionDependenciaIntermediacion(idAgente, baseRequestIntermediacion, authorization)

Obtener datos de atencion a la dependencia

Consulta la situacion actual del expediente y prestaciones de dependencia del ciudadano. La respuesta se muestra con la estructura completa Respuesta y el detalle interno de datos especificos.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de peticion para consultar datos de atencion a la dependencia por intermediacion.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosAtencionDependenciaIntermediacion(idAgente, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerDatosAtencionDependenciaIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de peticion para consultar datos de atencion a la dependencia por intermediacion. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosDiscapacidad1**
> Respuesta obtenerDatosDiscapacidad1(dni, authorization)

Obtener datos del carné de discapacidad

Recupera los datos del carné digital de discapacidad asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de discapacidad.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosDiscapacidad1(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerDatosDiscapacidad1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de discapacidad. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosDiscapacidadIntermediacion**
> Respuesta obtenerDatosDiscapacidadIntermediacion(id, baseRequestIntermediacion, authorization)

Obtener datos de discapacidad por intermediación

Consulta el servicio de intermediación para recuperar los datos del certificado de discapacidad del ciudadano.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{id}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de discapacidad por intermediación.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosDiscapacidadIntermediacion(id, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerDatosDiscapacidadIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{id}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de discapacidad por intermediación. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosa**
> Respuesta obtenerDatosFamiliaNumerosa(dni, authorization)

Obtener datos del carné de familia numerosa

Recupera los datos del carné digital de familia numerosa asociados al ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de familia numerosa.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerDatosFamiliaNumerosa(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerDatosFamiliaNumerosa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de familia numerosa. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosFamiliaNumerosaIntermediacion**
> Respuesta obtenerDatosFamiliaNumerosaIntermediacion(numDocumento, baseRequestIntermediacion, authorization)

Obtener datos de familia numerosa por intermediación

Consulta el servicio de intermediación para recuperar los datos del título de familia numerosa del ciudadano. Devuelve información detallada del título incluyendo categoría, vigencia, fecha de caducidad, número de hijos y datos de todos los beneficiarios (titular e hijos) con sus documentos de identidad y fecha de nacimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String numDocumento = numDocumento_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{numDocumento}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosFamiliaNumerosaIntermediacion(numDocumento, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerDatosFamiliaNumerosaIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **numDocumento** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{numDocumento}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de familia numerosa por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosTarjetaEstacionamientoIntermediacion1**
> Respuesta obtenerDatosTarjetaEstacionamientoIntermediacion1(idAgente, baseRequestIntermediacion, authorization)

Obtener datos de la tarjeta de estacionamiento para personas con discapacidad

Consulta la información de la tarjeta de estacionamiento en vigor de personas con discapacidad y movilidad reducida de Castilla-La Mancha. La respuesta incluye el identificador de la tarjeta, modalidad (Persona con Discapacidad o Movilidad Reducida), fechas de vigencia de inicio y fin, y demás datos asociados a la tarjeta.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de tarjeta de estacionamiento por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosTarjetaEstacionamientoIntermediacion1(idAgente, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerDatosTarjetaEstacionamientoIntermediacion1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de tarjeta de estacionamiento por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerDatosTermalismoIntermediacion**
> Respuesta obtenerDatosTermalismoIntermediacion(idAgente, baseRequestIntermediacion, authorization)

Obtener datos del último balneario adjudicado del programa de termalismo

Consulta el último balneario adjudicado en el programa de termalismo de Castilla-La Mancha para el ciudadano especificado. La respuesta incluye información detallada del balneario incluyendo su nombre, localidad, fechas de estancia programadas y otros datos de la adjudicación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de petición para consultar datos de termalismo por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerDatosTermalismoIntermediacion(idAgente, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerDatosTermalismoIntermediacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de petición para consultar datos de termalismo por intermediación. Campo obligatorio 'tipo' indica el tipo de petición (A=Consulta), 'idaut' es el identificador de autoridad que realiza la consulta, 'proc' es el código de procedimiento, 'tipodoc' es el tipo de documento del ciudadano (NIF/NIE), 'docu' es el número de documento, 'doc_funcionario' es el documento del funcionario que realiza la consulta y 'nombre_funcionario' es su nombre. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerEventosAgenda1**
> Respuesta obtenerEventosAgenda1(idAgente, periodo, authorization)

Obtener eventos de la Agenda

Obtiene los eventos de agenda de un agente para un periodo determinado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = PER9998003; // String | Identificador del agente/ciudadano sobre el que se consultan los eventos de agenda. Debe coincidir con el identificado en el token de seguridad.
final String periodo = TODOS, SEMANA, MES, ANIO; // String | Periodo de consulta de eventos de agenda enviado al servicio externo.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerEventosAgenda1(idAgente, periodo, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerEventosAgenda1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador del agente/ciudadano sobre el que se consultan los eventos de agenda. Debe coincidir con el identificado en el token de seguridad. | 
 **periodo** | **String**| Periodo de consulta de eventos de agenda enviado al servicio externo. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerListaHechosByIdAgente**
> Respuesta obtenerListaHechosByIdAgente(idAgente, authorization)

Obtener lista de hechos vitales por agente

Recupera la lista completa de hechos vitales (situaciones de vida) disponibles en el sistema para un agente específico (ciudadano). Los hechos vitales representan diferentes situaciones o circunstancias de la vida del ciudadano (tener hijos, buscar trabajo, jubilación, etc.). La respuesta incluye todos los hechos disponibles con su identificador, nombre descriptivo y estado de selección actual.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = PER9998003; // String | Identificador único del agente (ciudadano) para el cual se recuperará la lista de hechos vitales.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud.

try {
    final response = api.obtenerListaHechosByIdAgente(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerListaHechosByIdAgente: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador único del agente (ciudadano) para el cual se recuperará la lista de hechos vitales. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. Requerido para autenticar la solicitud. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerNotificacion**
> Respuesta obtenerNotificacion(id, notificacionId, authorization, sisOrigen, origen)

Obtener una notificación concreta de un ciudadano

Recupera el detalle completo de una notificación electrónica específica, incluyendo documentos adjuntos, histórico de estados e interesados. Aplica control de acceso para verificar que el ciudadano autenticado es interesado en la notificación.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.obtenerNotificacion(id, notificacionId, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerNotificacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerNotificacionesCiudadano**
> BuiltList<NotificacionIndexaDto> obtenerNotificacionesCiudadano(id, authorization, estado, page, size)

Obtener notificaciones de un ciudadano

Recupera el listado de notificaciones electrónicas asociadas a un ciudadano identificado por su NIF/NIE. Permite filtrar por estado y paginar los resultados. Requiere autenticación mediante token JWT y validación de la cláusula de consentimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String estado = estado_example; // String | Estado de las notificaciones a filtrar
final int page = 0; // int | Número de página para paginación (base 0)
final int size = 10; // int | Tamaño de página para paginación

try {
    final response = api.obtenerNotificacionesCiudadano(id, authorization, estado, page, size);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerNotificacionesCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **estado** | **String**| Estado de las notificaciones a filtrar | [optional] 
 **page** | **int**| Número de página para paginación (base 0) | [optional] 
 **size** | **int**| Tamaño de página para paginación | [optional] 

### Return type

[**BuiltList&lt;NotificacionIndexaDto&gt;**](NotificacionIndexaDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerOfertasEmpleoInscritas1**
> Respuesta obtenerOfertasEmpleoInscritas1(idAgente, baseRequestIntermediacion, authorization)

Obtener ofertas de empleo inscritas

Consulta las ofertas de empleo en las que el ciudadano figura inscrito. La respuesta se muestra con la estructura completa Respuesta y el listado de ofertas en datosespecificos.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/...
final BaseRequestIntermediacion baseRequestIntermediacion = {"tipo":"A","idaut":"ESP-CIUDADANO","proc":"JCCMEC","tipodoc":"NIF","docu":"99999999R","doc_funcionario":"00000000T","nombre_funcionario":"USUARIO TEST"}; // BaseRequestIntermediacion | Cuerpo de peticion para consultar ofertas de empleo inscritas por intermediacion.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerOfertasEmpleoInscritas1(idAgente, baseRequestIntermediacion, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerOfertasEmpleoInscritas1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador ciudadano en path cuando se usa ruta /ciudadanos/{idAgente}/... | 
 **baseRequestIntermediacion** | [**BaseRequestIntermediacion**](BaseRequestIntermediacion.md)| Cuerpo de peticion para consultar ofertas de empleo inscritas por intermediacion. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPdf**
> Respuesta obtenerPdf(dni, authorization)

Obtener PDF del carné joven digital

Genera el documento PDF del carné joven digital del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPdf(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerPdf: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPass**
> Respuesta obtenerPkPass(dni, authorization)

Obtener PKPass del carné joven digital

Genera el fichero PKPass del carné joven digital del ciudadano autenticado para su uso en wallet compatible.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPass(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerPkPass: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPassDiscapacidad**
> Respuesta obtenerPkPassDiscapacidad(dni, authorization)

Obtener PKPass del carné de discapacidad

Genera el fichero PKPass del carné digital de discapacidad del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de discapacidad.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPassDiscapacidad(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerPkPassDiscapacidad: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de discapacidad. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerPkPassFamiliaNumerosa**
> Respuesta obtenerPkPassFamiliaNumerosa(dni, authorization)

Obtener PKPass del carné de familia numerosa

Genera el fichero PKPass del carné digital de familia numerosa del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String dni = 12345678Z; // String | Documento identificativo del ciudadano titular del carné de familia numerosa.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerPkPassFamiliaNumerosa(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerPkPassFamiliaNumerosa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné de familia numerosa. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **obtenerQr**
> Respuesta obtenerQr(dni, authorization)

Obtener QR del carné joven digital

Genera el código QR asociado al carné joven digital del ciudadano autenticado.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String dni = 99999999R; // String | Documento identificativo del ciudadano titular del carné joven.
final String authorization = authorization_example; // String | Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.obtenerQr(dni, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->obtenerQr: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dni** | **String**| Documento identificativo del ciudadano titular del carné joven. | 
 **authorization** | **String**| Token JWT de autorización en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refrescarAgendaEvents1**
> Respuesta refrescarAgendaEvents1(idAgente, authorization)

Refrescar eventos de la Agenda por idAgente

Refresca los eventos de agenda del agente y devuelve el resumen del proceso.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = PER9998003; // String | Identificador del agente/ciudadano para el que se ejecuta el refresco de eventos de agenda.
final String authorization = authorization_example; // String | Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'.

try {
    final response = api.refrescarAgendaEvents1(idAgente, authorization);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->refrescarAgendaEvents1: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAgente** | **String**| Identificador del agente/ciudadano para el que se ejecuta el refresco de eventos de agenda. | 
 **authorization** | **String**| Token JWT de autorizacion en cabecera HTTP con formato 'Bearer <token>'. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registrarCiudadano**
> TerceroN2Dto registrarCiudadano(id, terceroN2Dto, authorization, sisOrigen, origen)

Registrar el contacto de un ciudadano en Notifica

Crea un nuevo registro de contacto (tercero) en el sistema Notifica para recibir notificaciones electrónicas. El NIF del ciudadano debe coincidir con el del token de autenticación. Requiere aceptación previa de la cláusula de consentimiento.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final TerceroN2Dto terceroN2Dto = ; // TerceroN2Dto | Datos de contacto del ciudadano a registrar en Notifica
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.registrarCiudadano(id, terceroN2Dto, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->registrarCiudadano: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **terceroN2Dto** | [**TerceroN2Dto**](TerceroN2Dto.md)| Datos de contacto del ciudadano a registrar en Notifica | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**TerceroN2Dto**](TerceroN2Dto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registrarFicheroOperation**
> Uint8List registrarFicheroOperation(idAgente, idExpediente, registrarFicheroRequest)

Registrar fichero y obtener justificante

Registra un fichero en el procedimiento administrativo indicado. Devuelve el justificante de registro como fichero PDF firmado o justificante de envío.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String idAgente = idAgente_example; // String | Identificador único del agente (ciudadano). Ejemplo: PER9999927
final String idExpediente = idExpediente_example; // String | 
final RegistrarFicheroRequest registrarFicheroRequest = {"confirmarProcedimiento":{"procedimiento":{"idunico":"03874761C_171447919011019","tipoprocedimiento":"020","unidadorganica":"999999","consejeria":"001003","provincia":"12","noexpediente":"EXP-2024-00123","registro":{},"identificacion":{"category":"NIF","nifcif":"99999999R"},"identificacionrep":{},"asunto":"S020","asudescripcion":"","source":"TRAM","datossolicitante":{"nombre":"Juan García","apellido1":"López","apellido2":"Martínez","entidad":"","domicilio":"Calle Mayor","numero":"1","poblacion":"Toledo","provincia":"Toledo","codigopostal":"45000"},"datosprocedimiento":null,"datospago":{},"adjuntos":{"adjunto":[]},"firma":""},"pdatos":{"asuid":"SIM2","descrip":"CREACION Y REGULACION DEL REGISTRO DE INSTALACIONES DE DISTRIBUCION AL POR MENOR DE CARBURANTES Y COMBUSTIBLES PETROLIFEROS","uniorg":"010036","numdoc":"99999999R","nombre":"Juan García","apellido1":"López","apellido2":"Martínez","idunico":"03874761C_171447919011019"}},"oficinaTramitadora":"Oficina1","consejeriaTramitadora":"UAT-Consejeria de Medio ambiente","procedimiento":"Procedimiento1","fechaInicioTramitacion":"2022-01-01 22:30","fechaCierreTramitacion":"2022-01-31 21:15","estadoTramitacion":"En curso","documentos":[{"nombre":"testfile.pdf","algoritmo":"SHA-512","hash":"3452345235rtert45dfadfadfa43342y365u65u96ijhuu8iuu","fileSize":"80kb"}],"xmlRegistro":{"xmlClave":"xmlClave"},"esPorContraste":true,"datosRepresentante":{"nombre":"Tercero","apellido1":"TER-APE1","apellido2":"TER-APE2","nifcif":"05915863X","tipodoc":"NIF"}}; // RegistrarFicheroRequest | Datos del procedimiento y documentos a registrar. Incluye información del procedimiento, solicitante, documentos adjuntos y datos de firma.

try {
    final response = api.registrarFicheroOperation(idAgente, idExpediente, registrarFicheroRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->registrarFicheroOperation: $e\n');
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

# **transicionNotificacion**
> Respuesta transicionNotificacion(id, notificacionId, authorization, sisOrigen, origen)

Realizar una transición sobre una notificación

Ejecuta una transición de estado sobre una notificación (por ejemplo: comparecer, aceptar, rechazar). La transición modifica el estado de la notificación según las reglas de negocio del sistema Notifica. Puede requerir justificación según el tipo de transición.

### Example
```dart
import 'package:espacio_ciudadano_api/api.dart';

final api = EspacioCiudadanoApi().getCiudadanosApi();
final String id = 12345678Z; // String | Documento de identificación del ciudadano (NIF/NIE)
final int notificacionId = 123456; // int | Identificador único de la notificación
final String authorization = authorization_example; // String | Token JWT de autenticación del ciudadano obtenido tras el login
final String sisOrigen = sisOrigen_example; // String | Código del sistema origen que realiza la petición (header)
final String origen = origen_example; // String | Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto.

try {
    final response = api.transicionNotificacion(id, notificacionId, authorization, sisOrigen, origen);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CiudadanosApi->transicionNotificacion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Documento de identificación del ciudadano (NIF/NIE) | 
 **notificacionId** | **int**| Identificador único de la notificación | 
 **authorization** | **String**| Token JWT de autenticación del ciudadano obtenido tras el login | [optional] 
 **sisOrigen** | **String**| Código del sistema origen que realiza la petición (header) | [optional] 
 **origen** | **String**| Código del sistema origen alternativo (query param). Valores permitidos: 'notifica2' o 'notifica3'. Si no se especifica ninguno, se usa 'notifica2' por defecto. | [optional] 

### Return type

[**Respuesta**](Respuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

