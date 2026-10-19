import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';

/// Fixtures de **Gestión** del modo demostración: expedientes, registros y
/// notificaciones de la persona ficticia, con la forma exacta que devuelve la
/// fachada —`publicacionportal` al estilo SAP para expedientes y registros,
/// `NotificacionIndexaDto`/`NotificacionDto` de Notifica para las
/// notificaciones— para que los repositorios reales los mapeen sin tocarlos.
///
/// Las fechas se calculan a partir del `now` que recibe cada constructor, así
/// que la demo no envejece: siempre hay una notificación que caduca dentro de
/// unos días y un expediente abierto hace unas semanas.
///
/// El contenido es ficticio en su totalidad, pero verosímil para Castilla-La
/// Mancha; no hay personas reales.

/// Fecha en el formato `yyyy-MM-dd` de los campos SAP (`fechaini`, `fechareg`…).
String demoFechaSap(final DateTime fecha) => '${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';

/// Centinela SAP de fecha nula, el que los repositorios tratan como ausente.
const String demoFechaSapNula = '0000-00-00';

/// Fecha-hora ISO con zona, como la emite Notifica (`fecAlta`, `fecCaducidad`,
/// `fecha-cambio`).
String demoFechaNotifica(final DateTime fecha) => fecha.toUtc().toIso8601String();

/// Número de registro ficticio: `DEMO/2026/0004`, o `DEMO-S/2026/0001` para
/// los de salida. El prefijo deja claro en pantalla que es una demostración.
String demoNumeroRegistro(final DateTime fecha, final int secuencia, {final bool salida = false}) => '${salida ? 'DEMO-S' : 'DEMO'}/${fecha.year}/${secuencia.toString().padLeft(4, '0')}';

/// Un expediente tal y como lo publica el tramitador SAP (`selectbynifexp`,
/// `selectbynumexp`, `selectbynumreg`): códigos y descripciones por separado,
/// porque la app necesita los códigos (`consej`, `uniorg`, `asunto`) para
/// abrir la aportación de documentación y las descripciones para pintar.
final class DemoExpedienteRow {
  const DemoExpedienteRow({
    required this.numexp,
    required this.tipoproc,
    required this.desproc,
    required this.asunto,
    required this.desasunto,
    required this.solicitud,
    required this.consej,
    required this.desconsej,
    required this.uniorg,
    required this.desuniorg,
    required this.registro,
    required this.fechareg,
    required this.fechaini,
    required this.estado,
    required this.descrip,
    required this.adjuntar,
    this.fechafin,
  });

  final String numexp;

  /// Código de tipo de procedimiento; viaja en `tipoprocedimiento` al aportar.
  final String tipoproc;
  final String desproc;

  /// Código SIACI del asunto y su descripción (el título que pinta la app).
  final String asunto;
  final String desasunto;

  /// Texto del registro de entrada que abrió el expediente.
  final String solicitud;

  final String consej;
  final String desconsej;
  final String uniorg;
  final String desuniorg;

  /// Registro de entrada que abrió el expediente y su fecha.
  final String registro;
  final DateTime fechareg;

  final DateTime fechaini;
  final DateTime? fechafin;

  /// Código SAP del estado y su descripción, que es lo que se muestra.
  final String estado;
  final String descrip;

  /// `adjuntar: "X"` en el detalle: el expediente admite aportar documentación.
  final bool adjuntar;

  /// Elemento de `publicacionportal` con los campos del ejemplo oficial del
  /// swagger. La dirección es la de la persona ficticia, no del expediente.
  Map<String, Object?> toPublicacionItem() {
    final fin = fechafin;
    return <String, Object?>{
      'tipoproc': tipoproc,
      'desproc': desproc,
      'ejeexp': '${fechaini.year}',
      'numexp': numexp,
      'registro': registro,
      'fechareg': demoFechaSap(fechareg),
      'titulo': '',
      'asunto': asunto,
      'desasunto': desasunto,
      'source': 'TRAM',
      'nombre': DemoSession.givenName,
      'apellido1': DemoSession.firstSurname,
      'apellido2': DemoSession.secondSurname,
      'tipodoc': 'NIF',
      'destipodoc': 'Nº NIF',
      'numdoc': DemoSession.personIdentifier,
      'tipvia': 'C/',
      'destipvia': 'Calle',
      'calle': 'de la Demostración',
      'ncalle': '1',
      'bland': '45',
      'bezei': 'Toledo',
      'codpos': '45001',
      'land1': 'ES',
      'landx50': 'España',
      'tlfno': '600000000',
      'fechaini': demoFechaSap(fechaini),
      'fechafin': fin == null ? demoFechaSapNula : demoFechaSap(fin),
      'estado': estado,
      'descrip': descrip,
      'consej': consej,
      'desconsej': desconsej,
      'uniorg': uniorg,
      'desuniorg': desuniorg,
      'documentos': <String, Object?>{'item': <Object?>[]},
    };
  }
}

