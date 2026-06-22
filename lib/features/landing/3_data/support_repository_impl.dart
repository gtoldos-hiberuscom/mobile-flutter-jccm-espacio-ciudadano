import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/repositories/support_repository.dart';

final class SupportRepositoryImpl implements SupportRepository {
  const SupportRepositoryImpl({required final Dio dio}) : _dio = dio;

  static const endpoint = '/api/v1/soporte';

  final Dio _dio;

  @override
  Future<void> submitSupportRequest(final SupportRequest request) async {
    await _dio.post<dynamic>(
      endpoint,
      data: _toFormData(request),
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
  }

  FormData _toFormData(final SupportRequest request) {
    final attachment = request.attachment;
    return FormData.fromMap(
      <String, dynamic>{
        'datos': jsonEncode(
          <String, String>{
            'asunto': request.subject,
            'descripcion': request.message,
            'email': request.email,
            if (request.name.isNotEmpty) 'nombreApellidos': request.name,
          },
        ),
        if (attachment != null)
          'adjunto': MultipartFile.fromBytes(
            attachment.bytes,
            filename: attachment.fileName,
          ),
      },
    );
  }
}
