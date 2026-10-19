import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';

/// Una cláusula del catálogo legal del modo demostración.
final class DemoClauseFixture {
  const DemoClauseFixture({required this.id, required this.checkText, required this.description, this.version = '1'});

  /// `idClausula`: los mismos identificadores que el gateway (empiezan en 0).
  final int id;

  /// `textoCheck`: HTML breve junto a la casilla. El repositorio lo aplana.
  final String checkText;

  /// `descripcion`: texto ampliado en HTML, que la app no muestra.
  final String description;

  final String version;
}

/// Catálogo de cláusulas que sirve `GET {id}/clausulas` en demo, en el orden
/// en que se presentan. Los ids son las constantes de `clause.dart`, no una
/// numeración propia: el `SessionGuard` y las pantallas preguntan por ellas.
const List<DemoClauseFixture> demoClausesCatalogue = <DemoClauseFixture>[
  DemoClauseFixture(
    id: requiredConsentClauseId,
    checkText: '<p><b>He leído y acepto la información sobre protección de datos del Espacio Ciudadano.</b></p>',
    description: '<p>La Junta de Comunidades de Castilla-La Mancha tratará tus datos personales con la única finalidad de prestarte los servicios del Espacio Ciudadano. Entorno de demostración con datos ficticios.</p>',
  ),
  DemoClauseFixture(
    id: jccmDataConsentClauseId,
    checkText: '<p>Autorizo la consulta de los hechos administrativos que la Junta de Comunidades de Castilla-La Mancha tiene sobre mí en bienestar social, empleo, educación y salud.</p>',
    description: '<p>Permite mostrar en la app la información que ya obra en poder de las consejerías de la Junta.</p>',
  ),
  DemoClauseFixture(
    id: ageDataConsentClauseId,
    checkText: '<p>Autorizo al Espacio Ciudadano a consultar la información que la Administración General del Estado tiene sobre mí.</p>',
    description: '<p>Títulos oficiales, situación como demandante de empleo, domicilio, bienes inmuebles y vehículos.</p>',
  ),
  DemoClauseFixture(
    id: recommendationsConsentClauseId,
    checkText: '<p>Consiento el tratamiento de mis hechos vitales para recibir recomendaciones personalizadas de trámites y servicios.</p>',
    description: '<p>Solo se usan los hechos vitales que marques tú; puedes cambiarlos o borrarlos cuando quieras.</p>',
  ),
  DemoClauseFixture(
    id: digitalCardsConsentClauseId,
    checkText: '<p>Autorizo la consulta y descarga de mis carnets digitales.</p>',
    description: '<p>Carné joven, título de familia numerosa y tarjeta acreditativa del grado de discapacidad.</p>',
  ),
];

/// Una cláusula tal y como viaja en `body.textosClausulas`.
///
/// [selected] a `null` es «sin contestar»: `seleccionado: false` más
/// `pendiente: true`, que es como el gateway distingue un registro nuevo de
/// una revocación real. `idClausula` va como cadena, igual que en las capturas
/// del gateway; el repositorio acepta ambas formas.
Map<String, Object?> demoClauseJson(final DemoClauseFixture clause, {required final bool? selected}) => <String, Object?>{
  'idClausula': '${clause.id}',
  'version': clause.version,
  'textoCheck': clause.checkText,
  'descripcion': clause.description,
  'seleccionado': selected ?? false,
  'pendiente': selected == null,
};

/// Cuerpo de `GET {id}/clausulas` para las respuestas registradas en
/// [answers] (`idClausula` → respuesta; `null` = pendiente).
Map<String, Object?> demoClausesBody(final Map<int, bool?> answers) => <String, Object?>{
  'idAgente': DemoSession.idAgente,
  'clausulaPendiente': demoClausesCatalogue.any((final clause) => answers[clause.id] == null),
  'textosClausulas': <Map<String, Object?>>[
    for (final clause in demoClausesCatalogue) demoClauseJson(clause, selected: answers[clause.id]),
  ],
};
