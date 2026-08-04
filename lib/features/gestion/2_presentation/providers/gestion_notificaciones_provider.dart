import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_notificaciones_repository_impl.dart';

final gestionNotificacionesRepositoryProvider = Provider<GestionNotificacionesRepository>((final ref) {
  return GestionNotificacionesRepositoryImpl(dio: ref.watch(dioProvider));
});

/// Citizen identifier used by the notification-transition endpoint.
/// Uses the same per-environment strategy as listing and detail: UAT requires
/// `idAgente`, while PRE currently requires the document number.
final gestionNotificacionesTransitionCitizenIdProvider = Provider<String>((final ref) {
  return ref.watch(ciudadanosEndpointIdProvider);
});

/// Family param: estado filter — null = all, 'pendiente', 'aceptada', etc.
final gestionNotificacionesProvider = FutureProvider.autoDispose.family<List<Notificacion>, String?>((final ref, final estado) async {
  final citizenId = ref.watch(ciudadanosEndpointIdProvider);
  if (citizenId.isEmpty) {
    throw StateError('No hay ciudadano identificado.');
  }
  final repo = ref.watch(gestionNotificacionesRepositoryProvider);
  return repo.loadNotificaciones(citizenId: citizenId, estado: estado);
});

typedef NotificacionDetalleArgs = ({int id, String estado, String? sistemaOrigen});

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
        estado: args.estado,
        sistemaOrigen: args.sistemaOrigen,
      );
});
