/// Identifier for each block rendered on the authenticated home dashboard.
///
/// Pure Dart — no Flutter, Riverpod or infrastructure imports allowed
/// (canon §11, 0_entity layer).
///
/// Two semantic groups:
/// - **Thematic landings** ([education], [employment], [socialWelfare],
///   [stateAffairs], [agenda]) — tapping navigates to the corresponding
///   landing screen.
/// - **Personal widgets** ([upcomingEvents], [casework], [notifications],
///   [digitalCards], [recommendations]) — tapping navigates to the
///   user-scoped section.
enum HomeBlockId {
  education,
  employment,
  socialWelfare,
  stateAffairs,
  agenda,
  upcomingEvents,
  casework,
  notifications,
  digitalCards,
  recommendations,
}
