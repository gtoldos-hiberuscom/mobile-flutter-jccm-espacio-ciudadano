/// Sprint 9 / STORY-67 — agenda tile dynamic-type regression test.
///
/// Reproduces the carry-over from Sprint 7 / Sprint 8: at large
/// dynamic-type scales (Spanish accessibility settings can scale up to
/// ~200%), a long event title overflowed the `ListTile` row, throwing
/// a `RenderFlex overflowed` exception and clipping pixels in release
/// mode. This test pumps the tile inside a `MediaQuery` with
/// `TextScaler.linear(2.0)` and asserts:
///   1. no exception is raised by the framework, and
///   2. the title still finds the (truncated) text on screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/agenda_event_tile.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const String _longTitle =
    'Cita médica con el especialista en cardiología en el centro de '
    'salud Toledo Norte para revisión anual y pruebas complementarias';

const String _longSubtitle =
    'Centro de Salud Toledo Norte — planta 2, consulta 215 — '
    'duración estimada 45 minutos';

AgendaEvent _event() => AgendaEvent(
  id: 'evt-1',
  startsAt: DateTime(2030, 1, 1, 10, 30),
  category: AgendaCategory.salud,
  source: AgendaEventSource.ssalud,
  rawTitle: _longTitle,
  centro: 'Centro de Salud Toledo Norte',
  profesional: 'Dra. Ejemplo',
  tipo: 'Revisión',
);

Future<void> _pump(
  final WidgetTester tester, {
  required final double scale,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: SizedBox(
            width: 360, // narrow phone width to force wrapping pressure
            child: AgendaEventTile(
              event: _event(),
              subtitle: _longSubtitle,
              onTap: () {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('AgendaEventTile does not overflow at 2.0x text scale', (
    final tester,
  ) async {
    await _pump(tester, scale: 2);

    // Framework would surface RenderFlex overflow as a test exception.
    expect(tester.takeException(), isNull);
    // Title is still rendered (Text widget present); ellipsis applies
    // visually, the underlying String stays in the tree.
    expect(find.text(_longTitle), findsOneWidget);
  });

  testWidgets('AgendaEventTile renders cleanly at 1.0x text scale', (
    final tester,
  ) async {
    await _pump(tester, scale: 1);
    expect(tester.takeException(), isNull);
    expect(find.text(_longTitle), findsOneWidget);
  });
}
