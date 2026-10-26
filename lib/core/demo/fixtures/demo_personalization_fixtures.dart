import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';

/// Un hecho vital del catálogo del modo demostración.
final class DemoLifeEventFixture {
  const DemoLifeEventFixture({required this.id, required this.name});

  /// `idHecho` del contrato de `GET /api/v1/ciudadanos/{id}/hechos`.
  final int id;

  /// `nombreHecho`, en primera persona como los enuncia la JCCM.
  final String name;
}

/// Catálogo de hechos vitales que sirve `GET {id}/hechos` en demo.
///
/// Los identificadores son los que referencian los trámites de
/// `demoProceduresCatalogue`: todos tienen al menos dos trámites asociados para
/// que marcar o desmarcar cualquiera cambie algo visible en Recomendaciones.
const List<DemoLifeEventFixture> demoLifeEventsCatalogue = <DemoLifeEventFixture>[
  DemoLifeEventFixture(id: 1, name: 'He tenido un hijo/a'),
  DemoLifeEventFixture(id: 2, name: 'Tengo un familiar dependiente'),
  DemoLifeEventFixture(id: 3, name: 'Me gustaría independizarme'),
  DemoLifeEventFixture(id: 4, name: 'Busco empleo o quiero cambiar de trabajo'),
  DemoLifeEventFixture(id: 5, name: 'Voy a estudiar o a formarme'),
  DemoLifeEventFixture(id: 6, name: 'Me voy a jubilar'),
  DemoLifeEventFixture(id: 7, name: 'Tengo una discapacidad reconocida'),
  DemoLifeEventFixture(id: 8, name: 'Quiero comprar o rehabilitar una vivienda'),
];

/// Hechos marcados al empezar la demostración.
///
/// No está vacío a propósito: el onboarding de hechos vitales se abre con la
/// selección limpia y el revisor puede saltárselo; con estos dos marcados
/// Recomendaciones muestra contenido igualmente en vez de un estado vacío.
const Set<int> demoInitiallySelectedLifeEventIds = <int>{1, 4};

/// Nombre del hecho [id], o `null` si no está en el catálogo.
String? demoLifeEventName(final int id) {
  for (final event in demoLifeEventsCatalogue) {
    if (event.id == id) {
      return event.name;
    }
  }
  return null;
}

/// Cuerpo de `GET {id}/hechos`: el catálogo completo con la marca
/// `seleccionado` según [selection].
Map<String, Object?> demoLifeEventsBody(final Set<int> selection) => <String, Object?>{
  'idAgente': DemoSession.idAgente,
  'listaHechos': <Map<String, Object?>>[
    for (final event in demoLifeEventsCatalogue) <String, Object?>{'idHecho': event.id, 'nombreHecho': event.name, 'seleccionado': selection.contains(event.id)},
  ],
};
