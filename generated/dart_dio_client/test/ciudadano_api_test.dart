import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for CiudadanoApi
void main() {
  final instance = EspacioCiudadanoApi().getCiudadanoApi();

  group(CiudadanoApi, () {
    // Descargar documento de una notificación
    //
    //Future<Uint8List> descargarDocumento(String id, int notificacionId, int orden, { String authorization, String sisOrigen }) async
    test('test descargarDocumento', () async {
      // TODO
    });

    // Descargar justificante de una notificación
    //
    //Future<Uint8List> descargarJustificante(String id, int notificacionId, { String authorization, String sisOrigen }) async
    test('test descargarJustificante', () async {
      // TODO
    });

    // Modificar el contacto de un ciudadano en Notifica
    //
    //Future<TerceroN2Dto> modificarCiudadano(String id, TerceroN2Dto terceroN2Dto, { String authorization, String sisOrigen }) async
    test('test modificarCiudadano', () async {
      // TODO
    });

    // Obtener contacto de un ciudadano registrado en Notifica
    //
    //Future<TerceroN2Dto> obtenerCiudadano(String id, { String authorization, String sisOrigen }) async
    test('test obtenerCiudadano', () async {
      // TODO
    });

    // Obtener una notificación concreta de un ciudadano
    //
    //Future<NotificacionDto> obtenerNotificacion(String id, int notificacionId, { String authorization, String sisOrigen }) async
    test('test obtenerNotificacion', () async {
      // TODO
    });

    // Obtener notificaciones de un ciudadano
    //
    //Future<BuiltList<NotificacionIndexaDto>> obtenerNotificacionesCiudadano(String id, { String authorization, String estado, int page, int size }) async
    test('test obtenerNotificacionesCiudadano', () async {
      // TODO
    });

    // Registrar el contacto de un ciudadano en Notifica
    //
    //Future<TerceroN2Dto> registrarCiudadano(String id, TerceroN2Dto terceroN2Dto, { String authorization, String sisOrigen }) async
    test('test registrarCiudadano', () async {
      // TODO
    });

    // Realizar una transición sobre una notificación
    //
    //Future<NotificacionDto> transicionNotificacion(String id, int notificacionId, TransicionDto transicionDto, { String authorization, String sisOrigen }) async
    test('test transicionNotificacion', () async {
      // TODO
    });
  });
}
