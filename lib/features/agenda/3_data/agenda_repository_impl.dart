import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/repositories/agenda_repository.dart';

final class AgendaRepositoryImpl implements AgendaRepository {
  AgendaRepositoryImpl({required final Dio dio}) : _sescamApi = SescamApi(withGeneratedApiCompat(dio), standardSerializers), _agendaApi = AgendaApi(withGeneratedApiCompat(dio), standardSerializers);

  final SescamApi _sescamApi;
  final AgendaApi _agendaApi;

  @override
  Future<AgendaAppointmentsSnapshot> loadAppointments({
    required final String documentNumber,
    final String? agentId,
    final bool includeHealth = true,
  }) async {
    final trimmedAgentId = agentId?.trim();
    // Cada fuente se resuelve por separado: si una cae, la agenda se pinta con
    // lo que sí llegó y la pantalla avisa de lo que falta. El error solo se
    // propaga cuando fallan todas las fuentes que se han llegado a intentar.
    final results = await Future.wait([
      if (includeHealth)
        _captureAppointments(
          AgendaAppointmentSource.health,
          () => _loadAppointmentsFrom(
            // La variante `1` apunta al path gateway
            // /api/v1/ciudadanos/{numDocumento}/salud/primaria-citas-pendientes
            // (el legacy /api/v1/sescam/citas/... no existe en el gateway y
            // responde 404, igual que pasaba con /api/v1/agenda/...). Es el mismo
            // endpoint que usa Mis Datos → Salud, que sí devuelve las citas.
            () => _sescamApi.citasFuturas1(
              numDocumento: documentNumber,
              extra: _generatedExtra,
            ),
            source: AgendaAppointmentSource.health,
            ignoreUnauthorized: true,
            emptyResultErrorCodes: const {'3031'},
            confirmEmptyResult: () => _isCipMissing(documentNumber),
          ),
        ),
      // Sin `idAgente` la agenda general ni se pide: eso no es un fallo y no
      // entra en `failedSources`.
      if (trimmedAgentId != null && trimmedAgentId.isNotEmpty)
        _captureAppointments(
          AgendaAppointmentSource.general,
          () => _loadAppointmentsFrom(
            // La variante `1` apunta al path gateway
            // /api/v1/ciudadanos/{sid}/eventos/{periodo} (el legacy
            // /api/v1/agenda/... no existe en el gateway y responde 404). El
            // periodo va en mayúsculas: TODOS, SEMANA, MES o ANIO.
            () => _agendaApi.obtenerEventosAgenda1(
              idAgente: trimmedAgentId,
              periodo: 'TODOS',
              extra: _generatedExtra,
            ),
            source: AgendaAppointmentSource.general,
            ignoreBadRequest: true,
          ),
        ),
    ]);

    final healthCipMissing = results.any((final result) => result.error is _HealthCipMissing);
    final failures = results.where((final result) => result.error != null && result.error is! _HealthCipMissing).toList(growable: false);
    // Cuando hay representación se consulta solo la agenda de notificaciones.
    if (results.isEmpty) {
      return const AgendaAppointmentsSnapshot(appointments: []);
    }
    if (failures.length == results.length) {
      final failure = failures.first;
      Error.throwWithStackTrace(failure.error!, failure.stackTrace!);
    }

    // Las dos fuentes se solapan: la agenda general publica las citas de
    // Atención Primaria como eventos con el detalle dentro del mensaje, y
    // primaria-citas-pendientes las devuelve estructuradas. Cuando coinciden en
    // fecha y hora se conserva la de SESCAM, que trae centro y profesional en
    // campos propios, para no pintar la misma cita dos veces. Se filtra por
    // `source` y no por posición: la lista varía de longitud y puede traer
    // fuentes caídas. Con SESCAM caída no hay franjas que descartar, así que
    // las citas de primaria que publica la agenda general sobreviven.
    final healthAppointments = <AgendaAppointment>[
      for (final result in results)
        if (result.source == AgendaAppointmentSource.health) ...result.appointments,
    ];
    final healthSlots = healthAppointments.map((final appointment) => _appointmentSlot(appointment.dateTime)).toSet();
    final appointments = <AgendaAppointment>[
      ...healthAppointments,
      for (final result in results)
        if (result.source != AgendaAppointmentSource.health)
          for (final appointment in result.appointments)
            if (appointment.kind != AgendaAppointmentKind.health || !healthSlots.contains(_appointmentSlot(appointment.dateTime))) appointment,
    ]..sort((final a, final b) => a.dateTime.compareTo(b.dateTime));

    return AgendaAppointmentsSnapshot(
      appointments: List<AgendaAppointment>.unmodifiable(appointments),
      failedSources: Set<AgendaAppointmentSource>.unmodifiable(failures.map((final result) => result.source)),
      healthCipMissing: healthCipMissing,
    );
  }

