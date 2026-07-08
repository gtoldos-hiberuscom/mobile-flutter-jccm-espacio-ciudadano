import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_documento_repository.dart';

final class GestionDocumentoRepositoryImpl implements GestionDocumentoRepository {
  GestionDocumentoRepositoryImpl({required final Dio dio}) : _api = ProcedimientoApi(withGeneratedApiCompat(dio), standardSerializers);

  final ProcedimientoApi _api;

  @override
  Future<void> subirDocumentoSinFirma({
    required final String documentNumber,
    required final String idUnico,
    required final String tipoProcedimiento,
    required final String nombreFichero,
    required final Uint8List bytes,
    final CancelToken? cancelToken,
    final void Function(double progreso)? onProgress,
  }) async {
    final adjunto = ADJUNTO(
      (final builder) => builder
        ..idunico = idUnico
        ..nifcif = documentNumber
        ..nombre = nombreFichero
        ..tipoprocedimiento = tipoProcedimiento
        ..data = base64Encode(bytes),
    );

    try {
      await _api.miSubirAdjuntoSinFirmaOperation(
        adjuntoBody: adjunto,
        cancelToken: cancelToken,
        onSendProgress: (final sent, final total) {
          if (total > 0) {
            onProgress?.call(sent / total);
          }
        },
      );
    } on DioException catch (error) {
      // Confirmado contra backend real (UAT): este endpoint responde 200 con
      // el sobre genérico `Respuesta` ({body, timestamp, mensaje-respuesta,
      // codigo-respuesta, info-error}), no con `RESULTADOPROCEDIMIENTO` como
      // documenta el swagger. El cliente generado deserializa en tipado
      // estricto y lanza DioException aunque la petición HTTP haya sido
      // correcta — si el status es 2xx se considera éxito pese al fallo de
      // deserialización.
      final statusCode = error.response?.statusCode;
      if (statusCode == null || statusCode < 200 || statusCode >= 300) {
        rethrow;
      }
    }
  }
}
