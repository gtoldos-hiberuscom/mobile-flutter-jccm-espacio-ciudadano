import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

void main() {
  testWidgets('blocks every format and shows feedback while downloading', (
    final tester,
  ) async {
    var pkPassPresses = 0;
    var pdfPresses = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppQrDownloadBottomSheetBody(
            downloadingFormat: 'PKPASS',
            onPkPassPressed: () => pkPassPresses++,
            onPdfPressed: () => pdfPresses++,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Descargando PKPASS'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Descargando PKPASS'));
    await tester.tap(find.bySemanticsLabel('Descargar PDF'));
    await tester.pump();

    expect(pkPassPresses, 0);
    expect(pdfPresses, 0);
  });
}
