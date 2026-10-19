import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_binaries.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_gestion_fixtures.dart';

/// Transacción de aportación de documentación: la abre `ficheros/iniciar`, la
/// alimenta `ficheros` (una subida por fichero) y la cierra
/// `ficheros/registrar`, igual que el buzón de tramitación real.
final class DemoAportacion {
  DemoAportacion({required this.idunico, this.numexp});

  final String idunico;

  /// Expediente al que se aporta; `null` si el fichero llegó sin `iniciar`
  /// previo (el backend real también lo guarda en el buzón sin más).
  final String? numexp;

  /// Ficheros subidos, con el hash que devolvió cada subida.
  final List<({String nombre, String hash})> ficheros = <({String nombre, String hash})>[];

  /// Número del registro de entrada emitido al cerrar, o `null` si sigue
  /// abierta.
  String? registro;
}

/// Estado en memoria de **Gestión** —expedientes, registros, notificaciones y
/// aportaciones— de una sesión demo.
///
/// Nace con las fixtures y muere con el `Dio` de la sesión: cada demostración
/// empieza igual y lo que haga el revisor (comparecer, aportar documentación)
/// solo vive en memoria, pero se refleja en todas las pantallas mientras dure
/// la sesión, que es lo que da verosimilitud a la demo.
final class DemoGestionState {
  DemoGestionState({required final DateTime Function() now}) : this._(now, now());

  // El reloj se lee una sola vez para las fixtures: así todas las fechas
  // relativas parten del mismo instante.
  DemoGestionState._(this.now, final DateTime reference) : expedientes = demoExpedientes(reference), registrosEntrada = demoRegistrosEntrada(reference), registrosSalida = demoRegistrosSalida(reference), notificaciones = demoNotificaciones(reference);

  /// Reloj del backend: las fixtures son relativas a él y las mutaciones
  /// (comparecencia, registro de la aportación) se fechan con él.
  final DateTime Function() now;

  final List<DemoExpedienteRow> expedientes;

  /// Más reciente primero; la aportación registrada se inserta en cabeza.
  final List<DemoRegistroRow> registrosEntrada;
  final List<DemoRegistroRow> registrosSalida;
  final List<DemoNotificacionRow> notificaciones;

  /// Aportaciones abiertas o cerradas, por `idunico`.
  final Map<String, DemoAportacion> aportaciones = <String, DemoAportacion>{};

  DemoExpedienteRow? expediente(final String? numexp) => numexp == null ? null : expedientes.where((final expediente) => expediente.numexp == numexp).firstOrNull;

  /// Busca en entrada y en salida: `selectbynumreg` localiza el expediente
  /// por cualquiera de los dos.
  DemoRegistroRow? registro(final String? numregistro) => numregistro == null ? null : registrosEntrada.followedBy(registrosSalida).where((final registro) => registro.numregistro == numregistro).firstOrNull;

  DemoNotificacionRow? notificacion(final int id) => notificaciones.where((final notificacion) => notificacion.id == id).firstOrNull;

  List<DemoNotificacionRow> notificacionesEn(final DemoNotificacionEstado estado) => notificaciones.where((final notificacion) => notificacion.estado == estado).toList(growable: false);

  /// Comparecencia: pendiente → aceptada, fechada ahora. `false` si la
  /// notificación no estaba pendiente (Notifica rechaza la transición).
  bool comparecer(final DemoNotificacionRow notificacion) {
    if (notificacion.estado != DemoNotificacionEstado.pendiente) {
      return false;
    }
    notificacion
      ..estado = DemoNotificacionEstado.aceptada
      ..fechaTransicion = now();
    return true;
  }

  DemoAportacion abrirAportacion({required final String idunico, required final String numexp}) => aportaciones[idunico] = DemoAportacion(idunico: idunico, numexp: numexp);

  /// Guarda el fichero en la aportación de [idunico], abriéndola sin
  /// expediente si no existía.
  void guardarFichero({required final String idunico, required final String nombre, required final String hash}) => aportaciones.putIfAbsent(idunico, () => DemoAportacion(idunico: idunico)).ficheros.add((nombre: nombre, hash: hash));

  /// Cierra la aportación de [idunico] y emite su registro de entrada en
  /// cabeza del listado, que es la evidencia que el revisor verá en
  /// Gestión › Registros.
  DemoRegistroRow registrarAportacion({required final DemoExpedienteRow expediente, required final String idunico, required final int ficheros}) {
    final fecha = now();
    final registro = DemoRegistroRow(
      numregistro: demoNumeroRegistro(fecha, registrosEntrada.length + 1),
      fecha: fecha,
      asunto: expediente.asunto,
      desasunto: 'Aportación de documentación ($ficheros ${ficheros == 1 ? 'fichero' : 'ficheros'})',
      desconsej: expediente.desconsej,
      numexp: expediente.numexp,
    );
    registrosEntrada.insert(0, registro);
    aportaciones.putIfAbsent(idunico, () => DemoAportacion(idunico: idunico, numexp: expediente.numexp)).registro = registro.numregistro;
    return registro;
  }
}

