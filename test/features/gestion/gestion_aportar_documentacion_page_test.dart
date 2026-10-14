import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/app/app_lifecycle_provider.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';
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

const _registrarLabel = 'Enviar documentos';
const _avisoParcial = 'Algunos ficheros no se han podido enviar. Puedes reintentarlo.';
const _tercero = TerceroIdentificacion(tipodoc: 'NIF', documentNumber: '99999999R');

/// Clave de la familia: la misma con la que la página consulta el detalle.
const ExpedienteDetailKey _key = (numexp: 'EXP-1', tercero: _tercero);

final _provider = gestionAportarDocumentacionProvider(_key);

/// Deja correr el flujo real hasta que se cumple [condicion].
///
/// Va dentro de `runAsync` porque la subida lee el fichero de disco: con el
/// reloj falso de `testWidgets` esa E/S real no completa nunca. Los pumps son
/// acotados en vez de `pumpAndSettle` porque mientras se sube hay indicadores
/// de progreso animados, que no dejan quieto el árbol. El pump final, ya con
/// reloj falso, es el que deja entrar el snackbar.
Future<void> esperar(final WidgetTester tester, final bool Function() condicion, {final int vueltas = 80}) async {
  await tester.runAsync(() async {
    for (var i = 0; i < vueltas; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await tester.pump();
      if (condicion()) {
        return;
      }
    }
  });
  await tester.pump(const Duration(milliseconds: 300));
}

