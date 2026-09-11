import 'package:dio/dio.dart';
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

  test('al liberar el provider se cancela el barrido en curso', () async {
    final repository = _FakeGestionNotificacionesRepository();
    final container = ProviderContainer(
      overrides: [
        ciudadanosEndpointIdProvider.overrideWithValue('PER9998003'),
        gestionNotificacionesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(gestionNotificacionesProvider(NotificacionEstado.aceptada).future);
    final token = repository.tokensRecibidos.single;
    expect(token, isNotNull);
    expect(token!.isCancelled, isFalse);

    // Es lo que ocurre al salir de la pantalla: sin esto los cuatro barridos de
    // "Todo" seguían pidiendo páginas hasta agotarse.
    container.invalidate(gestionNotificacionesProvider(NotificacionEstado.aceptada));

    expect(token.isCancelled, isTrue);
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

  test('la aceptación que el índice aún no devuelve se muestra arriba, no al final', () async {
    final repository = _FakeGestionNotificacionesRepository(
      accepted: [
        _notification(id: 100, concepto: 'Aceptada antigua'),
        _notification(id: 101, concepto: 'Otra aceptada'),
      ],
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

    expect(notifications, hasLength(3));
    expect(notifications.first.concepto, 'Aceptación local');
  });

  test('"Todo" mantiene la aceptación local mientras el índice la da por pendiente', () async {
    final repository = _FakeGestionNotificacionesRepository(
      todo: [_notification(concepto: 'Versión del servidor', estado: NotificacionEstado.pendiente)],
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

    final notifications = await container.read(gestionNotificacionesProvider(null).future);

    // R-14: antes el servidor sobreescribía la entrada optimista, así que la
    // notificación recién aceptada volvía a aparecer como pendiente en "Todo".
    expect(notifications, hasLength(1));
    expect(notifications.single.estado, NotificacionEstado.aceptada);
    expect(notifications.single.concepto, 'Aceptación local');
  });
}

Notificacion _notification({
  required final String concepto,
  final NotificacionEstado estado = NotificacionEstado.aceptada,
  final int id = 7924,
}) => Notificacion(
  id: id,
  concepto: concepto,
  procedimientoDenominacion: 'Procedimiento',
  sistemaOrigen: 'notifica2',
  estado: estado,
);

final class _FakeGestionNotificacionesRepository implements GestionNotificacionesRepository {
  _FakeGestionNotificacionesRepository({this.accepted = const [], this.todo = const []});

  final List<Notificacion> accepted;
  final List<Notificacion> todo;

  /// Tokens que el provider pasó en cada barrido, para comprobar que los
  /// cancela al liberarse.
  final List<CancelToken?> tokensRecibidos = [];

  @override
  Future<List<Notificacion>> loadNotificaciones({required final String citizenId, final NotificacionEstado? estado, final CancelToken? cancelToken}) async {
    tokensRecibidos.add(cancelToken);
    return switch (estado) {
      NotificacionEstado.aceptada => accepted,
      null => todo,
      _ => const [],
    };
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}