/// Rutas de Gestión del backend demo, sobre [state].
///
/// Los `{id}` de ciudadano se aceptan tal cual (`([^/]+)`): la fachada los
/// valida contra el token, y aquí el token es el de la demo.
List<DemoRoute> demoGestionRoutes(final DemoGestionState state) => <DemoRoute>[
  // Los dos listados de registros van ANTES del detalle de expediente: su path
  // también casa con `expedientes/([^/]+)` y el enrutador se queda con la
  // primera ruta que coincida.
  DemoRoute('POST', '/api/v1/ciudadanos/([^/]+)/expedientes', (final request) => _listadoExpedientes(state)),
  DemoRoute('POST', '/api/v1/ciudadanos/([^/]+)/expedientes/listado-registro-entrada', (final request) => _listadoRegistros(state, state.registrosEntrada)),
  DemoRoute('POST', '/api/v1/ciudadanos/([^/]+)/expedientes/listado-registro-salida', (final request) => _listadoRegistros(state, state.registrosSalida)),
  DemoRoute('POST', '/api/v1/ciudadanos/([^/]+)/expedientes/([^/]+)', (final request) => _detalleExpediente(state, request)),
  // `(.+)` y no `([^/]+)`: el cliente generado no codifica el path param y los
  // números de registro llevan barras (`DEMO/2026/0001`), que llegan como
  // segmentos sueltos. El backend identifica el registro por el `pregistro`
  // del cuerpo, y aquí también.
  DemoRoute('POST', '/api/v1/ciudadanos/([^/]+)/registros/(.+)', (final request) => _detalleRegistro(state, request)),
  DemoRoute('GET', '/api/v1/ciudadanos/([^/]+)/notificaciones', (final request) => _listadoNotificaciones(state, request)),
  DemoRoute('GET', r'/api/v1/ciudadanos/([^/]+)/notificaciones/(\d+)', (final request) => _detalleNotificacion(state, request)),
  DemoRoute('POST', r'/api/v1/ciudadanos/([^/]+)/notificaciones/(\d+)/comparecer', (final request) => _comparecer(state, request)),
  DemoRoute('GET', r'/api/v1/ciudadanos/([^/]+)/notificaciones/(\d+)/documentos/(\d+)', (final request) => _documentoNotificacion(state, request)),
  DemoRoute('GET', r'/api/v1/ciudadanos/([^/]+)/notificaciones/(\d+)/justificante', (final request) => _justificanteNotificacion(state, request)),
  DemoRoute('POST', '/api/v1/ciudadanos/([^/]+)/expedientes/([^/]+)/ficheros', (final request) => _subirFichero(state, request)),
  DemoRoute('POST', '/api/v1/ciudadanos/([^/]+)/expedientes/([^/]+)/ficheros/iniciar', (final request) => _iniciarAportacion(state, request)),
  DemoRoute('POST', '/api/v1/ciudadanos/([^/]+)/expedientes/([^/]+)/ficheros/registrar', (final request) => _registrarAportacion(state, request)),
];

// ── Expedientes y registros ───────────────────────────────────────────────────

/// Cuerpo `ZCSRFCPUBLISELECTBY*Response` del tramitador: `isubrc: 0` con
/// publicaciones, o `isubrc: 1` + «No hay publicaciones…» cuando no hay nada
/// —responde 200 en los dos casos, nunca 404, y los repositorios ya lo saben—.
/// `adjuntar: "X"` solo cuando el expediente admite aportar documentación.
Map<String, Object?> _publicacionPortal(final Object? publicacionportal, {required final bool hayDatos, final bool adjuntar = false}) => <String, Object?>{
  if (adjuntar) 'adjuntar': 'X',
  'isubrc': hayDatos ? 0 : 1,
  'publicacionportal': publicacionportal,
  'resultado': hayDatos ? 'Correcto' : 'No hay publicaciones para los parametros introducidos',
};

Map<String, Object?> _sinPublicaciones() => _publicacionPortal(<String, Object?>{'item': <Object?>[]}, hayDatos: false);

DemoResponse _listadoExpedientes(final DemoGestionState state) => DemoResponse.ok(
  _publicacionPortal(<String, Object?>{
    'item': <Object?>[for (final expediente in state.expedientes) expediente.toPublicacionItem()],
  }, hayDatos: state.expedientes.isNotEmpty),
  now: state.now(),
);