/// Deja pasar el «Completado» de una tarjeta recién subida.
///
/// En tiempo real: el temporizador nace en la reconstrucción que dispara
/// [esperar], dentro de `runAsync`, así que el reloj falso no lo mueve.
Future<void> esperarFinCompletado(final WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(aportacionDuracionCompletado + const Duration(milliseconds: 50)));
  await tester.pump();
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

  /// Conectividad del sistema, controlada por el test. Sin override el
  /// provider real falla por falta de plugin y Riverpod agenda un reintento
  /// que queda como timer pendiente.
  late StreamController<List<ConnectivityResult>> conectividad;

  /// Vuelta de segundo plano, controlada por el test.
  late StreamController<void> vueltaDeSegundoPlano;

  Future<ProviderContainer> pumpPage(final WidgetTester tester, final _FakeDocumentoRepository repository, {final Duration? plazoSinProgreso}) async {
    conectividad = StreamController<List<ConnectivityResult>>.broadcast();
    addTearDown(conectividad.close);
    vueltaDeSegundoPlano = StreamController<void>.broadcast();
    addTearDown(vueltaDeSegundoPlano.close);
    final container = ProviderContainer(
      overrides: [
        connectivityRawStreamProvider.overrideWith((final ref) => conectividad.stream),
        appResumedFromBackgroundProvider.overrideWithValue(vueltaDeSegundoPlano.stream),
        if (plazoSinProgreso != null) plazoSinProgresoSubidaProvider.overrideWithValue(plazoSinProgreso),
        citizenEndpointIdsProvider.overrideWithValue((numDocumento: 'PER9998003', idAgente: 'PER9998003')),
        gestionDocumentoRepositoryProvider.overrideWithValue(repository),
        expedienteDetailProvider.overrideWith(
          (final ref, final key) async => Expediente(numexp: key.numexp, titulo: 'Expediente de prueba', consejeria: 'JCCM', tipoproc: '020'),
        ),
      ],
    );
    addTearDown(container.dispose);
    repository.notifier = container.read(_provider.notifier);

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
            tercero: _tercero,
          ),
        ),
      ),
    );
    return container;
  }

  /// El botón "Registrar" está pintado y pulsable.
  bool registrarHabilitado(final WidgetTester tester) => tester.widget<AppButton>(find.widgetWithText(AppButton, _registrarLabel)).onPressed != null;

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'seleccionar arranca la subida sin pulsar Registrar', (final tester) async {
    final repository = _FakeDocumentoRepository();
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([file('primero.pdf'), file('segundo.pdf')]);
    await esperar(tester, () => repository.subidas.length == 2);

    // C-37: en la web la carga empieza al seleccionar, no al registrar.
    expect(repository.iniciarCalls, 1);
    expect(repository.subidas, ['primero.pdf', 'segundo.pdf']);
    expect(repository.registrarCalls, 0);

    final lote = container.read(_provider);
    expect(lote.archivos.map((final a) => a.estado), everyElement(AportacionArchivoEstado.completado));
    expect(lote.todosSubidos, isTrue);
    expect(registrarHabilitado(tester), isTrue);
  });

  testWidgets('el botón de registrar no aparece hasta que hay documentos', (final tester) async {
    final container = await pumpPage(tester, _FakeDocumentoRepository());

    // C-36. Como en la web: sin documentos solo se ofrece seleccionarlos.
    expect(find.text(_registrarLabel), findsNothing);
    expect(find.text('Seleccionar documentos'), findsOneWidget);

    container.read(_provider.notifier).addArchivos([file('primero.pdf')]);
    // Con duración: deja correr también lo que Riverpod agenda al leer el
    // provider `autoDispose`, que si no queda como timer pendiente.
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(_registrarLabel), findsOneWidget);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'registra la aportación con los ficheros subidos', (final tester) async {
    final repository = _FakeDocumentoRepository();
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([file('primero.pdf'), file('segundo.pdf')]);
    await esperar(tester, () => container.read(_provider).todosSubidos);

    await tester.tap(find.text(_registrarLabel));
    await esperar(tester, () => repository.registrarCalls == 1);

    expect(repository.registrarCalls, 1);
    expect(repository.registrados.map((final d) => d.hash), ['hash-primero.pdf', 'hash-segundo.pdf']);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'cancelar la subida de un fichero solo retira ese fichero', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final tercero = file('tercero.pdf');
    // Reproduce la X de la tarjeta sobre el fichero que está subiendo.
    final repository = _FakeDocumentoRepository(cancelPath: segundo.path);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero, segundo, tercero]);
    await esperar(tester, () => container.read(_provider).archivos.length == 2 && container.read(_provider).todosSubidos);

    // C-38: cancelaba TODO el lote y remataba con un mensaje de error.
    final lote = container.read(_provider);
    expect(lote.archivos.map((final a) => a.path), [primero.path, tercero.path]);
    expect(lote.archivos.map((final a) => a.estado), everyElement(AportacionArchivoEstado.completado));
    expect(find.text('Algunos ficheros no se han podido enviar. Puedes reintentarlo.'), findsNothing);
    expect(find.text('Falta algún fichero por enviar. Al registrar de nuevo se enviarán todos otra vez.'), findsNothing);
    expect(registrarHabilitado(tester), isTrue);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'un fichero que falla no corta la cola y avisa una sola vez', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final tercero = file('tercero.pdf');
    // El que falla va en medio: antes cortaba el lote y los siguientes no se
    // subían nunca.
    final repository = _FakeDocumentoRepository(failPath: segundo.path);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero, segundo, tercero]);
    await esperar(tester, () => repository.subidas.length == 3);

    expect(repository.subidas, ['primero.pdf', 'segundo.pdf', 'tercero.pdf']);
    final estados = container.read(_provider).archivos.map((final a) => a.estado).toList();
    expect(estados, [AportacionArchivoEstado.completado, AportacionArchivoEstado.error, AportacionArchivoEstado.completado]);
    expect(find.text('Reintentar'), findsOneWidget);
    // Un único aviso al vaciarse la cola, no uno por fichero (JCCMEC-185).
    expect(find.text(_avisoParcial), findsOneWidget);
    // Con la cola parada, "Registrar" se ofrece: reintenta los fallidos.
    expect(registrarHabilitado(tester), isTrue);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'perder la red a mitad de subida la da por fallida y el reintento la completa', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    // La primera subida se cuelga como con el modo avión en iOS: solo termina
    // si alguien cancela su token.
    final repository = _FakeDocumentoRepository(colgarPath: primero.path);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero, segundo]);
    await esperar(tester, () => container.read(_provider).haySubidasEnCurso);

    await tester.runAsync(() async => conectividad.add([ConnectivityResult.none]));
    await esperar(tester, () => !container.read(_provider).haySubidasEnCurso);

    // Ninguna tarjeta congelada en «enviando»: la que subía falla y la que
    // esperaba no se intenta sin red.
    final lote = container.read(_provider);
    expect(lote.archivos.map((final a) => a.estado), everyElement(AportacionArchivoEstado.error));
    expect(repository.subidas, ['primero.pdf']);
    expect(find.text(_avisoParcial), findsOneWidget);
    expect(registrarHabilitado(tester), isTrue);

    // Vuelve la red y se pulsa "Registrar": reintenta los fallidos y cierra.
    // Por el notifier y no con un tap: el snackbar tapa la barra inferior.
    repository.colgarPath = null;
    await tester.runAsync(() async => conectividad.add([ConnectivityResult.wifi]));
    await tester.pump();
    // Sin `await` directo: la transacción se abrió con el reloj falso y sus
    // continuaciones solo corren con pumps, que es lo que hace `esperar`.
    Object? resultado;
    unawaited(container.read(_provider.notifier).registrar().then((final r) => resultado = r));
    await esperar(tester, () => resultado != null);

    expect(resultado, isNotNull);
    expect(repository.subidas, ['primero.pdf', 'primero.pdf', 'segundo.pdf']);
    expect(repository.iniciarCalls, 1);
    expect(repository.registrarCalls, 1);
    expect(repository.registrados.map((final d) => d.hash), ['hash-primero.pdf', 'hash-segundo.pdf']);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'volver de segundo plano con una subida en curso la da por fallida', (final tester) async {
    final primero = file('primero.pdf');
    // Esperando la respuesta del servidor con una conexión que iOS cortó al
    // suspender la app: sin nadie que la aborte no termina nunca.
    final repository = _FakeDocumentoRepository(colgarPath: primero.path);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero]);
    await esperar(tester, () => container.read(_provider).haySubidasEnCurso);

    await tester.runAsync(() async => vueltaDeSegundoPlano.add(null));
    await esperar(tester, () => !container.read(_provider).haySubidasEnCurso);

    expect(container.read(_provider).archivos.single.estado, AportacionArchivoEstado.error);
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.text(_avisoParcial), findsOneWidget);
    expect(registrarHabilitado(tester), isTrue);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'con el cuerpo enviado la barra espera al 90 % y el hash la completa', (final tester) async {
    final primero = file('primero.pdf');
    final repository = _FakeDocumentoRepository(colgarPath: primero.path, progresoAlColgar: 1);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero]);
    await esperar(tester, () => container.read(_provider).archivos.single.progreso == 1);

    // Cuerpo enviado pero sin hash: la barra no se da por terminada.
    expect(tester.widget<AppFileUpload>(find.byType(AppFileUpload)).progress, closeTo(0.9, 1e-9));
    expect(tester.widget<AppFileUpload>(find.byType(AppFileUpload)).status, AppFileUploadStatus.uploading);

    // El fake solo se destraba abortando; al reintentarlo sí llega el hash y
    // la tarjeta pasa a «Completado» (barra completa) y luego a la papelera.
    await tester.runAsync(() async => vueltaDeSegundoPlano.add(null));
    await esperar(tester, () => !container.read(_provider).haySubidasEnCurso);
    repository.colgarPath = null;
    container.read(_provider.notifier).reintentarArchivo(primero.path);
    await esperar(tester, () => container.read(_provider).todosSubidos);

    expect(tester.widget<AppFileUpload>(find.byType(AppFileUpload)).status, AppFileUploadStatus.complete);
    expect(find.text('Completado'), findsOneWidget);
    expect(find.byTooltip('Eliminar archivo'), findsNothing);

    await esperarFinCompletado(tester);

    expect(tester.widget<AppFileUpload>(find.byType(AppFileUpload)).status, AppFileUploadStatus.uploaded);
    expect(find.text('Completado'), findsNothing);
    expect(find.byTooltip('Eliminar archivo'), findsOneWidget);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'un fichero en cola se pinta cargando, sin papelera, y se puede cancelar', (final tester) async {
    // JCCMEC-245: el que esperaba turno salía con la papelera, como si ya
    // estuviera subido, antes de pasar a cargando.
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final repository = _FakeDocumentoRepository(colgarPath: primero.path);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero, segundo]);
    await esperar(tester, () => container.read(_provider).haySubidasEnCurso);

    final tarjetas = tester.widgetList<AppFileUpload>(find.byType(AppFileUpload)).toList();
    expect(tarjetas.map((final t) => t.status), [AppFileUploadStatus.uploading, AppFileUploadStatus.pending]);
    expect(find.byTooltip('Eliminar archivo'), findsNothing);
    // La página tiene su propio «Cancelar»: solo cuentan los de las tarjetas.
    final cancelarEnTarjeta = find.descendant(of: find.byType(AppFileUpload), matching: find.widgetWithText(TextButton, 'Cancelar'));
    expect(cancelarEnTarjeta, findsNWidgets(2));

    await tester.tap(cancelarEnTarjeta.last);
    await tester.pump(const Duration(milliseconds: 300));

    expect(container.read(_provider).archivos.map((final a) => a.path), [primero.path]);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'una subida sin progreso se aborta y deja reintentar', (final tester) async {
    final primero = file('primero.pdf');
    // Red perdida sin evento del sistema (cobertura débil): nadie avisa, solo
    // deja de avanzar.
    final repository = _FakeDocumentoRepository(colgarPath: primero.path);
    final container = await pumpPage(tester, repository, plazoSinProgreso: const Duration(milliseconds: 50));

    container.read(_provider.notifier).addArchivos([primero]);
    await esperar(tester, () => container.read(_provider).archivos.single.estado == AportacionArchivoEstado.error);

    expect(container.read(_provider).archivos.single.estado, AportacionArchivoEstado.error);
    expect(find.text(_avisoParcial), findsOneWidget);

    repository.colgarPath = null;
    container.read(_provider.notifier).reintentarArchivo(primero.path);
    await esperar(tester, () => container.read(_provider).todosSubidos);

    expect(container.read(_provider).todosSubidos, isTrue);
    expect(repository.subidas, ['primero.pdf', 'primero.pdf']);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'Reintentar vuelve a subir solo ese fichero', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final repository = _FakeDocumentoRepository(failPath: segundo.path);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero, segundo]);
    await esperar(tester, () => repository.subidas.length == 2);
    expect(container.read(_provider).archivos.last.estado, AportacionArchivoEstado.error);

    repository.failPath = null;
    await tester.tap(find.text('Reintentar'));
    await esperar(tester, () => container.read(_provider).todosSubidos);

    // C-40: reintentar rearrancaba la carga de TODOS los ficheros. Ahora la
    // transacción sigue abierta, así que el hash del hermano sigue valiendo.
    expect(repository.subidas, ['primero.pdf', 'segundo.pdf', 'segundo.pdf']);
    expect(repository.iniciarCalls, 1);
    expect(container.read(_provider).archivos.first.hash, 'hash-primero.pdf');
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'un fichero en error se puede quitar del lote', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final repository = _FakeDocumentoRepository(failPath: segundo.path);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero, segundo]);
    await esperar(tester, () => repository.subidas.length == 2);

    // C-39: antes solo se ofrecía "Reintentar" y el fichero que falla se
    // quedaba clavado en el lote.
    await tester.tap(find.byTooltip('Eliminar archivo'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(container.read(_provider).archivos.map((final a) => a.path), [primero.path]);
    expect(registrarHabilitado(tester), isTrue);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'quitar un fichero ya subido no toca a los demás', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final repository = _FakeDocumentoRepository();
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero, segundo]);
    await esperar(tester, () => container.read(_provider).todosSubidos);
    await esperarFinCompletado(tester);

    await tester.tap(find.byTooltip('Eliminar archivo').first);
    await tester.pump(const Duration(milliseconds: 300));

    // C-41: antes no hacía nada; luego abandonaba el intento entero. Ahora el
    // adjunto solo desaparece de `documentos` y el hermano conserva su hash.
    final lote = container.read(_provider);
    expect(lote.archivos.map((final a) => a.path), [segundo.path]);
    expect(lote.archivos.single.hash, 'hash-segundo.pdf');
    expect(lote.archivos.single.estado, AportacionArchivoEstado.completado);
    expect(registrarHabilitado(tester), isTrue);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'dos selecciones seguidas abren una sola transacción', (final tester) async {
    final gate = Completer<void>();
    final repository = _FakeDocumentoRepository()..inicioGate = gate;
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([file('primero.pdf')]);
    await esperar(tester, () => repository.iniciarCalls == 1, vueltas: 20);

    // Segunda selección con la apertura todavía en vuelo: dos `idunico`
    // entrelazados corromperían los hashes, porque cada uno solo vale dentro
    // del suyo (AP-1).
    container.read(_provider.notifier).addArchivos([file('segundo.pdf')]);
    gate.complete();
    await esperar(tester, () => container.read(_provider).todosSubidos);

    expect(repository.iniciarCalls, 1);
    expect(repository.subidas, ['primero.pdf', 'segundo.pdf']);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'un cierre fallido conserva los hashes y reintenta solo el cierre', (final tester) async {
    final repository = _FakeDocumentoRepository(registrarFalla: true);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([file('primero.pdf')]);
    await esperar(tester, () => container.read(_provider).todosSubidos);

    await tester.tap(find.text(_registrarLabel));
    await esperar(tester, () => repository.registrarCalls == 1);

    expect(find.text('Los documentos se han subido pero no se ha podido finalizar el registro. Puedes reintentarlo.'), findsOneWidget);
    // La transacción sigue abierta: el hash no ha muerto.
    expect(container.read(_provider).archivos.single.hash, 'hash-primero.pdf');
    expect(registrarHabilitado(tester), isTrue);

    // El reintento se dispara por el mismo camino que el botón —que ya se ha
    // comprobado habilitado— en vez de con un segundo tap: el snackbar tapa la
    // barra inferior y su plazo de 5 s nació dentro de `runAsync`, así que es
    // un timer real que el reloj falso no vence y el tap no llegaría al botón.
    repository.registrarFalla = false;
    await container.read(_provider.notifier).registrar();
    await tester.pump(const Duration(milliseconds: 300));

    // Se reintenta solo el cierre: no se vuelve a subir nada.
    expect(repository.registrarCalls, 2);
    expect(repository.subidas, ['primero.pdf']);
    expect(repository.iniciarCalls, 1);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'un fallo al abrir la transacción avisa y deja los ficheros para reintentar', (final tester) async {
    final repository = _FakeDocumentoRepository(iniciarFalla: true);
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([file('primero.pdf')]);
    await esperar(tester, () => repository.iniciarCalls == 1);

    // Ninguna tarjeta explica este fallo por sí sola, así que sí lleva aviso.
    expect(find.text('No hemos podido registrar la documentación. Inténtalo de nuevo.'), findsOneWidget);
    // En error y no «Seleccionado»: esa tarjeta no ofrece "Reintentar" y el
    // lote se quedaba sin salida (JCCMEC-185).
    expect(container.read(_provider).archivos.single.estado, AportacionArchivoEstado.error);
    expect(find.text('Reintentar'), findsOneWidget);
    expect(registrarHabilitado(tester), isTrue);
    expect(repository.subidas, isEmpty);

    repository.iniciarFalla = false;
    container.read(_provider.notifier).reintentarArchivo(container.read(_provider).archivos.single.path);
    await esperar(tester, () => container.read(_provider).todosSubidos);

    expect(repository.iniciarCalls, 2);
    expect(repository.subidas, ['primero.pdf']);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'borrar un fichero de la cola mientras sube otro no lo sube al buzón', (final tester) async {
    final primero = file('primero.pdf');
    final segundo = file('segundo.pdf');
    final tercero = file('tercero.pdf');
    late final ProviderContainer container;
    final repository = _FakeDocumentoRepository(
      onUpload: (final nombre) async {
        if (nombre == 'primero.pdf') {
          container.read(_provider.notifier).removeArchivo(tercero.path);
        }
      },
    );
    container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([primero, segundo, tercero]);
    await esperar(tester, () => container.read(_provider).todosSubidos);

    // La cola relee el estado en cada vuelta: el fichero retirado no llega al
    // buzón aunque estuviera en la foto inicial del lote.
    expect(repository.subidas, ['primero.pdf', 'segundo.pdf']);
    expect(container.read(_provider).archivos.map((final a) => a.path), [primero.path, segundo.path]);
  });

  testWidgets(timeout: const Timeout(Duration(seconds: 60)), 'salir de la pantalla en mitad del lote detiene la cola sin reventar', (final tester) async {
    final gate = Completer<void>();
    final repository = _FakeDocumentoRepository(
      // Ignora el CancelToken a propósito: es el peor caso, con la petición
      // resolviendo después de que la pantalla se haya ido.
      onUpload: (final nombre) async {
        if (nombre == 'primero.pdf') {
          await gate.future;
        }
      },
    );
    final container = await pumpPage(tester, repository);

    container.read(_provider.notifier).addArchivos([file('primero.pdf'), file('segundo.pdf'), file('tercero.pdf')]);

    await tester.runAsync(() async {
      for (var i = 0; i < 40 && repository.subidas.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await tester.pump();
      }

      // Desmonta la página, como al volver al expediente.
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SizedBox.shrink()),
        ),
      );
      gate.complete();
      for (var i = 0; i < 40 && repository.subidas.length < 2; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await tester.pump();
      }
    });
    // Un frame con reloj falso para que corra el dispose que Riverpod agenda
    // al liberar el provider `autoDispose` de la página desmontada.
    await tester.pump(const Duration(milliseconds: 300));

    expect(repository.subidas, ['primero.pdf']);
    expect(repository.registrarCalls, 0);
    // La cola seguía viva y reventaba con el provider `autoDispose` ya liberado.
    expect(tester.takeException(), isNull);
  });
}