/// Un asiento registral (`listado-registro-entrada`/`-salida`), ligado al
/// expediente que `selectbynumreg` devuelve al buscarlo por su número.
final class DemoRegistroRow {
  const DemoRegistroRow({
    required this.numregistro,
    required this.fecha,
    required this.asunto,
    required this.desasunto,
    required this.desconsej,
    required this.numexp,
  });

  final String numregistro;
  final DateTime fecha;
  final String asunto;
  final String desasunto;
  final String desconsej;
  final String numexp;

  Map<String, Object?> toPublicacionItem() => <String, Object?>{
    'registro': numregistro,
    'fechareg': demoFechaSap(fecha),
    'asunto': asunto,
    'desasunto': desasunto,
    'desconsej': desconsej,
    'numexp': numexp,
    'nombre': DemoSession.givenName,
    'apellido1': DemoSession.firstSurname,
    'apellido2': DemoSession.secondSurname,
    'tipodoc': 'NIF',
    'numdoc': DemoSession.personIdentifier,
  };
}

/// Estado de una notificación en los dos vocabularios del contrato: el del
/// filtro `estado` del listado (el nombre del valor) y el del histórico de
/// Notifica que informa el detalle.
enum DemoNotificacionEstado {
  pendiente('PUESTO_A_DISPOSICION'),
  aceptada('ACEPTADA'),
  rechazada('RECHAZADA'),
  expirada('EXPIRADA');

  const DemoNotificacionEstado(this.notifica);

  /// Literal de `estado` y `historicoEstados` en el `NotificacionDto`.
  final String notifica;

  /// Valor del parámetro `estado` del listado: `pendiente|aceptada|rechazada|expirada`.
  String get query => name;
}

/// El estado que pide el filtro `estado` del listado, o `null` si no viene o
/// no es uno de los cuatro del contrato.
DemoNotificacionEstado? demoNotificacionEstadoDesdeQuery(final String? value) => DemoNotificacionEstado.values.where((final estado) => estado.query == value).firstOrNull;

/// Una notificación electrónica de Notifica. Mutable a propósito: comparecer
/// la pasa de pendiente a aceptada y la demo tiene que reflejarlo en el
/// listado y en el detalle.
final class DemoNotificacionRow {
  DemoNotificacionRow({
    required this.id,
    required this.concepto,
    required this.descripcion,
    required this.procedimiento,
    required this.idFicha,
    required this.unidadOrganica,
    required this.expediente,
    required this.fechaAlta,
    required this.fechaCaducidad,
    required this.estado,
    required this.documentos,
    this.fechaTransicion,
  });

  final int id;
  final String concepto;
  final String descripcion;
  final String procedimiento;
  final String idFicha;
  final String unidadOrganica;
  final String expediente;
  final DateTime fechaAlta;

  /// Plazo de acceso; en el listado es la única fecha que informa Notifica.
  final DateTime fechaCaducidad;

  /// Nombres de los documentos notificados, en orden (`orden` empieza en 1).
  final List<String> documentos;

  DemoNotificacionEstado estado;

  /// Cuándo salió de pendiente (aceptación, rechazo o expiración); `null`
  /// mientras siga pendiente.
  DateTime? fechaTransicion;

