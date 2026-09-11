import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/placeholder_screens.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_registro_detail_page.dart';

void main() {
  group('buildGestionRegistroDetail', () {
    const registro = Registro(numregistro: 'REG-1', titulo: 'Solicitud', fecha: '2026-03-31', consejeria: 'JCCM');

    test('muestra el detalle cuando el extra trae el registro', () {
      final page = buildGestionRegistroDetail((registro, true));

      expect(
        page,
        isA<GestionRegistroDetailPage>().having((final p) => p.registro, 'registro', registro).having((final p) => p.isEntrada, 'isEntrada', isTrue),
      );
    });

    test('distingue entradas de salidas', () {
      expect(buildGestionRegistroDetail((registro, false)), isA<GestionRegistroDetailPage>().having((final p) => p.isEntrada, 'isEntrada', isFalse));
    });

    test('cae a NotFound sin extra — deep link o restauración de estado', () {
      // Antes: `state.extra! as (Registro, bool)` lanzaba dentro del builder.
      expect(buildGestionRegistroDetail(null), isA<NotFoundScreen>());
    });

    test('cae a NotFound si el extra es de otro tipo', () {
      expect(buildGestionRegistroDetail('REG-1'), isA<NotFoundScreen>());
      expect(buildGestionRegistroDetail(registro), isA<NotFoundScreen>());
      expect(buildGestionRegistroDetail((registro, 'entrada')), isA<NotFoundScreen>());
    });
  });
}