final class _FakeDocumentoRepository implements GestionDocumentoRepository {
  _FakeDocumentoRepository({this.cancelPath, this.failPath, this.colgarPath, this.progresoAlColgar = 0.1, this.registrarFalla = false, this.iniciarFalla = false, this.onUpload});

  /// Fichero cuya subida cancela el ciudadano con la X mientras está en curso.
  final String? cancelPath;

  /// Fichero cuya subida falla por un error de red. Mutable para poder
  /// reintentarlo con éxito en el mismo test.
  String? failPath;

  /// Fichero cuya subida no termina nunca salvo que se cancele su token: la
  /// red caída sin que el socket se rompa. Mutable para reintentar con éxito.
  String? colgarPath;

  /// Progreso de envío que se notifica antes de colgarse: `1` reproduce el
  /// cuerpo ya enviado esperando el hash.
  final double progresoAlColgar;

  /// `registrarfichero` falla, que es como se llega al reintento del cierre.
  bool registrarFalla;

  /// `inicproc` falla: no hay transacción en la que subir nada.
  bool iniciarFalla;

  /// Retiene `inicproc` para poder seleccionar otro fichero mientras la
  /// apertura está en vuelo — la ventana real de AP-1.
  Completer<void>? inicioGate;

  /// Se invoca al empezar cada subida, con el nombre del fichero: permite
  /// retirar otro fichero del lote o retener la subida en curso.
  final Future<void> Function(String nombre)? onUpload;

  /// Ficheros que llegaron a subirse al buzón, en orden.
  List<String> subidas = [];

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
    final CancelToken? cancelToken,
  }) async {
    iniciarCalls++;
    await inicioGate?.future;
    if (iniciarFalla) {
      throw DioException(
        requestOptions: RequestOptions(path: 'inicproc'),
        type: DioExceptionType.connectionError,
      );
    }
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
    subidas.add(nombreFichero);
    await onUpload?.call(nombreFichero);
    if (colgarPath != null && colgarPath!.endsWith(nombreFichero)) {
      onProgress?.call(progresoAlColgar);
      await cancelToken!.whenCancel;
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.cancel,
      );
    }
    if (failPath != null && failPath!.endsWith(nombreFichero)) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.connectionError,
      );
    }
    if (cancelPath != null && cancelPath!.endsWith(nombreFichero)) {
      // Lo que hace la X de la tarjeta: retira el fichero del lote, lo que
      // cancela su token y aborta esta petición.
      notifier.removeArchivo(cancelPath!);
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
    final CancelToken? cancelToken,
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