  /// `NotificacionIndexaDto` del listado. No lleva `estado` a propósito: el
  /// contrato tampoco lo informa, y así se ejercita el etiquetado por estado
  /// consultado que hace el repositorio.
  Map<String, Object?> toIndexa() => <String, Object?>{
    'idNotificacion': id,
    'concepto': concepto,
    'fechaCaducidad': demoFechaNotifica(fechaCaducidad),
    'procedimientoAdministrativo': <String, Object?>{'denominacion': procedimiento, 'idFicha': idFicha},
    'unidadOrganica': <String, Object?>{'nombre': unidadOrganica},
    'sistemaOrigen': 'notifica2',
  };

  /// `NotificacionDto` del detalle y de la comparecencia, con la forma del
  /// ejemplo «Respuesta transición realizada» del swagger: organismo y
  /// procedimiento en `informacionAdicional`, documentos con referencias
  /// internas y el histórico de estados del que el repositorio saca las fechas
  /// de puesta a disposición y de lectura.
  Map<String, Object?> toDetalle() {
    final transicion = fechaTransicion;
    return <String, Object?>{
      'id': id,
      'fecAlta': demoFechaNotifica(fechaAlta),
      'concepto': concepto,
      'descripcion': descripcion,
      'fecCaducidad': demoFechaNotifica(fechaCaducidad),
      'tipoEnvio': 'ELECTRONICO',
      'estado': estado.notifica,
      'unidadOrganica': <String, Object?>{
        'sistema': 'notifica2',
        'informacionAdicional': <Object?>[
          <String, Object?>{'clave': 'nombre', 'valor': unidadOrganica},
        ],
      },
      'procedimientoAdministrativo': <String, Object?>{
        'informacionAdicional': <Object?>[
          <String, Object?>{'clave': 'denominacion', 'valor': procedimiento},
          <String, Object?>{'clave': 'idFicha', 'valor': idFicha},
        ],
      },
      'expediente': <String, Object?>{'identificador': expediente},
      'documentos': <Object?>[
        for (final (index, nombre) in documentos.indexed)
          <String, Object?>{
            'orden': index + 1,
            'identificadorReferencia': 'DOC-$id-${index + 1}',
            'documento': <String, Object?>{
              'id': id * 10 + index + 1,
              'identificador': 'demo-doc-$id-${index + 1}',
              'aplicacion': 'notifica2',
              'tipoEntidad': 'DOCUMENTO',
              'informacionAdicional': <Object?>[
                <String, Object?>{'clave': 'nombre-documento', 'valor': nombre},
                <String, Object?>{'clave': 'formato-documento', 'valor': 'PDF'},
              ],
            },
          },
      ],
      'historicoEstados': <Object?>[
        <String, Object?>{'estado': DemoNotificacionEstado.pendiente.notifica, 'fecha-cambio': demoFechaNotifica(fechaAlta)},
        if (transicion != null) <String, Object?>{'estado': estado.notifica, 'fecha-cambio': demoFechaNotifica(transicion)},
      ],
    };
  }
}

// ── Expedientes ───────────────────────────────────────────────────────────────

/// Expedientes de la persona ficticia, del más reciente al más antiguo: dos
/// abiertos que admiten aportar documentación y uno cerrado que no.
List<DemoExpedienteRow> demoExpedientes(final DateTime now) => <DemoExpedienteRow>[
  _comedorEscolar(now),
  _familiaNumerosa(now),
  _licenciaPesca(now),
];

DemoExpedienteRow _comedorEscolar(final DateTime now) => DemoExpedienteRow(
  numexp: 'EDU1/${now.year}/000215',
  tipoproc: 'EDU1',
  desproc: 'AYUDAS DE COMEDOR ESCOLAR',
  asunto: 'SED1',
  desasunto: 'Solicitud de ayuda de comedor escolar para el curso ${now.year}/${now.year + 1}',
  solicitud: 'Solicitud de ayuda de comedor escolar',
  consej: '001800',
  desconsej: 'CONSEJERÍA DE EDUCACIÓN, CULTURA Y DEPORTES',
  uniorg: '018045',
  desuniorg: 'DELEGACIÓN PROVINCIAL DE EDUCACIÓN, CULTURA Y DEPORTES DE TOLEDO',
  registro: demoNumeroRegistro(now, 3),
  fechareg: now.subtract(const Duration(days: 25)),
  fechaini: now.subtract(const Duration(days: 25)),
  estado: '01',
  descrip: 'LA SOLICITUD HA ENTRADO EN EL ÓRGANO COMPETENTE',
  adjuntar: true,
);

