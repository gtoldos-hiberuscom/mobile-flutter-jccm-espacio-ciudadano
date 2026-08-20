import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_social_welfare_repository_impl.dart';

void main() {
  group('MyDataSocialWelfareRepositoryImpl', () {
    test('loads large family title from intermediacion contract', () async {
      final adapter = _MyDataSocialWelfareAdapter(
        responseData: {
          'body': {
            'respuesta': {
              'codestado': '0',
              'mensaje': 'Existe el título de familia numerosa.',
              'datosespecificos': {
                'datos_titulo': {
                  'row': [
                    {
                      'codigo_comunidad_automa': '8',
                      'numero_titulo': '28/000028/2015.3',
                      'categoria': 'G',
                      'titulo_vigente': 'S',
                      'fecha_efecto': '19/10/2015',
                      'fecha_caducidad': '19/10/2025',
                      'numero_hijos': 2,
                    },
                  ],
                },
                'beneficiarios': {
                  'row': [
                    {
                      'documentacion': '99046202Z',
                      'fecha_nacimiento': null,
                      'nombre': 'Adela',
                      'apellido1': 'San Juan',
                      'apellido2': 'Martin',
                      'titular': 'S',
                    },
                    {
                      'documentacion': null,
                      'fecha_nacimiento': '08/10/2012',
                      'nombre': 'Alberto',
                      'apellido1': 'Manzanares',
                      'apellido2': 'San Juan',
                      'titular': 'N',
                    },
                  ],
                },
              },
            },
          },
          'codigo-respuesta': '200.00',
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataSocialWelfareRepositoryImpl(dio: dio);

      final title = await repository.loadLargeFamilyTitle(citizenId: '99999999R', documentNumber: '99999999R');

      expect(adapter.requests.single.method, 'POST');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/99999999R/bienestar-social/familia-numerosa');
      // El contrato de intermediación exige tipo, idaut y proc además del
      // documento; la fachada los resolvía internamente y por eso no se enviaban.
      expect(adapter.requests.single.data, {
        'tipo': 'A',
        'idaut': 'ESP-CIUDADANO',
        'proc': 'JCCMEC',
        'tipodoc': 'NIF',
        'docu': '99999999R',
      });
      expect(title, isNotNull);
      expect(title!.region, 'Castilla-La Mancha');
      expect(title.titleNumber, '28/000028/2015.3');
      expect(title.category, 'G');
      expect(title.isValid, isTrue);
      expect(title.issueDate, DateTime(2015, 10, 19));
      expect(title.expiryDate, DateTime(2025, 10, 19));
      expect(title.childrenCount, 2);
      expect(title.beneficiaries, hasLength(2));
      expect(title.beneficiaries.first.documentNumber, '99046202Z');
      expect(title.beneficiaries.first.fullName, 'Adela San Juan Martin');
      expect(title.beneficiaries.first.isHolder, isTrue);
      expect(title.beneficiaries.last.birthDate, DateTime(2012, 10, 8));
    });

    test('loads thermal spa award from intermediacion contract', () async {
      final adapter = _MyDataSocialWelfareAdapter(
        responseData: {
          'body': {
            'respuesta': {
              'codestado': '0',
              'datosespecificos': {
                'Balneario': 'LA CONCEPCION',
                'FechaEntrada': '05-OCT-25',
                'FechaSalida': '10-OCT-25',
              },
            },
          },
          'codigo-respuesta': '200.00',
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataSocialWelfareRepositoryImpl(dio: dio);

      final award = await repository.loadThermalSpaAward(citizenId: 'PER9998003', documentNumber: '24540447E');

      expect(adapter.requests.single.path, '/api/v1/ciudadanos/PER9998003/bienestar-social/termalismo');
      // El contrato de intermediación exige tipo, idaut y proc además del
      // documento; la fachada los resolvía internamente y por eso no se enviaban.
      expect(adapter.requests.single.data, {
        'tipo': 'A',
        'idaut': 'ESP-CIUDADANO',
        'proc': 'JCCMEC',
        'tipodoc': 'NIF',
        'docu': '24540447E',
      });
      expect(award, isNotNull);
      expect(award!.name, 'LA CONCEPCION');
      expect(award.startDate, DateTime(2025, 10, 5));
      expect(award.endDate, DateTime(2025, 10, 10));
    });

    test('reports authorization required for business response 412.00', () async {
      final adapter = _MyDataSocialWelfareAdapter(
        responseData: {
          'body': null,
          'codigo-respuesta': '412.00',
          'info-error': {
            'errores': [
              {'codigo-error': 3034},
            ],
          },
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataSocialWelfareRepositoryImpl(dio: dio);

      expect(
        () => repository.loadLargeFamilyTitle(citizenId: '99999999R', documentNumber: '99999999R'),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('reports service unavailable when intermediacion returns no response', () async {
      final adapter = _MyDataSocialWelfareAdapter(
        responseData: {
          'body': {
            'respuesta': {
              'codestado': '1',
              'mensaje': 'Comunicación sin respuesta',
              'datosespecificos': null,
            },
          },
          'codigo-respuesta': '200.00',
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataSocialWelfareRepositoryImpl(dio: dio);

      expect(
        () => repository.loadLargeFamilyTitle(citizenId: '99999999R', documentNumber: '99999999R'),
        throwsA(
          isA<StateError>().having(
            (final error) => error.message,
            'message',
            'Comunicación sin respuesta',
          ),
        ),
      );
    });
  });
}

final class _MyDataSocialWelfareAdapter implements HttpClientAdapter {
  _MyDataSocialWelfareAdapter({this.responseData});

  final Object? responseData;
  final List<_RecordedRequest> requests = [];

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    requests.add(
      _RecordedRequest(
        method: options.method,
        path: options.path,
        data: options.data,
      ),
    );

    return ResponseBody.fromString(
      jsonEncode(
        responseData ??
            {
              'body': {
                'resul': '0',
                'mensaje': 'Existe el titulo de familia numerosa',
                'idpeticion': '7a7479f7fa5fec7a5t0013342',
                'comaut': '13',
                'nutitulo': '28/000028/2015.3',
                'categoria': 'G',
                'vigente': 'S',
                'fecexpedi': '19/10/2015',
                'feccaduci': '19/10/2025',
                'numhij': '2',
                'beneficiarios': [
                  {
                    'tipdoc': 'NIF',
                    'numdoc': '99046202Z',
                    'fecnac': null,
                    'nombre': 'Adela',
                    'apellido1': 'San Juan',
                    'apellido2': 'Martin',
                    'titular': 'S',
                  },
                  {
                    'tipdoc': null,
                    'numdoc': null,
                    'fecnac': '08/10/2012',
                    'nombre': 'Alberto',
                    'apellido1': 'Manzanares',
                    'apellido2': 'San Juan',
                    'titular': 'N',
                  },
                ],
              },
              'timestamp': '2025-07-28T08:04:57.184',
              'mensaje-respuesta': 'Respuesta correcta',
              'codigo-respuesta': '200.00',
              'info-error': null,
            },
      ),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}

final class _RecordedRequest {
  const _RecordedRequest({
    required this.method,
    required this.path,
    required this.data,
  });

  final String method;
  final String path;
  final Object? data;
}
