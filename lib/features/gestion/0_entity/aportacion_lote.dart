import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:meta/meta.dart';

/// Paso de la transacción de aportación que falló.
///
/// Solo se modelan los dos fallos que **ninguna tarjeta explica por sí sola**:
/// la subida de un fichero concreto ya se anuncia en su propia tarjeta
/// (`AportacionArchivoEstado.error`), y duplicarla en un aviso sobraría.
enum AportacionLoteErrorTipo {
  /// `iniciarProcedimiento` (o la lectura previa del expediente) no pudo abrir
  /// la transacción: no hay `idunico` con el que subir nada.
  aperturaTransaccion,

  /// `registrarfichero` no pudo cerrar la transacción. Los ficheros siguen
  /// subidos y con su hash: la transacción no ha muerto, solo el cierre.
  cierre,
}

/// Fallo del lote listo para que la presentación elija su mensaje curado.
///
/// **Deliberadamente sin el error original**: ni `DioException` ni el cuerpo
/// del backend salen de aquí, porque el detalle interno nunca se muestra al
/// ciudadano (va a los logs). El notifier ya lo ha clasificado.
@immutable
final class AportacionLoteError {
  const AportacionLoteError({required this.tipo, required this.secuencia, this.sesionCaducada = false});

  final AportacionLoteErrorTipo tipo;

  /// La sesión caducó (401 traducido a `UnauthorizedError`): la presentación
  /// avisa de eso y no del paso que fallaba.
  final bool sesionCaducada;

  /// Contador monótono del lote. Dos fallos idénticos seguidos —reintentar el
  /// cierre y que vuelva a fallar— producen estados distintos, así que el
  /// `ref.listen` de la página vuelve a avisar en vez de callarse porque el
  /// error «no ha cambiado».
  final int secuencia;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AportacionLoteError && runtimeType == other.runtimeType && tipo == other.tipo && sesionCaducada == other.sesionCaducada && secuencia == other.secuencia;

  @override
  int get hashCode => Object.hash(tipo, sesionCaducada, secuencia);
}

/// Estado completo de la pantalla de aportación: los ficheros del lote, si el
/// cierre está en vuelo y el último fallo pendiente de anunciar.
///
/// El `idunico` de la transacción **no** vive aquí: es un detalle de la
/// orquestación que nadie pinta, y publicarlo invitaría a que la UI lo usara.
@immutable
final class AportacionLote {
  const AportacionLote({this.archivos = const [], this.cerrando = false, this.error});

  final List<AportacionArchivo> archivos;

  /// `registrarfichero` en vuelo. Mientras dure, la petición ya viajó con la
  /// lista de documentos construida, así que retirar o añadir algo no se podría
  /// honrar y las acciones por fichero se apagan.
  final bool cerrando;

  final AportacionLoteError? error;

  bool get haySubidasEnCurso => archivos.any((final a) => a.estado == AportacionArchivoEstado.enviando);

  /// Todos los ficheros subidos y al menos uno: la condición para poder cerrar
  /// la transacción. Se exige que **todos** lo estén, no solo que ninguno haya
  /// fallado, porque cada entrada de `documentos` necesita el hash de su
  /// subida y solo un fichero completado lo tiene.
  bool get todosSubidos => archivos.isNotEmpty && archivos.every((final a) => a.estado == AportacionArchivoEstado.completado);

  bool get puedeRegistrar => todosSubidos && !cerrando;

  /// Las acciones por fichero (cancelar, reintentar, eliminar) están vivas
  /// salvo mientras se cierra la transacción.
  bool get puedeEditarLista => !cerrando;

  /// [clearError] descarta el fallo pendiente independientemente de [error] —
  /// mismo convenio que `AportacionArchivo.copyWith`, porque pasar `null`
  /// directamente es indistinguible de «mantener el valor actual».
  AportacionLote copyWith({
    final List<AportacionArchivo>? archivos,
    final bool? cerrando,
    final AportacionLoteError? error,
    final bool clearError = false,
  }) {
    return AportacionLote(
      archivos: archivos ?? this.archivos,
      cerrando: cerrando ?? this.cerrando,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AportacionLote && runtimeType == other.runtimeType && cerrando == other.cerrando && error == other.error && _archivosIguales(archivos, other.archivos);

  @override
  int get hashCode => Object.hash(Object.hashAll(archivos), cerrando, error);
}

/// Comparación elemento a elemento: `List.==` en Dart es identidad, y cada
/// mutación construye una lista nueva, así que sin esto dos estados idénticos
/// se tomarían por distintos y repintarían de más.
bool _archivosIguales(final List<AportacionArchivo> a, final List<AportacionArchivo> b) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
