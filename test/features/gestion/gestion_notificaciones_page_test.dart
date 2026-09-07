import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_notificaciones_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// `_RefRow` pinta la etiqueta en mayúsculas (spec de Figma).
const _procedimientoLabel = 'PROCEDIMIENTO';

void main() {
  testWidgets('la tarjeta muestra el procedimiento con la denominación, que es lo único que informa el gateway', (final tester) async {
    // Payload real de UAT (04/09): `idFicha` llega null en todos los
    // elementos y el dato viaja en `denominacion`. La tarjeta leía solo
    // `idFicha`, así que la fila no se pintaba nunca (C-28/C-31).
    await _pumpList(tester, const [
      Notificacion(
        id: 346307,
        concepto: 'Prueba 7',
        procedimientoDenominacion: 'Procedimiento 7',
        unidadOrganicaNombre: 'UnidadOrganica 7',
        estado: NotificacionEstado.pendiente,
      ),
    ]);

    expect(find.text(_procedimientoLabel), findsOneWidget);
    expect(find.text('Procedimiento 7'), findsOneWidget);
  });

  testWidgets('sin denominación se cae al idFicha, no se apaga la fila', (final tester) async {
    await _pumpList(tester, const [
      Notificacion(
        id: 1,
        concepto: 'Transmisiones patrimoniales',
        procedimientoDenominacion: '   ',
        procedimientoIdFicha: 'JT34',
        estado: NotificacionEstado.aceptada,
      ),
    ]);

    expect(find.text(_procedimientoLabel), findsOneWidget);
    expect(find.text('JT34'), findsOneWidget);
  });

  testWidgets('sin concepto el título ya es la denominación, así que la fila no la repite', (final tester) async {
    await _pumpList(tester, const [
      Notificacion(
        id: 2,
        concepto: '',
        procedimientoDenominacion: 'Ayudas al alquiler',
        estado: NotificacionEstado.aceptada,
      ),
    ]);

    expect(find.text('Ayudas al alquiler'), findsOneWidget);
    expect(find.text(_procedimientoLabel), findsNothing);
  });

  testWidgets('sin procedimiento por ninguna vía la fila no se pinta', (final tester) async {
    await _pumpList(tester, const [
      Notificacion(
        id: 3,
        concepto: 'Requerimiento de subsanación',
        procedimientoDenominacion: '',
        estado: NotificacionEstado.aceptada,
      ),
    ]);

    expect(find.text(_procedimientoLabel), findsNothing);
  });
}

Future<void> _pumpList(final WidgetTester tester, final List<Notificacion> notificaciones) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        gestionNotificacionesProvider.overrideWith((final ref, final estado) async => notificaciones),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GestionNotificacionesPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
