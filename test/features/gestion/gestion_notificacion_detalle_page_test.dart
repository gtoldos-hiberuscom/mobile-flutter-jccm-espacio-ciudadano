import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_notificacion_detalle_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _acceptLabel = 'Aceptar notificación';
// `AppTag` pinta la etiqueta en mayúsculas (spec de Figma).
const _pendingTag = 'PENDIENTE';
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
    // El repositorio recibe `fallbackEstado` y es quien distingue "el detalle
    // no informa estado" de "informa uno que no sabemos leer". La página
    // repetía el respaldo con `?? widget.estado`, y eso resucitaba la acción
    // en el segundo caso — el estado que llega aquí ya es la decisión tomada.
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
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionNotificacionDetallePage(notificacionId: 7924, estado: NotificacionEstado.pendiente),
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
        GoRoute(path: '/', builder: (final _, final _) => const Scaffold(body: SizedBox.shrink())),
        GoRoute(path: '/detalle', builder: (final _, final _) => const GestionNotificacionDetallePage(notificacionId: 7924, estado: null)),
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
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    unawaited(router.push('/detalle'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(tester.element(find.byType(GestionNotificacionDetallePage)));
    await tester.tap(find.text(_acceptLabel));
    await tester.pump();

    // Con la transición en vuelo, el detalle cae y se invalida.
    detailFails = true;
    container.invalidate(gestionNotificacionDetalleProvider);
    transition.complete();
    await tester.pumpAndSettle();

    expect(find.text('Has aceptado la notificación.'), findsOneWidget);
    expect(find.text('No hemos podido aceptar la notificación. Inténtalo de nuevo.'), findsNothing);

    // Deja expirar el snackbar para no terminar con timers pendientes.
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}

final class _FakeNotificacionesRepository implements GestionNotificacionesRepository {
  _FakeNotificacionesRepository({required this.onTransition});

  final Future<void> Function() onTransition;

  @override
  Future<void> transitionNotificacion({
    required final String citizenId,
    required final int notificacionId,
    required final String accion,
    final String? sistemaOrigen,
    final String? justificacion,
  }) => onTransition();

  @override
  dynamic noSuchMethod(final Invocation invocation) => throw UnimplementedError('$invocation');
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GestionNotificacionDetallePage(notificacionId: 7924, estado: resumenEstado),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
