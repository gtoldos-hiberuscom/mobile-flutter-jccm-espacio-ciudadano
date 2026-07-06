import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_notificaciones_repository_impl.dart';

final gestionNotificacionesRepositoryProvider = Provider<GestionNotificacionesRepository>((final ref) {
  return GestionNotificacionesRepositoryImpl(dio: ref.watch(dioProvider));
});

/// Family param: estado filter — null = all, 'pendiente', 'aceptada', etc.
final gestionNotificacionesProvider = FutureProvider.autoDispose.family<List<Notificacion>, String?>((final ref, final estado) async {
  final claims = ref.watch(jwtClaimsProvider);
  final citizenId = claims?.normalizedPersonIdentifier ?? '';
  if (citizenId.isEmpty) {
    throw StateError('No hay ciudadano identificado.');
  }
  final repo = ref.watch(gestionNotificacionesRepositoryProvider);
  return repo.loadNotificaciones(citizenId: citizenId, estado: estado);
});
