import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/logger/log_redaction.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/core/network/transfer_timeout.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/representante.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_documento_repository.dart';

final class GestionDocumentoRepositoryImpl implements GestionDocumentoRepository {
  GestionDocumentoRepositoryImpl({required final Dio dio}) : _dio = dio, _procedimientoApi = ProcedimientoApi(withGeneratedApiCompat(dio), standardSerializers);

  final Dio _dio;
  final ProcedimientoApi _procedimientoApi;

  /// Timeout configurado para el entorno (`TIMEOUT` del config), que aquí solo
  /// cubre la conexión y el trabajo del servidor: el tiempo de transferencia se
  /// suma aparte.
  Duration get _baseTimeout => _dio.options.sendTimeout ?? _dio.options.connectTimeout ?? const Duration(seconds: 20);

  @override
  Future<String> subirDocumentoSinFirma({
    required final String citizenId,
    required final String documentNumber,
    required final String idUnico,
    required final String tipoProcedimiento,
    required final String nombreFichero,
    required final Uint8List bytes,
    final CancelToken? cancelToken,
    final void Function(double progreso)? onProgress,
  }) async {
    final encoded = base64Encode(bytes);
    final adjunto = ADJUNTO(
      (final builder) => builder
        ..idunico = idUnico
        ..nifcif = documentNumber
        ..nombre = nombreFichero
        ..tipoprocedimiento = tipoProcedimiento
        ..data = encoded
        // Metadatos del documento que api-rest-doc.html marca como
        // `required` (`categoria`, `idprop`, `tipodoc`) y que el ejemplo
        // oficial envía siempre. La subida devuelve 200 + hash también sin
        // ellos (solo almacena en el buzón), pero es `registrarfichero`
        // quien procesa después los adjuntos almacenados para incorporarlos
        // al expediente — un adjunto guardado sin estos metadatos es
        // candidato al 500 sin detalle que sufre ese paso final. Valores
        // literales del ejemplo oficial; semántica de `categoria`/`tdoc`/
        // `origen` no documentada. Sin confirmar contra UAT real.
        ..categoria = '501'
        ..tdoc = 'C'
        ..origen = '0'
        ..idprop = documentNumber
        ..tipodoc = _extensionMayusculas(nombreFichero),
    );

    try {
      // La variante `1` apunta al path gateway POST
      // /api/v1/ciudadanos/{sid}/expedientes/{idExpediente}/ficheros. El
      // segmento `{idExpediente}` es decorativo (el backend opera con el
      // cuerpo ADJUNTO) y los números de expediente llevan barras que
      // romperían la ruta, así que se pasa el idunico de la transacción,
      // que es path-safe.
      await _procedimientoApi.miSubirAdjuntoSinFirmaOperation1(
        idAgente: citizenId,
        idExpediente: idUnico,
        adjuntoBody: adjunto,
        cancelToken: cancelToken,
        // El timeout general de la app (10 s en producción) es un plazo total
        // para empujar el cuerpo, así que un adjunto grande no podría subirse
        // nunca: este va dimensionado por lo que realmente se envía.
        extra: {
          generatedApiTimeoutExtraKey: payloadTransferTimeout(
            payloadBytes: encoded.length,
            baseTimeout: _baseTimeout,
          ),
        },
        onSendProgress: (final sent, final total) {
          if (total > 0) {
            onProgress?.call(sent / total);
          }
        },
      );
      // No observado contra backend real (ver rama catch): el tipo
      // declarado (`RESULTADOPROCEDIMIENTO`) no tiene ningún campo de hash,
      // así que esta rama no puede producir uno.
      throw StateError('Respuesta inesperada de subiradjuntosinfirma: no se pudo obtener el hash del documento.');
    } on DioException catch (error) {
      // Confirmado contra backend real (UAT): este endpoint responde 200 con
      // el sobre genérico `Respuesta` ({body, timestamp, mensaje-respuesta,
      // codigo-respuesta, info-error}), no con `RESULTADOPROCEDIMIENTO` como
      // documenta el swagger. El cliente generado deserializa en tipado
      // estricto y lanza DioException aunque la petición HTTP haya sido
      // correcta — si el status es 2xx se considera éxito pese al fallo de
      // deserialización, y `body` es el hash del documento.
      final statusCode = error.response?.statusCode;
      if (statusCode == null || statusCode < 200 || statusCode >= 300) {
        rethrow;
      }
      final hash = _string(_asMap(_decode(error.response?.data)), 'body');
      if (hash == null) {
        throw StateError('No se pudo extraer el hash del documento de la respuesta.');
      }
      return hash;
    }
  }

