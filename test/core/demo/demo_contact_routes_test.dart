import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_contact_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_contact_routes.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/3_data/notification_contact_repository_impl.dart';

void main() {
  final fixedNow = DateTime(2026, 10, 16, 10, 30);
  // La pantalla manda `sub_alt` en la ruta (`ciudadanosEndpointIdProvider`) y
  // el documento en el cuerpo.
  const citizenId = DemoSession.idAgente;
  const dni = DemoSession.personIdentifier;

  late DemoContactState state;
  late List<String> methods;
  late NotificationContactRepositoryImpl repository;

  setUp(() {
    state = DemoContactState();
    methods = <String>[];
    final dio = _demoDio(demoContactRoutes(state), fixedNow)
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (final options, final handler) {
            methods.add(options.method);
            handler.next(options);
          },
        ),
      );
    // Como `notificationContactRepositoryProvider`.
    repository = NotificationContactRepositoryImpl(dio: dio);
  });

  group('demoContactRoutes', () {
    test('sin contacto, la lectura devuelve null (404 documentado)', () async {
      expect(await repository.loadContact(citizenId: citizenId), isNull);
      expect(methods, <String>['GET']);
      expect(state.exists, isFalse);
    });

    test('guardar sin contacto previo da de alta (POST) y la lectura lo devuelve', () async {
      final saved = await repository.saveContact(
        citizenId: citizenId,
        dni: dni,
        contact: const NotificationContact(phone: '600 123 456', email: 'lucia.ejemplo@example.com'),
      );

      expect(methods, <String>['GET', 'POST']);
      expect(saved.idTercero, demoContactIdTercero);
      expect(saved.phone, '600123456');
      expect(saved.email, 'lucia.ejemplo@example.com');
      expect(state.contact?.dni, dni);

      final loaded = await repository.loadContact(citizenId: citizenId);
      expect(loaded?.idTercero, demoContactIdTercero);
      expect(loaded?.phone, '600123456');
      expect(loaded?.email, 'lucia.ejemplo@example.com');
    });

    test('guardar con contacto existente lo modifica (PUT) conservando el idTercero', () async {
      await repository.saveContact(
        citizenId: citizenId,
        dni: dni,
        contact: const NotificationContact(phone: '600123456', email: 'lucia.ejemplo@example.com'),
      );
      methods.clear();

      final updated = await repository.saveContact(
        citizenId: citizenId,
        dni: dni,
        contact: const NotificationContact(phone: '611222333'),
      );

      expect(methods, <String>['GET', 'PUT']);
      expect(updated.idTercero, demoContactIdTercero);
      expect(updated.phone, '611222333');
      expect(updated.email, isNull);

      final loaded = await repository.loadContact(citizenId: citizenId);
      expect(loaded?.idTercero, demoContactIdTercero);
      expect(loaded?.phone, '611222333');
      expect(loaded?.email, isNull);
    });

    test('tras borrar el estado, la lectura vuelve a ser null', () async {
      await repository.saveContact(
        citizenId: citizenId,
        dni: dni,
        contact: const NotificationContact(phone: '600123456'),
      );

      state.clear();

      expect(await repository.loadContact(citizenId: citizenId), isNull);
    });
  });
}

Dio _demoDio(final List<DemoRoute> routes, final DateTime now) => Dio(BaseOptions(baseUrl: 'https://demo.invalid'))
  ..httpClientAdapter = DemoHttpClientAdapter(
    DemoBackend(routes: routes, now: () => now),
    latency: Duration.zero,
  );
