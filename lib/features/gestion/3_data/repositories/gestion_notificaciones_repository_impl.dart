import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/logger/log_redaction.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/notificaciones_paginacion_exception.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/mappers/notificacion_estado_mapper.dart';

/// Tamaño de página del listado de notificaciones.
///
/// La pestaña "Todo" barre los cuatro estados, así que cada página de más son
/// cuatro peticiones de más: con 10 (el ejemplo del swagger) un ciudadano con
/// ~45 aceptadas costaba 9 peticiones por visita.
///
/// **Asume que el gateway respeta el `size` pedido**, porque la paginación se
/// detiene en la primera página que devuelve menos elementos de los pedidos.
/// Si el backend recortara el tamaño por su cuenta, la primera página
/// parecería la última y se perderían notificaciones: hay que comprobarlo en
/// UAT antes de mergear.
const int _kNotificationsPageSize = 50;

/// Tope de carga inicial por estado: 10 × 50 = 500 notificaciones.
///
/// PRE contiene ciudadanos de prueba con miles de notificaciones expiradas.
/// Descargar el histórico completo al abrir la bandeja provoca decenas de
/// peticiones y acaba activando el rate limit (429) del gateway. El listado
/// viene ordenado por el backend, por lo que se conservan las 500 primeras; la
/// repetición consecutiva de ids se sigue detectando como contrato roto.
const int _kNotificationsMaxPages = gestionNotificacionesInitialLoadLimit ~/ _kNotificationsPageSize;

final class GestionNotificacionesRepositoryImpl implements GestionNotificacionesRepository {
  GestionNotificacionesRepositoryImpl({required final Dio dio, final int maxPages = _kNotificationsMaxPages}) : _dio = withGeneratedApiCompat(dio), _api = CiudadanosApi(withGeneratedApiCompat(dio), standardSerializers), _maxPages = maxPages;

  final Dio _dio;
  final CiudadanosApi _api;

  /// Solo se cambia desde los tests, para no tener que preparar 20 respuestas.
  final int _maxPages;

