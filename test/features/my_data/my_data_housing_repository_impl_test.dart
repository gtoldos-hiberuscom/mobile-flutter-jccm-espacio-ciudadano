import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_housing_repository_impl.dart';

void main() {
  group('MyDataHousingRepositoryImpl', () {
    test('loads address data from INE endpoint', () async {
      final adapter = _HousingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      final address = await repository.loadAddress(citizenId: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6', documentNumber: '12345678A');

      expect(adapter.request?.method, 'POST');
      expect(adapter.request?.path, '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/vivienda/datos-residencia');
      expect(adapter.request?.jsonBody, {
        'tipodoc': 'NIF',
        'docu': '12345678A',
      });
      expect(address?.address, 'Calle goya lorem ipsum dolor sit amet consectetur');
      expect(address?.postalCode, '25400');
      expect(address?.municipality, 'Toledo');
      expect(address?.province, 'Toledo');
      expect(address?.collectiveEntity, 'consectetur adipiscing elit');
      expect(address?.singleEntity, 'Entidad singular');
      expect(address?.populationUnit, 'Nucleo');
      expect(address?.variationType, 'Modificación por cambio domicilio');
      expect(address?.variationDate, DateTime(2035, 7, 25));
    });

    test('compone todos los componentes del domicilio y los datos de población del INE', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _StaticAdapter(200, {
          'body': {
            'tipvia': 'CALLE',
            'nomvia': 'DEL OLVIDO',
            'kimres': '000',
            'hecres': '003',
            'numres': '4',
            'numsup': '4',
            'blores': 'AT',
            'portes': '3J',
            'escres': '22',
            'plares': '02',
            'pueres': 'B',
            'codpos': '15873',
            'denmun': 'LEON',
            'denpro': 'LEON',
            'denencol': '',
            'denensin': 'LEON',
            'dennuc': 'DISEMINADO',
          },
        });
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      final address = await repository.loadAddress(citizenId: 'citizen-1', documentNumber: '12345678A');

      expect(
        address?.address,
        'CALLE DEL OLVIDO Km 000 Hm 003 Num 4 NumSup 4 Bloque AT Portal 3J Escalera 22 Planta 02 Puerta B',
      );
      expect(address?.collectiveEntity, isNull);
      expect(address?.singleEntity, 'LEON');
      expect(address?.populationUnit, 'DISEMINADO');
    });

    test('returns null when address data is not found', () async {
      final adapter = _HousingAdapter(returnNotFound: true);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      final address = await repository.loadAddress(citizenId: 'citizen-1', documentNumber: '00000000T');

      expect(address, isNull);
    });

    test('loads real estate properties from Catastro endpoint', () async {
      final adapter = _HousingAdapter(responseKind: _ResponseKind.properties);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      final properties = await repository.loadRealEstateProperties(citizenId: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6', documentNumber: '12345678A');

      expect(adapter.request?.method, 'POST');
      expect(adapter.request?.path, '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/vivienda/datos-catastrales');
      // `tipdoc`, sin la `o`: es el nombre del campo en `DTCTROCDATREQ`.
      expect(adapter.request?.jsonBody, {
        'tipdoc': 'NIF',
        'docu': '12345678A',
      });
      expect(properties, hasLength(2));
      expect(properties.first.cadastralReference, '0009323VBD');
      expect(properties.first.address, 'C/ Central 2 - 45005 Toledo');
      expect(properties.first.cadastralValue, '123.456,89€');
      expect(properties.first.landValue, '90.000,09€');
      expect(properties.first.constructionValue, '123.456,89€');
      expect(properties.first.status, 'Esto puede ser una frase completa');
    });

    test('loads real estate properties from Catastro SVD response shape', () async {
      final adapter = _HousingAdapter(responseKind: _ResponseKind.realCatastroProperties);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      final properties = await repository.loadRealEstateProperties(citizenId: 'citizen-1', documentNumber: '27799274W');

      expect(properties, hasLength(3));
      expect(properties.first.cadastralReference, '1180217UF0818S0001YQ');
      expect(properties.first.address, 'CL TRASERA MOLINO 4 11691 TORRE-ALHAQUIME (CÁDIZ)');
      expect(properties.first.cadastralValue, '67.497,70€');
      expect(properties.first.landValue, '16.808,65€');
      expect(properties.first.constructionValue, '50.689,05€');
      expect(properties.first.use, 'RESIDENCIAL');
      expect(properties.first.cartographyUrl, 'https://www1.sedecatastro.gob.es/Cartografia/mapa.aspx?del=11&mun=36&refcat=1180217UF0818S0001YQ');
      expect(properties.first.holders, hasLength(2));
      expect(properties.first.holders.first.name, 'GARCIA GONZALEZ VIRTUDES');
      expect(properties.first.holders.first.ownership, '50,00% de Propiedad');
      expect(properties[1].cadastralReference, '4047925QA4444E0172EG');
      expect(properties[2].address, 'CL MEDINA SIDONIA 9 Es:1 Pl:03 Pt:C 11012 CADIZ');
    });

    test('returns empty list when real estate data is not found', () async {
      final adapter = _HousingAdapter(returnNotFound: true);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      final properties = await repository.loadRealEstateProperties(citizenId: 'citizen-1', documentNumber: '00000000T');

      expect(properties, isEmpty);
    });

    // Contrato de estados de intermediación (el mismo que salud y bienestar
    // social): el sobre manda, el 403 desnudo es fallo de servicio y ningún
    // error de transporte puede leerse como «sin domicilio» o «sin inmuebles».

    test('un 403 con el sobre de autorización pide autorizar', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(403, {'codigo-respuesta': '412.00'});
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadAddress(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
      await expectLater(
        repository.loadRealEstateProperties(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('un 403 sin sobre es un fallo de servicio, no falta de autorización', () async {
      // "403 Forbidden: [no body]" es la fachada fallando contra su
      // microservicio: ofrecer "autorizar" ahí no lleva a ninguna parte.
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(403, null);
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadAddress(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<DioException>()),
      );
      await expectLater(
        repository.loadRealEstateProperties(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<DioException>()),
      );
    });

    test('a 500 with body propagates instead of becoming empty housing data', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(500, {'codigo-respuesta': '500.00', 'mensaje-respuesta': 'Error'});
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadAddress(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<DioException>()),
      );
      await expectLater(
        repository.loadRealEstateProperties(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<DioException>()),
      );
    });

    test('un 200 con el sobre de autorización no se pinta como datos', () async {
      // El fallo cerrado del gateway: responde 200 y mete el 412.00 en el
      // sobre. Leerlo como datos pintaba "sin domicilio"/"sin inmuebles" en
      // vez del aviso de autorización (MD-1, misma familia que salud).
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(200, {'codigo-respuesta': '412.00', 'body': null});
      final repository = MyDataHousingRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadAddress(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
      await expectLater(
        repository.loadRealEstateProperties(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });
  });
}

final class _StaticAdapter implements HttpClientAdapter {
  _StaticAdapter(this.statusCode, this.body);

  final int statusCode;
  final Object? body;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    await (requestStream ?? const Stream<Uint8List>.empty()).drain<void>();
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}

enum _ResponseKind { address, properties, realCatastroProperties }

final class _CapturedRequest {
  const _CapturedRequest({
    required this.method,
    required this.path,
    required this.jsonBody,
  });

  final String method;
  final String path;
  final Map<String, dynamic>? jsonBody;
}

final class _HousingAdapter implements HttpClientAdapter {
  _HousingAdapter({
    this.returnNotFound = false,
    this.responseKind = _ResponseKind.address,
  });

  final bool returnNotFound;
  final _ResponseKind responseKind;
  _CapturedRequest? request;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    final bodyBytes = <int>[];
    await for (final chunk in requestStream ?? const Stream<Uint8List>.empty()) {
      chunk.forEach(bodyBytes.add);
    }
    request = _CapturedRequest(
      method: options.method,
      path: options.path,
      jsonBody: bodyBytes.isEmpty ? null : jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>,
    );

    if (returnNotFound) {
      return ResponseBody.fromString('', 404);
    }

    return ResponseBody.fromString(
      jsonEncode(_responseBody()),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  Map<String, Object?> _responseBody() {
    return switch (responseKind) {
      _ResponseKind.address => {
        'body': {
          'domicilio': 'Calle goya lorem ipsum dolor sit amet consectetur',
          'codpos': '25400',
          'denmun': 'Toledo',
          'denpro': 'Toledo',
          'denencol': 'consectetur adipiscing elit',
          'denensin': 'Entidad singular',
          'dennuc': 'Nucleo',
          'descvar': 'Modificación por cambio domicilio',
          'fecvar': '25/07/2035',
        },
      },
      _ResponseKind.properties => {
        'body': {
          'inmuebles': [
            {
              'refcat': '0009323VBD',
              'direccion': 'C/ Central 2 - 45005 Toledo',
              'valorCatastral': '123456.89',
              'valorSuelo': '90000,09',
              'valorConstruccion': '123.456,89€',
              'estado': 'Esto puede ser una frase completa',
              'tipo': 'Urbano',
            },
            {
              'referenciaCatastral': '16079A01700159',
              'direccion': 'Calle Trillo, 15 - 16400 Cuenca',
              'valor_catastral': '87950.34',
              'valor_suelo': '52770.20',
              'valor_construccion': '35180.14',
              'estado': 'Esto puede ser una frase completa',
              'tipo': 'Rústico',
            },
          ],
        },
      },
      _ResponseKind.realCatastroProperties => {
        'body': {
          'atributos': {
            'numElementos': 1,
            'estado': {'literalError': 'Tramitada'},
          },
          'transmisiones': {
            'transmisionDatos': {
              'datosEspecificos': {
                'listaBienesInmuebles': {
                  'datosInmueble': [
                    {
                      'bienInmuebleRustico': {
                        'idine': {
                          'cn': 'UR',
                          'rc': {
                            'pc1': '1180217',
                            'pc2': 'UF0818S',
                            'car': '0001',
                            'cc1': 'Y',
                            'cc2': 'Q',
                          },
                        },
                        'ldt': 'CL TRASERA MOLINO 4 11691 TORRE-ALHAQUIME (CÁDIZ)',
                        'debi': {
                          'vcat': '67497,70',
                          'vcs': '16808,65',
                          'vcc': '50689,05',
                          'luso': 'RESIDENCIAL',
                        },
                      },
                      'listaTitulares': {
                        'titular': [
                          {
                            'idpOut': {'nom': 'GARCIA GONZALEZ VIRTUDES'},
                            'lder': '50,00% de Propiedad',
                          },
                          {
                            'idpOut': {'nom': 'FERNANDEZ GONZALEZ CESAR'},
                            'lder': '50,00% de Propiedad',
                          },
                        ],
                      },
                      'finca': {
                        'infgraf': {
                          'igraf': 'https://www1.sedecatastro.gob.es/Cartografia/mapa.aspx?del=11&amp;mun=36&amp;refcat=1180217UF0818S0001YQ',
                        },
                      },
                    },
                    {
                      'bienInmuebleRustico': {
                        'idine': {
                          'cn': 'UR',
                          'rc': {
                            'pc1': '4047925',
                            'pc2': 'QA4444E',
                            'car': '0172',
                            'cc1': 'E',
                            'cc2': 'G',
                          },
                        },
                        'ldt': 'AV SAN SEVERIANO 47 Es:1 Pl:-2 Pt:84 11012 CADIZ (CÁDIZ)',
                        'debi': {
                          'vcat': '9212,20',
                          'vcs': '2210,82',
                          'vcc': '7001,38',
                        },
                      },
                    },
                    {
                      'bienInmuebleRustico': {
                        'idine': {
                          'cn': 'UR',
                          'rc': {
                            'pc1': '4144604',
                            'pc2': 'QA4444C',
                            'car': '0074',
                            'cc1': 'K',
                            'cc2': 'Z',
                          },
                        },
                        'ldt': 'CL MEDINA SIDONIA 9 Es:1 Pl:03 Pt:C 11012 CADIZ',
                        'debi': {
                          'vcat': '48645,77',
                          'vcs': '17955,53',
                          'vcc': '30690,24',
                        },
                      },
                    },
                  ],
                },
              },
            },
          },
        },
      },
    };
  }

  @override
  void close({final bool force = false}) {}
}
