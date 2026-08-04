import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';

void main() {
  test('transition uses the configured ciudadanos endpoint identifier', () {
    final container = ProviderContainer(
      overrides: [
        ciudadanosEndpointIdProvider.overrideWithValue('PER9998003'),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(gestionNotificacionesTransitionCitizenIdProvider),
      'PER9998003',
    );
  });
}