  @override
  Future<InicioProcedimientoResultado> iniciarProcedimiento({
    required final String citizenId,
    required final String idUnico,
    required final String documentNumber,
    required final Expediente expediente,
    final Representante? representante,
  }) async {
    // Bypass deliberado del cliente generado para este campo: el modelo
    // generado declara `datosprocedimiento` como JsonObject no-nulo (no
    // puede representar un `null` real — su factory lanza ArgumentError
    // para cualquier valor que no sea num/String/bool/List/Map), pero
    // enviar `{}` en su lugar devolvió un 500 real del backend en pruebas
    // contra UAT, igual que enviar cadenas vacías en `registro`/
    // `identificacionrep` (ya corregido más abajo). Se construye el body a
    // mano para poder enviar `datosprocedimiento: null` literal — sin
    // confirmar todavía si esto resuelve el 500.
    final body = _buildIniciarProcedimientoBody(
      idUnico: idUnico,
      documentNumber: documentNumber,
      expediente: expediente,
      representante: representante,
    );

    logger.d('[inicproc] req idunico=${maskedIdUnico(idUnico)} noexpediente=${expediente.numexp} tipoproc=${expediente.tipoproc ?? ''} category=NIF titular=${maskedDocument(documentNumber)} repNif=${maskedDocument(representante?.nifcif ?? documentNumber)}');
    Map<String, Object?>? responseBody;
    try {
      // Path gateway (el legacy /api/v1/procedimiento/inicproc no existe en el
      // gateway y responde 404). `{idExpediente}` es decorativo — el backend
      // opera con el cuerpo — y los números de expediente llevan barras que
      // romperían la ruta, así que se pasa el idunico, que es path-safe. Se
      // mantiene el POST crudo por el bypass de `datosprocedimiento: null`.
      final response = await _dio.post<Object?>(
        '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/expedientes/${Uri.encodeComponent(idUnico)}/ficheros/iniciar',
        data: body,
        options: Options(contentType: Headers.jsonContentType),
      );
      _logEnvelope('inicproc', response.statusCode, response.data);
      responseBody = _asMap(_decode(response.data));
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      _logEnvelope('inicproc(error)', statusCode, error.response?.data);
      if (statusCode == null || statusCode < 200 || statusCode >= 300) {
        logger.e('[inicproc] fallo HTTP $statusCode', error: error);
        rethrow;
      }
      responseBody = _asMap(_decode(error.response?.data));
    }

    final envelopeBody = _asMap(responseBody?['body']);
    if (envelopeBody == null) {
      throw StateError('Respuesta vacía o ilegible al iniciar el procedimiento.');
    }
    final estado = _string(envelopeBody, 'estado');
    if (estado == null || estado != 'OK') {
      throw StateError('El procedimiento no se pudo iniciar: ${_string(envelopeBody, 'mensaje') ?? 'sin mensaje'}.');
    }
    final pregistro = _asMap(_asMap(envelopeBody['datosregistro'])?['pregistro']);
    if (pregistro == null) {
      throw StateError('Respuesta de inicio de procedimiento sin datosregistro.pregistro.');
    }

    return InicioProcedimientoResultado(
      idunico: _string(envelopeBody, 'idunico') ?? idUnico,
      estado: estado,
      asuid: _string(pregistro, 'asuid') ?? '',
      descrip: _string(pregistro, 'descrip') ?? '',
      uniorg: _string(pregistro, 'uniorg') ?? '',
      numdoc: _string(pregistro, 'numdoc') ?? documentNumber,
      nombre: _string(pregistro, 'nombre') ?? '',
      apellido1: _string(pregistro, 'apellido1') ?? '',
      apellido2: _string(pregistro, 'apellido2') ?? '',
    );
  }

