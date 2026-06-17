import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/repositories/support_repository.dart';

final class SupportRepositoryImpl implements SupportRepository {
  const SupportRepositoryImpl({required final Dio dio}) : _dio = dio;

  static const endpoint = '/api/v1/consulta/miconsultareq';

  final Dio _dio;

  @override
  Future<void> submitSupportRequest(final SupportRequest request) async {
    await _dio.post<Map<String, dynamic>>(
      endpoint,
      data: _toJson(request),
    );
  }

  Map<String, dynamic> _toJson(final SupportRequest request) {
    return <String, dynamic>{
      'idatos': <String, dynamic>{
        'subfam': 'SOPORTE_TECNICO',
      },
      'returns': <String, dynamic>{},
      'tfaq': <String, dynamic>{
        'item': <Map<String, String>>[
          _line(1, 'nombre', request.name),
          _line(2, 'email', request.email),
          _line(3, 'asunto', request.subject),
          _line(4, 'mensaje', request.message),
          _line(5, 'proteccion_datos', request.privacyConsentAccepted ? 'S' : 'N'),
          if (request.attachment case final attachment?) ...[
            _line(6, 'adjunto_nombre', attachment.fileName),
            _line(7, 'adjunto_base64', base64Encode(attachment.bytes)),
          ],
        ],
      },
    };
  }

  Map<String, String> _line(final int sequence, final String key, final String value) {
    return <String, String>{
      'numseq': sequence.toString().padLeft(3, '0'),
      'textlinea': key,
      'textarea': value,
    };
  }
}
