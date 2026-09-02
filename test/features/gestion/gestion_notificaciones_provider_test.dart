import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
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

  test('accepted list includes a notification while the backend index is stale', () async {
    final repository = _FakeGestionNotificacionesRepository();
    final container = ProviderContainer(
      overrides: [
        ciudadanosEndpointIdProvider.overrideWithValue('PER9998003'),
        gestionNotificacionesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    container
        .read(gestionNotificacionesOptimisticAcceptedProvider.notifier)
        .add(
          citizenId: 'PER9998003',
          notification: _notification(concepto: 'Aceptación local'),
        );

    final notifications = await container.read(gestionNotificacionesProvider(NotificacionEstado.aceptada).future);

    expect(notifications, hasLength(1));
    expect(notifications.single.concepto, 'Aceptación local');
    expect(notifications.single.estado, NotificacionEstado.aceptada);
  });

  test('server version replaces the optimistic copy without duplication', () async {
    final repository = _FakeGestionNotificacionesRepository(
      accepted: [_notification(concepto: 'Versión del servidor')],
    );
    final container = ProviderContainer(
      overrides: [
        ciudadanosEndpointIdProvider.overrideWithValue('PER9998003'),
        gestionNotificacionesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    container
        .read(gestionNotificacionesOptimisticAcceptedProvider.notifier)
        .add(
          citizenId: 'PER9998003',
          notification: _notification(concepto: 'Aceptación local'),
        );

    final notifications = await container.read(gestionNotificacionesProvider(NotificacionEstado.aceptada).future);

    expect(notifications, hasLength(1));
    expect(notifications.single.concepto, 'Versión del servidor');
  });
}

Notificacion _notification({required final String concepto}) => Notificacion(
  id: 7924,
  concepto: concepto,
  procedimientoDenominacion: 'Procedimiento',
  sistemaOrigen: 'notifica2',
  estado: NotificacionEstado.aceptada,
);

final class _FakeGestionNotificacionesRepository implements GestionNotificacionesRepository {
  _FakeGestionNotificacionesRepository({this.accepted = const []});

  final List<Notificacion> accepted;

  @override
  Future<List<Notificacion>> loadNotificaciones({required final String citizenId, final NotificacionEstado? estado}) async {
    return estado == NotificacionEstado.aceptada ? accepted : const [];
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}
