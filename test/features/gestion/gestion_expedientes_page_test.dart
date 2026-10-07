import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_expedientes_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('muestra la oficina tramitadora en la cabecera de la tarjeta', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expedientesProvider.overrideWith(
            (final ref) async => const [
              Expediente(
                numexp: 'EXP-1',
                titulo: 'Expediente de prueba',
                consejeria: 'Consejería que no debe mostrarse',
                oficinaTramitadora: 'Oficina tramitadora',
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionExpedientesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('OFICINA TRAMITADORA'), findsOneWidget);
    expect(find.text('CONSEJERÍA QUE NO DEBE MOSTRARSE'), findsNothing);
  });

  testWidgets('muestra la fecha de inicio como dd/mm/aaaa, igual que la web', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expedientesProvider.overrideWith(
            (final ref) async => const [
              Expediente(
                numexp: 'WM49/2026/000062',
                titulo: 'Expediente de prueba',
                consejeria: 'JCCM',
                fechaInicio: '2026-08-27',
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionExpedientesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('27/08/2026'), findsOneWidget);
  });

  testWidgets('reintenta la carga de expedientes después de un error', (final tester) async {
    var attempts = 0;

    await tester.pumpWidget(
      ProviderScope(
        retry: (final _, final _) => null,
        overrides: [
          expedientesProvider.overrideWith((final ref) async {
            attempts++;
            if (attempts == 1) {
              throw Exception('Error transitorio');
            }
            return const <Expediente>[];
          }),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionExpedientesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reintentar'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('mientras se reintenta muestra la carga y no deja reintentar otra vez', (final tester) async {
    var attempts = 0;
    final segundoIntento = Completer<List<Expediente>>();

    await tester.pumpWidget(
      ProviderScope(
        retry: (final _, final _) => null,
        overrides: [
          expedientesProvider.overrideWith((final ref) async {
            attempts++;
            if (attempts == 1) {
              throw Exception('Error transitorio');
            }
            return segundoIntento.future;
          }),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionExpedientesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reintentar'));
    await tester.pump();

    // `refresh` conserva el error mientras recarga: antes se seguía pintando
    // con "Reintentar" activo y cada pulsación lanzaba otra petición.
    expect(find.text('Reintentar'), findsNothing);
    expect(find.byType(LoadingStateWidget), findsOneWidget);
    expect(attempts, 2);

    segundoIntento.complete(const <Expediente>[]);
    await tester.pumpAndSettle();
    expect(attempts, 2);
  });
}