  /// Resuelve una fuente sin dejar que su fallo tumbe a las demás: el error se
  /// devuelve como valor, con su traza, para que quien agrega decida.
  Future<_AgendaSourceResult> _captureAppointments(
    final AgendaAppointmentSource source,
    final Future<List<AgendaAppointment>> Function() load,
  ) async {
    try {
      return (source: source, appointments: await load(), error: null, stackTrace: null);
    } catch (error, stackTrace) {
      return (source: source, appointments: const <AgendaAppointment>[], error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> refreshEvents({required final String agentId}) async {
    // El resultado (RefrescarAgendaDTO: contadores ok/error por fuente) no se
    // muestra; el refresco se refleja recargando los eventos después.
    await _agendaApi.refrescarAgendaEvents1(
      idAgente: agentId,
      extra: _generatedExtra,
    );
  }

  Future<List<AgendaAppointment>> _loadAppointmentsFrom(
    final Future<Response<Respuesta>> Function() fetch, {
    required final AgendaAppointmentSource source,
    final bool ignoreBadRequest = false,
    final bool ignoreUnauthorized = false,
    final Set<String> emptyResultErrorCodes = const {},
    final Future<bool> Function()? confirmEmptyResult,
  }) async {
    final Object? payload;
    try {
      final response = await fetch();
      if (_isEmptyResultStatus(
        response.statusCode,
        ignoreBadRequest: ignoreBadRequest,
        ignoreUnauthorized: ignoreUnauthorized,
      )) {
        return const [];
      }
      payload = response.extra[generatedApiRawResponseDataExtraKey] ?? response.data;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (_isEmptyResultStatus(
        statusCode,
        ignoreBadRequest: ignoreBadRequest,
        ignoreUnauthorized: ignoreUnauthorized,
      )) {
        return const [];
      }
      final rawData = error.response?.extra[generatedApiRawResponseDataExtraKey] ?? error.response?.data;
      if (rawData == null) {
        rethrow;
      }
      final decodedError = _decodePayload(rawData);
      if (_containsErrorCode(decodedError, emptyResultErrorCodes) && (confirmEmptyResult == null || await confirmEmptyResult())) {
        throw const _HealthCipMissing();
      }
      // Salvage-or-rethrow: si el cuerpo del error no contiene citas parseables,
      // el fallo se propaga. La excepción son los estados que la llamada haya
      // configurado explícitamente como resultado vacío (401/403 y código
      // funcional 3031 en salud).
      final salvaged = _appointmentMaps(decodedError).map((final raw) => _tryParseAppointment(raw, source: source)).nonNulls.toList(growable: false);
      if (salvaged.isNotEmpty) {
        return salvaged;
      }
      rethrow;
    }
    if (payload == null) {
      return const [];
    }

    final decoded = _decodePayload(payload);
    final objects = _appointmentMaps(decoded);
    return objects.map((final raw) => _tryParseAppointment(raw, source: source)).nonNulls.toList(growable: false);
  }

  bool _isEmptyResultStatus(
    final int? statusCode, {
    required final bool ignoreBadRequest,
    required final bool ignoreUnauthorized,
  }) => statusCode == 404 || (ignoreBadRequest && statusCode == 400) || (ignoreUnauthorized && (statusCode == 401 || statusCode == 403));

  bool _containsErrorCode(final Object? value, final Set<String> expectedCodes) {
    if (expectedCodes.isEmpty) {
      return false;
    }
    final maps = _collectMaps(value);
    return maps.any((final map) {
      final code = _firstString(map, const ['codigo-error', 'codigoError']);
      return code != null && expectedCodes.contains(code);
    });
  }

  /// SESCAM devuelve el mismo 3031 cuando el ciudadano no tiene CIP y cuando el
  /// servicio de citas está caído; solo la consulta del CIP los distingue. Si
  /// esa consulta falla tampoco se confirma nada: la fuente se da por caída en
  /// vez de afirmar que no hay CIP.
  Future<bool> _isCipMissing(final String documentNumber) async {
    final Object? payload;
    try {
      final response = await _sescamApi.getCipFromNif1(
        numDocumento: documentNumber,
        extra: _generatedExtra,
      );
      payload = response.extra[generatedApiRawResponseDataExtraKey] ?? response.data;
    } on DioException catch (error) {
      return error.response?.statusCode == 404;
    }
    final body = _asStringMap(_asStringMap(_decodePayload(payload))?['body']);
    return body == null || _firstString(body, const ['cip']) == null;
  }

  Map<String, dynamic> get _generatedExtra => const {
    generatedApiDecodeStringResponseExtraKey: true,
  };

  Object? _decodePayload(final Object? payload) {
    Object? current = payload;
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

  List<Map<String, dynamic>> _appointmentMaps(final Object? value) {
    final root = _asStringMap(value);
    final body = _asStringMap(root?['body']);
    final rawAppointments = body?['listaCitas'];
    if (body != null && rawAppointments is List<dynamic>) {
      final centerData = <String, dynamic>{
        for (final entry in body.entries)
          if (entry.key != 'listaCitas') entry.key: entry.value,
      };
      return rawAppointments
          .map(_asStringMap)
          .nonNulls
          .map(
            (final appointment) => <String, dynamic>{
              ...centerData,
              ...appointment,
            },
          )
          .toList(growable: false);
    }

    return _collectMaps(value);
  }

  Map<String, dynamic>? _asStringMap(final Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map<dynamic, dynamic>) {
      return <String, dynamic>{
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  List<Map<String, dynamic>> _collectMaps(final Object? value) {
    final maps = <Map<String, dynamic>>[];
    void visit(final Object? node) {
      switch (node) {
        case final Map<String, dynamic> map:
          maps.add(map);
          map.values.forEach(visit);
        case final Map<dynamic, dynamic> map:
          final normalized = <String, dynamic>{
            for (final entry in map.entries)
              if (entry.key != null) entry.key.toString(): entry.value,
          };
          maps.add(normalized);
          normalized.values.forEach(visit);
        case final List<dynamic> list:
          list.forEach(visit);
      }
    }

    visit(value);
    return maps;
  }

  AgendaAppointment? _tryParseAppointment(
    final Map<String, dynamic> raw, {
    required final AgendaAppointmentSource source,
  }) {
    final dateTime = _extractDateTime(raw);
    if (dateTime == null) {
      return null;
    }

    final title = _firstString(raw, const [
      'titulo',
      'title',
      'nombre',
      'asunto',
      'resumen',
      'summary',
      'evento',
      'nombreEvento',
      'descripcionEvento',
    ]);
    final professional = _firstString(raw, const [
      'profesional',
      'nombreProfesional',
      'nombreCompletoProfesional',
      'nombre_medico',
      'medico',
      'facultativo',
      'doctor',
      'doctorNombre',
      'nombreDoctor',
      'nomProfesionalRealizador',
      'profesionalRealizador',
    ]);
    final specialty = _firstString(raw, const [
      'especialidad',
      'servicio',
      'agenda',
      'prestacion',
      'tipoCita',
      'descTipoCita',
      'descripcionTipoCita',
      'descripcionCita',
      'nombreCita',
      'nomTvisita',
      'nomTVisita',
      'nomTipoVisita',
      'nombreTipoVisita',
      'tipoEvento',
      'descTipoEvento',
      'descripcionTipoEvento',
      'tipo',
      'descripcion',
      'motivo',
      'nomVisita',
    ]);
    final center = _firstString(raw, const [
      'centro',
      'centroSalud',
      'centro_sanitario',
      'nombreCentro',
      'dirCentro',
      'municipioCentro',
      'ubicacion',
      'localizacion',
    ]);
    final channel = _firstString(raw, const [
      'canal',
      'descripcionCanal',
      'modalidad',
      'descripcionModalidad',
      'tipoConsulta',
      'tipoAsistencia',
      'nomModoVisita',
      'forma',
    ]);
    final detail = _firstString(raw, const [
      'detalle',
      'detalleCita',
      'descripcionConsulta',
      'descripcionModoVisita',
      'descModoVisita',
      'descripcionTipoConsulta',
      'descTipoConsulta',
      'nombreTipoConsulta',
      'nomTipoVisita',
      'tipoVisita',
      'subtipoCita',
      'observaciones',
    ]);
    final rawMessage = _firstString(raw, const [
      'mensaje',
      'message',
      'contenido',
      'texto',
    ]);
    final message = _cleanHtml(rawMessage);
    final notificationDetails = _notificationDetails(raw, rawMessage);
    final primaryCareDetails = _parsePrimaryCareMessage(message);
    final isPrimaryCare = source == AgendaAppointmentSource.general && (_isPrimaryCareEvent(title, specialty, message, detail, center) || primaryCareDetails != null);
    final isHealthEvent = source == AgendaAppointmentSource.general && (isPrimaryCare || _isHospitalAppointmentEvent(title, specialty, message, detail, center));
    final isOnDemandHealthAppointment = source == AgendaAppointmentSource.health && _isOnDemandAppointment(specialty);
    final kind = switch (source) {
      AgendaAppointmentSource.health => AgendaAppointmentKind.health,
      AgendaAppointmentSource.general when _isCredentialEvent(title, specialty, message) => AgendaAppointmentKind.credential,
      AgendaAppointmentSource.general when isHealthEvent => AgendaAppointmentKind.health,
      AgendaAppointmentSource.general => AgendaAppointmentKind.notification,
    };

    // La agenda general publica el cuerpo del evento como párrafos HTML
    // («<p>Profesional: …</p> <p>Sala: …</p>»). Cuando traen filas etiquetadas
    // se conservan una a una, para pintarlas como hace la web, en vez de
    // aplanarlas en una sola frase (JCCMEC-256). El título es el del evento y
    // la intro, los párrafos sin etiqueta. «Hora» se descarta: ya va en la
    // fecha de la cita.
    if (source == AgendaAppointmentSource.general) {
      final structured = _structuredMessage(rawMessage);
      if (structured.details.isNotEmpty) {
        return AgendaAppointment(
          dateTime: dateTime,
          title: title ?? (isHealthEvent ? 'Cita sanitaria' : specialty ?? 'Cita'),
          description: structured.intro ?? message ?? title ?? 'Cita',
          kind: kind,
          channel: primaryCareDetails?.channel ?? channel,
          center: center,
          details: structured.details,
        );
      }
    }

    final description = switch (source) {
      AgendaAppointmentSource.health when isOnDemandHealthAppointment => 'Cita de Atención Primaria',
      AgendaAppointmentSource.health => specialty ?? 'Cita sanitaria',
      AgendaAppointmentSource.general when isPrimaryCare => title ?? 'Cita de Atención Primaria',
      AgendaAppointmentSource.general => notificationDetails.subject ?? message ?? specialty ?? title ?? 'Cita',
    };

    return AgendaAppointment(
      dateTime: dateTime,
      title: source == AgendaAppointmentSource.health
          ? professional ?? specialty ?? 'Cita sanitaria'
          : isPrimaryCare
          ? primaryCareDetails?.professional ?? professional ?? title ?? 'Cita de Atención Primaria'
          : title ?? specialty ?? 'Cita',
      description: description,
      kind: kind,
      channel: primaryCareDetails?.channel ?? channel,
      detail: isOnDemandHealthAppointment ? _primaryCareAppointmentDetail(specialty, channel) : primaryCareDetails?.appointmentDetail ?? notificationDetails.issuer ?? detail ?? center,
      center: center,
    );
  }

  _NotificationDetails _notificationDetails(
    final Map<String, dynamic> raw,
    final String? rawMessage,
  ) {
    final directSubject = _firstString(raw, const [
      'asunto',
      'subject',
      'concepto',
      'denominacionProcedimiento',
    ]);
    final directIssuer = _firstString(raw, const [
      'emisor',
      'issuer',
      'unidadOrganica',
      'unidadOrganicaNombre',
      'nombreUnidadOrganica',
      'unidad',
      'organismo',
      'servicio',
    ]);
    final lines = _cleanHtmlLines(rawMessage);
    final subject = directSubject ?? _lineWithLabel(lines, const ['asunto']);
    const issuerLabels = ['organismo emisor', 'emisor', 'unidad', 'organismo', 'servicio'];
    final issuer = directIssuer ?? _lineWithLabel(lines, issuerLabels);

    return (
      subject: subject == null ? null : _withLabel('Asunto', subject),
      issuer: issuer == null ? null : _withoutLabel(issuer, issuerLabels),
    );
  }

  /// Etiquetas que no se convierten en fila: la hora ya se muestra junto a la
  /// fecha de la tarjeta.
  static const _omittedDetailLabels = {'hora'};

  /// Separa el mensaje HTML del evento en la intro (párrafos sin etiqueta,
  /// unidos) y las filas «Etiqueta: valor» (un párrafo cada una), en el orden
  /// original.
  ({String? intro, List<AgendaAppointmentDetail> details}) _structuredMessage(final String? rawMessage) {
    final intro = <String>[];
    final details = <AgendaAppointmentDetail>[];
    for (final line in _cleanHtmlLines(rawMessage)) {
      final row = _labeledRow(line);
      if (row == null) {
        intro.add(line);
      } else if (!_omittedDetailLabels.contains(row.label.toLowerCase())) {
        details.add(row);
      }
    }
    return (intro: intro.isEmpty ? null : intro.join(' '), details: details);
  }

  /// «Profesional:CAMPO CRIPTANA» → (Profesional, CAMPO CRIPTANA). Una línea
  /// que termina en dos puntos («Tiene una notificación próxima a caducar:»)
  /// no es una fila, es intro.
  AgendaAppointmentDetail? _labeledRow(final String line) {
    final match = RegExp(r'^([^:]{1,40}?)\s*:\s*(.+)$').firstMatch(line);
    if (match == null) {
      return null;
    }
    final label = match.group(1)!.trim();
    final value = match.group(2)!.trim();
    if (label.isEmpty || value.isEmpty) {
      return null;
    }
    return (label: '${label[0].toUpperCase()}${label.substring(1)}', value: value);
  }

  List<String> _cleanHtmlLines(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return const [];
    }
    final withBreaks = value.replaceAll(RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false), '\n').replaceAll(RegExp(r'</\s*(?:p|div|li)\s*>', caseSensitive: false), '\n');
    return withBreaks.split('\n').map(_cleanHtml).whereType<String>().where((final line) => line.isNotEmpty).toList(growable: false);
  }

  String? _lineWithLabel(final List<String> lines, final List<String> labels) {
    for (final line in lines) {
      final normalized = line.toLowerCase();
      if (labels.any((final label) => normalized.startsWith('$label:'))) {
        return line;
      }
    }
    return null;
  }

  String _withLabel(final String label, final String value) {
    final trimmed = value.trim();
    return trimmed.toLowerCase().startsWith('${label.toLowerCase()}:') ? trimmed : '$label: $trimmed';
  }

  String _withoutLabel(final String value, final List<String> labels) {
    final trimmed = value.trim();
    for (final label in labels) {
      final prefix = '$label:';
      if (trimmed.toLowerCase().startsWith(prefix)) {
        return trimmed.substring(prefix.length).trim();
      }
    }
    return trimmed;
  }

  _PrimaryCareMessageDetails? _parsePrimaryCareMessage(final String? message) {
    if (message == null || !_isPrimaryCareEvent(null, null, message, null, null)) {
      return null;
    }

    String? valueBetween(final String start, final String? end) {
      final endPattern = end == null ? r'$' : RegExp.escape(end);
      final match = RegExp('${RegExp.escape(start)}\\s*(.*?)\\s*$endPattern', caseSensitive: false).firstMatch(message);
      final value = match?.group(1)?.trim();
      return value == null || value.isEmpty ? null : value;
    }

    final professional = valueBetween('Profesional:', 'Tipo de cita:');
    final appointmentType = valueBetween('Tipo de cita:', 'Modo de cita:');
    final channel = valueBetween('Modo de cita:', null);
    final appointmentDetail = _primaryCareAppointmentDetail(appointmentType, channel);

    return (
      professional: professional,
      channel: channel,
      appointmentDetail: appointmentDetail,
    );
  }

  String? _primaryCareAppointmentDetail(
    final String? appointmentType,
    final String? channel,
  ) {
    final normalizedType = appointmentType?.toLowerCase();
    final isOnDemand = normalizedType?.contains('demanda') ?? false;
    if (!isOnDemand) {
      return appointmentType;
    }

    final isRemote = (channel?.toLowerCase().contains('telef') ?? false) || (normalizedType?.contains('teleconsulta') ?? false);
    return isRemote ? 'Teleconsulta a demanda' : 'Consulta a demanda';
  }

  bool _isOnDemandAppointment(final String? appointmentType) => appointmentType?.toLowerCase().contains('demanda') ?? false;

  bool _isPrimaryCareEvent(
    final String? title,
    final String? specialty,
    final String? message,
    final String? detail,
    final String? center,
  ) {
    final searchableText = '${title ?? ''} ${specialty ?? ''} ${message ?? ''} ${detail ?? ''} ${center ?? ''}'.toLowerCase();
    return searchableText.contains('atención primaria') || searchableText.contains('atencion primaria');
  }

  bool _isHospitalAppointmentEvent(
    final String? title,
    final String? specialty,
    final String? message,
    final String? detail,
    final String? center,
  ) {
    final searchableText = '${title ?? ''} ${specialty ?? ''} ${message ?? ''} ${detail ?? ''} ${center ?? ''}'.toLowerCase();
    return searchableText.contains('atención hospitalaria') || searchableText.contains('atencion hospitalaria');
  }

  bool _isCredentialEvent(
    final String? title,
    final String? specialty,
    final String? message,
  ) {
    final searchableText = '${title ?? ''} ${specialty ?? ''} ${message ?? ''}'.toLowerCase();
    return searchableText.contains('carnet') || searchableText.contains('carné') || searchableText.contains('tarjeta');
  }

  String? _cleanHtml(final String? value) {
    if (value == null) {
      return null;
    }
    final cleaned = value.replaceAll(RegExp('<[^>]+>'), ' ').replaceAll('&nbsp;', ' ').replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned.isEmpty ? null : cleaned;
  }

  DateTime? _extractDateTime(final Map<String, dynamic> raw) {
    final combined = _firstString(raw, const [
      'fechaHora',
      'fecha_hora',
      'fechaCita',
      'fecha_cita',
      'dateTime',
      'datetime',
      'inicio',
      'start',
      'fechaInicio',
      'fecha_inicio',
      'fechaVencimiento',
      'fecha_vencimiento',
      'startDate',
      'start_date',
    ]);
    final parsedCombined = _parseDateTime(combined);
    if (parsedCombined != null) {
      return parsedCombined;
    }

    final date = _firstString(raw, const [
      'fecha',
      'date',
      'dia',
      'fechaInicio',
      'fecha_inicio',
      'fechaEvento',
      'fecha_evento',
      'diaEvento',
    ]);
    final time = _firstString(raw, const [
      'hora',
      'time',
      'horaInicio',
      'hora_inicio',
      'horaEvento',
      'hora_evento',
    ]);
    return _parseDateAndTime(date: date, time: time);
  }

  DateTime? _parseDateAndTime({required final String? date, required final String? time}) {
    if (date == null) {
      return null;
    }
    final normalizedTime = time == null || time.trim().isEmpty ? '00:00' : time.trim();
    return _parseDateTime('${date.trim()} $normalizedTime') ?? _parseDateTime(date);
  }

  /// Clave de coincidencia entre fuentes: fecha y hora local a precisión de
  /// minuto. Las dos fuentes expresan la misma cita con granularidades
  /// distintas (los eventos añaden segundos; SESCAM publica `HH:mm`) y, si el
  /// backend emitiera ISO con zona, con husos distintos — la igualdad exacta
  /// de [DateTime] (que compara también `isUtc`) duplicaba la cita.
  DateTime _appointmentSlot(final DateTime value) {
    final local = value.toLocal();
    return DateTime(local.year, local.month, local.day, local.hour, local.minute);
  }

  DateTime? _parseDateTime(final String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      // Siempre en hora local: un ISO con `Z` u offset quedaba en UTC, se
      // pintaba con la hora desplazada y nunca casaba en la deduplicación con
      // la misma cita expresada en local por la otra fuente.
      return iso.toLocal();
    }

    final dateTimeMatch = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})(?:\s+(\d{1,2}):(\d{2}))?').firstMatch(trimmed);
    if (dateTimeMatch == null) {
      return null;
    }

    final day = int.tryParse(dateTimeMatch.group(1)!);
    final month = int.tryParse(dateTimeMatch.group(2)!);
    final year = int.tryParse(dateTimeMatch.group(3)!);
    final hour = int.tryParse(dateTimeMatch.group(4) ?? '0');
    final minute = int.tryParse(dateTimeMatch.group(5) ?? '0');
    if (day == null || month == null || year == null || hour == null || minute == null) {
      return null;
    }
    return DateTime(year, month, day, hour, minute);
  }

  String? _firstString(final Map<String, dynamic> raw, final List<String> keys) {
    final normalized = <String, Object?>{
      for (final entry in raw.entries) entry.key.toLowerCase(): entry.value,
    };
    for (final key in keys) {
      final value = normalized[key.toLowerCase()];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value is num) {
        return value.toString();
      }
    }
    return null;
  }
}

typedef _AgendaSourceResult = ({
  AgendaAppointmentSource source,
  List<AgendaAppointment> appointments,
  Object? error,
  StackTrace? stackTrace,
});

typedef _PrimaryCareMessageDetails = ({String? professional, String? channel, String? appointmentDetail});
typedef _NotificationDetails = ({String? subject, String? issuer});

final class _HealthCipMissing implements Exception {
  const _HealthCipMissing();
}
