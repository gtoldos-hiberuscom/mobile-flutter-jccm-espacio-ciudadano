/// Stable category an `ExternalLink` belongs to.
///
/// Pure Dart — no Flutter, Riverpod or infrastructure imports allowed
/// (canon §11, 0_entity layer). Used by analytics, tests, and the catalog
/// to classify outbound destinations without leaking the localised label
/// or full URL.
///
/// The inventory mirrors STORY-28 acceptance criteria (Educamos CLM,
/// Carpeta Ciudadana AGE, Sede Electrónica DGT, Empleo CLM, Empleo
/// público CLM, Historia social única, Infancia y familias).
enum ExternalLinkCategory {
  /// Educamos CLM portal (general education services).
  educationCLM,

  /// Empleo CLM (regional employment portal).
  employmentCLM,

  /// Empleo público CLM (regional civil-service employment portal).
  publicEmploymentCLM,

  /// Sede Electrónica DGT (national traffic authority e-office).
  dgtElectronic,

  /// Carpeta Ciudadana AGE (Spanish General State Administration).
  ageCarpetaCiudadana,

  /// Historia social única — social welfare unified history portal.
  socialHistoria,

  /// Infancia y familias — childhood and families portal.
  infanciaFamilias,
}
