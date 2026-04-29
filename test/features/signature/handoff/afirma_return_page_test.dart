import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_outcome.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_handoff_controller.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/afirma_return_page.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'AfirmaReturnPage parses the deep-link, updates the controller and renders the processing surface',
    (final tester) async {
      var processed = false;
      final container = ProviderContainer(
        overrides: [
          signatureRepositoryProvider.overrideWith(
            (final ref) => SignatureRepositoryImpl(
              fixedCertificateState: CertificateValidationState.valid,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es'),
            home: AfirmaReturnPage(
              returnUri: Uri.parse(
                'jccmespacio://sign/afirma/return?docId=DOC-7&result=signed',
              ),
              onProcessed: () => processed = true,
            ),
          ),
        ),
      );

      // Pump the post-frame callback + microtask.
      await tester.pump();
      await tester.pump();

      expect(find.text('Volviendo de Afirma'), findsOneWidget);
      expect(find.text('Procesando firma…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final outcome = container.read(signatureHandoffControllerProvider);
      expect(outcome, isNotNull);
      expect(outcome!.status, SignatureHandoffStatus.signed);
      expect(outcome.documentId, 'DOC-7');
      expect(processed, isTrue);
    },
  );

  testWidgets(
    'AfirmaReturnPage on a malformed deep-link still renders the processing surface and leaves controller untouched',
    (final tester) async {
      final container = ProviderContainer(
        overrides: [
          signatureRepositoryProvider.overrideWith(
            (final ref) => SignatureRepositoryImpl(
              fixedCertificateState: CertificateValidationState.valid,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es'),
            home: AfirmaReturnPage(
              returnUri: Uri.parse('https://wrong/scheme'),
              onProcessed: () {},
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Procesando firma…'), findsOneWidget);
      expect(container.read(signatureHandoffControllerProvider), isNull);
    },
  );
}
