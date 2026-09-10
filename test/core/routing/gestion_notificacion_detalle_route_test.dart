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

    test('monta el detalle con el resumen completo cuando el extra lo trae', () {
      final page = buildGestionNotificacionDetalle('7924', resumen);

      expect(
        page,
        isA<GestionNotificacionDetallePage>()
            .having((final p) => p.notificacionId, 'notificacionId', 7924)
            // El resumen entero, no dos campos sueltos: el repositorio también
            // respalda procedimiento y fecha de expiración con él.
            .having((final p) => p.resumen, 'resumen', resumen),
      );
    });

    test('sin resumen (deep link, restauración) no se fabrica ningún respaldo', () {
      final page = buildGestionNotificacionDetalle('7924', null);

      expect(page, isA<GestionNotificacionDetallePage>().having((final p) => p.resumen, 'resumen', isNull));
    });

    test('un extra que no es un resumen se ignora en vez de romper la pantalla', () {
      expect(
        buildGestionNotificacionDetalle('7924', 'basura'),
        isA<GestionNotificacionDetallePage>().having((final p) => p.resumen, 'resumen', isNull),
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