DemoExpedienteRow _familiaNumerosa(final DateTime now) => DemoExpedienteRow(
  numexp: 'BSO2/${now.year}/000078',
  tipoproc: 'BSO2',
  desproc: 'TÍTULO DE FAMILIA NUMEROSA: EXPEDICIÓN Y RENOVACIÓN',
  asunto: 'SBS2',
  desasunto: 'Renovación del título de familia numerosa',
  solicitud: 'Solicitud de renovación del título de familia numerosa',
  consej: '002700',
  desconsej: 'CONSEJERÍA DE BIENESTAR SOCIAL',
  uniorg: '027002',
  desuniorg: 'DELEGACIÓN PROVINCIAL DE BIENESTAR SOCIAL DE ALBACETE',
  registro: demoNumeroRegistro(now, 2),
  fechareg: now.subtract(const Duration(days: 60)),
  fechaini: now.subtract(const Duration(days: 58)),
  estado: '05',
  descrip: 'EN TRAMITACIÓN: PENDIENTE DE DOCUMENTACIÓN',
  adjuntar: true,
);

DemoExpedienteRow _licenciaPesca(final DateTime now) => DemoExpedienteRow(
  numexp: 'DSO3/${now.year - 1}/001942',
  tipoproc: 'DSO3',
  desproc: 'LICENCIAS DE PESCA FLUVIAL',
  asunto: 'SDS3',
  desasunto: 'Expedición de licencia de pesca fluvial',
  solicitud: 'Solicitud de licencia de pesca fluvial',
  consej: '003300',
  desconsej: 'CONSEJERÍA DE DESARROLLO SOSTENIBLE',
  uniorg: '033016',
  desuniorg: 'DELEGACIÓN PROVINCIAL DE DESARROLLO SOSTENIBLE DE CUENCA',
  registro: demoNumeroRegistro(now, 1),
  fechareg: now.subtract(const Duration(days: 200)),
  fechaini: now.subtract(const Duration(days: 200)),
  fechafin: now.subtract(const Duration(days: 150)),
  estado: '20',
  descrip: 'CERRADO: LICENCIA EXPEDIDA',
  adjuntar: false,
);

// ── Registros ─────────────────────────────────────────────────────────────────

/// Registros de entrada, del más reciente al más antiguo: el que abrió cada
/// expediente, para que buscar por número de registro lo localice.
List<DemoRegistroRow> demoRegistrosEntrada(final DateTime now) => <DemoRegistroRow>[
  for (final expediente in demoExpedientes(now))
    DemoRegistroRow(
      numregistro: expediente.registro,
      fecha: expediente.fechareg,
      asunto: expediente.asunto,
      desasunto: expediente.solicitud,
      desconsej: expediente.desconsej,
      numexp: expediente.numexp,
    ),
];

/// Registros de salida, del más reciente al más antiguo.
List<DemoRegistroRow> demoRegistrosSalida(final DateTime now) {
  final comedor = _comedorEscolar(now);
  final pesca = _licenciaPesca(now);
  return <DemoRegistroRow>[
    DemoRegistroRow(
      numregistro: demoNumeroRegistro(now, 2, salida: true),
      fecha: now.subtract(const Duration(days: 15)),
      asunto: comedor.asunto,
      desasunto: 'Requerimiento de subsanación de la solicitud de ayuda de comedor escolar',
      desconsej: comedor.desconsej,
      numexp: comedor.numexp,
    ),
    DemoRegistroRow(
      numregistro: demoNumeroRegistro(now, 1, salida: true),
      fecha: now.subtract(const Duration(days: 150)),
      asunto: pesca.asunto,
      desasunto: 'Resolución de concesión de la licencia de pesca fluvial',
      desconsej: pesca.desconsej,
      numexp: pesca.numexp,
    ),
  ];
}

// ── Notificaciones ────────────────────────────────────────────────────────────

