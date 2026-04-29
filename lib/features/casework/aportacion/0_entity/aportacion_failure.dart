/// Domain failure surfaced by the aportación wizard (STORY-37).
///
/// Locale-independent. The presentation layer maps each value to a
/// localized message rendered as an in-step banner.
enum AportacionFailure {
  /// The identification value does not match NIF/NIE/passport/CIF format.
  invalidIdentification,

  /// The query did not match any expediente or registro entry.
  notFound,

  /// The repository call failed (network, server error, ...).
  networkError,
}
