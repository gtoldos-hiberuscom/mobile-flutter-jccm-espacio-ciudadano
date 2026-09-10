import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_vehicles_repository_impl.dart';

void main() {
  group('MyDataVehiclesRepositoryImpl', () {
    test('loads vehicles from the ciudadano vehicles resource', () async {
      final adapter = _VehiclesAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataVehiclesRepositoryImpl(dio: dio);

      final vehicles = await repository.loadVehicles(
        citizenId: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
        documentNumber: '12345678A',
      );

      expect(adapter.method, 'POST');
      expect(adapter.path, '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/vehiculos');
      expect(adapter.jsonBody, {
        'tipodoc': 'NIF',
        'docu': '12345678A',
      });
      expect(vehicles.map((final vehicle) => vehicle.licensePlate), ['1234ABC', '9876KPV']);
    });

    test('infers the document type instead of assuming NIF', () async {
      final adapter = _VehiclesAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataVehiclesRepositoryImpl(dio: dio);

      await repository.loadVehicles(citizenId: 'citizen-1', documentNumber: 'X1234567L');

      expect(adapter.jsonBody?['tipodoc'], 'NIE');
    });

    test('returns an empty list when there are no vehicles', () async {
      final adapter = _VehiclesAdapter(returnNotFound: true);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = MyDataVehiclesRepositoryImpl(dio: dio);

      final vehicles = await repository.loadVehicles(citizenId: 'citizen-1', documentNumber: '00000000T');

      expect(vehicles, isEmpty);
    });

    // Contrato de estados de intermediación (el mismo que salud y bienestar
    // social): el sobre manda, el 403 desnudo es fallo de servicio y ningún
    // error de transporte puede leerse como «no tienes vehículos».

    test('un 403 con el sobre de autorización pide autorizar', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(403, {'codigo-respuesta': '412.00'});
      final repository = MyDataVehiclesRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadVehicles(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<MyDataAuthorizationRequired>()),
      );
    });

    test('un 403 sin sobre es un fallo de servicio, no falta de autorización', () async {
      // "403 Forbidden: [no body]" es la fachada fallando contra su
      // microservicio: ofrecer "autorizar" ahí no lleva a ninguna parte.
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(403, null);
      final repository = MyDataVehiclesRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadVehicles(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<DioException>()),
      );
    });

    test('a 500 with body propagates instead of becoming an empty vehicle list', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(500, {'codigo-respuesta': '500.00', 'mensaje-respuesta': 'Error'});
      final repository = MyDataVehiclesRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadVehicles(citizenId: 'citizen-1', documentNumber: '12345678A'),
        throwsA(isA<DioException>()),
      );
    });

    test('un 200 con el sobre de autorización no se pinta como datos', () async {
      // El fallo cerrado del gateway: responde 200 y mete el 412.00 en el
      // sobre. Leerlo como datos pintaba "no tienes vehículos" en vez del
      // aviso de autorización (MD-1, misma familia que salud).
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = _StaticAdapter(200, {'codigo-respuesta': '412.00', 'body': null});
      final repository = MyDataVehiclesRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadVehicles(citizenId: 'citizen-1', documentNumber: '12345678A'),
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

final class _VehiclesAdapter implements HttpClientAdapter {
  _VehiclesAdapter({this.returnNotFound = false});

  final bool returnNotFound;
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
    await for (final chunk in requestStream ?? const Stream<Uint8List>.empty()) {
      chunk.forEach(bodyBytes.add);
    }
    if (bodyBytes.isNotEmpty) {
      jsonBody = jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
    }

    if (returnNotFound) {
      return ResponseBody.fromString('', 404);
    }

    return ResponseBody.fromString(
      jsonEncode({
        'body': {
          'listavehiculos': {
            'vehiculo': [
              {'matricula': '1234ABC'},
              {'matricula': '9876KPV'},
            ],
          },
        },
        'timestamp': '2026-08-20T08:35:53.157147',
        'mensaje-respuesta': 'Respuesta correcta',
        'codigo-respuesta': '200.00',
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
