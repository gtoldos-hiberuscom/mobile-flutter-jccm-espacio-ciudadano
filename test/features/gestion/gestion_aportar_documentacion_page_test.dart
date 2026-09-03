import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/representante.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_documento_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_aportar_documentacion_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_documento_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/tercero_identificacion.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _registrarLabel = 'Registrar documentos aportados';

/// El botón "Registrar" de la barra inferior, localizado por tipo: mientras la
/// operación está en curso `AppButton` sustituye el label por el spinner, así
/// que `find.text` no sirve para un segundo tap.
final Finder _registrarButton = find.byType(AppButton).last;

/// Bombea con espera real (dentro de `runAsync` los timers son de verdad)
/// hasta que se cumple [condicion].
///
/// Siempre da al menos una vuelta: la condición puede cumplirse ya durante el
/// `tap` (que bombea por dentro) y hace falta el frame para ver el árbol
/// repintado.
Future<void> pumpHasta(final WidgetTester tester, final bool Function() condicion, {final int vueltas = 60}) async {
  for (var i = 0; i < vueltas; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    await tester.pump();
    if (condicion()) {
      return;
    }
  }
}

/// Pulsa "Registrar" y deja correr el flujo completo.
///
/// Va dentro de `runAsync` porque la subida lee el fichero de disco: con el
/// reloj falso de `testWidgets` esa E/S real no completa nunca. Y los pumps
/// son acotados en vez de `pumpAndSettle` porque mientras se sube hay
/// indicadores de progreso animados, que no dejan quieto el árbol.
Future<void> tapRegistrar(final WidgetTester tester) async {
  await tester.runAsync(() async {
    await tester.tap(find.text(_registrarLabel));
    for (var i = 0; i < 30; i++) {
      // Espera real (dentro de `runAsync` los timers son de verdad) para que
      // la lectura del fichero y el resto de la cadena async progresen.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await tester.pump();
    }
  });
  // Un frame más ya con reloj falso para que entre el snackbar.
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  late Directory tempDir;

  // E/S síncrona a propósito: `testWidgets` corre con reloj falso y una
  // escritura asíncrona no completaría nunca fuera de `runAsync`.
  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('aportacion_test');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  AportacionArchivo file(final String nombre) {
    final created = File('${tempDir.path}/$nombre')..writeAsBytesSync(List.filled(64, 7));
    return AportacionArchivo(path: created.path, nombre: nombre, tamanioBytes: 64);
  }

  Future<ProviderContainer> pumpPage(final WidgetTester tester, final _FakeDocumentoRepository repository) async {
    final container = ProviderContainer(
      overrides: [
        citizenEndpointIdsProvider.overrideWithValue((numDocumento: 'PER9998003', idAgente: 'PER9998003')),
        gestionDocumentoRepositoryProvider.overrideWithValue(repository),
        expedienteDetailProvider.overrideWith(
          (final ref, final key) async => Expediente(numexp: key.numexp, titulo: 'Expediente de prueba', consejeria: 'JCCM', tipoproc: '020'),
        ),
      ],
    );
    addTearDown(container.dispose);
    repository.notifier = container.read(gestionAportarDocumentacionProvider.notifier);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionAportarDocumentacionPage(
            numexp: 'EXP-1',
            // Evita depender del JWT: el documento del titular sale de aquí.
            tercero: TerceroIdentificacion(tipodoc: 'NIF', documentNumber: '99999999R'),
          ),
        ),
      ),
    );
    return container;
  }

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'cancelar un fichero a mitad de subida no registra la aportación ni tira los ya subidos', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final repository = _FakeDocumentoRepository(cancelPath: segundo.path);
    final container = await pumpPage(tester, repository);

    container.read(gestionAportarDocumentacionProvider.notifier).addArchivos([primero, segundo]);
    await tester.pump();

    await tapRegistrar(tester);

    // El fichero cancelado se queda sin hash: registrar en ese estado
    // reventaba con un TypeError sobre `hash!`, que el catch convertía en
    // "no hemos podido finalizar" y marcaba como erróneos incluso los
    // ficheros ya subidos.
    expect(repository.registrarCalls, 0);
    expect(find.text('Falta algún fichero por enviar. Al registrar de nuevo se enviarán todos otra vez.'), findsOneWidget);

    final archivos = container.read(gestionAportarDocumentacionProvider);
    expect(archivos.map((final a) => a.estado), everyElement(AportacionArchivoEstado.noEnviado));
    expect(archivos.map((final a) => a.hash), everyElement(isNull));
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'registra la aportación cuando todos los ficheros se suben', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final repository = _FakeDocumentoRepository();
    final container = await pumpPage(tester, repository);

    container.read(gestionAportarDocumentacionProvider.notifier).addArchivos([primero, segundo]);
    await tester.pump();

    await tapRegistrar(tester);

    expect(repository.registrarCalls, 1);
    expect(repository.registrados.map((final d) => d.hash), ['hash-primero.pdf', 'hash-segundo.pdf']);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'un fichero que falla al subir tampoco registra y deja todo listo para reintentar', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final repository = _FakeDocumentoRepository(failPath: segundo.path);
    final container = await pumpPage(tester, repository);

    container.read(gestionAportarDocumentacionProvider.notifier).addArchivos([primero, segundo]);
    await tester.pump();

    await tapRegistrar(tester);

    expect(repository.registrarCalls, 0);
    expect(find.text('Algunos ficheros no se han podido enviar. Puedes reintentarlo.'), findsOneWidget);

    final archivos = container.read(gestionAportarDocumentacionProvider);
    expect(archivos.map((final a) => a.estado), everyElement(AportacionArchivoEstado.noEnviado));
    expect(archivos.map((final a) => a.hash), everyElement(isNull));
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'un segundo tap en Registrar durante inicproc no abre una segunda transacción', (final tester) async {
    final gate = Completer<void>();
    final repository = _FakeDocumentoRepository()..inicioGate = gate;
    final container = await pumpPage(tester, repository);

    container.read(gestionAportarDocumentacionProvider.notifier).addArchivos([file('primero.pdf')]);
    await tester.pump();

    await tester.runAsync(() async {
      await tester.tap(find.text(_registrarLabel));
      await pumpHasta(tester, () => repository.iniciarCalls == 1);

      // La ventana de AP-1: la transacción ya está abierta y todavía no hay
      // ningún fichero `enviando`, que era lo único que apagaba el botón.
      expect(repository.iniciarCalls, 1);
      expect(find.text(_registrarLabel), findsNothing);

      await tester.tap(_registrarButton, warnIfMissed: false);
      await tester.pump();
      gate.complete();
      await pumpHasta(tester, () => repository.registrarCalls == 1);
    });
    await tester.pump(const Duration(milliseconds: 300));

    // Dos `idunico` entrelazados corrompen los hashes: cada uno solo vale
    // dentro del suyo.
    expect(repository.iniciarCalls, 1);
    expect(repository.registrarCalls, 1);
    expect(repository.registrados, hasLength(1));
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'Reintentar durante un intento en curso tampoco abre otra transacción', (final tester) async {
    final repository = _FakeDocumentoRepository(registrarFalla: true);
    final container = await pumpPage(tester, repository);

    container.read(gestionAportarDocumentacionProvider.notifier).addArchivos([file('primero.pdf')]);
    await tester.pump();

    await tapRegistrar(tester);
    expect(repository.iniciarCalls, 1);
    expect(container.read(gestionAportarDocumentacionProvider).single.estado, AportacionArchivoEstado.error);

    // Segundo intento, esta vez retenido en `inicproc` para pulsar Reintentar
    // mientras corre.
    final gate = Completer<void>();
    repository.inicioGate = gate;
    await tester.runAsync(() async {
      await tester.tap(find.text('Reintentar'));
      await pumpHasta(tester, () => repository.iniciarCalls == 2);
      await tester.tap(find.text('Reintentar'), warnIfMissed: false);
      await tester.pump();
      gate.complete();
      await pumpHasta(tester, () => repository.registrarCalls == 2);
    });
    await tester.pump(const Duration(milliseconds: 300));

    expect(repository.iniciarCalls, 2);
  });
}

