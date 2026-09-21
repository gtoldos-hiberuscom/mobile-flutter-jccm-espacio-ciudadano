import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/repositories/support_repository.dart';

final class SupportRepositoryImpl implements SupportRepository {
  SupportRepositoryImpl({required final Dio dio}) : _api = SoporteApi(withGeneratedApiCompat(dio), standardSerializers);

  /// Ruta pública (sin sesión). El gateway de Espacio Ciudadano no la sirve
  /// (404): sólo expone `/api/v1/ciudadanos/**`.
  static const endpoint = '/api/v1/soporte';

  /// Ruta autenticada que sirve el gateway para un ciudadano con sesión.
  static String citizenEndpoint(final String idAgente) => '/api/v1/ciudadanos/$idAgente/soporte';

  final SoporteApi _api;

  @override
  Future<void> submitSupportRequest(final SupportRequest request, {final String? idAgente}) async {
    final datos = _requestData(request);
    final adjunto = _attachment(request);
    if (idAgente != null && idAgente.isNotEmpty) {
      await _api.crearTareaSoporte1(
        idAgente: idAgente,
        datos: datos,
        adjunto: adjunto,
      );
      return;
    }
    await _api.crearTareaSoporte(
      datos: datos,
      adjunto: adjunto,
    );
  }

  String _requestData(final SupportRequest request) {
    return jsonEncode(
      <String, String>{
        'asunto': request.subject,
        'descripcion': request.message,
        'email': request.email,
        if (request.name.isNotEmpty) 'nombreApellidos': request.name,
      },
    );
  }

  MultipartFile? _attachment(final SupportRequest request) {
    final attachment = request.attachment;
    if (attachment == null) {
      return null;
    }
    return MultipartFile.fromBytes(
      attachment.bytes,
      filename: attachment.fileName,
    );
  }
}
