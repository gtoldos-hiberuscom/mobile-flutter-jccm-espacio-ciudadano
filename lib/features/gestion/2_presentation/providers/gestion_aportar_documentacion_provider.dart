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
  @override
  List<AportacionArchivo> build() => const [];

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
    state = state.where((final a) => a.path != path).toList(growable: false);
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
