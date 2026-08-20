import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';

/// Identifier used as the `{id}` path segment of the `/api/v1/ciudadanos/{id}`
/// endpoints (contacto, notificaciones).
///
/// PRE follows the documented contract and uses DNI/NIF. UAT still validates
/// `idAgente`, so the identifier is selected from the environment strategy.
/// Returns an empty string when there are no authenticated claims.
final ciudadanosEndpointIdProvider = Provider<String>((final ref) {
  final claims = ref.watch(jwtClaimsProvider);
  return switch (ref.watch(appConfigProvider).citizenIdStrategy) {
        CitizenIdStrategy.idAgente => claims?.idAgente,
        CitizenIdStrategy.numDocumento => claims?.normalizedPersonIdentifier,
        CitizenIdStrategy.subAlt => claims?.subAlt,
      } ??
      '';
});
