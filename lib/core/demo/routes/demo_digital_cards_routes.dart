import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_digital_cards_fixtures.dart';

/// Rutas de `CarnetDigitalApi` para el modo demostración.
///
/// Mismos verbos que el cliente generado —los artefactos del Carné Joven son
/// `POST`; los pkpass de familia numerosa y discapacidad, `GET`— y mismo sobre
/// con el base64 dentro de `body`, para que el repositorio real los decodifique
/// tal cual. El segmento `{dni}` se casa con `([^/]+)`: el identificador lo
/// decide el provider de la app, no esta tabla.
List<DemoRoute> demoDigitalCardsRoutes({required final DateTime Function() now}) {
  const base = '/api/v1/ciudadanos/([^/]+)/carnet-digital';
  return <DemoRoute>[
    DemoRoute('GET', '$base/joven', (final _) => DemoResponse.ok(DemoDigitalCardsFixtures.youthCard(now: now()), now: now())),
    DemoRoute('GET', '$base/familia-numerosa', (final _) => DemoResponse.ok(DemoDigitalCardsFixtures.largeFamilyCard(now: now()), now: now())),
    DemoRoute('GET', '$base/discapacidad', (final _) => DemoResponse.ok(DemoDigitalCardsFixtures.disabilityCard(now: now()), now: now())),
    DemoRoute('POST', '$base/joven/pdf', (final _) => DemoResponse.ok(DemoDigitalCardsFixtures.youthPdf, now: now())),
    DemoRoute('POST', '$base/joven/pkpass', (final _) => DemoResponse.ok(DemoDigitalCardsFixtures.pkPass, now: now())),
    DemoRoute('POST', '$base/joven/qr', (final _) => DemoResponse.ok(DemoDigitalCardsFixtures.youthQr, now: now())),
    DemoRoute('GET', '$base/familia-numerosa/pkpass', (final _) => DemoResponse.ok(DemoDigitalCardsFixtures.pkPass, now: now())),
    DemoRoute('GET', '$base/discapacidad/pkpass', (final _) => DemoResponse.ok(DemoDigitalCardsFixtures.pkPass, now: now())),
  ];
}
