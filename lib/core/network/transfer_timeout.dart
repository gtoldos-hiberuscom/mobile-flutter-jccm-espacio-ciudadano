/// Plazos para peticiones cuyo cuerpo no cabe en el timeout general.
///
/// `sendTimeout` de Dio es un **plazo total** para empujar el cuerpo, no un
/// tiempo de inactividad entre bloques: el adaptador envuelve
/// `request.addStream(...)` en un único `.timeout(sendTimeout)`. Con el timeout
/// general de la app (10 s en producción) una subida grande no puede terminar
/// por definición, así que estas peticiones necesitan un plazo propio
/// dimensionado por el tamaño de lo que envían.
library;

/// Ritmo de subida asumido para dimensionar el plazo: 128 kB/s, es decir ~1 Mbps
/// de subida. Es deliberadamente pesimista — una red móvil mala — porque el
/// coste de quedarse corto es que la operación **nunca** pueda completarse,
/// mientras que el de pasarse es solo un plazo que casi nunca se alcanza. El
/// ciudadano ve el progreso real de la subida y puede cancelarla.
const int assumedUplinkBytesPerSecond = 128 * 1024;

/// Plazo para transferir [payloadBytes] bytes, sobre [baseTimeout], que cubre
/// el establecimiento de conexión y el trabajo del servidor.
///
/// El resultado está acotado por construcción: el tamaño de un adjunto lo
/// limita la propia app (`maxTamanioBytesAportacion`), así que subir ese límite
/// alarga este plazo en proporción y no hay que retocar nada más.
Duration payloadTransferTimeout({
  required final int payloadBytes,
  required final Duration baseTimeout,
}) {
  if (payloadBytes <= 0) {
    return baseTimeout;
  }
  final transferSeconds = (payloadBytes / assumedUplinkBytesPerSecond).ceil();
  return baseTimeout + Duration(seconds: transferSeconds);
}

/// Tamaño en la red de [bytes] bytes codificados en base64: el cuerpo viaja
/// como texto JSON, cuatro caracteres por cada tres bytes.
int base64WireSize(final int bytes) => ((bytes + 2) ~/ 3) * 4;