  @override
  Future<NotificacionDetalle> loadNotificacion({
    required final String citizenId,
    required final int notificacionId,
    final Notificacion? resumen,
  }) async {
    final Response<Object?> response;
    try {
      response = await _api.obtenerNotificacion(
        id: citizenId,
        notificacionId: notificacionId,
        sisOrigen: resumen?.sistemaOrigen,
        extra: {generatedApiDecodeStringResponseExtraKey: true},
      );
    } on DioException catch (error) {
      _throwIfAuthorizationRequired(
        error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey],
        statusCode: error.response?.statusCode,
        path: 'notificaciones/$notificacionId',
      );
      rethrow;
    }
    final raw = response.extra[generatedApiRawResponseDataExtraKey];
    final body = _bodyMap(raw, notificacionId);
    return _toDetalle(body, requestedId: notificacionId, resumen: resumen);
  }

  @override
  Future<void> transitionNotificacion({
    required final String citizenId,
    required final int notificacionId,
    required final String accion,
    final String? sistemaOrigen,
    final String? justificacion,
  }) async {
    // API 1.86: el endpoint de transiciones con cuerpo (TransicionDto) fue
    // sustituido por POST .../notificaciones/{id}/comparecer sin cuerpo. La
    // acción y la justificación ya no viajan al backend, que aplica la
    // transición según sus reglas de negocio; se conserva la validación de
    // acciones conocidas para no silenciar llamadas erróneas.
    const supportedActions = {'COMPARECER', 'ACEPTAR', 'RECHAZAR'};
    final normalizedAction = accion.trim().toUpperCase();
    if (!supportedActions.contains(normalizedAction)) {
      throw ArgumentError.value(accion, 'accion', 'Transición no soportada');
    }
    await _api.transicionNotificacion(
      id: citizenId,
      notificacionId: notificacionId,
      sisOrigen: sistemaOrigen,
      extra: const {
        generatedApiDecodeStringResponseExtraKey: true,
      },
    );
  }

  @override
  Future<Uint8List> downloadDocumento({
    required final String citizenId,
    required final int notificacionId,
    required final int orden,
    final String? sistemaOrigen,
  }) async {
    final response = await _api.descargarDocumento(
      id: citizenId,
      notificacionId: notificacionId,
      orden: orden,
      sisOrigen: sistemaOrigen,
    );
    final bytes = response.data;
    // Un 200 sin cuerpo no es un documento vacío que merezca guardarse: es un
    // fallo del que la pantalla tiene que avisar.
    if (bytes == null || bytes.isEmpty) {
      throw const FormatException('El documento llegó vacío.');
    }
    return bytes;
  }

  @override
  Future<List<Notificacion>> loadNotificaciones({
    required final String citizenId,
    final NotificacionEstado? estado,
    final CancelToken? cancelToken,
  }) async {
    if (estado != null) {
      return _loadForEstado(citizenId: citizenId, estado: estado, cancelToken: cancelToken);
    }
    // "Todo": el listado indexado no informa el estado de cada elemento, y sin
    // estado la tarjeta no puede pintar ni la etiqueta ni la fecha de
    // expiración. El parámetro `estado` del contrato es un enum cerrado, así
    // que se consultan los cuatro en paralelo y cada elemento queda etiquetado
    // con el estado por el que se encontró (`_toNotificacionMap`).
    //
    // `Future.wait` espera a los cuatro y propaga el primer error: si un estado
    // falla, "Todo" falla — nunca se muestra una lista incompleta como si
    // estuviera completa. Un 404 no es fallo, ya se traduce a lista vacía.
    final sweeps = await Future.wait(
      NotificacionEstado.values.map(
        (final value) => _loadForEstado(citizenId: citizenId, estado: value, cancelToken: cancelToken),
      ),
    );
    return _mergeSweeps(sweeps);
  }

  /// Fusiona por `id` los barridos de "Todo", recorridos en orden de enum y
  /// resolviendo las colisiones con [pickByNotificacionEstadoPrecedence]: un
  /// elemento solo aparece en dos barridos si transitó durante la consulta.
  ///
  /// El resultado se ordena con [compareNotificacionesForInbox]: al fusionar
  /// cuatro listas filtradas no queda ningún orden del backend que preservar,
  /// así que "Todo" define el suyo en vez de heredar el del mapa.
  List<Notificacion> _mergeSweeps(final List<List<Notificacion>> sweeps) {
    final merged = <int, Notificacion>{};
    for (final sweep in sweeps) {
      for (final notification in sweep) {
        final current = merged[notification.id];
        merged[notification.id] = current == null ? notification : pickByNotificacionEstadoPrecedence(current, notification);
      }
    }
    return merged.values.toList()..sort(compareNotificacionesForInbox);
  }

  Future<List<Notificacion>> _loadForEstado({
    required final String citizenId,
    required final NotificacionEstado estado,
    final CancelToken? cancelToken,
  }) async {
    final notifications = <int, Notificacion>{};
    Set<int>? previousPageIds;
    for (var page = 0; page < _maxPages; page++) {
      final (:rawCount, :items) = await _loadPageForEstado(
        citizenId: citizenId,
        estado: estado,
        page: page,
        cancelToken: cancelToken,
      );
      for (final notification in items) {
        notifications[notification.id] = notification;
      }

      // El corte va por los elementos **crudos** que devolvió el backend, no
      // por los que sobrevivieron al mapeo: una página llena de 50 con un
      // elemento sin id utilizable quedaba en 49, se tomaba por incompleta y
      // las páginas siguientes no se pedían nunca.
      if (rawCount < _kNotificationsPageSize) {
        return notifications.values.toList(growable: false);
      }
      if (rawCount > _kNotificationsPageSize) {
        logger.w('[notificaciones] el gateway devolvió $rawCount elementos para size=$_kNotificationsPageSize (estado ${notificacionEstadoQueryValue(estado)}): no respeta el tamaño pedido');
      }

      // Página llena que repite exactamente los ids de la anterior: el backend
      // está ignorando `page`. Se corta aquí en vez de gastar el tope entero.
      final pageIds = {for (final notification in items) notification.id};
      if (previousPageIds != null && previousPageIds.length == pageIds.length && previousPageIds.containsAll(pageIds)) {
        throw _paginacionIncompleta(estado, page + 1, notifications.length, 'la página $page repite los ids de la anterior');
      }
      previousPageIds = pageIds;
    }
    logger.w(
      '[notificaciones] carga limitada de ${notificacionEstadoQueryValue(estado)} '
      'a $_maxPages páginas (${notifications.length} acumuladas)',
    );
    return notifications.values.toList(growable: false);
  }

  /// Traza y construye el fallo de barrido incompleto. Solo lleva el token del
  /// filtro y conteos: nada personal.
  NotificacionesPaginacionIncompletaException _paginacionIncompleta(final NotificacionEstado estado, final int paginas, final int acumuladas, final String motivo) {
    final token = notificacionEstadoQueryValue(estado);
    logger.w('[notificaciones] barrido incompleto de $token: $motivo (páginas: $paginas, acumuladas: $acumuladas)');
    return NotificacionesPaginacionIncompletaException(estado: token, paginas: paginas, acumuladas: acumuladas, motivo: motivo);
  }

  Future<({int rawCount, List<Notificacion> items})> _loadPageForEstado({
    required final String citizenId,
    required final NotificacionEstado estado,
    required final int page,
    final CancelToken? cancelToken,
  }) async {
    final encodedCitizenId = Uri.encodeComponent(citizenId);
    final estadoQuery = notificacionEstadoQueryValue(estado);
    try {
      final response = await _dio.get<Object?>(
        '/api/v1/ciudadanos/$encodedCitizenId/notificaciones',
        queryParameters: {
          'estado': estadoQuery,
          'page': page,
          'size': _kNotificationsPageSize,
        },
        options: Options(
          validateStatus: (final status) => status == 404 || (status != null && status >= 200 && status < 300),
        ),
        cancelToken: cancelToken,
      );

      if (response.statusCode == 404) {
        return const (rawCount: 0, items: <Notificacion>[]);
      }
      _throwIfAuthorizationRequired(
        response.data,
        statusCode: response.statusCode,
        path: 'notificaciones',
      );
      return _pageForEstado(response.data, estado);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        // Fin del listado, o el ciudadano no tiene notificaciones en ese
        // estado: decisión validada, no es un fallo.
        return const (rawCount: 0, items: <Notificacion>[]);
      }
      final rawData = error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey];
      _throwIfAuthorizationRequired(
        rawData,
        statusCode: error.response?.statusCode,
        path: 'notificaciones',
      );
      // Un cuerpo de error que además parsea como notificación NO es una
      // página: aceptarlo era una tercera vía de lista parcial sin error, con
      // exposición ×4 en "Todo".
      rethrow;
    }
  }

  /// Traduce el sobre de autorización de la fachada a una señal tipada.
  ///
  /// La fachada lo devuelve con 403, pero también aparece dentro de un 2xx, así
  /// que se comprueban los dos caminos. Quien lo resuelve es
  /// `withAuthorizationGuard`: aquí no se sabe **qué** autorización falta, y el
  /// sobre tampoco distingue una revocación de un fallo de preferencias.
  void _throwIfAuthorizationRequired(
    final Object? data, {
    required final String path,
    final int? statusCode,
  }) {
    if (isAuthorizationRequiredEnvelope(data)) {
      throw AuthorizationRequiredException(statusCode: statusCode, path: path);
    }
  }

  /// Los elementos tal y como llegaron (`rawCount`) junto a los que se pueden
  /// mapear (`items`).
  ///
  /// La distinción es el corte de la paginación: `rawCount` dice si la página
  /// venía llena —lo único que indica que hay más— e `items` es lo que se puede
  /// pintar. Contar por lo segundo perdía las páginas siguientes en silencio.
  ({int rawCount, List<Notificacion> items}) _pageForEstado(final Object? data, final NotificacionEstado estado) {
    final payload = _notificationPayload(data);
    final raws = switch (payload) {
      final List<dynamic> list => list,
      final Map<dynamic, dynamic> map when _hasNotificationId(map) => [map],
      _ => const <dynamic>[],
    };
    return (
      rawCount: raws.length,
      items: raws
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (final item) => <String, Object?>{
              for (final entry in item.entries)
                if (entry.key != null) entry.key.toString(): entry.value,
            },
          )
          .map((final map) => _toNotificacionMap(map, estado))
          .nonNulls
          .toList(growable: false),
    );
  }

  Object? _notificationPayload(final Object? data) {
    Object? current = data;
    for (var i = 0; i < 3 && current is String; i++) {
      try {
        current = jsonDecode(current);
      } on FormatException {
        return current;
      }
    }
    if (current is! Map<dynamic, dynamic>) {
      return current;
    }
    for (final key in const ['body', 'content', 'items', 'notificaciones', 'results', 'data']) {
      if (current.containsKey(key)) {
        return _notificationPayload(current[key]);
      }
    }
    return current;
  }

  bool _hasNotificationId(final Map<dynamic, dynamic> data) => data.containsKey('idNotificacion') || data.containsKey('id');

  /// `null` cuando el elemento no trae un id utilizable.
  ///
  /// Esta capa indexa por id cuanto hace con un listado: la acumulación de
  /// páginas de un estado y la fusión de los cuatro barridos de la pestaña
  /// "Todo". Un id fabricado (antes `?? 0`) convertía **dos notificaciones
  /// distintas sin id en una sola tarjeta**, con los datos de una y el estado de
  /// la otra al resolver la precedencia entre barridos; y podía cortar la
  /// paginación antes de tiempo, porque una página que no aporta ids nuevos se
  /// interpreta como final del listado.
  Notificacion? _toNotificacionMap(final Map<String, Object?> data, final NotificacionEstado estado) {
    final id = _int(data, 'idNotificacion') ?? _int(data, 'id');
    if (id == null) {
      // Solo las claves, nunca los valores: el concepto de una notificación es
      // dato personal.
      logger.w('[notificaciones] elemento sin id utilizable descartado (claves: ${data.keys.join(', ')})');
      return null;
    }
    final procMap = _map(data['procedimientoAdministrativo']);
    final unidadMap = _map(data['unidadOrganica']);
    final lecturaEstado = notificacionEstadoLecturaFromBackend(_string(data, 'estado'));
    if (lecturaEstado case NotificacionEstadoNoReconocido(:final raw)) {
      logger.w('[notificaciones] estado no reconocido en el listado: "$raw" — se conserva el consultado (${notificacionEstadoQueryValue(estado)})');
    }
    final fechaStr = _string(data, 'fechaCaducidad') ?? _string(data, 'fecCaducidad') ?? _string(data, 'fechaExpiracion');

    return Notificacion(
      id: id,
      concepto: _string(data, 'concepto') ?? _string(data, 'descripcion') ?? '',
      procedimientoDenominacion: _string(procMap, 'denominacion') ?? _additional(procMap, 'denominacion') ?? '',
      fechaCaducidad: fechaStr != null ? DateTime.tryParse(fechaStr) : null,
      procedimientoIdFicha: _string(procMap, 'idFicha'),
      unidadOrganicaNombre: _string(unidadMap, 'nombre') ?? _additional(unidadMap, 'nombre'),
      sistemaOrigen: _string(data, 'sistemaOrigen') ?? _string(unidadMap, 'sistema'),
      // El DTO indexado no informa el estado; cuando el elemento no lo trae,
      // el estado conocido es el que se consultó. Todo listado se pide filtrando
      // por un estado (también "Todo", que pide los cuatro), así que aquí nunca
      // queda `null` — y desde luego nunca `''`, que la UI leía como expirada.
      //
      // Asimetría deliberada con el detalle: aquí un valor no reconocido
      // conserva el estado consultado, porque el elemento llegó filtrando por
      // él y el backend lo clasifica ahí. Dejarlo en `null` devolvería la
      // tarjeta sin etiqueta ni fecha que este listado vino a arreglar.
      estado: switch (lecturaEstado) {
        NotificacionEstadoConocido(estado: final declarado) => declarado,
        NotificacionEstadoAusente() || NotificacionEstadoNoReconocido() => estado,
      },
    );
  }

  int? _int(final Map<String, Object?>? map, final String key) {
    if (map == null) {
      return null;
    }
    return switch (map[key]) {
      final int v => v,
      final double v => v.toInt(),
      final String v => int.tryParse(v),
      _ => null,
    };
  }

  String? _string(final Map<String, Object?>? map, final String key) {
    if (map == null) {
      return null;
    }
    final val = map[key];
    if (val is String) {
      final trimmed = val.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  Map<String, Object?> _bodyMap(final Object? raw, final int id) {
    Object? value = raw;
    if (value is String) {
      try {
        value = jsonDecode(value);
      } on FormatException {
        throw const FormatException('Respuesta de detalle no válida.');
      }
    }
    if (value is Map<Object?, Object?>) {
      value = value['body'] ?? value;
    }
    if (value is List) {
      final items = value.whereType<Map<Object?, Object?>>().toList(growable: false);
      if (items.isEmpty) {
        throw const FormatException('El detalle de la notificación está vacío.');
      }
      value = items.firstWhere(
        (final item) => _int(_stringKeyMap(item), 'idNotificacion') == id,
        orElse: () => items.first,
      );
    }
    if (value is! Map<Object?, Object?>) {
      throw const FormatException('El detalle de la notificación está vacío.');
    }
    return _stringKeyMap(value);
  }

  Map<String, Object?> _stringKeyMap(final Map<dynamic, dynamic> source) => {
    for (final entry in source.entries) entry.key.toString(): entry.value,
  };

  NotificacionDetalle _toDetalle(
    final Map<String, Object?> data, {
    required final int requestedId,
    final Notificacion? resumen,
  }) {
    final unidad = _map(data['unidadOrganica']);
    final procedimiento = _map(data['procedimientoAdministrativo']);
    final expediente = _map(data['expediente']);
    final historico = _list(data['historicoEstados']);
    DateTime? dateFor(final String state) {
      for (final item in historico.reversed) {
        final map = _map(item);
        if (map != null && (_string(map, 'estado') ?? '').toUpperCase() == state) {
          return _date(map['fecha-cambio'] ?? map['fechaCambio']);
        }
      }
      return null;
    }

    final docs = _list(data['documentos']).indexed
        .map((final entry) {
          final (index, item) = entry;
          final map = _map(item);
          if (map == null) {
            return null;
          }
          final nested = _map(map['documento']);
          final order = _int(map, 'orden') ?? index + 1;
          final name = _documentName(map) ?? _documentName(nested);
          if (name != null) {
            return NotificacionDocumento(
              orden: order,
              nombre: name,
              tamanoBytes: _documentSize(map, nested),
            );
          }
          // Antes se descartaba todo documento sin nombre, "para no inventar
          // nombres visibles". El payload oficial del detalle (swagger
          // `.../notificaciones/{id}/comparecer`, ejemplo "Respuesta transición
          // realizada") NO trae nombre, ni tamaño, ni URL: solo `orden`,
          // `identificadorReferencia` y un `documento` con referencias
          // internas. Con la regla vieja la sección "Documentos" salía vacía en
          // TODAS las notificaciones aceptadas (C-30) pese a que la descarga
          // (`GET .../documentos/{orden}`) solo necesita el orden, que sí
          // viene. Así que se conserva con una etiqueta derivada del orden;
          // lo que se descarta es únicamente lo que no permite descargar nada.
          if (_int(map, 'orden') == null && nested == null && !map.containsKey('identificadorReferencia')) {
            logger.w('[notificaciones] documento sin nombre ni referencia descartado en el detalle $requestedId (claves: ${map.keys.join(', ')})');
            return null;
          }
          return NotificacionDocumento(
            orden: order,
            nombre: 'Documento $order',
            tamanoBytes: _documentSize(map, nested),
          );
        })
        .nonNulls
        .toList(growable: false);
    final lecturaEstado = notificacionEstadoLecturaFromBackend(_string(data, 'estado'));
    if (lecturaEstado case NotificacionEstadoNoReconocido(:final raw)) {
      // Vocabulario de backend sin documentar: esta traza es la única forma de
      // descubrirlo. Solo el token del estado y el id consultado.
      logger.w('[notificaciones] estado no reconocido en el detalle $requestedId: "$raw" — sin respaldo del resumen');
    }
    return NotificacionDetalle(
      // El detalle se pide POR id, así que si el sobre no lo repite se conoce
      // igualmente: el respaldo es el id consultado, no un 0 fabricado.
      id: _int(data, 'id') ?? _int(data, 'idNotificacion') ?? requestedId,
      // El resumen antes del literal: si el detalle no trae concepto, la
      // pantalla debe titularse como la tarjeta desde la que se abrió, no
      // "Notificación".
      titulo: _string(data, 'concepto') ?? _string(data, 'descripcion') ?? _blankToNull(resumen?.concepto) ?? 'Notificación',
      estado: switch (lecturaEstado) {
        NotificacionEstadoConocido(:final estado) => estado,
        // El detalle no informa estado: el del resumen es lo único que se sabe.
        NotificacionEstadoAusente() => resumen?.estado,
        // El backend SÍ declara un estado y no sabemos leerlo: eso no es "no lo
        // sé", así que el resumen no puede sustituirlo. Sin estado no hay
        // acción de comparecer ni etiqueta.
        NotificacionEstadoNoReconocido() => null,
      },
      organismo: _string(data, 'organismo') ?? _string(unidad, 'nombre') ?? _additional(unidad, 'nombre') ?? resumen?.unidadOrganicaNombre,
      procedimiento: _procedimiento(data, procedimiento, requestedId: requestedId, resumen: resumen),
      expediente: _string(data, 'numeroExpediente') ?? _string(expediente, 'identificador'),
      fechaPuestaDisposicion: _date(data['fechaPuestaDisposicion'] ?? data['fecAlta']) ?? dateFor('PUESTO_A_DISPOSICION'),
      // El listado sí informa siempre la caducidad (`NotificacionIndexaDto`);
      // el detalle no está tipado y puede no traerla. Sin este respaldo la
      // fila "Fecha de expiración" desaparecía del detalle (C-28).
      fechaExpiracion: _date(data['fechaExpiracion'] ?? data['fechaCaducidad'] ?? data['fecCaducidad']) ?? resumen?.fechaCaducidad,
      fechaLectura: _date(data['fechaLectura']) ?? dateFor('ACEPTADA') ?? dateFor('RECHAZADA'),
      sistemaOrigen: _string(data, 'sistemaOrigen') ?? _string(unidad, 'sistema') ?? resumen?.sistemaOrigen,
      documentos: docs,
    );
  }

  /// Resuelve el dato que la pantalla pinta como "Procedimiento".
  ///
  /// Orden deliberado: **primero la denominación y después el `idFicha`**. En
  /// UAT el gateway devuelve `{denominacion: "SKA4"|"Procedimiento 7",
  /// idFicha: null}` en todos los elementos, así que la precedencia anterior
  /// (`idFicha` antes que `denominacion`) resolvía siempre a `null` cuando el
  /// detalle traía el bloque en su forma plana, y con él desaparecía la fila
  /// entera (C-31). La denominación es además lo que el diseño muestra —
  /// notifica2 guarda ahí tanto códigos como nombres.
  ///
  /// Se cubren las tres formas que el contrato admite (plana, `informacionAdicional`
  /// y clave suelta `procedimiento`, esta última tanto como cadena como como
  /// objeto) y, si ninguna resuelve, el resumen del listado, que sí está tipado.
  String? _procedimiento(
    final Map<String, Object?> data,
    final Map<String, Object?>? procedimiento, {
    required final int requestedId,
    final Notificacion? resumen,
  }) {
    final suelto = _map(data['procedimiento']);
    final resuelto = _string(procedimiento, 'denominacion') ?? _additional(procedimiento, 'denominacion') ?? _string(procedimiento, 'idFicha') ?? _additional(procedimiento, 'idFicha') ?? _string(data, 'procedimiento') ?? _string(suelto, 'denominacion') ?? _additional(suelto, 'denominacion') ?? _string(suelto, 'idFicha');
    if (resuelto != null) {
      return resuelto;
    }
    final delResumen = _blankToNull(resumen?.procedimientoDenominacion) ?? _blankToNull(resumen?.procedimientoIdFicha);
    // Traza de contrato: el swagger no tipa este cuerpo y sus dos ejemplos se
    // contradicen, así que esta línea es la única forma de saber qué envía el
    // backend de verdad. `redactForLog` deja la estructura a la vista y
    // enmascara los valores no listados como registrables (`idFicha` sí lo
    // está, `denominacion` no).
    logger.w(
      '[notificaciones] procedimiento sin resolver en el detalle $requestedId '
      '(bloque: ${redactForLog(procedimiento ?? suelto)}) — '
      '${delResumen != null ? 'se usa el del resumen' : 'sin respaldo del resumen'}',
    );
    return delResumen;
  }

  String? _blankToNull(final String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  int? _documentSize(final Map<String, Object?>? map, final Map<String, Object?>? nested) => _int(map, 'tamano') ?? _int(map, 'tamanoBytes') ?? _int(nested, 'tamano') ?? _int(nested, 'tamanoBytes');

  Map<String, Object?>? _map(final Object? value) => value is Map ? _stringKeyMap(value) : null;
  List<Object?> _list(final Object? value) => value is List ? value.cast<Object?>() : const [];
  DateTime? _date(final Object? value) => value is String ? DateTime.tryParse(value) : null;
  String? _documentName(final Map<String, Object?>? map) => _string(map, 'nombre') ?? _string(map, 'nombreFichero') ?? _string(map, 'nombreDocumento') ?? _string(map, 'titulo') ?? _string(map, 'descripcion') ?? _additional(map, 'nombre-documento');

  String? _additional(final Map<String, Object?>? map, final String key) {
    for (final item in _list(map?['informacionAdicional'])) {
      final entry = _map(item);
      if (_string(entry, 'clave') == key) {
        return _string(entry, 'valor');
      }
    }
    return null;
  }
}
