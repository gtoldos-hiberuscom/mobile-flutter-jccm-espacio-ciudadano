import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_notificacion_detalle_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _acceptLabel = 'Aceptar notificación';
const _dialogTitle = 'Confirmación de aceptación de notificación';
const _confirmLabel = 'Sí, estoy seguro';
const _cancelLabel = 'No';
// `AppTag` pinta la etiqueta en mayúsculas (spec de Figma).
const _pendingTag = 'PENDIENTE';
const _acceptedTag = 'ACEPTADA';
const _expiredTag = 'EXPIRADA';

void main() {
  testWidgets('ofrece comparecer cuando el detalle llega pendiente y el resumen no traía estado', (final tester) async {
    // Es el caso de la pestaña "Todo": el listado indexado no informa el estado.
    await _pumpDetail(tester, resumenEstado: null, detalleEstado: NotificacionEstado.pendiente);

    expect(find.text(_acceptLabel), findsOneWidget);
    expect(find.text(_pendingTag), findsOneWidget);
    expect(find.text(_expiredTag), findsNothing);
  });

  testWidgets('no ofrece comparecer si el detalle dice que ya no está pendiente', (final tester) async {
    await _pumpDetail(tester, resumenEstado: NotificacionEstado.pendiente, detalleEstado: NotificacionEstado.expirada);

    expect(find.text(_acceptLabel), findsNothing);
    expect(find.text(_expiredTag), findsOneWidget);
  });

  testWidgets('el respaldo del resumen lo aplica el repositorio, no la página', (final tester) async {
    // El repositorio recibe el resumen y es quien distingue "el detalle no
    // informa estado" de "informa uno que no sabemos leer". La página repetía
    // el respaldo con `?? widget.estado`, y eso resucitaba la acción en el
    // segundo caso — el estado que llega aquí ya es la decisión tomada.
    await _pumpDetail(tester, resumenEstado: NotificacionEstado.pendiente, detalleEstado: null);

    expect(find.text(_acceptLabel), findsNothing);
  });

  testWidgets('no ofrece comparecer mientras el detalle carga', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Nunca resuelve: es la ventana en la que la acción con efectos
          // jurídicos se ofrecía sin saber todavía el estado.
          gestionNotificacionDetalleProvider.overrideWith((final ref, final args) => Completer<NotificacionDetalle>().future),
        ],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionNotificacionDetallePage(notificacionId: 7924, resumen: _resumen(NotificacionEstado.pendiente)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(_acceptLabel), findsNothing);
  });

  testWidgets('sin estado por ninguna vía no etiqueta la notificación como expirada', (final tester) async {
    await _pumpDetail(tester, resumenEstado: null, detalleEstado: null);

    expect(find.text(_acceptLabel), findsNothing);
    expect(find.text(_expiredTag), findsNothing);
    expect(find.text(_pendingTag), findsNothing);
  });

  testWidgets('un fallo posterior a la transición no se presenta como fallo de la aceptación', (final tester) async {
    // NC-2: la comparecencia se registra en el backend y ACTO SEGUIDO el
    // detalle se invalida y su relectura falla (microcorte, sesión renovándose).
    // Releer el provider dentro de `_accept` convertía ese fallo en «No hemos
    // podido aceptar» sobre una transición YA registrada — y el «inténtalo de
    // nuevo» habría repetido la comparecencia.
    final transition = Completer<void>();
    var detailFails = false;

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (final _, final _) => const Scaffold(body: SizedBox.shrink()),
        ),
        GoRoute(path: '/detalle', builder: (final _, final _) => const GestionNotificacionDetallePage(notificacionId: 7924, resumen: null)),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gestionNotificacionDetalleProvider.overrideWith((final ref, final args) async {
            if (detailFails) {
              throw StateError('detalle caído tras la transición');
            }
            return NotificacionDetalle(id: args.id, titulo: 'Requerimiento de subsanación', estado: NotificacionEstado.pendiente, documentos: const []);
          }),
          gestionNotificacionesTransitionCitizenIdProvider.overrideWithValue('cit-1'),
          gestionNotificacionesRepositoryProvider.overrideWithValue(_FakeNotificacionesRepository(onTransition: () => transition.future)),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    unawaited(router.push('/detalle'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(tester.element(find.byType(GestionNotificacionDetallePage)));
    await tester.tap(find.text(_acceptLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_confirmLabel));
    await tester.pump();

    // Con la transición en vuelo, el detalle cae y se invalida.
    detailFails = true;
    container.invalidate(gestionNotificacionDetalleProvider);
    transition.complete();
    await tester.pumpAndSettle();

    expect(find.text('Has aceptado la notificación.'), findsOneWidget);
    expect(find.text('No hemos podido aceptar la notificación. Inténtalo de nuevo.'), findsNothing);
    // Ya no se vuelve al listado, así que el fallo de la relectura se ve en
    // pantalla: tiene que decir que la aceptación SÍ quedó registrada.
    expect(find.text('Has aceptado la notificación, pero no hemos podido cargar el detalle actualizado.'), findsOneWidget);
    expect(find.text('No hemos podido cargar el detalle de la notificación.'), findsNothing);

    // Deja expirar el snackbar para no terminar con timers pendientes.
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('la CTA pide confirmación antes de comparecer', (final tester) async {
    final repository = _FakeNotificacionesRepository(onTransition: () async {});
    await _pumpAcceptable(tester, repository: repository);

    await tester.tap(find.text(_acceptLabel));
    await tester.pumpAndSettle();

    expect(find.text(_dialogTitle), findsOneWidget);
    expect(find.text('¿Estás seguro que quieres aceptar la notificación?'), findsOneWidget);
    expect(find.text(_confirmLabel), findsOneWidget);
    // La acción es irreversible: abrir el diálogo no puede haberla disparado.
    expect(repository.transitionCalls, 0);
  });

  testWidgets('cancelar la confirmación no comparece y deja la CTA disponible', (final tester) async {
    final repository = _FakeNotificacionesRepository(onTransition: () async {});
    await _pumpAcceptable(tester, repository: repository);

    await tester.tap(find.text(_acceptLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_cancelLabel));
    await tester.pumpAndSettle();

    expect(find.text(_dialogTitle), findsNothing);
    expect(repository.transitionCalls, 0);
    expect(find.text(_acceptLabel), findsOneWidget);
    expect(find.text(_pendingTag), findsOneWidget);
  });

  testWidgets('tras confirmar se queda en el detalle, ya aceptado y con sus documentos', (final tester) async {
    // Paridad con la web: el ciudadano ve la notificación que acaba de aceptar
    // —con los documentos que la comparecencia desbloquea— en vez de que la
    // pantalla se cierre de vuelta al listado.
    var acceptedInBackend = false;
    final repository = _FakeNotificacionesRepository(onTransition: () async {});
    await _pumpAcceptable(
      tester,
      repository: repository,
      detalle: (final args) => NotificacionDetalle(
        id: args.id,
        titulo: 'Requerimiento de subsanación',
        estado: acceptedInBackend ? NotificacionEstado.aceptada : NotificacionEstado.pendiente,
        documentos: acceptedInBackend ? const [NotificacionDocumento(orden: 1, nombre: 'Notificacion.pdf')] : const [],
      ),
    );

    await tester.tap(find.text(_acceptLabel));
    await tester.pumpAndSettle();
    acceptedInBackend = true;
    await tester.tap(find.text(_confirmLabel));
    await tester.pumpAndSettle();

    expect(repository.transitionCalls, 1);
    expect(find.byType(GestionNotificacionDetallePage), findsOneWidget);
    expect(find.text(_acceptedTag), findsOneWidget);
    expect(find.text('Documentos'), findsOneWidget);
    expect(find.text('Notificacion.pdf'), findsOneWidget);
    expect(find.text('Acuse de recibo.pdf'), findsOneWidget);
    expect(find.text(_acceptLabel), findsNothing);

    // Deja expirar el snackbar para no terminar con timers pendientes.
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('tras aceptar, el respaldo del resumen ya no resucita la CTA', (final tester) async {
    // El respaldo lo aplica el repositorio cuando el detalle NO informa estado.
    // Si tras comparecer siguiera siendo el del resumen ("pendiente"), la
    // acción con efectos jurídicos reaparecería sobre algo ya aceptado.
    final seenArgs = <NotificacionDetalleArgs>[];
    final repository = _FakeNotificacionesRepository(onTransition: () async {});
    await _pumpAcceptable(
      tester,
      repository: repository,
      detalle: (final args) {
        seenArgs.add(args);
        // Imita al repositorio: el detalle no informa estado, así que hereda
        // el del resumen.
        return NotificacionDetalle(id: args.id, titulo: 'Requerimiento de subsanación', estado: args.resumen?.estado, documentos: const []);
      },
    );

    await tester.tap(find.text(_acceptLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_confirmLabel));
    await tester.pumpAndSettle();

    expect(seenArgs.last.resumen?.estado, NotificacionEstado.aceptada);
    expect(find.text(_acceptLabel), findsNothing);
    expect(find.text(_acceptedTag), findsOneWidget);
    expect(find.text(_pendingTag), findsNothing);

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('pulsar un documento pide su descarga una sola vez', (final tester) async {
    // C-30: la tarjeta pintaba el nombre subrayado como un enlace y no hacía
    // nada, con `downloadDocumento` ya implementado en el repositorio.
    final descarga = Completer<Uint8List>();
    final repository = _FakeNotificacionesRepository(onDownload: (final _) => descarga.future);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gestionNotificacionDetalleProvider.overrideWith(
            (final ref, final args) async => NotificacionDetalle(
              id: args.id,
              titulo: 'Requerimiento de subsanación',
              estado: NotificacionEstado.aceptada,
              documentos: const [NotificacionDocumento(orden: 1, nombre: 'Notificacion.pdf', tamanoBytes: 125952)],
            ),
          ),
          gestionNotificacionesTransitionCitizenIdProvider.overrideWithValue('cit-1'),
          gestionNotificacionesRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionNotificacionDetallePage(notificacionId: 7924, resumen: _resumen(NotificacionEstado.aceptada)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notificacion.pdf'));
    await tester.pump();
    // Segunda pulsación con la primera descarga en vuelo: no debe encadenar
    // dos selectores nativos.
    await tester.tap(find.text('Notificacion.pdf'), warnIfMissed: false);
    await tester.pump();

    expect(repository.downloads, [1]);

    // No se completa con bytes a propósito: guardar abriría el selector
    // nativo, que en un test es MissingPluginException. Cortando la descarga
    // se ejercita el camino de error, cuyo aviso hay que dejar expirar para no
    // terminar con temporizadores pendientes.
    descarga.completeError(StateError('descarga cortada por el test'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}

final class _FakeNotificacionesRepository implements GestionNotificacionesRepository {
  _FakeNotificacionesRepository({this.onTransition, this.onDownload});

  final Future<void> Function()? onTransition;
  final Future<Uint8List> Function(int orden)? onDownload;

  /// Órdenes por los que se ha pedido una descarga, en orden de llamada.
  final List<int> downloads = [];

  /// Veces que se ha pedido la transición: la confirmación previa se comprueba
  /// por ausencia de llamada, no solo por lo que se ve en pantalla.
  int transitionCalls = 0;

  @override
  Future<void> transitionNotificacion({
    required final String citizenId,
    required final int notificacionId,
    required final String accion,
    final String? sistemaOrigen,
    final String? justificacion,
  }) {
    transitionCalls += 1;
    return onTransition!();
  }

  @override
  Future<NotificacionArchivoDescargado> downloadDocumento({
    required final String citizenId,
    required final int notificacionId,
    required final int orden,
    final String? sistemaOrigen,
  }) {
    downloads.add(orden);
    return onDownload!(orden).then((final bytes) => (bytes: bytes, nombreFichero: null));
  }

  @override
  Future<NotificacionArchivoDescargado> downloadJustificante({
    required final String citizenId,
    required final int notificacionId,
    final String? sistemaOrigen,
  }) => onDownload!(0).then((final bytes) => (bytes: bytes, nombreFichero: null));

  @override
  dynamic noSuchMethod(final Invocation invocation) => throw UnimplementedError('$invocation');
}

/// Resumen del listado con el estado indicado; `null` = no se conocía (deep
/// link o pestaña "Todo" antes de la fusión).
Notificacion? _resumen(final NotificacionEstado? estado) => estado == null
    ? null
    : Notificacion(
        id: 7924,
        concepto: 'Requerimiento de subsanación',
        procedimientoDenominacion: 'Ayudas al alquiler',
        estado: estado,
      );

/// Monta el detalle en estado pendiente, con el repositorio y el ciudadano
/// necesarios para comparecer.
Future<void> _pumpAcceptable(
  final WidgetTester tester, {
  required final _FakeNotificacionesRepository repository,
  final NotificacionDetalle Function(NotificacionDetalleArgs args)? detalle,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        gestionNotificacionDetalleProvider.overrideWith(
          (final ref, final args) async =>
              detalle?.call(args) ??
              NotificacionDetalle(
                id: args.id,
                titulo: 'Requerimiento de subsanación',
                estado: NotificacionEstado.pendiente,
                documentos: const [],
              ),
        ),
        gestionNotificacionesTransitionCitizenIdProvider.overrideWithValue('cit-1'),
        gestionNotificacionesRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GestionNotificacionDetallePage(notificacionId: 7924, resumen: _resumen(NotificacionEstado.pendiente)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpDetail(
  final WidgetTester tester, {
  required final NotificacionEstado? resumenEstado,
  required final NotificacionEstado? detalleEstado,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        gestionNotificacionDetalleProvider.overrideWith(
          (final ref, final args) async => NotificacionDetalle(
            id: args.id,
            titulo: 'Requerimiento de subsanación',
            estado: detalleEstado,
            documentos: const [],
          ),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GestionNotificacionDetallePage(notificacionId: 7924, resumen: _resumen(resumenEstado)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
