/// Domain contract for landing screen content.
///
/// Currently the content is built entirely in the presentation layer from
/// localised strings; this interface exists to satisfy the mandatory
/// `1_domain/` layer and to provide an extension point for future remote
/// content or A/B variants.
///
/// Pure Dart only — no Flutter, Riverpod, Dio, or infrastructure imports.
abstract interface class LandingRepository {
  // No remote operations required yet.
  // Add content-fetching methods here when a backend CMS is introduced.
}
