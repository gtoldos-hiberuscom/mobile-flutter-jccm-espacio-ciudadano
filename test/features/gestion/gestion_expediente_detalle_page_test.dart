import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_expediente_detalle_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('shows attach documents only when backend returns adjuntar X', (final tester) async {
    await _pumpDetail(tester, canAttachDocuments: true);

    expect(find.text('Aportar documentación'), findsOneWidget);

    await _pumpDetail(tester, canAttachDocuments: false);

    expect(find.text('Aportar documentación'), findsNothing);
  });

  testWidgets('shows fecha de inicio as dd/MM/yyyy', (final tester) async {
    await _pumpDetail(tester, canAttachDocuments: false, fechaInicio: '2026-07-15');

    expect(find.text('15/07/2026'), findsOneWidget);
  });

  testWidgets('shows a dash when fecha de inicio is missing', (final tester) async {
    await _pumpDetail(tester, canAttachDocuments: false);

    expect(find.text('FECHA DE INICIO'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
  });

  testWidgets('reintenta la carga del detalle después de un error', (final tester) async {
    var attempts = 0;

    await tester.pumpWidget(
      ProviderScope(
        retry: (final _, final _) => null,
        overrides: [
          expedienteDetailProvider.overrideWith((final ref, final key) async {
            attempts++;
            if (attempts == 1) {
              throw Exception('Error transitorio');
            }
            return Expediente(
              numexp: key.numexp,
              titulo: 'Expediente recuperado',
              consejeria: 'JCCM',
            );
          }),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionExpedienteDetallePage(numexp: 'EXP-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reintentar'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('Expediente recuperado'), findsOneWidget);
  });
}

Future<void> _pumpDetail(final WidgetTester tester, {required final bool canAttachDocuments, final String? fechaInicio}) async {
  await tester.pumpWidget(
    ProviderScope(
      key: ValueKey(canAttachDocuments),
      overrides: [
        expedienteDetailProvider.overrideWith(
          (final ref, final key) async => Expediente(
            numexp: key.numexp,
            titulo: 'Expediente de prueba',
            consejeria: 'JCCM',
            fechaInicio: fechaInicio,
            canAttachDocuments: canAttachDocuments,
          ),
        ),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GestionExpedienteDetallePage(numexp: 'EXP-1'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
