/// Digital cards exporters (EPIC-7 / STORY-52) — pure-Dart entity.
library;

/// Reason why a `BinaryArtifact` cannot be persisted/opened.
///
/// Maps to localised messages via the presentation layer; no PII ever
/// flows into these values (canon §24).
enum BinaryArtifactValidationFailure {
  /// The source variant is `unavailable(...)` or empty.
  unsupportedSource,

  /// Magic header check failed (e.g. expected `%PDF-` but got something else).
  invalidMagic,

  /// Payload exceeds the safe in-memory threshold.
  tooLarge,

  /// Decoded payload has zero bytes / characters.
  empty,
}
