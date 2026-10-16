import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_personalization_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_recommendations_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_personalization_routes.dart';

/// Ventana de «últimos trámites» (`operacion=ut`) si la petición no manda
/// `ultimosDias`.
const int _defaultRecentDays = 30;

/// Horizonte de «plazo inmediato» (`operacion=ti`): trámites cuyo plazo de
/// presentación cierra dentro de estos días.
const int _immediateHorizonDays = 15;

/// `GET {id}/recomendaciones`, derivadas de los hechos marcados en
/// [personalization] en ese momento: cambiar la selección cambia la lista.
///
/// Misma forma que el gateway: con `operacion=todo` el cuerpo agrupa los
/// trámites por hecho (`listaTramitesPorHechos`); con `ut`/`no`/`ti` es un
/// listado plano paginado en el que cada trámite lleva sus `hechosVitales`.
/// Sin resultados responde el sobre de negocio `404.01`, que el repositorio
/// traduce a lista vacía.
List<DemoRoute> demoRecommendationsRoutes({required final DemoPersonalizationState personalization, required final DateTime Function() now}) => <DemoRoute>[
  DemoRoute('GET', '/api/v1/ciudadanos/([^/]+)/recomendaciones', (final request) {
    final today = now();
    final operation = request.query['operacion'] ?? 'todo';
    final selected = personalization.selectedIds;
    final procedures = demoProceduresCatalogue.where((final procedure) => selected.contains(procedure.lifeEventId)).where((final procedure) => _matchesOperation(procedure, operation, request.query)).toList(growable: false);
    if (procedures.isEmpty) {
      return _noResults(today);
    }
    if (operation == 'todo') {
      return DemoResponse.ok(_groupedBody(procedures, today), now: today);
    }
    return DemoResponse.ok(_flatBody(_page(procedures, request.query), today), now: today);
  }),
];

bool _matchesOperation(final DemoProcedureFixture procedure, final String operation, final Map<String, String> query) => switch (operation) {
  'ut' => procedure.opensInDays <= 0 && procedure.opensInDays >= -(int.tryParse(query['ultimosDias'] ?? '') ?? _defaultRecentDays),
  'no' => procedure.isNews,
  'ti' => procedure.closesInDays != null && procedure.closesInDays! >= 0 && procedure.closesInDays! <= _immediateHorizonDays,
  _ => true,
};

/// Aplica `size`/`page` si vienen; sin `size` se devuelve todo.
List<DemoProcedureFixture> _page(final List<DemoProcedureFixture> procedures, final Map<String, String> query) {
  final size = int.tryParse(query['size'] ?? '');
  if (size == null || size <= 0) {
    return procedures;
  }
  final page = int.tryParse(query['page'] ?? '') ?? 0;
  return procedures.skip(page * size).take(size).toList(growable: false);
}

Map<String, Object?> _groupedBody(final List<DemoProcedureFixture> procedures, final DateTime now) => <String, Object?>{
  'idAgente': DemoSession.idAgente,
  'listaTramitesPorHechos': <Map<String, Object?>>[
    for (final event in demoLifeEventsCatalogue)
      if (procedures.any((final procedure) => procedure.lifeEventId == event.id))
        <String, Object?>{
          'idHecho': event.id,
          'nombreHecho': event.name,
          'tramites': <Map<String, Object?>>[
            for (final procedure in procedures)
              if (procedure.lifeEventId == event.id) demoProcedureJson(procedure, now: now),
          ],
        },
  ],
};

List<Map<String, Object?>> _flatBody(final List<DemoProcedureFixture> procedures, final DateTime now) => <Map<String, Object?>>[
  for (final procedure in procedures)
    <String, Object?>{
      ...demoProcedureJson(procedure, now: now),
      'hechosVitales': <Map<String, Object?>>[
        <String, Object?>{'idHechoVital': procedure.lifeEventId, 'nombreHechoVital': demoLifeEventName(procedure.lifeEventId)},
      ],
    },
];

DemoResponse _noResults(final DateTime now) {
  // El código de negocio es `404.01`, que es el que el repositorio reconoce
  // como «sin resultados»; el `.00` genérico de `DemoResponse.status` sería un
  // error de transporte.
  final envelope = demoEnvelope(null, statusCode: 404, message: 'No se obtuvieron resultados para los criterios indicados', now: now)..['codigo-respuesta'] = '404.01';
  return DemoResponse.envelope(envelope, statusCode: 404);
}
