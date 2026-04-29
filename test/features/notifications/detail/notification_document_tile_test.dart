import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/widgets/notification_document_tile.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Widget _wrap(final Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('es'),
  home: Scaffold(body: child),
);

void main() {
  group('NotificationDocumentTile', () {
    testWidgets('renders filename, mime label and KB-formatted size for available document', (
      final tester,
    ) async {
      var taps = 0;
      const document = NotificationDocument(
        id: 'doc-1',
        name: 'Acta-firmada.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 250 * 1024,
        availability: NotificationDocumentAvailability.available,
      );

      await tester.pumpWidget(
        _wrap(
          NotificationDocumentTile(
            document: document,
            onDownload: () => taps++,
          ),
        ),
      );

      expect(find.text('Acta-firmada.pdf'), findsOneWidget);
      expect(find.textContaining('PDF'), findsOneWidget);
      expect(find.textContaining('KB'), findsOneWidget);

      await tester.tap(find.byTooltip('Descargar documento'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('shows MB size for documents above 1 MiB', (
      final tester,
    ) async {
      const document = NotificationDocument(
        id: 'doc-mb',
        name: 'Anexo.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 2 * 1024 * 1024,
        availability: NotificationDocumentAvailability.available,
      );

      await tester.pumpWidget(
        _wrap(
          NotificationDocumentTile(
            document: document,
            onDownload: () {},
          ),
        ),
      );

      expect(find.textContaining('MB'), findsOneWidget);
    });

    testWidgets('shows unknown size label when sizeBytes is null', (
      final tester,
    ) async {
      const document = NotificationDocument(
        id: 'doc-none',
        name: 'Sin-tamano.pdf',
        availability: NotificationDocumentAvailability.available,
      );

      await tester.pumpWidget(
        _wrap(
          NotificationDocumentTile(
            document: document,
            onDownload: () {},
          ),
        ),
      );

      expect(find.text('Tamaño desconocido'), findsOneWidget);
    });

    testWidgets('disables the download button and shows the unavailable chip when not available', (
      final tester,
    ) async {
      const document = NotificationDocument(
        id: 'doc-unavail',
        name: 'No-descargable.zip',
        mimeType: 'application/zip',
        sizeBytes: 1024,
        availability: NotificationDocumentAvailability.unavailable,
      );

      await tester.pumpWidget(
        _wrap(
          const NotificationDocumentTile(
            document: document,
            onDownload: null,
          ),
        ),
      );

      expect(find.text('No disponible'), findsOneWidget);
      final IconButton button = tester.widget<IconButton>(
        find.byType(IconButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows a spinner instead of the download icon while downloading', (
      final tester,
    ) async {
      const document = NotificationDocument(
        id: 'doc-loading',
        name: 'Cargando.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 1024,
        availability: NotificationDocumentAvailability.available,
      );

      await tester.pumpWidget(
        _wrap(
          NotificationDocumentTile(
            document: document,
            onDownload: () {},
            isDownloading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(IconButton), findsNothing);
    });
  });
}