final class _FakeDocumentoRepository implements GestionDocumentoRepository {
  _FakeDocumentoRepository({this.cancelPath, this.failPath, this.registrarFalla = false});

  /// Fichero cuya subida cancela el ciudadano con la X mientras está en curso.
  final String? cancelPath;

  /// Fichero cuya subida falla por un error de red.
  final String? failPath;

  /// `registrarfichero` falla y deja las tarjetas en error, que es como se
  /// llega al "Reintentar" de una tarjeta.
  final bool registrarFalla;

  /// Retiene `inicproc` para poder pulsar durante la ventana en la que todavía
  /// no hay ningún fichero `enviando` — la ventana real de AP-1.
  Completer<void>? inicioGate;

  late GestionAportarDocumentacionNotifier notifier;
  int iniciarCalls = 0;
  int registrarCalls = 0;
  List<({String nombre, String hash, int tamanioBytes})> registrados = const [];

  @override
  Future<InicioProcedimientoResultado> iniciarProcedimiento({
    required final String citizenId,
    required final String idUnico,
    required final String documentNumber,
    required final Expediente expediente,
    final Representante? representante,
  }) async {
    iniciarCalls++;
    await inicioGate?.future;
    return InicioProcedimientoResultado(
      idunico: idUnico,
      estado: 'OK',
      asuid: 'ASU-1',
      descrip: 'descripcion',
      uniorg: 'UNI-1',
      numdoc: documentNumber,
      nombre: 'Nombre',
      apellido1: 'Apellido1',
      apellido2: 'Apellido2',
    );
  }

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
    final path = '$idUnico/$nombreFichero';
    if (failPath != null && failPath!.endsWith(nombreFichero)) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.connectionError,
      );
    }
    if (cancelPath != null && cancelPath!.endsWith(nombreFichero)) {
      // Lo que hace la X de la tarjeta: cancela el token, lo que aborta la
      // petición y devuelve el fichero a `noEnviado`.
      notifier.cancelarSubida(cancelPath!);
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.cancel,
      );
    }
    return 'hash-$nombreFichero';
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
    registrarCalls++;
    registrados = documentos;
    if (registrarFalla) {
      throw DioException(
        requestOptions: RequestOptions(path: 'registrarfichero'),
        type: DioExceptionType.connectionError,
      );
    }
    return Uint8List.fromList('%PDF-1.4'.codeUnits);
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}
