/// Expediente lifecycle state (STORY-35).
///
/// The backend `/publicacion/selectbynumexp` payload exposes an `estado`
/// field whose canonical values are not finalised yet (TASK-40 open
/// question Q1). The client tolerates unknown values by mapping them to
/// [ExpedienteEstado.unknown] so the UI can still render the detail
/// without crashing.
enum ExpedienteEstado {
  abierto,
  cerrado,
  unknown
  ;

  /// Whether the citizen can submit additional documentation while the
  /// expediente is in this state. Only [ExpedienteEstado.abierto]
  /// allows aportación documental from the detail screen.
  bool get permiteAportacion => this == ExpedienteEstado.abierto;
}
