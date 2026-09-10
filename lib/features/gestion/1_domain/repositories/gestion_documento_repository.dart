import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/representante.dart';

abstract interface class GestionDocumentoRepository {
  /// En los tres métodos, [citizenId] es el identificador del ciudadano
  /// autenticado para el path `/ciudadanos/{sid}/...` (sub_alt contra el
  /// gateway); el documento real viaja siempre en el cuerpo.

  /// Sube un fichero sin firma electrónica al buzón de tramitación.
  /// Devuelve el hash del documento confirmado por el backend.
  ///
  /// **No verificado contra backend real** — ver riesgos conocidos en el PR:
  /// el contrato de `idunico` para continuar un expediente ya existente no
  /// está documentado por el backend.
  Future<String> subirDocumentoSinFirma({
    required final String citizenId,
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
  /// [representante], si no es nulo, identifica a quien presenta realmente la
  /// documentación (el usuario autenticado) al aportar a un expediente de
  /// terceros: su documento va en `identificacionrep`, mientras que
  /// [documentNumber] es siempre el titular del expediente. Si es nulo se
  /// aporta como interesado y `identificacionrep` toma el propio
  /// [documentNumber] (comportamiento existente).
  ///
  /// [cancelToken] aborta la apertura: la dispara la selección del primer
  /// fichero, así que abandonar la pantalla acto seguido no debe dejar la
  /// petición colgada abriendo una transacción que nadie va a cerrar.
  ///
  /// **No verificado contra backend real.**
  Future<InicioProcedimientoResultado> iniciarProcedimiento({
    required final String citizenId,
    required final String idUnico,
    required final String documentNumber,
    required final Expediente expediente,
    final Representante? representante,
    final CancelToken? cancelToken,
  });

  /// Cierra la transacción abierta por [iniciarProcedimiento] una vez
  /// subidos todos los ficheros, y devuelve el justificante en PDF.
  ///
  /// [representante], si no es nulo, marca la aportación como "por
  /// contraste" (`esPorContraste: true`) con los datos de quien presenta
  /// realmente la documentación — uso al aportar a un expediente de
  /// terceros. Si es nulo, se aporta como interesado (comportamiento
  /// existente, sin cambios).
  ///
  /// [cancelToken] aborta el cierre: puede tardar minutos con un lote grande
  /// (el backend procesa el buzón entero), y salir de la pantalla no debe
  /// dejar la petición colgada.
  ///
  /// **No verificado contra backend real.**
  Future<Uint8List> registrarFicheros({
    required final String citizenId,
    required final String documentNumber,
    required final Expediente expediente,
    required final InicioProcedimientoResultado inicio,
    required final List<({String nombre, String hash, int tamanioBytes})> documentos,
    final Representante? representante,
    final CancelToken? cancelToken,
  });
}
