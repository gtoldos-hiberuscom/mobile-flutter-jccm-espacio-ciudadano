import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';

const int maxArchivosAportacion = 5;
const int maxTamanioBytesAportacion = 20 * 1024 * 1024;
const List<String> extensionesPermitidasAportacion = ['pdf', 'doc', 'docx', 'zip', 'xls', 'xlsx'];

sealed class AddArchivosResult {
  const AddArchivosResult();
}

final class AddArchivosAdded extends AddArchivosResult {
  const AddArchivosAdded(this.count);

  final int count;
}

final class AddArchivosRejectedTooMany extends AddArchivosResult {
  const AddArchivosRejectedTooMany();
}

final class AddArchivosRejectedTooLarge extends AddArchivosResult {
  const AddArchivosRejectedTooLarge(this.nombres);

  final List<String> nombres;
}

final class AddArchivosRejectedInvalidType extends AddArchivosResult {
  const AddArchivosRejectedInvalidType(this.nombres);

  final List<String> nombres;
}

final class AddArchivosRejectedDuplicate extends AddArchivosResult {
  const AddArchivosRejectedDuplicate(this.nombres);

  final List<String> nombres;
}

class GestionAportarDocumentacionNotifier extends Notifier<List<AportacionArchivo>> {
  final Map<String, CancelToken> _cancelTokens = {};

  @override
  List<AportacionArchivo> build() {
    ref.onDispose(cancelarTodas);
    return const [];
  }

  AddArchivosResult addArchivos(final List<AportacionArchivo> nuevos) {
    final existingPaths = state.map((final a) => a.path).toSet();

    final duplicados = nuevos.where((final a) => existingPaths.contains(a.path)).map((final a) => a.nombre).toList(growable: false);
    if (duplicados.isNotEmpty) {
      return AddArchivosRejectedDuplicate(duplicados);
    }

    final tiposInvalidos = nuevos.where((final a) => !_hasAllowedExtension(a.nombre)).map((final a) => a.nombre).toList(growable: false);
    if (tiposInvalidos.isNotEmpty) {
      return AddArchivosRejectedInvalidType(tiposInvalidos);
    }

    final demasiadoGrandes = nuevos.where((final a) => a.tamanioBytes > maxTamanioBytesAportacion).map((final a) => a.nombre).toList(growable: false);
    if (demasiadoGrandes.isNotEmpty) {
      return AddArchivosRejectedTooLarge(demasiadoGrandes);
    }

    if (state.length + nuevos.length > maxArchivosAportacion) {
      return const AddArchivosRejectedTooMany();
    }

    state = [...state, ...nuevos];
    return AddArchivosAdded(nuevos.length);
  }

  void removeArchivo(final String path) {
    _cancelTokens.remove(path)?.cancel();
    state = state.where((final a) => a.path != path).toList(growable: false);
  }

  /// Crea y registra un [CancelToken] para la subida de [path], marcando ese
  /// fichero como `enviando` con progreso `0`. Devuelve el token para que el
  /// llamador lo pase a la llamada de red.
  CancelToken beginUpload(final String path) {
    final token = CancelToken();
    _cancelTokens[path] = token;
    _updateArchivo(path, (final a) => a.copyWith(estado: AportacionArchivoEstado.enviando, progreso: 0));
    return token;
  }

  void updateProgreso(final String path, final double progreso) {
    _updateArchivo(path, (final a) => a.copyWith(progreso: progreso));
  }

  void marcarCompletado(final String path, final String hash) {
    _cancelTokens.remove(path);
    _updateArchivo(path, (final a) => a.copyWith(estado: AportacionArchivoEstado.completado, clearProgreso: true, hash: hash));
  }

  void marcarError(final String path) {
    _cancelTokens.remove(path);
    _updateArchivo(path, (final a) => a.copyWith(estado: AportacionArchivoEstado.error, clearProgreso: true));
  }

  /// Revierte todos los ficheros a `error` — usado cuando `registrarFicheros`
  /// falla tras haber subido correctamente todos los ficheros: la
  /// transacción no llegó a cerrarse, así que "Reintentar"/"Registrar" deben
  /// volver a ejecutar la secuencia completa desde `iniciarProcedimiento`.
  void marcarErrorTodos() {
    state = [for (final archivo in state) archivo.copyWith(estado: AportacionArchivoEstado.error, clearProgreso: true, clearHash: true)];
  }

  /// Cancela la subida en curso de [path] (si la hay) y lo revierte a
  /// `noEnviado`.
  void cancelarSubida(final String path) {
    _cancelTokens.remove(path)?.cancel();
    _updateArchivo(path, (final a) => a.copyWith(estado: AportacionArchivoEstado.noEnviado, clearProgreso: true));
  }

  /// Cancela todas las subidas en curso — usado al pulsar "Cancelar" y al
  /// liberarse el provider (`ref.onDispose`) para no dejar peticiones
  /// colgadas si se abandona la pantalla en mitad de una subida.
  void cancelarTodas() {
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _cancelTokens.clear();
  }

  void _updateArchivo(final String path, final AportacionArchivo Function(AportacionArchivo) update) {
    state = [
      for (final archivo in state)
        if (archivo.path == path) update(archivo) else archivo,
    ];
  }

  bool _hasAllowedExtension(final String nombre) {
    final dotIndex = nombre.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == nombre.length - 1) {
      return false;
    }
    final extension = nombre.substring(dotIndex + 1).toLowerCase();
    return extensionesPermitidasAportacion.contains(extension);
  }
}

final gestionAportarDocumentacionProvider = NotifierProvider.autoDispose<GestionAportarDocumentacionNotifier, List<AportacionArchivo>>(
  GestionAportarDocumentacionNotifier.new,
);
