import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });
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
