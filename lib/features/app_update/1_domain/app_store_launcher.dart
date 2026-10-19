/// Abre la ficha de la app en la tienda de la plataforma.
///
/// La URL no viene del servidor: la implementación la construye a partir de
/// la plataforma y el id de la app. Devuelve `false` en vez de lanzar: el aviso
/// enseña un texto de error y el ciudadano puede volver a intentarlo.
abstract interface class AppStoreLauncher {
  Future<bool> openStore();
}
