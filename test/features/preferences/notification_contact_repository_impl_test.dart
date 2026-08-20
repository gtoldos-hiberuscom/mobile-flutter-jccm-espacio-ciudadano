import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/3_data/notification_contact_repository_impl.dart';

import '../../test_support/sequence_http_client_adapter.dart';

void main() {
  group('NotificationContactRepositoryImpl', () {
    test('preserves the case of sub_alt in the citizen path', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 404, body: <String, dynamic>{}),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      await repository.loadContact(
        citizenId: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
      );

      expect(
        adapter.requests.single.path,
        '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/contacto',
      );
    });

    test('loads contact when API returns the direct DTO shape from the generated client', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'idTercero': 5,
            'telefono': 640559754,
            'email': 'test@example.com',
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      final result = await repository.loadContact(citizenId: '12345678Z');

      expect(result?.idTercero, 5);
      expect(result?.phone, '640559754');
      expect(result?.email, 'test@example.com');
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/12345678Z/contacto');
    });

    test('does not create contact when loading existing contact is forbidden', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 403, body: <String, dynamic>{}),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      await expectLater(
        repository.saveContact(
          citizenId: '12345678Z',
          dni: '12345678Z',
          contact: const NotificationContact(phone: '640559754'),
        ),
        throwsA(isA<DioException>()),
      );

      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/api/v1/ciudadanos/12345678Z/contacto');
    });

    test('creates contact when loading existing contact returns not found', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 404, body: <String, dynamic>{}),
        const AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'body': {
              'telefono': 640559754,
              'email': null,
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      final result = await repository.saveContact(
        citizenId: '12345678Z',
        dni: '12345678Z',
        contact: const NotificationContact(phone: '640559754'),
      );

      expect(result.phone, '640559754');
      expect(adapter.requests.map((final request) => request.method), ['GET', 'POST']);
      expect(
        adapter.requests.last.jsonBody,
        <String, dynamic>{
          'dni': '12345678Z',
          'email': null,
          'telefono': 640559754,
        },
      );
    });

    test('normalizes only the DNI body when Cl@ve provides an eIDAS identifier', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(statusCode: 404, body: <String, dynamic>{}),
        const AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'body': {
              'telefono': 640559754,
              'email': null,
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      await repository.saveContact(
        citizenId: 'ES/ES/12345678z',
        dni: 'ES/ES/12345678z',
        contact: const NotificationContact(phone: '640559754'),
      );

      expect(adapter.requests.map((final request) => request.path), [
        '/api/v1/ciudadanos/ES/ES/12345678z/contacto',
        '/api/v1/ciudadanos/ES/ES/12345678z/contacto',
      ]);
      expect(adapter.requests.last.jsonBody, containsPair('dni', '12345678Z'));
    });

    test('updates contact including idTercero when backend already has a record', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'body': {
              'idTercero': 5,
              'telefono': 640559754,
              'email': 'old@example.com',
            },
          },
        ),
        const AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'body': {
              'idTercero': 5,
              'telefono': 666777888,
              'email': 'new@example.com',
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      final result = await repository.saveContact(
        citizenId: '12345678Z',
        dni: '12345678Z',
        contact: const NotificationContact(
          phone: '666777888',
          email: 'new@example.com',
        ),
      );

      expect(result.idTercero, 5);
      expect(result.phone, '666777888');
      expect(result.email, 'new@example.com');
      expect(adapter.requests.map((final request) => request.method), ['GET', 'PUT']);
      expect(
        adapter.requests.last.jsonBody,
        <String, dynamic>{
          'dni': '12345678Z',
          'email': 'new@example.com',
          'idTercero': 5,
          'telefono': 666777888,
        },
      );
    });

    test('updates contact when record exists with only idTercero and no visible contact data', () async {
      final adapter = SequenceHttpClientAdapter([
        const AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'body': {
              'idTercero': 5,
              'telefono': null,
              'email': null,
            },
          },
        ),
        const AdapterResponse(
          statusCode: 200,
          body: <String, dynamic>{
            'body': {
              'idTercero': 5,
              'telefono': 640559754,
              'email': null,
            },
          },
        ),
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
      final repository = NotificationContactRepositoryImpl(dio: dio);

      final result = await repository.saveContact(
        citizenId: '12345678Z',
        dni: '12345678Z',
        contact: const NotificationContact(phone: '640559754'),
      );

      expect(result.idTercero, 5);
      expect(result.phone, '640559754');
      expect(adapter.requests.map((final request) => request.method), ['GET', 'PUT']);
      expect(
        adapter.requests.last.jsonBody,
        <String, dynamic>{
          'dni': '12345678Z',
          'email': null,
          'idTercero': 5,
          'telefono': 640559754,
        },
      );
    });
  });
}