DemoResponse _listadoRegistros(final DemoGestionState state, final List<DemoRegistroRow> registros) => DemoResponse.ok(
  _publicacionPortal(<String, Object?>{
    'item': <Object?>[for (final registro in registros) registro.toPublicacionItem()],
  }, hayDatos: registros.isNotEmpty),
  now: state.now(),
);

DemoResponse _detalleExpediente(final DemoGestionState state, final DemoRequest request) {
  // El `{idExpediente}` del path es decorativo (la app manda `detalle`): el
  // expediente va en `pnumexp`. Cualquier documento lo encuentra, para que la
  // aportación a un expediente de terceros se pueda recorrer en la demo.
  final expediente = state.expediente(_string(request.jsonObject['pnumexp']));
  if (expediente == null) {
    return DemoResponse.ok(_sinPublicaciones(), now: state.now());
  }
  // A diferencia del listado, aquí `publicacionportal` es el objeto plano.
  return DemoResponse.ok(_publicacionPortal(expediente.toPublicacionItem(), hayDatos: true, adjuntar: expediente.adjuntar), now: state.now());
}

DemoResponse _detalleRegistro(final DemoGestionState state, final DemoRequest request) {
  final registro = state.registro(_string(request.jsonObject['pregistro']) ?? request.group(2));
  final expediente = state.expediente(registro?.numexp);
  if (expediente == null) {
    return DemoResponse.ok(_sinPublicaciones(), now: state.now());
  }
  // `selectbynumreg` devuelve `publicacionportal.item` como lista aunque solo
  // pueda haber un expediente por registro.
  return DemoResponse.ok(
    _publicacionPortal(
      <String, Object?>{
        'item': <Object?>[expediente.toPublicacionItem()],
      },
      hayDatos: true,
      adjuntar: expediente.adjuntar,
    ),
    now: state.now(),
  );
}

// ── Notificaciones ────────────────────────────────────────────────────────────

DemoResponse _listadoNotificaciones(final DemoGestionState state, final DemoRequest request) {
  // La pestaña "Todo" pide los cuatro estados en paralelo: la respuesta se decide por el
  // filtro `estado`, nunca por orden de llegada.
  final estado = demoNotificacionEstadoDesdeQuery(request.query['estado']);
  final page = int.tryParse(request.query['page'] ?? '') ?? 0;
  // El listado cabe entero en la primera página; las siguientes llegan vacías por si algún
  // cliente las pidiera.
  final List<DemoNotificacionRow> filas;
  if (page > 0) {
    filas = const <DemoNotificacionRow>[];
  } else if (estado == null) {
    filas = state.notificaciones;
  } else {
    filas = state.notificacionesEn(estado);
  }
  return DemoResponse.ok(<Object?>[for (final notificacion in filas) notificacion.toIndexa()], now: state.now());
}

DemoNotificacionRow? _notificacionDe(final DemoGestionState state, final DemoRequest request) {
  final id = int.tryParse(request.group(2) ?? '');
  return id == null ? null : state.notificacion(id);
}

DemoResponse _detalleNotificacion(final DemoGestionState state, final DemoRequest request) {
  final notificacion = _notificacionDe(state, request);
  if (notificacion == null) {
    return DemoResponse.notFound(now: state.now());
  }
  return DemoResponse.ok(notificacion.toDetalle(), now: state.now());
}

DemoResponse _comparecer(final DemoGestionState state, final DemoRequest request) {
  final notificacion = _notificacionDe(state, request);
  if (notificacion == null) {
    return DemoResponse.notFound(now: state.now());
  }
  if (!state.comparecer(notificacion)) {
    return DemoResponse.status(400, message: 'Transición no permitida desde el estado actual', now: state.now());
  }
  // Devuelve el `NotificacionDto` ya transitado, como la «Respuesta transición
  // realizada» del swagger.
  return DemoResponse.ok(notificacion.toDetalle(), now: state.now());
}

DemoResponse _documentoNotificacion(final DemoGestionState state, final DemoRequest request) {
  final notificacion = _notificacionDe(state, request);
  final orden = int.tryParse(request.group(3) ?? '');
  // `orden` empieza en 1, como en el detalle.
  final nombre = notificacion == null || orden == null ? null : notificacion.documentos.elementAtOrNull(orden - 1);
  if (nombre == null) {
    return DemoResponse.notFound(now: state.now());
  }
  return DemoResponse.bytes(DemoBinaries.pdf, contentType: 'application/pdf', fileName: nombre);
}

DemoResponse _justificanteNotificacion(final DemoGestionState state, final DemoRequest request) {
  final notificacion = _notificacionDe(state, request);
  if (notificacion == null) {
    return DemoResponse.notFound(now: state.now());
  }
  return DemoResponse.bytes(DemoBinaries.pdf, contentType: 'application/pdf', fileName: 'justificante-comparecencia-${notificacion.id}.pdf');
}

