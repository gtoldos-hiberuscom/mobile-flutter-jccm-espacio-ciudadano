/// Familia numerosa carnet (EPIC-7 / STORY-49) — pure-Dart entity.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

/// Category of the familia numerosa carnet, as classified by the
/// Spanish Ministerio de Sanidad criteria (general / especial). The
/// `unknown` case covers carnets where the backend did not project the
/// classification (defensive default; UI shows a neutral label).
enum FamiliaNumerosaCategoria {
  general,
  especial,
  unknown,
}
