import 'dart:ui' show SemanticsAction, SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_notificaciones_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// `_RefRow` pinta la etiqueta en mayúsculas (spec de Figma).
const _procedimientoLabel = 'PROCEDIMIENTO';

void main() {
  testWidgets('los cambios de pestaña filtran en memoria sin hacer nuevas peticiones', (final tester) async {
    final requested = <NotificacionEstado?>[];
    await _pumpWithLoader(tester, (final estado) async {
      requested.add(estado);
      return [
        _notification(id: 1, concepto: 'Pendiente local', estado: NotificacionEstado.pendiente),
        _notification(id: 2, concepto: 'Aceptada local', estado: NotificacionEstado.aceptada),
      ];
    });
    final l10n = AppLocalizations.of(tester.element(find.byType(GestionNotificacionesPage)));

    await tester.tap(find.text(l10n.gestionNotificacionesTabPendientes));
    await tester.pump();
    expect(find.text('Pendiente local'), findsOneWidget);
    expect(find.text('Aceptada local'), findsNothing);

    await tester.tap(find.text(l10n.gestionNotificacionesTabAceptadas));
    await tester.pump();

    expect(requested, [null]);
    expect(find.text('Aceptada local'), findsOneWidget);
    expect(find.text('Pendiente local'), findsNothing);
  });

  testWidgets('reintentar vuelve a cargar el filtro seleccionado', (final tester) async {
    var acceptedAttempts = 0;
    await _pumpWithLoader(tester, (final estado) async {
      expect(estado, isNull);
      if (acceptedAttempts++ == 0) {
        throw Exception('fallo transitorio');
      }
      return [_notification(id: 3, concepto: 'Recuperada', estado: NotificacionEstado.aceptada)];
    });
    final l10n = AppLocalizations.of(tester.element(find.byType(GestionNotificacionesPage)));

    await tester.tap(find.text(l10n.gestionNotificacionesTabAceptadas));
    await tester.pump();
    expect(find.text(l10n.gestionNotificacionesLoadError), findsOneWidget);

    await tester.tap(find.text(l10n.errorStateRetry));
    await tester.pumpAndSettle();

    expect(acceptedAttempts, 2);
    expect(find.text('Recuperada'), findsOneWidget);
  });

  testWidgets('tablet muestra los cuatro filtros compactos y permite seleccionar expiradas', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 1100);
    addTearDown(tester.view.reset);
    await _pumpList(tester, const []);
    final context = tester.element(find.byType(GestionNotificacionesPage));
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.gestionNotificacionesTabTodo,
      l10n.gestionNotificacionesTabPendientes,
      l10n.gestionNotificacionesTabAceptadas,
      l10n.gestionNotificacionesTabExpiradas,
    ];
    for (final (index, label) in labels.indexed) {
      expect(find.text(label).hitTestable(), findsOneWidget);
      final semantics = find.semantics.byLabel(label).evaluate().single.getSemanticsData();
      expect(semantics.role, SemanticsRole.tab);
      expect(semantics.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
      expect(semantics.flagsCollection.isSelected, index == 0 ? Tristate.isTrue : Tristate.isFalse);
      expect(semantics.value, 'Pestaña ${index + 1} de 4');
    }
    expect(find.byTooltip(l10n.gestionNotificacionesTabExpiradas), findsNothing);
    await tester.tap(find.text(l10n.gestionNotificacionesTabExpiradas));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(context);
    expect(container.exists(gestionNotificacionesProvider(null)), isTrue);
    expect(container.exists(gestionNotificacionesProvider(NotificacionEstado.expirada)), isFalse);
    expect(tester.takeException(), isNull);
  });

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

  testWidgets('WCAG 2.1.1 / 4.1.2: cada notificación es un botón activable por el lector', (final tester) async {
    await _pumpList(tester, [_notification(id: 1, concepto: 'Resolución de ayuda', estado: NotificacionEstado.pendiente)]);

    final data = find.semantics.byLabel(RegExp('Resolución de ayuda')).evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
  });

  testWidgets('WCAG 2.1.1 / 2.4.7: el tabulador recorre una lista larga y marca cada notificación', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);
    final notifications = [
      for (var i = 1; i <= 12; i++) _notification(id: i, concepto: 'Notificación número $i', estado: NotificacionEstado.pendiente),
    ];
    await _pumpList(tester, notifications);

    final ring = find.byWidgetPredicate((final w) => w is CustomPaint && w.foregroundPainter is AppFocusRingPainter);
    final reached = <String>{};
    for (var i = 0; i < 60 && reached.length < notifications.length; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = primaryFocus?.context;
      if (focused == null) {
        continue;
      }
      for (final notification in notifications) {
        final title = find.text(notification.concepto);
        if (find.descendant(of: find.byWidget(focused.widget), matching: title).evaluate().isNotEmpty) {
          reached.add(notification.concepto);
          final rect = tester.getRect(title);
          expect(rect.top, greaterThanOrEqualTo(0));
          expect(rect.bottom, lessThanOrEqualTo(667));
          expect(find.ancestor(of: title, matching: ring), findsOneWidget);
        }
      }
    }
    expect(reached, notifications.map((final n) => n.concepto).toSet());
  });

  testWidgets('WCAG 4.1.2: en móvil la posición de cada filtro se cuenta sobre los cuatro', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);
    await _pumpList(tester, const []);
    final l10n = AppLocalizations.of(tester.element(find.byType(GestionNotificacionesPage)));

    expect(find.semantics.byLabel(l10n.gestionNotificacionesTabTodo).evaluate().single.getSemanticsData().value, 'Pestaña 1 de 4');

    await tester.tap(find.byTooltip(l10n.gestionNotificacionesTabExpiradas));
    await tester.pumpAndSettle();
    expect(find.semantics.byLabel(l10n.gestionNotificacionesTabExpiradas).evaluate().single.getSemanticsData().value, 'Pestaña 4 de 4');
  });

  testWidgets('WCAG 2.5.1: al 200 por ciento los cuatro filtros se ven sin deslizar ni flechas', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 667);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [gestionNotificacionesProvider.overrideWith((final ref, final estado) async => const <Notificacion>[])],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (final context, final child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: const GestionNotificacionesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(GestionNotificacionesPage)));

    for (final label in [
      l10n.gestionNotificacionesTabTodo,
      l10n.gestionNotificacionesTabPendientes,
      l10n.gestionNotificacionesTabAceptadas,
      l10n.gestionNotificacionesTabExpiradas,
    ]) {
      final rect = tester.getRect(find.text(label));
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(375));
    }
    expect(find.byTooltip(l10n.gestionNotificacionesTabExpiradas), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpList(final WidgetTester tester, final List<Notificacion> notificaciones) async {
  await _pumpWithLoader(tester, (final _) async => notificaciones);
  await tester.pumpAndSettle();
}

Future<void> _pumpWithLoader(
  final WidgetTester tester,
  final Future<List<Notificacion>> Function(NotificacionEstado? estado) loader,
) async {
  await tester.pumpWidget(
    ProviderScope(
      retry: (final _, final _) => null,
      overrides: [
        gestionNotificacionesProvider.overrideWith((final ref, final estado) => loader(estado)),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GestionNotificacionesPage(),
      ),
    ),
  );
  await tester.pump();
}

Notificacion _notification({
  required final int id,
  required final String concepto,
  required final NotificacionEstado? estado,
}) => Notificacion(
  id: id,
  concepto: concepto,
  procedimientoDenominacion: 'Procedimiento',
  estado: estado,
);
