import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
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
final authenticationLevelProvider = Provider<AuthenticationLevelReading>((final ref) {
  final claims = ref.watch(jwtClaimsProvider);
  if (claims != null) {
    final fromAccessToken = AuthenticationLevelReading.parse(claims.authNLevelRaw);
    if (fromAccessToken is! MissingAuthenticationLevel) {
      return fromAccessToken;
    }
  }

  final idToken = ref.watch(tokenResponseProvider)?.idToken;
  if (idToken == null || idToken.isEmpty) {
    return const MissingAuthenticationLevel();
  }
  return AuthenticationLevelReading.parse(JwtDecoder.decodePayload(idToken)['authNLevel']);
});