// ── Aportación de documentación ───────────────────────────────────────────────

DemoResponse _subirFichero(final DemoGestionState state, final DemoRequest request) {
  final body = request.jsonObject;
  final idunico = _string(body['idunico']) ?? request.group(2) ?? '';
  final nombre = _string(body['nombre']) ?? 'documento.pdf';
  final hash = _hashDeAdjunto(_string(body['data']));
  state.guardarFichero(idunico: idunico, nombre: nombre, hash: hash);
  // Como el backend real (confirmado en UAT por el repositorio): 200 con el
  // sobre genérico y el hash como `body`, no el `RESULTADOPROCEDIMIENTO` del
  // swagger. El cliente generado falla al tipar y el repositorio lee el hash
  // del sobre crudo; devolver el tipo del swagger rompería ese camino.
  return DemoResponse.ok(hash, now: state.now());
}

DemoResponse _iniciarAportacion(final DemoGestionState state, final DemoRequest request) {
  final body = request.jsonObject;
  final idunico = _string(body['idunico']) ?? request.group(2) ?? '';
  final expediente = state.expediente(_string(body['noexpediente']));
  if (expediente == null) {
    // `estado: KO` dentro de un 200: el repositorio lo convierte en el fallo
    // de apertura de transacción, que la pantalla ya sabe mostrar.
    return DemoResponse.ok(<String, Object?>{
      'idunico': idunico,
      'mensaje': 'No existe el expediente indicado',
      'estado': 'KO',
      'idregistro': '',
      'datosregistro': <String, Object?>{'pregistro': <String, Object?>{}},
    }, now: state.now());
  }
  state.abrirAportacion(idunico: idunico, numexp: expediente.numexp);
  // `pregistro` es lo que la app devolverá tal cual en `pdatos` al cerrar.
  return DemoResponse.ok(<String, Object?>{
    // El backend puede ajustar el idunico; la demo lo confirma tal cual.
    'idunico': idunico,
    'mensaje': 'El procedimiento se ha iniciado correctamente',
    'estado': 'OK',
    'idregistro': '',
    'datosregistro': <String, Object?>{
      'pregistro': <String, Object?>{
        'asuid': expediente.asunto,
        'descrip': expediente.desasunto,
        'uniorg': expediente.uniorg,
        'numdoc': DemoSession.personIdentifier,
        'nombre': DemoSession.givenName,
        'apellido1': DemoSession.firstSurname,
        'apellido2': DemoSession.secondSurname,
      },
    },
  }, now: state.now());
}

DemoResponse _registrarAportacion(final DemoGestionState state, final DemoRequest request) {
  final body = request.jsonObject;
  final procedimiento = _map(_map(body['confirmarProcedimiento'])?['procedimiento']);
  final idunico = _string(procedimiento?['idunico']) ?? request.group(2) ?? '';
  // Manda la lista `documentos` con la que se cierra, no lo subido al buzón:
  // el ciudadano puede haber retirado ficheros ya subidos.
  final documentos = body['documentos'];
  final ficheros = documentos is List<Object?> ? documentos.length : 0;
  final expediente = state.expediente(_string(procedimiento?['noexpediente']) ?? state.aportaciones[idunico]?.numexp);
  if (expediente == null) {
    return DemoResponse.status(400, message: 'Expediente no encontrado', now: state.now());
  }
  final registro = state.registrarAportacion(expediente: expediente, idunico: idunico, ficheros: ficheros);
  // El justificante vuelve como bytes crudos, no como sobre JSON.
  return DemoResponse.bytes(DemoBinaries.pdf, contentType: 'application/pdf', fileName: 'justificante-${registro.numregistro.replaceAll('/', '-')}.pdf');
}

/// Hash del fichero como lo devuelve `subiradjuntosinfirma`: SHA-256 en
/// hexadecimal y mayúsculas. Se calcula sobre los bytes reales para que dos
/// ficheros distintos nunca compartan hash, igual que en el backend.
String _hashDeAdjunto(final String? dataBase64) {
  List<int> bytes;
  if (dataBase64 == null) {
    bytes = const <int>[];
  } else {
    try {
      bytes = base64Decode(dataBase64);
    } on FormatException {
      bytes = utf8.encode(dataBase64);
    }
  }
  return sha256.convert(bytes).toString().toUpperCase();
}

// ── Lectura del cuerpo ────────────────────────────────────────────────────────

String? _string(final Object? value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

Map<String, Object?>? _map(final Object? value) {
  if (value is! Map<Object?, Object?>) {
    return null;
  }
  return <String, Object?>{
    for (final entry in value.entries)
      if (entry.key != null) entry.key.toString(): entry.value,
  };
}
