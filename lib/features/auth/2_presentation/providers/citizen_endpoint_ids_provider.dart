import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';

/// Identificadores que aceptan las rutas `/api/v1/ciudadanos/{...}/...`.
///
/// La fachada **no usa un identificador único**: cada operación declara el suyo
/// en el OpenAPI. Por ejemplo, dentro de Salud:
///
/// - `{numDocumento}` en `salud/cip`, `salud/primaria-citas-pendientes` y
///   `salud/primaria-citas-pasadas`.
/// - `{idAgente}` en `salud/hospitalaria-citas-pendientes` y
///   `salud/hospitalaria-citas-pasadas`.
///
/// Enviar el que no toca devuelve 403, no 404: la fachada rechaza al validar el
/// identificador contra el token antes de resolver la operación.
///
/// Cuando el gateway se ponga delante, todas las rutas aceptarán `sub_alt` y lo
/// traducirá él; para eso basta poner `CIUDADANOS_ID_STRATEGY` a `subAlt`, que
/// hace que ambos campos devuelvan ese claim.
typedef CitizenEndpointIds = ({String? numDocumento, String? idAgente});

final citizenEndpointIdsProvider = Provider<CitizenEndpointIds>((final ref) {
  final claims = ref.watch(jwtClaimsProvider);

  if (ref.watch(appConfigProvider).citizenIdStrategy == CitizenIdStrategy.subAlt) {
    final subAlt = _nonEmpty(claims?.subAlt);
    return (numDocumento: subAlt, idAgente: subAlt);
  }

  return (
    numDocumento: _nonEmpty(claims?.normalizedPersonIdentifier),
    idAgente: _nonEmpty(claims?.idAgente),
  );
});

String? _nonEmpty(final String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

extension CitizenEndpointIdsX on CitizenEndpointIds {
  /// Documento del ciudadano para las operaciones que declaran `{numDocumento}`.
  String requireNumDocumento() => numDocumento ?? (throw StateError('El token no informa el documento del ciudadano.'));

  /// Identificador de agente para las operaciones que declaran `{idAgente}`.
  String requireIdAgente() => idAgente ?? (throw StateError('El token no informa el idAgente del ciudadano.'));
}
