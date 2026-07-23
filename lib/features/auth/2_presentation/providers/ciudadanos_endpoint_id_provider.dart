import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';

/// Identifier used as the `{id}` path segment of the `/api/v1/ciudadanos/{id}`
/// endpoints (contacto, notificaciones).
///
/// The backend is mid-migration: PRE resolves the citizen by numDocumento (the
/// DNI carried in the token), while UAT still resolves by `idAgente`. Sending
/// the wrong one returns 403. The claim to use is driven per environment by
/// [AppConfig.citizenIdStrategy] (config key `CIUDADANOS_ID_STRATEGY`).
///
/// This is the single source of truth for that path id — every caller of the
/// ciudadanos endpoints must read it here rather than picking a claim directly,
/// so the two environments stay consistent. Returns '' when there are no claims.
final ciudadanosEndpointIdProvider = Provider<String>((final ref) {
  final claims = ref.watch(jwtClaimsProvider);
  return switch (ref.watch(appConfigProvider).citizenIdStrategy) {
        CitizenIdStrategy.idAgente => claims?.idAgente,
        CitizenIdStrategy.numDocumento => claims?.normalizedPersonIdentifier,
      } ??
      '';
});
