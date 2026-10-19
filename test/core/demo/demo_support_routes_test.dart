import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_support_routes.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/3_data/support_repository_impl.dart';

void main() {
  // Como `supportRepositoryProvider`: la URL autenticada sale de la
  // configuración del entorno, no se escribe a mano en el test.
  const config = AppConfig.fromMap({'APP_FLAVOR': 'development'});
  late SupportRepositoryImpl repository;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'https://demo.invalid'))
      ..httpClientAdapter = DemoHttpClientAdapter(
        DemoBackend(routes: demoSupportRoutes(), now: DateTime.now),
        latency: Duration.zero,
      );
    repository = SupportRepositoryImpl(dio: dio, authenticatedEndpoint: config.authenticatedSupportUrl);
  });

  test('el envío anónimo (URL absoluta del gateway, multipart con adjunto) se da por registrado', () async {
    await expectLater(
      repository.submitSupportRequest(
        SupportRequest(
          name: 'Lucía Ejemplo Demo',
          email: 'lucia.demo@example.es',
          subject: 'Prueba de soporte',
          message: 'Mensaje de demostración.',
          privacyConsentAccepted: true,
          attachment: SupportRequestAttachment(
            fileName: 'captura.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          ),
        ),
      ),
      completes,
    );
  });

  test('el envío autenticado (URL absoluta de la fachada) se da por registrado', () async {
    await expectLater(
      repository.submitSupportRequest(
        const SupportRequest(
          name: '',
          email: 'lucia.demo@example.es',
          subject: 'Prueba de soporte',
          message: 'Mensaje de demostración.',
          privacyConsentAccepted: false,
        ),
        idAgente: DemoSession.idAgente,
      ),
      completes,
    );
  });
}