  Map<String, Object?> _buildIniciarProcedimientoBody({
    required final String idUnico,
    required final String documentNumber,
    required final Expediente expediente,
    required final Representante? representante,
  }) {
    final datos = expediente.datosAportacion;
    return <String, Object?>{
      'idunico': idUnico,
      'tipoprocedimiento': expediente.tipoproc ?? '',
      'unidadorganica': datos?.uniorg ?? '',
      'consejeria': datos?.consej ?? '',
      'provincia': datos?.bland ?? '',
      'noexpediente': expediente.numexp,
      'asunto': datos?.asunto ?? '',
      'asudescripcion': datos?.desasunto,
      'source': datos?.source,
      'registro': {
        'fecha': datos?.fechareg ?? '',
        'noregistro': datos?.registro ?? '',
      },
      // `category` describe el tipo de documento del titular; el backend solo
      // acepta NIF (rechaza `DNI` con "numero de DNI incorrecto") y el propio
      // expediente devuelve `tipodoc: NIF` — se fija a NIF, igual que en
      // `selectbynumexp`.
      'identificacion': {'category': 'NIF', 'nifcif': documentNumber},
      // `identificacionrep` es el representante (quien presenta): el usuario
      // autenticado al aportar como tercero, o el propio titular cuando se
      // aporta como interesado (`representante == null`).
      'identificacionrep': {'categoryrep': 'NIF', 'nifcifrep': representante?.nifcif ?? documentNumber},
      'datossolicitante': {
        'nombre': datos?.nombre ?? '',
        'apellido1': datos?.apellido1 ?? '',
        'apellido2': datos?.apellido2 ?? '',
        'entidad': '',
        'numero': datos?.tlfno ?? '',
        'poblacion': datos?.bezei ?? '',
        'provincia': datos?.bland ?? '',
        'codigopostal': datos?.codpos ?? '',
        'domicilio': '${datos?.calle ?? ''} ${datos?.ncalle ?? ''}'.trim(),
      },
      'datosprocedimiento': null,
      'adjuntos': {'adjunto': <String>[]},
    };
  }

  @override
  Future<Uint8List> registrarFicheros({
    required final String citizenId,
    required final String documentNumber,
    required final Expediente expediente,
    required final InicioProcedimientoResultado inicio,
    required final List<({String nombre, String hash, int tamanioBytes})> documentos,
    final Representante? representante,
  }) async {
    // Mismo bypass que en iniciarProcedimiento: `DTProcedimiento.datosprocedimiento`
    // exige un `JsonObject` no nulo en el cliente generado, pero enviar `{}`
    // reprodujo el mismo 500 real del backend que sufrió inicproc antes del
    // bypass — confirmado contra UAT real. `documentacion/registrarfichero`
    // además devuelve el justificante como bytes crudos (no un sobre JSON),
    // de ahí `ResponseType.bytes` en vez del parseo `_decode`/`_asMap`.
    final body = _buildRegistrarFicherosBody(
      documentNumber: documentNumber,
      expediente: expediente,
      inicio: inicio,
      documentos: documentos,
      representante: representante,
    );

    logger.d('[registrarfichero] req idunico=${maskedIdUnico(inicio.idunico)} noexpediente=${expediente.numexp} esPorContraste=${representante != null} documentos=${documentos.length}');
    Uint8List? bytes;
    try {
      // Path gateway; mismo criterio que en iniciarProcedimiento: segmento
      // `{idExpediente}` decorativo cubierto con el idunico confirmado.
      final response = await _dio.post<Uint8List>(
        '/api/v1/ciudadanos/${Uri.encodeComponent(citizenId)}/expedientes/${Uri.encodeComponent(inicio.idunico)}/ficheros/registrar',
        data: body,
        options: Options(contentType: Headers.jsonContentType, responseType: ResponseType.bytes),
      );
      bytes = response.data;
      logger.d('[registrarfichero] ok (200 directo) ${bytes?.length ?? 0} bytes');
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == null || statusCode < 200 || statusCode >= 300) {
        // El justificante vuelve como bytes; en un error el cuerpo suele ser
        // el sobre JSON del 500 crudo (sin `info-error`) — se decodifica a
        // texto para hacerlo visible en la traza.
        _logBytesBody('registrarfichero(error)', statusCode, error.response?.data);
        logger.e('[registrarfichero] fallo HTTP $statusCode', error: error);
        rethrow;
      }
      bytes = error.response?.data as Uint8List?;
      logger.d('[registrarfichero] ok (2xx vía DioException) ${bytes?.length ?? 0} bytes');
    }

