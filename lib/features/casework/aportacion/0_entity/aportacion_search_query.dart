/// Discriminated union for the aportación search input (STORY-37).
///
/// The wizard only allows two mutually exclusive ways to locate an
/// expediente: by número de expediente or by número de registro. A sealed
/// class keeps the type system enforcing that contract end-to-end.
///
/// Pure Dart — no Flutter, no Riverpod, no infrastructure imports.
sealed class AportacionSearchQuery {
  const AportacionSearchQuery();

  /// Query by número de expediente. Reuses
  /// `/publicacion/selectbynumexp` via the casework repository.
  const factory AportacionSearchQuery.byExpediente(final String numexp) = AportacionSearchByExpediente;

  /// Query by número de registro. Reuses
  /// `/publicacion/selectbynumreg` via the casework repository.
  const factory AportacionSearchQuery.byRegistro(final String numreg) = AportacionSearchByRegistro;

  /// The user-facing value, trimmed.
  String get value;

  /// True when the query is non-empty after trimming.
  bool get isNotBlank => value.isNotEmpty;
}

final class AportacionSearchByExpediente extends AportacionSearchQuery {
  const AportacionSearchByExpediente(this.numexp);

  final String numexp;

  @override
  String get value => numexp.trim();
}

final class AportacionSearchByRegistro extends AportacionSearchQuery {
  const AportacionSearchByRegistro(this.numreg);

  final String numreg;

  @override
  String get value => numreg.trim();
}
