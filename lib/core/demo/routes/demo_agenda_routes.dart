import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_agenda_fixtures.dart';

/// Rutas de la agenda general del backend demo.
///
/// Solo `eventos`: la otra fuente de la agenda, `salud/primaria-citas-pendientes`,
/// la sirve `demoMyDataRoutes`, porque es la misma URL que consume Mis datos →
/// Salud y una sola ruta vale para `SaludApi` y para `SescamApi`. El backend
/// demo tiene que registrar las dos listas para que la agenda cargue entera;
/// con solo esta, SESCAM responde 404 y la agenda se queda con los eventos.
List<DemoRoute> demoAgendaRoutes({required final DateTime Function() now}) {
  const citizen = '/api/v1/ciudadanos/([^/]+)';
  return [
    // El periodo va en mayúsculas y la app solo pide TODOS.
    DemoRoute('GET', '$citizen/eventos/TODOS', (final _) {
      final at = now();
      return DemoResponse.ok(DemoAgendaFixtures.eventos(at), now: at);
    }),
    // Refrescar no hace nada en demo: no hay sistemas origen que consultar.
    // Devuelve los contadores del contrato y la app recarga los eventos.
    DemoRoute('GET', '$citizen/eventos/refrescar', (final _) => DemoResponse.ok(DemoAgendaFixtures.refrescar, now: now())),
  ];
}
