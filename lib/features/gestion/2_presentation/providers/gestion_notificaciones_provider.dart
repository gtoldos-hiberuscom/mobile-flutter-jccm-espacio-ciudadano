import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
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
final gestionNotificacionesProvider = FutureProvider.autoDispose.family<List<Notificacion>, NotificacionEstado?>((final ref, final estado) async {
  final citizenId = ref.watch(ciudadanosEndpointIdProvider);
  if (citizenId.isEmpty) {
    throw StateError('No hay ciudadano identificado.');
  }
  final repo = ref.watch(gestionNotificacionesRepositoryProvider);
  final notifications = await repo.loadNotificaciones(citizenId: citizenId, estado: estado);
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
  for (final entry in optimistic.entries) {
    if (entry.key.citizenId != citizenId) {
      continue;
    }
    final accepted = entry.value;
    final current = merged[accepted.id];
    merged[accepted.id] = current == null ? accepted : pickByNotificacionEstadoPrecedence(current, accepted);
  }
  return merged.values.toList(growable: false);
});

/// `estado` es el estado que traía el resumen del listado, o `null` si no se
/// conocía: solo sirve de respaldo si el detalle no lo informa.
typedef NotificacionDetalleArgs = ({int id, NotificacionEstado? estado, String? sistemaOrigen});

final gestionNotificacionDetalleProvider = FutureProvider.autoDispose.family<NotificacionDetalle, NotificacionDetalleArgs>((final ref, final args) async {
  final citizenId = ref.watch(ciudadanosEndpointIdProvider);
  if (citizenId.isEmpty) {
    throw StateError('No hay ciudadano identificado.');
  }
  return ref
      .watch(gestionNotificacionesRepositoryProvider)
      .loadNotificacion(
        citizenId: citizenId,
        notificacionId: args.id,
        fallbackEstado: args.estado,
        sistemaOrigen: args.sistemaOrigen,
      );
});
