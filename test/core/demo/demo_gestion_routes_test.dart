import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_gestion_routes.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_documento_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_expediente_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_notificaciones_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_registros_repository_impl.dart';

/// Las rutas demo de Gestión se prueban de extremo a extremo con los
/// repositorios REALES, construidos como lo hacen los providers de la app:
/// lo que se comprueba es que las fixtures tienen la forma que la fachada
/// devuelve de verdad, porque el mismo mapper que sirve al gateway tiene que
/// servir a la demo.
void main() {
  // Reloj fijo en UTC: las fixtures son relativas a él y las mutaciones
  // (comparecer, registrar) se fechan con él.
  final fixedNow = DateTime.utc(2026, 10, 16, 10, 30);
  const citizenId = DemoSession.idAgente;
  const documentNumber = DemoSession.personIdentifier;

  late DemoGestionState state;
  late Dio dio;

  setUp(() {
    state = DemoGestionState(now: () => fixedNow);
    dio = Dio(BaseOptions(baseUrl: 'https://demo.invalid'))
      ..httpClientAdapter = DemoHttpClientAdapter(
        DemoBackend(routes: demoGestionRoutes(state), now: () => fixedNow),
        latency: Duration.zero,
      );
  });

  group('expedientes', () {
    test('el listado llega mapeado por el repositorio real con al menos tres expedientes completos', () async {
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      final expedientes = await repository.loadExpedientes(citizenId: citizenId, documentNumber: documentNumber);

      expect(expedientes.length, greaterThanOrEqualTo(3));
      for (final expediente in expedientes) {
        expect(expediente.numexp, isNotEmpty);
        expect(expediente.titulo, isNotEmpty);
        expect(expediente.consejeria, isNotEmpty);
        expect(expediente.fechaInicio, isNotNull);
        expect(expediente.estado, isNotNull);
      }
    });

    test('el detalle de cada expediente trae los datos de aportación y al menos uno admite adjuntar', () async {
      final repository = GestionExpedienteRepositoryImpl(dio: dio);
      final expedientes = await repository.loadExpedientes(citizenId: citizenId, documentNumber: documentNumber);

      final detalles = <Expediente>[];
      for (final expediente in expedientes) {
        detalles.add(await repository.loadExpedienteDetail(citizenId: citizenId, documentNumber: documentNumber, numexp: expediente.numexp));
      }

      expect(detalles.map((final detalle) => detalle.numexp), expedientes.map((final expediente) => expediente.numexp));
      expect(detalles.where((final detalle) => detalle.canAttachDocuments), isNotEmpty);
      // También hay uno cerrado que no admite aportar: el botón no sale siempre.
      expect(detalles.where((final detalle) => !detalle.canAttachDocuments), isNotEmpty);
      for (final detalle in detalles) {
        expect(detalle.tipoproc, isNotNull);
        expect(detalle.datosAportacion?.registro, isNotNull);
        expect(detalle.datosAportacion?.fechareg, isNotNull);
        expect(detalle.datosAportacion?.numdoc, documentNumber);
      }
    });

    test('un expediente desconocido responde «no hay publicaciones», que el repositorio traduce a StateError', () async {
      // Es el "no encontrado" de negocio que la búsqueda de terceros ya trata.
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadExpedienteDetail(citizenId: citizenId, documentNumber: documentNumber, numexp: 'XXXX/2026/999999'),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('registros', () {
    test('entrada y salida llegan con número, asunto, fecha y consejería', () async {
      final repository = GestionRegistrosRepositoryImpl(dio: dio);

      final entradas = await repository.loadEntradas(citizenId: citizenId, documentNumber: documentNumber);
      final salidas = await repository.loadSalidas(citizenId: citizenId, documentNumber: documentNumber);

      expect(entradas.length, greaterThanOrEqualTo(3));
      expect(salidas.length, greaterThanOrEqualTo(2));
      for (final registro in entradas.followedBy(salidas)) {
        expect(registro.numregistro, isNotEmpty);
        expect(registro.titulo, isNotEmpty);
        expect(registro.fecha, isNotNull);
        expect(registro.consejeria, isNotNull);
      }
    });

    test('el detalle de un registro de entrada localiza el expediente que abrió', () async {
      final registros = GestionRegistrosRepositoryImpl(dio: dio);
      final expedientes = GestionExpedienteRepositoryImpl(dio: dio);
      final entradas = await registros.loadEntradas(citizenId: citizenId, documentNumber: documentNumber);

      final expediente = await expedientes.loadExpedienteByRegistro(citizenId: citizenId, documentNumber: documentNumber, numRegistro: entradas.first.numregistro);

      expect(expediente.numexp, isNotEmpty);
      expect(expediente.datosAportacion?.registro, entradas.first.numregistro);
    });

    test('un registro desconocido también se traduce a StateError', () async {
      final repository = GestionExpedienteRepositoryImpl(dio: dio);

      await expectLater(
        repository.loadExpedienteByRegistro(citizenId: citizenId, documentNumber: documentNumber, numRegistro: 'DEMO/2026/9999'),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('notificaciones', () {
    test('cada estado devuelve sus notificaciones etiquetadas con el estado consultado', () async {
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);

      final porEstado = {
        for (final estado in NotificacionEstado.values) estado: await repository.loadNotificaciones(citizenId: citizenId, estado: estado),
      };

      expect(porEstado[NotificacionEstado.pendiente], hasLength(greaterThanOrEqualTo(2)));
      expect(porEstado[NotificacionEstado.aceptada], isNotEmpty);
      expect(porEstado[NotificacionEstado.rechazada], isNotEmpty);
      expect(porEstado[NotificacionEstado.expirada], isNotEmpty);
      for (final entry in porEstado.entries) {
        for (final notificacion in entry.value) {
          expect(notificacion.estado, entry.key);
          expect(notificacion.concepto, isNotEmpty);
          expect(notificacion.procedimientoDenominacion, isNotEmpty);
          expect(notificacion.fechaCaducidad, isNotNull);
          expect(notificacion.unidadOrganicaNombre, isNotNull);
        }
      }
      // Las pendientes caducan después del "ahora" de la demo: la tarjeta
      // las pinta con plazo abierto.
      for (final pendiente in porEstado[NotificacionEstado.pendiente]!) {
        expect(pendiente.fechaCaducidad!.isAfter(fixedNow), isTrue);
      }
    });

    test('"Todo" fusiona los cuatro barridos sin duplicar y con las pendientes primero', () async {
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);
      var esperadas = 0;
      for (final estado in NotificacionEstado.values) {
        esperadas += (await repository.loadNotificaciones(citizenId: citizenId, estado: estado)).length;
      }

      final todas = await repository.loadNotificaciones(citizenId: citizenId);

      expect(todas, hasLength(esperadas));
      expect(todas.map((final notificacion) => notificacion.id).toSet(), hasLength(esperadas));
      final pendientes = todas.takeWhile((final notificacion) => notificacion.estado == NotificacionEstado.pendiente).length;
      expect(pendientes, greaterThanOrEqualTo(2));
      expect(todas.skip(pendientes).any((final notificacion) => notificacion.estado == NotificacionEstado.pendiente), isFalse);
    });

    test('el detalle de una pendiente trae organismo, procedimiento, expediente, fechas y documentos', () async {
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);
      final pendiente = (await repository.loadNotificaciones(citizenId: citizenId, estado: NotificacionEstado.pendiente)).first;

      final detalle = await repository.loadNotificacion(citizenId: citizenId, notificacionId: pendiente.id, resumen: pendiente);

      expect(detalle.id, pendiente.id);
      expect(detalle.estado, NotificacionEstado.pendiente);
      expect(detalle.titulo, pendiente.concepto);
      expect(detalle.organismo, isNotNull);
      expect(detalle.procedimiento, isNotNull);
      expect(detalle.expediente, isNotNull);
      expect(detalle.fechaPuestaDisposicion, isNotNull);
      expect(detalle.fechaExpiracion, pendiente.fechaCaducidad);
      expect(detalle.fechaLectura, isNull);
      expect(detalle.documentos, isNotEmpty);
      expect(detalle.documentos.first.nombre, endsWith('.pdf'));
    });

    test('comparecer pasa la notificación a aceptada, la fecha con el reloj del backend y la mueve de pestaña', () async {
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);
      final pendiente = (await repository.loadNotificaciones(citizenId: citizenId, estado: NotificacionEstado.pendiente)).first;
      final aceptadasAntes = await repository.loadNotificaciones(citizenId: citizenId, estado: NotificacionEstado.aceptada);

      await repository.transitionNotificacion(citizenId: citizenId, notificacionId: pendiente.id, accion: 'ACEPTAR', sistemaOrigen: pendiente.sistemaOrigen);

      // El detalle se pide SIN resumen: el estado tiene que venir del backend
      // demo, no del respaldo del listado.
      final detalle = await repository.loadNotificacion(citizenId: citizenId, notificacionId: pendiente.id);
      expect(detalle.estado, NotificacionEstado.aceptada);
      expect(detalle.fechaLectura, fixedNow);
      final pendientes = await repository.loadNotificaciones(citizenId: citizenId, estado: NotificacionEstado.pendiente);
      final aceptadas = await repository.loadNotificaciones(citizenId: citizenId, estado: NotificacionEstado.aceptada);
      expect(pendientes.map((final notificacion) => notificacion.id), isNot(contains(pendiente.id)));
      expect(aceptadas.map((final notificacion) => notificacion.id), contains(pendiente.id));
      expect(aceptadas, hasLength(aceptadasAntes.length + 1));
    });

    test('comparecer dos veces la misma notificación es rechazado por el backend demo', () async {
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);
      final pendiente = (await repository.loadNotificaciones(citizenId: citizenId, estado: NotificacionEstado.pendiente)).first;
      await repository.transitionNotificacion(citizenId: citizenId, notificacionId: pendiente.id, accion: 'COMPARECER');

      await expectLater(
        repository.transitionNotificacion(citizenId: citizenId, notificacionId: pendiente.id, accion: 'COMPARECER'),
        throwsA(isA<DioException>().having((final error) => error.response?.statusCode, 'statusCode', 400)),
      );
    });

    test('documento y justificante llegan como PDF con nombre de fichero', () async {
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);
      final aceptada = (await repository.loadNotificaciones(citizenId: citizenId, estado: NotificacionEstado.aceptada)).first;
      final detalle = await repository.loadNotificacion(citizenId: citizenId, notificacionId: aceptada.id, resumen: aceptada);

      final documento = await repository.downloadDocumento(citizenId: citizenId, notificacionId: aceptada.id, orden: detalle.documentos.first.orden, sistemaOrigen: aceptada.sistemaOrigen);
      final justificante = await repository.downloadJustificante(citizenId: citizenId, notificacionId: aceptada.id, sistemaOrigen: aceptada.sistemaOrigen);

      expect(_esPdf(documento.bytes), isTrue);
      expect(documento.nombreFichero, detalle.documentos.first.nombre);
      expect(_esPdf(justificante.bytes), isTrue);
      expect(justificante.nombreFichero, endsWith('.pdf'));
    });

    test('un documento que no existe responde 404', () async {
      final repository = GestionNotificacionesRepositoryImpl(dio: dio);
      final aceptada = (await repository.loadNotificaciones(citizenId: citizenId, estado: NotificacionEstado.aceptada)).first;

      await expectLater(
        repository.downloadDocumento(citizenId: citizenId, notificacionId: aceptada.id, orden: 99),
        throwsA(isA<DioException>().having((final error) => error.response?.statusCode, 'statusCode', 404)),
      );
    });
  });

  group('aportar documentación', () {
    test('iniciar, subir y registrar devuelven el justificante y dejan un registro de entrada nuevo en cabeza', () async {
      final expedientes = GestionExpedienteRepositoryImpl(dio: dio);
      final registros = GestionRegistrosRepositoryImpl(dio: dio);
      final documentos = GestionDocumentoRepositoryImpl(dio: dio);
      final listado = await expedientes.loadExpedientes(citizenId: citizenId, documentNumber: documentNumber);
      final entradasAntes = await registros.loadEntradas(citizenId: citizenId, documentNumber: documentNumber);
      // El flujo real parte del detalle: es el que trae `adjuntar` y los datos
      // en bruto que viajan en `inicproc`/`registrarfichero`.
      final expediente = await expedientes.loadExpedienteDetail(citizenId: citizenId, documentNumber: documentNumber, numexp: listado.first.numexp);
      expect(expediente.canAttachDocuments, isTrue);
      final bytes = Uint8List.fromList(utf8.encode('certificado de empadronamiento ficticio'));
      const nombreFichero = 'certificado_empadronamiento.pdf';

      final inicio = await documentos.iniciarProcedimiento(citizenId: citizenId, idUnico: '${documentNumber}_1700000000000', documentNumber: documentNumber, expediente: expediente);
      final hash = await documentos.subirDocumentoSinFirma(citizenId: citizenId, documentNumber: documentNumber, idUnico: inicio.idunico, tipoProcedimiento: expediente.tipoproc ?? '', nombreFichero: nombreFichero, bytes: bytes);
      final justificante = await documentos.registrarFicheros(
        citizenId: citizenId,
        documentNumber: documentNumber,
        expediente: expediente,
        inicio: inicio,
        documentos: [(nombre: nombreFichero, hash: hash, tamanioBytes: bytes.length)],
      );

      expect(inicio.estado, 'OK');
      expect(inicio.idunico, '${documentNumber}_1700000000000');
      expect(inicio.numdoc, documentNumber);
      expect(inicio.uniorg, isNotEmpty);
      // El hash es el SHA-256 real del fichero, en hexadecimal mayúsculas.
      expect(hash, sha256.convert(bytes).toString().toUpperCase());
      expect(_esPdf(justificante), isTrue);

      final entradas = await registros.loadEntradas(citizenId: citizenId, documentNumber: documentNumber);
      expect(entradas, hasLength(entradasAntes.length + 1));
      expect(entradas.first.titulo, 'Aportación de documentación (1 fichero)');
      expect(entradas.first.numregistro, matches(RegExp(r'^DEMO/\d{4}/\d{4}$')));
      expect(entradas.first.numregistro, isNot(isIn(entradasAntes.map((final registro) => registro.numregistro))));
      expect(entradas.first.fecha, '2026-10-16');
      expect(entradas.first.consejeria, expediente.consejeria);
      // El registro nuevo localiza el expediente al que se aportó.
      final localizado = await expedientes.loadExpedienteByRegistro(citizenId: citizenId, documentNumber: documentNumber, numRegistro: entradas.first.numregistro);
      expect(localizado.numexp, expediente.numexp);
      // Y el estado recuerda qué se subió a esa transacción.
      final aportacion = state.aportaciones[inicio.idunico];
      expect(aportacion?.numexp, expediente.numexp);
      expect(aportacion?.ficheros, [(nombre: nombreFichero, hash: hash)]);
      expect(aportacion?.registro, entradas.first.numregistro);
    });

    test('iniciar sobre un expediente desconocido falla como un KO del tramitador', () async {
      final documentos = GestionDocumentoRepositoryImpl(dio: dio);
      final expedientes = GestionExpedienteRepositoryImpl(dio: dio);
      final expediente = (await expedientes.loadExpedientes(citizenId: citizenId, documentNumber: documentNumber)).first.copyWith(numexp: 'XXXX/2026/999999');

      await expectLater(
        documentos.iniciarProcedimiento(citizenId: citizenId, idUnico: '${documentNumber}_1700000000001', documentNumber: documentNumber, expediente: expediente),
        throwsA(isA<StateError>()),
      );
    });
  });
}

/// Los binarios demo son un PDF válido: basta con la cabecera para saber que
/// llegó entero y sin pasar por el decodificador JSON.
bool _esPdf(final Uint8List bytes) => bytes.length > 4 && utf8.decode(bytes.sublist(0, 4)) == '%PDF';
