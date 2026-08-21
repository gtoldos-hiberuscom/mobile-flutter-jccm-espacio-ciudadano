import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';

/// Identifier used as the `{id}` path segment of the `/api/v1/ciudadanos/{id}`
/// endpoints (contacto, notificaciones).
///
/// Todas las rutas usan siempre `sub_alt`, independientemente de configuraciones
/// antiguas que pudieran seguir incluyendo otra estrategia.
/// Returns an empty string when there are no authenticated claims.
final ciudadanosEndpointIdProvider = Provider<String>((final ref) {
  final claims = ref.watch(jwtClaimsProvider);
  return claims?.subAlt?.trim() ?? '';
});
