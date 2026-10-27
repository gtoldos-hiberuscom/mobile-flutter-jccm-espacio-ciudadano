import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

/// Nivel de autenticación de la sesión en curso.
///
/// Se lee del **access token**, que es de donde `JwtClaims` saca ya `sub_alt`,
/// `idAgente` y `PersonIdentifier`, y si ahí no viene se reintenta con el **id
/// token**. Leer los dos cuesta una decodificación local y quita del camino
/// crítico la única incógnita que quedaba: en qué token viaja el claim.
///
/// Sin sesión devuelve [MissingAuthenticationLevel], que no concede nada.
///
/// No es `autoDispose`, igual que `citizenEndpointIdsProvider`: forma parte del
/// estado de sesión y debe sobrevivir a que ninguna pantalla lo mire.
final authenticationLevelProvider = Provider<AuthenticationLevelReading>(
  (final ref) => AuthenticationLevelReading.fromSession(
    accessTokenClaims: ref.watch(jwtClaimsProvider),
    idToken: ref.watch(tokenResponseProvider)?.idToken,
  ),
);
