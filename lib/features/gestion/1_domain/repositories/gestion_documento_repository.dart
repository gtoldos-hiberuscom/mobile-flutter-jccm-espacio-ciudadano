import 'dart:typed_data';

abstract interface class GestionDocumentoRepository {
  /// Sube un fichero sin firma electrónica al buzón de tramitación.
  ///
  /// **No verificado contra backend real** — ver riesgos conocidos en el PR:
  /// el contrato de `idunico` para continuar un expediente ya existente no
  /// está documentado por el backend.
  Future<void> subirDocumentoSinFirma({
    required final String documentNumber,
    required final String idUnico,
    required final String tipoProcedimiento,
    required final String nombreFichero,
    required final Uint8List bytes,
  });
}