/// Notificaciones de la persona ficticia: dos pendientes (una por caducar
/// pronto), una aceptada, una rechazada y una expirada, para que cada pestaña
/// tenga contenido y la de "Todo" tenga algo que fusionar y ordenar.
List<DemoNotificacionRow> demoNotificaciones(final DateTime now) {
  final comedor = _comedorEscolar(now);
  final familia = _familiaNumerosa(now);
  return <DemoNotificacionRow>[
    DemoNotificacionRow(
      id: 7001,
      concepto: 'Requerimiento de subsanación de la solicitud de ayuda de comedor escolar',
      descripcion: 'Se requiere la aportación del certificado de empadronamiento colectivo en el plazo de diez días hábiles.',
      procedimiento: 'Ayudas de comedor escolar',
      idFicha: comedor.tipoproc,
      unidadOrganica: 'Delegación Provincial de Educación, Cultura y Deportes de Toledo',
      expediente: comedor.numexp,
      fechaAlta: now.subtract(const Duration(days: 3)),
      fechaCaducidad: now.add(const Duration(days: 7)),
      estado: DemoNotificacionEstado.pendiente,
      documentos: const <String>['Requerimiento_subsanacion.pdf'],
    ),
    DemoNotificacionRow(
      id: 7002,
      concepto: 'Propuesta de resolución de la ayuda al alquiler de vivienda para jóvenes',
      descripcion: 'Se comunica la propuesta de resolución provisional y se abre el plazo de alegaciones.',
      procedimiento: 'Ayudas al alquiler de vivienda para jóvenes',
      idFicha: 'VIV4',
      unidadOrganica: 'Dirección General de Vivienda',
      expediente: 'VIV4/${now.year}/001873',
      fechaAlta: now.subtract(const Duration(days: 1)),
      fechaCaducidad: now.add(const Duration(days: 9)),
      estado: DemoNotificacionEstado.pendiente,
      documentos: const <String>['Propuesta_resolucion.pdf', 'Anexo_calculo_ayuda.pdf'],
    ),
    DemoNotificacionRow(
      id: 7003,
      concepto: 'Requerimiento de documentación para la renovación del título de familia numerosa',
      descripcion: 'Debe aportar el libro de familia actualizado y el certificado de convivencia.',
      procedimiento: 'Título de familia numerosa: expedición y renovación',
      idFicha: familia.tipoproc,
      unidadOrganica: 'Delegación Provincial de Bienestar Social de Albacete',
      expediente: familia.numexp,
      fechaAlta: now.subtract(const Duration(days: 20)),
      fechaCaducidad: now.subtract(const Duration(days: 10)),
      estado: DemoNotificacionEstado.aceptada,
      fechaTransicion: now.subtract(const Duration(days: 18)),
      documentos: const <String>['Requerimiento_documentacion.pdf'],
    ),
    DemoNotificacionRow(
      id: 7004,
      concepto: 'Trámite de audiencia en el procedimiento de licencia de caza',
      descripcion: 'Se concede trámite de audiencia previo a la resolución del procedimiento.',
      procedimiento: 'Licencias de caza',
      idFicha: 'DSO5',
      unidadOrganica: 'Delegación Provincial de Desarrollo Sostenible de Ciudad Real',
      expediente: 'DSO5/${now.year - 1}/000231',
      fechaAlta: now.subtract(const Duration(days: 40)),
      fechaCaducidad: now.subtract(const Duration(days: 30)),
      estado: DemoNotificacionEstado.rechazada,
      fechaTransicion: now.subtract(const Duration(days: 38)),
      documentos: const <String>['Tramite_audiencia.pdf'],
    ),
    DemoNotificacionRow(
      id: 7005,
      concepto: 'Resolución de la convocatoria de ayudas para libros de texto',
      descripcion: 'Resolución definitiva de la convocatoria de ayudas para la adquisición de libros de texto.',
      procedimiento: 'Ayudas para la adquisición de libros de texto',
      idFicha: 'EDU7',
      unidadOrganica: 'Dirección General de Inclusión Educativa y Programas',
      expediente: 'EDU7/${now.year - 1}/004512',
      fechaAlta: now.subtract(const Duration(days: 70)),
      fechaCaducidad: now.subtract(const Duration(days: 60)),
      estado: DemoNotificacionEstado.expirada,
      fechaTransicion: now.subtract(const Duration(days: 60)),
      documentos: const <String>['Resolucion_convocatoria.pdf'],
    ),
  ];
}
