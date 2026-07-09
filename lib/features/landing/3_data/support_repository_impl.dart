import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/repositories/support_repository.dart';

final class SupportRepositoryImpl implements SupportRepository {
  SupportRepositoryImpl({required final Dio dio}) : _api = SoporteApi(withGeneratedApiCompat(dio), standardSerializers);

  static const endpoint = '/api/v1/soporte';

  final SoporteApi _api;

  @override
  Future<void> submitSupportRequest(final SupportRequest request) async {
    await _api.crearTareaSoporte(
      datos: _requestData(request),
      adjunto: _attachment(request),
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
