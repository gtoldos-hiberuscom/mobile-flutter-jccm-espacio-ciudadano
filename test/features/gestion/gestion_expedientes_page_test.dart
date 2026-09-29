import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
