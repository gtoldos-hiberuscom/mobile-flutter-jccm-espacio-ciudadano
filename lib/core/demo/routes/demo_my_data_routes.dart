import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_health_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_my_data_fixtures.dart';

/// Rutas de «Mis datos» del backend demo: bienestar social, educación, empleo,
/// vivienda, vehículos y salud. Todas de solo lectura, y todas con datos: el
/// revisor tiene que poder entrar en cada pantalla y ver algo.
///
/// Las de salud viven aquí aunque `primaria-citas-pendientes` la consuma
/// también la agenda (vía `SescamApi`): es la misma URL con el mismo cuerpo, y
/// una sola ruta sirve a los dos parsers. `demoAgendaRoutes` no la repite.
///
/// Los cuerpos POST (`tipodoc`/`docu`, los datos del titular…) se ignoran: el
/// backend demo solo conoce a una persona, y el segmento `{id}` acepta
/// cualquier valor porque la fachada declara `numDocumento` o `idAgente`
/// según la operación.
List<DemoRoute> demoMyDataRoutes({required final DateTime Function() now}) {
  const citizen = '/api/v1/ciudadanos/([^/]+)';

  DemoRoute route(final String method, final String path, final Object? Function(DateTime now) body) => DemoRoute(method, '$citizen/$path', (final _) {
    final at = now();
    return DemoResponse.ok(body(at), now: at);
  });

  return [
    // Bienestar social (intermediación): `respuesta.codestado` a 0 y los datos
    // en `datosespecificos`, como devuelve el servicio real.
    route('POST', 'bienestar-social/familia-numerosa', DemoMyDataFixtures.familiaNumerosa),
    route('POST', 'bienestar-social/discapacidad', (final _) => DemoMyDataFixtures.discapacidad),
    route('POST', 'bienestar-social/termalismo', DemoMyDataFixtures.termalismo),
    route('POST', 'bienestar-social/atencion-dependencia', (final _) => DemoMyDataFixtures.atencionDependencia),
    route('POST', 'bienestar-social/tarjeta-estacionamiento', DemoMyDataFixtures.tarjetaEstacionamiento),
    // Educación.
    route('POST', 'educacion/titulos-universitarios', (final _) => DemoMyDataFixtures.titulosUniversitarios),
    route('POST', 'educacion/titulos-no-universitarios', (final _) => DemoMyDataFixtures.titulosNoUniversitarios),
    // Empleo. El segmento es `ofertas`, el de la fachada (ver `EmpleoApi`).
    route('POST', 'empleo/demandante-empleo-fecha-actual', (final _) => DemoMyDataFixtures.demandanteEmpleo),
    route('POST', 'empleo/ofertas', DemoMyDataFixtures.ofertasEmpleo),
    // Vivienda.
    route('POST', 'vivienda/datos-residencia', (final _) => DemoMyDataFixtures.datosResidencia),
    route('POST', 'vivienda/datos-catastrales', (final _) => DemoMyDataFixtures.datosCatastrales),
    // Vehículos. `vehiculos` a secas, el de la fachada (ver `VehiculosApi`).
    route('POST', 'vehiculos', (final _) => DemoMyDataFixtures.vehiculos),
    // Salud (SESCAM).
    route('GET', 'salud/cip', (final _) => DemoHealthFixtures.cipBody),
    route('GET', 'salud/primaria-citas-pendientes', DemoHealthFixtures.primaryCarePending),
    DemoRoute('GET', '$citizen/salud/primaria-citas-pasadas', (final request) {
      // `pagina` empieza en 0 como en el gateway; sin parámetro, la primera.
      final page = int.tryParse(request.query['pagina'] ?? '') ?? 0;
      final at = now();
      return DemoResponse.ok(DemoHealthFixtures.primaryCarePast(at, page: page), now: at);
    }),
    route('GET', 'salud/hospitalaria-citas-pendientes', DemoHealthFixtures.hospitalPending),
    route('GET', 'salud/hospitalaria-citas-pasadas', DemoHealthFixtures.hospitalPast),
  ];
}
