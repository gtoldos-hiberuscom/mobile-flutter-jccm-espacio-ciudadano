import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/document_type.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_education_repository_impl.dart';

void main() {
  group('MyDataEducationRepositoryImpl', () {
    test('queries university titles on the citizen resource route', () async {
      final adapter = _CapturingAdapter();
      final repository = MyDataEducationRepositoryImpl(dio: _dio(adapter));

      final titles = await repository.loadUniversityTitles(
        citizenId: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
        documentNumber: '99999999R',
      );

      expect(adapter.method, 'POST');
      expect(adapter.path, '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/educacion/titulos-universitarios');
      // El documento viaja en el cuerpo, no en la ruta: contra el gateway el
      // segmento lleva sub_alt y dejan de coincidir.
      expect(adapter.jsonBody, {'tipodoc': 'NIF', 'docu': '99999999R'});

      expect(titles, hasLength(1));
      expect(titles.single.titleName, 'Licenciado en Filología Hispánica');
      expect(titles.single.universityName, 'Universidad de Barcelona');
      expect(titles.single.titleNumber, '1988000333');
    });

    test('queries non-university titles on the citizen resource route', () async {
      final adapter = _CapturingAdapter();
      final repository = MyDataEducationRepositoryImpl(dio: _dio(adapter));

      await repository.loadNonUniversityTitles(
        citizenId: 'PER9998003',
        documentNumber: '99999999R',
      );

      expect(adapter.path, '/api/v1/ciudadanos/PER9998003/educacion/titulos-no-universitarios');
    });

    test('derives the document type instead of always sending NIF', () async {
      final adapter = _CapturingAdapter();
      final repository = MyDataEducationRepositoryImpl(dio: _dio(adapter));

      await repository.loadUniversityTitles(citizenId: 'id', documentNumber: 'X1234567L');

      // Estaba fijado a NIF, lo que rompía la consulta de cualquier NIE en cuanto
      // el documento dejó de viajar en la ruta.
      expect(adapter.jsonBody, {'tipodoc': 'NIE', 'docu': 'X1234567L'});
    });
  });

  group('documentTypeOf', () {
    test('classifies NIF, NIE and CIF', () {
      expect(documentTypeOf('99999999R'), 'NIF');
      expect(documentTypeOf('x1234567l'), 'NIE');
      expect(documentTypeOf('Y7654321X'), 'NIE');
      expect(documentTypeOf('B12345674'), 'CIF');
      expect(documentTypeOf(''), 'NIF');
    });
  });
}

Dio _dio(final _CapturingAdapter adapter) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://example.test',
      headers: const {Headers.contentTypeHeader: Headers.jsonContentType},
    ),
  )..httpClientAdapter = adapter;
}

final class _CapturingAdapter implements HttpClientAdapter {
  String? method;
  String? path;
  Map<String, dynamic>? jsonBody;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    method = options.method;
    path = options.path;

    final bodyBytes = <int>[];
    await (requestStream ?? const Stream<Uint8List>.empty()).forEach(bodyBytes.addAll);
    if (bodyBytes.isNotEmpty) {
      jsonBody = jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
    }

    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{
        'body': {
          'resul': '0',
          'mensaje': 'TRAMITADA',
          'elemento': [
            {
              'univers': 'Universidad de Barcelona',
              'centro': 'Facultad de Filología',
              'nomcar': 'Licenciado en Filología Hispánica',
              'tipotit': 'Licenciado',
              'fecfin': '01/06/2000',
              'numtit': '1988000333',
              'fecexpedicion': '08/05/2008',
            },
          ],
        },
        'codigo-respuesta': '200.00',
        'mensaje-respuesta': 'Respuesta correcta',
        'info-error': null,
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
