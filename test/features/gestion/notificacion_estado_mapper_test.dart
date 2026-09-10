import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/mappers/notificacion_estado_mapper.dart';

void main() {
  group('notificacionEstadoFromBackend', () {
    test('acepta el vocabulario del filtro del listado', () {
      expect(notificacionEstadoFromBackend('pendiente'), NotificacionEstado.pendiente);
      expect(notificacionEstadoFromBackend('ACEPTADA'), NotificacionEstado.aceptada);
      expect(notificacionEstadoFromBackend('Rechazada'), NotificacionEstado.rechazada);
      expect(notificacionEstadoFromBackend(' EXPIRADA '), NotificacionEstado.expirada);
    });

    test('acepta el vocabulario del histórico de Notifica', () {
      expect(notificacionEstadoFromBackend('PUESTO_A_DISPOSICION'), NotificacionEstado.pendiente);
      expect(notificacionEstadoFromBackend('puesta-a-disposicion'), NotificacionEstado.pendiente);
    });

    test('lo desconocido no se convierte en un estado concreto', () {
      expect(notificacionEstadoFromBackend(null), isNull);
      expect(notificacionEstadoFromBackend(''), isNull);
      expect(notificacionEstadoFromBackend('   '), isNull);
      expect(notificacionEstadoFromBackend('LEIDA_POR_TERCERO'), isNull);
    });
  });

  group('notificacionEstadoLecturaFromBackend', () {
    test('un campo ausente o vacío es ausencia, no valor desconocido', () {
      expect(notificacionEstadoLecturaFromBackend(null), isA<NotificacionEstadoAusente>());
      expect(notificacionEstadoLecturaFromBackend(''), isA<NotificacionEstadoAusente>());
      expect(notificacionEstadoLecturaFromBackend('   '), isA<NotificacionEstadoAusente>());
    });

    test('un valor fuera del vocabulario se marca como no reconocido y conserva el crudo', () {
      // Notifica tiene más vocabulario del que recoge el contrato: el crudo es
      // lo único que permite descubrir cuál falta.
      final lectura = notificacionEstadoLecturaFromBackend(' LEIDA_POR_TERCERO ');

      expect(lectura, isA<NotificacionEstadoNoReconocido>());
      expect((lectura as NotificacionEstadoNoReconocido).raw, 'LEIDA_POR_TERCERO');
    });

    test('acepta los dos vocabularios del contrato', () {
      expect(
        notificacionEstadoLecturaFromBackend(' EXPIRADA '),
        isA<NotificacionEstadoConocido>().having((final lectura) => lectura.estado, 'estado', NotificacionEstado.expirada),
      );
      expect(
        notificacionEstadoLecturaFromBackend('puesta-a-disposicion'),
        isA<NotificacionEstadoConocido>().having((final lectura) => lectura.estado, 'estado', NotificacionEstado.pendiente),
      );
    });
  });

  test('notificacionEstadoQueryValue usa los valores del enum del endpoint', () {
    expect(notificacionEstadoQueryValue(NotificacionEstado.pendiente), 'pendiente');
    expect(notificacionEstadoQueryValue(NotificacionEstado.aceptada), 'aceptada');
    expect(notificacionEstadoQueryValue(NotificacionEstado.rechazada), 'rechazada');
    expect(notificacionEstadoQueryValue(NotificacionEstado.expirada), 'expirada');
  });
}
