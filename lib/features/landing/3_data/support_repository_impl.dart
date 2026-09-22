import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/repositories/support_repository.dart';

final class SupportRepositoryImpl implements SupportRepository {
  SupportRepositoryImpl({required final Dio dio, required final Uri authenticatedEndpoint}) : _dio = dio, _authenticatedEndpoint = authenticatedEndpoint;

  /// Ruta pública para enviar solicitudes de soporte sin sesión.
  static const endpoint = 'https://gateway-espacio-ciudadano-des.cm-pre.jccm.es/api/v1/ciudadanos/soporte';

  final Dio _dio;
  final Uri _authenticatedEndpoint;

  @override
  Future<void> submitSupportRequest(final SupportRequest request, {final String? idAgente}) async {
    final datos = _requestData(request);
    final adjunto = _attachment(request);
    if (idAgente != null && idAgente.isNotEmpty) {
      await _dio.post<void>(
        _authenticatedEndpoint.toString(),
        data: _formData(datos: datos, adjunto: adjunto),
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      return;
    }
    await _dio.post<void>(
      endpoint,
      data: _formData(datos: datos, adjunto: adjunto),
      options: Options(
        contentType: Headers.multipartFormDataContentType,
        extra: const {anonymousRequestExtraKey: true},
      ),
    );
  }

  FormData _formData({required final String datos, required final MultipartFile? adjunto}) => FormData.fromMap(<String, dynamic>{
    'datos': datos,
    'adjunto': ?adjunto,
  });

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
