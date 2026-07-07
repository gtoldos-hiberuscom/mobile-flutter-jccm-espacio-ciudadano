import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

// tests for NotificacionIndexaDto
void main() {
  final instance = NotificacionIndexaDtoBuilder();
  // TODO add properties to the builder and call build()

  group(NotificacionIndexaDto, () {
    // Concepto o asunto de la notificación
    // String concepto
    test('to test the property `concepto`', () async {
      // TODO
    });

    // Fecha límite para acceder a la notificación antes de que expire
    // DateTime fechaCaducidad
    test('to test the property `fechaCaducidad`', () async {
      // TODO
    });

    // Identificador único de la notificación
    // int idNotificacion
    test('to test the property `idNotificacion`', () async {
      // TODO
    });

    // ProcedimientoAdministrativoIndexaDto procedimientoAdministrativo
    test('to test the property `procedimientoAdministrativo`', () async {
      // TODO
    });

    // Código del sistema origen que generó la notificación
    // String sistemaOrigen
    test('to test the property `sistemaOrigen`', () async {
      // TODO
    });

    // UnidadOrganicaIndexaDto unidadOrganica
    test('to test the property `unidadOrganica`', () async {
      // TODO
    });

  });
}
