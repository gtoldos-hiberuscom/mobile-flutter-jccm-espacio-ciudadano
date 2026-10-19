/// Un trámite recomendable del modo demostración.
///
/// Las fechas se expresan en días relativos al reloj del backend, no como
/// fechas fijas: así los plazos siguen pareciendo vigentes cualquiera que sea
/// el día en que el revisor abra la app.
final class DemoProcedureFixture {
  const DemoProcedureFixture({
    required this.id,
    required this.lifeEventId,
    required this.title,
    required this.unit,
    required this.opensInDays,
    this.closesInDays,
    this.isNews = false,
  });

  /// `idTramite`.
  final int id;

  /// `idHecho` del catálogo de hechos vitales al que pertenece.
  final int lifeEventId;

  /// `nombreTramite`.
  final String title;

  /// `nombreUnidadResponsable`: la consejería que lo gestiona.
  final String unit;

  /// Días desde hoy hasta `fechaPresentacionIni` (negativo = ya abierto).
  final int opensInDays;

  /// Días desde hoy hasta `fechaPresentacionFin`; `null` es plazo abierto.
  final int? closesInDays;

  /// Si el gateway lo devolvería en «novedades» (`operacion=no`).
  final bool isNews;
}

const String _bienestarSocial = 'Consejería de Bienestar Social';
const String _educacion = 'Consejería de Educación, Cultura y Deportes';
const String _fomento = 'Consejería de Fomento';
const String _empleo = 'Consejería de Economía, Empresas y Empleo';

/// Trámites del modo demostración, agrupables por hecho vital.
///
/// Cada hecho de `demoLifeEventsCatalogue` tiene al menos dos; los plazos
/// están repartidos para que «últimos», «novedades» y «plazo inmediato»
/// devuelvan subconjuntos distintos y no vacíos con la selección inicial.
const List<DemoProcedureFixture> demoProceduresCatalogue = <DemoProcedureFixture>[
  // 1 · He tenido un hijo/a
  DemoProcedureFixture(id: 1101, lifeEventId: 1, title: 'Ayuda por nacimiento o adopción de hijos e hijas', unit: _bienestarSocial, opensInDays: -20, closesInDays: 70, isNews: true),
  DemoProcedureFixture(id: 1102, lifeEventId: 1, title: 'Título de familia numerosa: expedición y renovación', unit: _bienestarSocial, opensInDays: -200, closesInDays: 300),
  DemoProcedureFixture(id: 1103, lifeEventId: 1, title: 'Solicitud de plaza en escuela infantil pública (0-3 años)', unit: _educacion, opensInDays: -5, closesInDays: 12),
  // 2 · Tengo un familiar dependiente
  DemoProcedureFixture(id: 1201, lifeEventId: 2, title: 'Reconocimiento de la situación de dependencia', unit: _bienestarSocial, opensInDays: -400),
  DemoProcedureFixture(id: 1202, lifeEventId: 2, title: 'Servicio de ayuda a domicilio', unit: _bienestarSocial, opensInDays: -10, closesInDays: 40),
  DemoProcedureFixture(id: 1203, lifeEventId: 2, title: 'Programa de respiro familiar para personas cuidadoras', unit: _bienestarSocial, opensInDays: -120, closesInDays: 10),
  // 3 · Me gustaría independizarme
  DemoProcedureFixture(id: 1301, lifeEventId: 3, title: 'Bono alquiler joven', unit: _fomento, opensInDays: -25, closesInDays: 60, isNews: true),
  DemoProcedureFixture(id: 1302, lifeEventId: 3, title: 'Ayudas al alquiler de vivienda habitual', unit: _fomento, opensInDays: -90, closesInDays: 9),
  DemoProcedureFixture(id: 1303, lifeEventId: 3, title: 'Inscripción en el registro de demandantes de vivienda protegida', unit: _fomento, opensInDays: -300),
  // 4 · Busco empleo o quiero cambiar de trabajo
  DemoProcedureFixture(id: 1401, lifeEventId: 4, title: 'Inscripción como demandante de empleo', unit: _empleo, opensInDays: -500),
  DemoProcedureFixture(id: 1402, lifeEventId: 4, title: 'Formación para el empleo: certificados de profesionalidad', unit: _empleo, opensInDays: -15, closesInDays: 45, isNews: true),
  DemoProcedureFixture(id: 1403, lifeEventId: 4, title: 'Ayudas al autoempleo y al emprendimiento', unit: _empleo, opensInDays: -60, closesInDays: 7),
  // 5 · Voy a estudiar o a formarme
  DemoProcedureFixture(id: 1501, lifeEventId: 5, title: 'Ayudas de comedor escolar y material curricular', unit: _educacion, opensInDays: -3, closesInDays: 14, isNews: true),
  DemoProcedureFixture(id: 1502, lifeEventId: 5, title: 'Admisión en ciclos de Formación Profesional', unit: _educacion, opensInDays: -150, closesInDays: 200),
  // 6 · Me voy a jubilar
  DemoProcedureFixture(id: 1601, lifeEventId: 6, title: 'Programa de termalismo para personas mayores', unit: _bienestarSocial, opensInDays: -8, closesInDays: 50),
  DemoProcedureFixture(id: 1602, lifeEventId: 6, title: 'Talleres de envejecimiento activo en centros de mayores', unit: _bienestarSocial, opensInDays: -45, closesInDays: 120),
  // 7 · Tengo una discapacidad reconocida
  DemoProcedureFixture(id: 1701, lifeEventId: 7, title: 'Reconocimiento y revisión del grado de discapacidad', unit: _bienestarSocial, opensInDays: -600),
  DemoProcedureFixture(id: 1702, lifeEventId: 7, title: 'Tarjeta de estacionamiento para personas con movilidad reducida', unit: _bienestarSocial, opensInDays: -200),
  DemoProcedureFixture(id: 1703, lifeEventId: 7, title: 'Ayudas para la adaptación funcional de la vivienda', unit: _bienestarSocial, opensInDays: -12, closesInDays: 11),
  // 8 · Quiero comprar o rehabilitar una vivienda
  DemoProcedureFixture(id: 1801, lifeEventId: 8, title: 'Ayudas a la rehabilitación energética de viviendas', unit: _fomento, opensInDays: -30, closesInDays: 35, isNews: true),
  DemoProcedureFixture(id: 1802, lifeEventId: 8, title: 'Ayudas para la adquisición de vivienda en el medio rural', unit: _fomento, opensInDays: -100, closesInDays: 6),
];

/// Fecha ISO a [days] días del día de [now], a medianoche: los plazos de
/// presentación son fechas, no instantes.
String demoDateFromNow(final DateTime now, final int days) => DateTime(now.year, now.month, now.day).add(Duration(days: days)).toIso8601String();

/// Un trámite tal y como viaja dentro de `tramites` (agrupado) o del listado
/// plano de las operaciones segmentadas, sin el hecho vital.
Map<String, Object?> demoProcedureJson(final DemoProcedureFixture procedure, {required final DateTime now}) {
  final closesInDays = procedure.closesInDays;
  return <String, Object?>{
    'idTramite': procedure.id,
    'nombreTramite': procedure.title,
    'nombreUnidadResponsable': procedure.unit,
    'fechaPresentacionIni': demoDateFromNow(now, procedure.opensInDays),
    'fechaPresentacionFin': closesInDays == null ? null : demoDateFromNow(now, closesInDays),
  };
}