    if (bytes == null) {
      throw StateError('Respuesta vacía al registrar los ficheros.');
    }
    return bytes;
  }

  // Body alineado con los ejemplos oficiales completos de las 3 fuentes
  // (manual de integración, swagger≡v3/api-docs en caliente y
  // api-rest-doc.html
  // #_registrar_todos_los_ficheros_adjuntos_a_una_transacción_iniciada_en_pi).
  // Historial contra UAT real: 5 iteraciones fallaron con el mismo 500
  // crudo sin `info-error` (excepción no controlada del backend) variando
  // el contenido de `confirmarProcedimiento` (datosprocedimiento null/{}
  // registro/identificacionrep vacíos o rellenos, datospago/firma/fileSize)
  // y añadiendo los hermanos `oficinaTramitadora`/`procedimiento`/fechas/
  // `estadoTramitacion`. La 6ª iteración añade las claves raíz que ningún
  // intento envió (`consejeriaTramitadora`, `xmlRegistro`,
  // `esPorContraste`, `datosRepresentante`) y, en paralelo, los metadatos
  // del ADJUNTO en subirDocumentoSinFirma — ver comentarios in situ.
  Map<String, Object?> _buildRegistrarFicherosBody({
    required final String documentNumber,
    required final Expediente expediente,
    required final InicioProcedimientoResultado inicio,
    required final List<({String nombre, String hash, int tamanioBytes})> documentos,
    required final Representante? representante,
  }) {
    final datos = expediente.datosAportacion;
    return <String, Object?>{
      'confirmarProcedimiento': {
        'procedimiento': {
          // El `idunico` confirmado por el servidor en iniciarProcedimiento,
          // no el generado localmente — puede diferir (el backend añade
          // sufijo).
          'idunico': inicio.idunico,
          'tipoprocedimiento': expediente.tipoproc ?? '',
          'unidadorganica': datos?.uniorg ?? '',
          'consejeria': datos?.consej ?? '',
          'provincia': datos?.bland ?? '',
          'noexpediente': expediente.numexp,
          // A diferencia de iniciarProcedimiento (donde enviar `registro`
          // vacío devolvió un 500 confirmado contra UAT real), aquí se sigue
          // el ejemplo literal "Datos Entrada Registrar Fichero" del manual
          // de integración, que muestra `registro: {}` e
          // `identificacionrep: {}` vacíos para este endpoint — sin
          // confirmar todavía si registrarfichero exige lo mismo que
          // inicproc o, como documenta el manual, los espera vacíos.
          // `identificacionrep` permanece vacío incluso en el ejemplo
          // oficial "por contraste" del swagger (los datos de quien
          // representa van en `datosRepresentante`, no aquí).
          'registro': <String, Object?>{},
          // El backend solo acepta NIF (rechaza `DNI`); ver misma nota en
          // `_buildIniciarProcedimientoBody`. Aquí el representante NO va en
          // `identificacionrep` (se deja vacío, según el ejemplo oficial) sino
          // en `datosRepresentante` + `esPorContraste`, más abajo.
          'identificacion': {'category': 'NIF', 'nifcif': documentNumber},
          'identificacionrep': <String, Object?>{},
          'asunto': datos?.asunto ?? '',
          'asudescripcion': datos?.desasunto ?? '',
          'source': datos?.source ?? '',
          'datossolicitante': {
            'nombre': datos?.nombre ?? '',
            'apellido1': datos?.apellido1 ?? '',
            'apellido2': datos?.apellido2 ?? '',
            'entidad': '',
            'domicilio': '${datos?.calle ?? ''} ${datos?.ncalle ?? ''}'.trim(),
            'numero': datos?.tlfno ?? '',
            'poblacion': datos?.bezei ?? '',
            'provincia': datos?.bland ?? '',
            'codigopostal': datos?.codpos ?? '',
          },
          'datosprocedimiento': null,
          'datospago': <String, Object?>{},
          'adjuntos': {'adjunto': <String>[]},
          'firma': '',
        },
        'pdatos': {
          // Confirmado contra backend real de UAT: `inicproc` devolvió
          // `pregistro.asuid`/`descrip` vacíos para este expediente (ya
          // tenía un registro de entrada previo) — se reutilizan los datos
          // ya existentes del expediente (`asunto`/`desasunto`) en su lugar
          // de enviarlos vacíos.
          'asuid': inicio.asuid.isNotEmpty ? inicio.asuid : (datos?.asunto ?? ''),
          'descrip': inicio.descrip.isNotEmpty ? inicio.descrip : (datos?.desasunto ?? ''),
          'uniorg': inicio.uniorg,
          'numdoc': inicio.numdoc,
          'nombre': inicio.nombre,
          'apellido1': inicio.apellido1,
          'apellido2': inicio.apellido2,
          'idunico': inicio.idunico,
        },
      },
      'documentos': documentos
          .map(
            (final d) => {
              'nombre': d.nombre,
              // Suposición sin confirmar: subiradjuntosinfirma no informa
              // el algoritmo de hash usado; se toma el valor del ejemplo
              // del manual de integración como mejor estimación.
              'algoritmo': 'SHA-512',
              'hash': d.hash,
              // El manual documenta `fileSize` como String (ejemplo: "80kb")
              // — formato exacto sin confirmar, se sigue el ejemplo literal.
              'fileSize': '${(d.tamanioBytes / 1024).round()}kb',
            },
          )
          .toList(growable: false),
      // Sin correspondencia documentada con ningún campo del expediente en
      // ninguna de las 3 fuentes — se reutiliza `desuniorg` (descripción de
      // la unidad orgánica, ya mapeada en `Expediente.oficinaTramitadora`
      // desde `selectbynumexp`) como la aproximación real más cercana
      // disponible; pendiente de confirmar contra UAT real.
      'oficinaTramitadora': expediente.oficinaTramitadora ?? '',
      'procedimiento': datos?.desasunto ?? expediente.titulo,
      'fechaInicioTramitacion': datos?.fechareg ?? '',
      // Fecha de cierre de esta tramitación: se cierra precisamente con esta
      // llamada, de ahí "hoy". Formato yyyy-MM-dd tomado del ejemplo
      // específico de este endpoint en api-rest-doc.html (el ejemplo
      // genérico del manual/swagger usa yyyy-MM-dd HH:mm) — sin confirmar
      // cuál exige realmente el backend.
      'fechaCierreTramitacion': _formatearFechaIso(DateTime.now()),
      'estadoTramitacion': 'En curso',
      // Claves raíz presentes en los ejemplos oficiales de las 3 fuentes
      // (manual, swagger/v3 y api-rest-doc.html) que ninguna iteración
      // anterior enviaba. `xmlRegistro.xmlClave` es consumida por la lógica
      // de registro según el manual ("se adjunta posteriormente al
      // expediente junto con el justificante de presentación") — su
      // ausencia es candidata directa al NPE detrás del 500 crudo sin
      // `info-error`; ídem un unboxing de `esPorContraste` nulo o una
      // cadena de getters sobre `datosRepresentante` ausente. Sin confirmar
      // contra UAT real.
      'consejeriaTramitadora': expediente.consejeria,
      'xmlRegistro': {'xmlClave': ''},
      // `true` + `datosRepresentante` poblado cuando se aporta a un
      // expediente de terceros ("por contraste"), replicando el ejemplo
      // oficial del swagger para este caso; `false` + estructura vacía para
      // la aportación como interesado (comportamiento previo, sin cambios).
      'esPorContraste': representante != null,
      'datosRepresentante': {
        'nombre': representante?.nombre ?? '',
        'apellido1': representante?.apellido1 ?? '',
        'apellido2': representante?.apellido2 ?? '',
        'nifcif': representante?.nifcif ?? '',
        'tipodoc': representante?.tipodoc ?? '',
      },
    };
  }

  String _formatearFechaIso(final DateTime fecha) {
    final anio = fecha.year.toString().padLeft(4, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final dia = fecha.day.toString().padLeft(2, '0');
    return '$anio-$mes-$dia';
  }

  // "PDF" en el ejemplo oficial de subiradjuntosinfirma ("Formato del
  // documento"); se deriva de la extensión real del fichero.
  String _extensionMayusculas(final String nombreFichero) {
    final punto = nombreFichero.lastIndexOf('.');
    if (punto <= 0 || punto == nombreFichero.length - 1) {
      return 'PDF';
    }
    return nombreFichero.substring(punto + 1).toUpperCase();
  }

  /// Traza los campos de diagnóstico del sobre genérico `Respuesta`
  /// ({body, mensaje-respuesta, codigo-respuesta, info-error}). Este backend
  /// puede responder con `estado != OK` o lanzar 500 crudos sin `info-error`,
  /// así que se registran tanto los campos del sobre como `body.estado`/
  /// `body.mensaje`.
  void _logEnvelope(final String op, final int? statusCode, final Object? raw) {
    final payload = _asMap(_decode(raw));
    final body = _asMap(payload?['body']);
    logger.d(
      '[$op] http=$statusCode codigo-respuesta=${payload?['codigo-respuesta']} '
      'mensaje-respuesta=${payload?['mensaje-respuesta']} info-error=${payload?['info-error']} '
      'estado=${_string(body, 'estado')} mensaje=${_string(body, 'mensaje')}',
    );
  }

  /// `registrarfichero` responde con bytes crudos (el justificante). En un
  /// error el cuerpo suele ser el sobre JSON del 500; se decodifica a texto
  /// (recortado) para verlo en la traza sin volcar un binario.
  ///
  /// La redacción va **antes** del recorte: así los campos de diagnóstico del
  /// sobre siguen visibles y cualquier dato personal que traiga queda
  /// enmascarado (recortar primero rompería el JSON y lo enmascararía entero).
  void _logBytesBody(final String op, final int? statusCode, final Object? data) {
    String preview;
    if (data is Uint8List) {
      try {
        preview = utf8.decode(data, allowMalformed: true);
      } on Object {
        preview = '<${data.length} bytes binarios>';
      }
    } else {
      preview = data?.toString() ?? 'null';
    }
    preview = redactForLog(preview).toString();
    if (preview.length > 600) {
      preview = '${preview.substring(0, 600)}…';
    }
    logger.d('[$op] http=$statusCode body=$preview');
  }

  Object? _decode(final Object? raw) {
    Object? current = raw;
    for (var i = 0; i < 3; i++) {
      if (current is! String) {
        return current;
      }
      final trimmed = current.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      try {
        current = jsonDecode(trimmed);
      } on FormatException {
        return trimmed;
      }
    }
    return current;
  }

  Map<String, Object?>? _asMap(final Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map<dynamic, dynamic>) {
      return {
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  String? _string(final Map<String, Object?>? map, final String key) {
    final value = map?[key];
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }
}
