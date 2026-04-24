/// Sequential steps of the third-party aportación wizard (STORY-37).
///
/// Locale-independent — UI labels are resolved through l10n in the
/// presentation layer.
enum AportacionStep {
  /// Introductory screen with explanation and restrictions.
  intro,

  /// Identification of the interested party (id type + id number).
  identificacion,

  /// Search by número de expediente or número de registro.
  searchExpediente,

  /// Operational detail of the resolved expediente — embeds the
  /// upload section.
  detail,

  /// Final acknowledgement after the upload session is finalized.
  uploadComplete;

  /// 1-based index used to render "Paso N de M" indicators.
  int get oneBasedIndex => index + 1;

  /// Total number of user-visible steps.
  static int get total => values.length;
}
