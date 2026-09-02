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

  test('notificacionEstadoQueryValue usa los valores del enum del endpoint', () {
    expect(notificacionEstadoQueryValue(NotificacionEstado.pendiente), 'pendiente');
    expect(notificacionEstadoQueryValue(NotificacionEstado.aceptada), 'aceptada');
    expect(notificacionEstadoQueryValue(NotificacionEstado.rechazada), 'rechazada');
    expect(notificacionEstadoQueryValue(NotificacionEstado.expirada), 'expirada');
  });
}
