import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/signature_inbox_page.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/widgets/certificate_status_banner.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/widgets/signature_document_tile.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Widget _wrap({
  required final Widget child,
  final CertificateValidationState certificateState =
      CertificateValidationState.valid,
}) => ProviderScope(
  overrides: [
    signatureRepositoryProvider.overrideWith(
      (final ref) => SignatureRepositoryImpl(
        fixedCertificateState: certificateState,
      ),
    ),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: child,
  ),
);

void main() {
  testWidgets(
    'renders AppBar title, both tabs, certificate banner and pending tiles',
    (final tester) async {
      await tester.pumpWidget(_wrap(child: const SignatureInboxPage()));
      // First frame loads; second/third settle the futures.
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Firma de documentos'), findsOneWidget);
      expect(find.text('Pendientes'), findsWidgets);
      expect(find.text('Histórico'), findsWidgets);
      expect(find.byType(CertificateStatusBanner), findsOneWidget);
      // Valid certificate path → banner shows the success title.
      expect(find.text('Certificado válido'), findsOneWidget);
      // At least one pending document tile is rendered.
      expect(find.byType(SignatureDocumentTile), findsWidgets);
    },
  );

  testWidgets(
    'banner exposes the re-validate CTA when the certificate is expired',
    (final tester) async {
      await tester.pumpWidget(
        _wrap(
          child: const SignatureInboxPage(),
          certificateState: CertificateValidationState.expired,
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Tu certificado ha caducado'), findsOneWidget);
      expect(find.text('Volver a validar'), findsOneWidget);
    },
  );
}
