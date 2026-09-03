import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/authorization_guard.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/notificaciones_paginacion_exception.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_notificaciones_repository_impl.dart';

final gestionNotificacionesRepositoryProvider = Provider<GestionNotificacionesRepository>((final ref) {
  return GestionNotificacionesRepositoryImpl(dio: ref.watch(dioProvider));
});

/// Citizen identifier used by the notification-transition endpoint.
/// Uses the identifier configured for the current backend environment.
final gestionNotificacionesTransitionCitizenIdProvider = Provider<String>((final ref) {
  return ref.watch(ciudadanosEndpointIdProvider);
});

typedef OptimisticAcceptedKey = ({String citizenId, int notificationId});

final class GestionNotificacionesOptimisticAcceptedNotifier extends Notifier<Map<OptimisticAcceptedKey, Notificacion>> {
  final Map<OptimisticAcceptedKey, Timer> _expirationTimers = {};

  @override
  Map<OptimisticAcceptedKey, Notificacion> build() {
    ref.onDispose(() {
      for (final timer in _expirationTimers.values) {
        timer.cancel();
      }
    });
    return const {};
  }

  void add({required final String citizenId, required final Notificacion notification}) {
    final accepted = Notificacion(
      id: notification.id,
      concepto: notification.concepto,
      procedimientoDenominacion: notification.procedimientoDenominacion,
      fechaCaducidad: notification.fechaCaducidad,
      procedimientoIdFicha: notification.procedimientoIdFicha,
      unidadOrganicaNombre: notification.unidadOrganicaNombre,
      sistemaOrigen: notification.sistemaOrigen,
      estado: NotificacionEstado.aceptada,
    );
    final key = (citizenId: citizenId, notificationId: accepted.id);
    state = {...state, key: accepted};
    _expirationTimers[key]?.cancel();
    _expirationTimers[key] = Timer(const Duration(minutes: 2), () {
      _expirationTimers.remove(key);
      state = {...state}..remove(key);
    });
  }
}

final gestionNotificacionesOptimisticAcceptedProvider = NotifierProvider<GestionNotificacionesOptimisticAcceptedNotifier, Map<OptimisticAcceptedKey, Notificacion>>(
  GestionNotificacionesOptimisticAcceptedNotifier.new,
);

/// Family param: filtro de estado — null = "Todo" (unión de todos los estados).
final gestionNotificacionesProvider = FutureProvider.autoDispose.family<List<Notificacion>, NotificacionEstado?>(retry: _noRetryOnDeterministicFailures, (final ref, final estado) async {
  final citizenId = ref.watch(ciudadanosEndpointIdProvider);
  if (citizenId.isEmpty) {
    throw StateError('No hay ciudadano identificado.');
  }
  final repo = ref.watch(gestionNotificacionesRepositoryProvider);
  // "Todo" lanza cuatro barridos y cada uno puede pedir varias páginas: al
  // salir de la pantalla (o al invalidar el provider) seguían pidiendo hasta
  // agotarse.
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel('gestionNotificacionesProvider($estado) liberado'));
  // Notificaciones solo exige la cláusula obligatoria (ver
  // `documentation/consent_clause_access_matrix.md`): no hay cláusula
  // intermedia que ofrecer, así que el rechazo por autorización solo puede ser
  // revocación (cierra sesión) o fallo transitorio (error con reintento).
  final notifications = await withAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId},
    request: () => repo.loadNotificaciones(citizenId: citizenId, estado: estado, cancelToken: cancelToken),
  );
  if (estado != null && estado != NotificacionEstado.aceptada) {
    return notifications;
  }

  final optimistic = ref.watch(gestionNotificacionesOptimisticAcceptedProvider);
  if (optimistic.isEmpty) {
    return notifications;
  }
  // Primero el servidor y después lo optimista, resolviendo con la misma
  // precedencia de estados que usa la fusión de "Todo": la aceptación que acaba
  // de hacer el usuario gana a la copia que el servidor sigue devolviendo como
  // pendiente, y en empate se conserva la del servidor, con los campos frescos.
  final merged = {for (final notification in notifications) notification.id: notification};
  // Lo que el índice del servidor todavía no devuelve se añade delante: acabas
  // de aceptar esa notificación, no tiene sentido enterrarla al final.
  final additions = <Notificacion>[];
  for (final entry in optimistic.entries) {
    if (entry.key.citizenId != citizenId) {
      continue;
    }
    final accepted = entry.value;
    final current = merged[accepted.id];
    if (current == null) {
      additions.add(accepted);
    } else {
      merged[accepted.id] = pickByNotificacionEstadoPrecedence(current, accepted);
    }
  }
  final result = [...additions, ...merged.values];
  if (estado == null) {
    // "Todo" tiene orden propio (ver `compareNotificacionesForInbox`); las
    // pestañas filtradas conservan el orden del backend.
    result.sort(compareNotificacionesForInbox);
  }
  return result;
});

/// `estado` es el estado que traía el resumen del listado, o `null` si no se
/// conocía: solo sirve de respaldo si el detalle no lo informa.
typedef NotificacionDetalleArgs = ({int id, NotificacionEstado? estado, String? sistemaOrigen});

final gestionNotificacionDetalleProvider = FutureProvider.autoDispose.family<NotificacionDetalle, NotificacionDetalleArgs>(retry: _noRetryOnDeterministicFailures, (final ref, final args) async {
  final citizenId = ref.watch(ciudadanosEndpointIdProvider);
  if (citizenId.isEmpty) {
    throw StateError('No hay ciudadano identificado.');
  }
  final repo = ref.watch(gestionNotificacionesRepositoryProvider);
  return withAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId},
    request: () => repo.loadNotificacion(
      citizenId: citizenId,
      notificacionId: args.id,
      fallbackEstado: args.estado,
      sistemaOrigen: args.sistemaOrigen,
    ),
  );
});

/// Riverpod reintenta con espera creciente cualquier provider que falle. Un
/// desenlace de autorización no es un fallo transitorio: reintentarlo repite el
/// rechazo del backend y la relectura de cláusulas mientras el usuario mira una
/// pantalla que ya le dice qué hacer (o mientras se cierra la sesión). El resto
/// de errores mantienen el comportamiento por defecto.
/// Los fallos deterministas no se reintentan con espera creciente: el rechazo
/// por autorización lo resuelve el guard, y un barrido que no cabe en el tope
/// de páginas volverá a no caber. El usuario ya tiene "Reintentar".
Duration? _noRetryOnDeterministicFailures(final int retryCount, final Object error) {
  if (error is AuthorizationFailure || error is NotificacionesPaginacionIncompletaException) {
    return null;
  }
  return ProviderContainer.defaultRetry(retryCount, error);
}
