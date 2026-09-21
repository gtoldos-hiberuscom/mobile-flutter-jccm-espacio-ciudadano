/// Resultado de validar/renovar la sesión.
///
/// El tercer estado existe por la misma razón que
/// `ConsentStatusUnknownException` en consentimiento: un fallo transitorio
/// (red, timeout, 5xx del SSO) no demuestra que la sesión sea inválida, y
/// tratarlo como tal expulsaba al ciudadano a la landing sin mensaje por un
/// microcorte. Solo un rechazo definitivo del servidor de autorización
/// (`invalid_grant`) o la ausencia de refresh token son [definitivelyInvalid].
enum SessionRefreshStatus {
  /// El access token es válido (renovado o aún vigente).
  valid,

  /// La sesión no puede renovarse jamás: sin refresh token, rechazo
  /// definitivo del servidor, o un logout ganó la carrera. El estado local
  /// ya queda limpio.
  definitivelyInvalid,

  /// No se pudo determinar (fallo transitorio). La sesión se conserva para
  /// que un intento posterior pueda renovarla.
  unknownTransient,
}
