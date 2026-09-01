import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
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

  testWidgets('conserva la acción cuando el detalle no informa estado y el resumen sí', (final tester) async {
    await _pumpDetail(tester, resumenEstado: NotificacionEstado.pendiente, detalleEstado: null);

    expect(find.text(_acceptLabel), findsOneWidget);
  });

  testWidgets('sin estado por ninguna vía no etiqueta la notificación como expirada', (final tester) async {
    await _pumpDetail(tester, resumenEstado: null, detalleEstado: null);

    expect(find.text(_acceptLabel), findsNothing);
    expect(find.text(_expiredTag), findsNothing);
    expect(find.text(_pendingTag), findsNothing);
  });
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
