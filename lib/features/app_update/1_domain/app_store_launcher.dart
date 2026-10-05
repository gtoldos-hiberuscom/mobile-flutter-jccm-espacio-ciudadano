/// Hosts desde los que se acepta abrir la ficha de la app.
///
/// La URL llega en el manifiesto remoto; esta lista impide que un manifiesto
/// manipulado o mal publicado mande al ciudadano a cualquier otro sitio.
const Set<String> appStoreAllowedHosts = {
  'play.google.com',
  'apps.apple.com',
  'itunes.apple.com',
};

/// Abre la ficha de la app en la tienda de la plataforma.
///
/// Devuelve `false` en vez de lanzar: el aviso enseña un texto de error y el
/// ciudadano puede volver a intentarlo. La URL completa no se registra nunca.
abstract interface class AppStoreLauncher {
  Future<bool> openStore(final Uri storeUrl);
}
