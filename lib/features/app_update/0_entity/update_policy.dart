/// Qué pide la app al ciudadano respecto a una versión publicada más nueva.
enum UpdatePolicy {
  /// No hay nada que notificar.
  none,

  /// Conviene actualizar; el aviso se puede descartar («Ahora no») y la
  /// versión descartada no vuelve a avisar.
  recommended,

  /// Es obligatorio actualizar; el aviso no deja seguir usando la app.
  forced,
}
