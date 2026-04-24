/// Workspace tabs for the "Mis gestiones" workspace (STORY-34).
///
/// Each tab maps 1:1 to a backend endpoint (see endpoint coverage in
/// `tickets/STORY-34.md`):
/// - [expedientes] → `/publicacion/selectbynif`
/// - [entradasRegistro] → `/publicacion/selectbynifentrada`
/// - [salidasRegistro] → `/publicacion/selectbynifsalida`
///
/// Pure-Dart enum — locale-independent and free of Flutter / Riverpod
/// imports per the architecture canon (entity layer).
enum CaseworkTab { expedientes, entradasRegistro, salidasRegistro }
