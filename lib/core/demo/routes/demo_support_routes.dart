import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';

/// Rutas del formulario de soporte para el modo demostración.
///
/// `SupportRepositoryImpl` envía a URLs **absolutas** —la pública del gateway
/// (`…/api/v1/ciudadanos/soporte`) y la autenticada de la fachada
/// (`AppConfig.authenticatedSupportUrl`, `…/api/v1/soporte`)—, pero el
/// enrutador casa solo la ruta, así que el host da igual. El cuerpo es
/// multipart y el adapter no lo decodifica: aquí basta con confirmar el alta,
/// que es lo único que el repositorio comprueba (un 2xx).
List<DemoRoute> demoSupportRoutes() => <DemoRoute>[
  DemoRoute('POST', '/api/v1/ciudadanos/soporte', (final _) => _registered()),
  DemoRoute('POST', '/api/v1/soporte', (final _) => _registered()),
];

/// Alta ficticia: no se envía nada a ningún sitio. El mensaje lo dice por si
/// algún día una pantalla lo muestra.
DemoResponse _registered() => DemoResponse.envelope(demoEnvelope(<String, Object?>{'numeroSoporte': 'SOP-DEMO-000001'}, message: 'Solicitud de soporte registrada (demostración)'));
