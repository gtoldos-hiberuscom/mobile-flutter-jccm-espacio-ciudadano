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
}

Future<void> _pumpDetail(final WidgetTester tester, {required final bool canAttachDocuments}) async {
  await tester.pumpWidget(
    ProviderScope(
      key: ValueKey(canAttachDocuments),
      overrides: [
        expedienteDetailProvider.overrideWith(
          (final ref, final key) async => Expediente(
            numexp: key.numexp,
            titulo: 'Expediente de prueba',
            consejeria: 'JCCM',
            canAttachDocuments: canAttachDocuments,
          ),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GestionExpedienteDetallePage(numexp: 'EXP-1'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
