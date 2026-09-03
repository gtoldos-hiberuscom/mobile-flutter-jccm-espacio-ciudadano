import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_notificacion_detalle_page.dart';

void main() {
  group('buildGestionNotificacionDetalle', () {
    const resumen = Notificacion(
      id: 7924,
      concepto: 'Requerimiento de subsanación',
      procedimientoDenominacion: 'Ayudas al alquiler',
      sistemaOrigen: 'NOTIFICA',
      estado: NotificacionEstado.pendiente,
    );

    test('monta el detalle con el estado del resumen cuando el extra lo trae', () {
      final page = buildGestionNotificacionDetalle('7924', resumen);

      expect(
        page,
        isA<GestionNotificacionDetallePage>()
            .having((final p) => p.notificacionId, 'notificacionId', 7924)
            .having((final p) => p.estado, 'estado', NotificacionEstado.pendiente)
            .having((final p) => p.sistemaOrigen, 'sistemaOrigen', 'NOTIFICA'),
      );
    });

    test('sin resumen (deep link, restauración) el estado viaja null, nunca inventado', () {
      final page = buildGestionNotificacionDetalle('7924', null);

      expect(
        page,
        isA<GestionNotificacionDetallePage>().having((final p) => p.estado, 'estado', isNull).having((final p) => p.sistemaOrigen, 'sistemaOrigen', isNull),
      );
    });

    test('un id no numérico cae a NotFound en vez de fabricar la notificación 0', () {
      // NC-3: antes `int.tryParse(...) ?? 0` montaba la página y consultaba al
      // backend por el id 0.
      expect(buildGestionNotificacionDetalle('abc', null), isA<NotFoundScreen>());
      expect(buildGestionNotificacionDetalle(null, null), isA<NotFoundScreen>());
      expect(buildGestionNotificacionDetalle('', resumen), isA<NotFoundScreen>());
    });
  });
}
