import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';

abstract interface class GestionDocumentoRepository {
  /// Sube un fichero sin firma electrónica al buzón de tramitación.
  /// Devuelve el hash del documento confirmado por el backend.
  ///
  /// **No verificado contra backend real** — ver riesgos conocidos en el PR:
  /// el contrato de `idunico` para continuar un expediente ya existente no
  /// está documentado por el backend.
  Future<String> subirDocumentoSinFirma({
    required final String documentNumber,
    required final String idUnico,
    required final String tipoProcedimiento,
    required final String nombreFichero,
    required final Uint8List bytes,
    final CancelToken? cancelToken,
    final void Function(double progreso)? onProgress,
  });

  /// Abre la transacción lógica de aportación de documentos
  /// (`procedimiento/inicproc`). El `idunico` del resultado puede diferir
  /// del enviado (el backend puede ajustarlo) — hay que usar el confirmado,
  /// no el generado localmente, en las llamadas siguientes.
  ///
  /// **No verificado contra backend real.**
  Future<InicioProcedimientoResultado> iniciarProcedimiento({
    required final String idUnico,
    required final String documentNumber,
    required final Expediente expediente,
  });

  /// Cierra la transacción abierta por [iniciarProcedimiento] una vez
  /// subidos todos los ficheros, y devuelve el justificante en PDF.
  ///
  /// **No verificado contra backend real.**
  Future<Uint8List> registrarFicheros({
    required final String documentNumber,
    required final Expediente expediente,
    required final InicioProcedimientoResultado inicio,
    required final List<({String nombre, String hash, int tamanioBytes})> documentos,
  });
}
