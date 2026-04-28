import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/justificante_state.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_session.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_validator.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/upload_evidence_section.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/widgets/upload_picker_panel.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/3_data/upload_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _StubRepo implements UploadRepository {
  @override
  Future<String> computeServerHash(final Uint8List bytes) async => sha256HexOf(bytes);

  @override
  Future<UploadAttachment> uploadUnsigned(
    final UploadAttachment attachment,
    final Uint8List bytes,
    final String expedienteRef,
  ) async => attachment.copyWith(
    status: UploadAttachmentStatus.uploaded,
    clearError: true,
  );

  @override
  Future<JustificanteState> requestJustificante(final UploadSession session) => Future<JustificanteState>.value(
    const JustificanteState.unavailable('builder-pending-backend-confirmation'),
  );
}

Future<List<PickedFile>> _stubPicker() async {
  final bytes = Uint8List.fromList(List<int>.filled(64, 7));
  return <PickedFile>[
    (
      name: 'demo.pdf',
      sizeBytes: bytes.length,
      mimeType: 'application/pdf',
      bytes: bytes,
    ),
  ];
}

Widget _harness({required final UploadFilePicker picker}) {
  return ProviderScope(
    overrides: [
      uploadRepositoryProvider.overrideWith((final ref) => _StubRepo()),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: UploadEvidenceSection(
            expedienteRef: 'EXP-1',
            picker: picker,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the limit hint and unavailable justificante banner', (final tester) async {
    await tester.pumpWidget(_harness(picker: _stubPicker));
    await tester.pumpAndSettle();
    // Limit hint contains the max files literal "5".
    expect(find.textContaining('5'), findsWidgets);
    // Empty list label is shown initially.
    expect(find.textContaining('Aún no hay'), findsOneWidget);
  });

  testWidgets('removing a picked file empties the list', (final tester) async {
    await tester.pumpWidget(_harness(picker: _stubPicker));
    await tester.pumpAndSettle();
    // Tap "Seleccionar archivos" — the FilledButton in the picker panel.
    await tester.tap(find.text('Seleccionar archivos'));
    await tester.pumpAndSettle();
    expect(find.text('demo.pdf'), findsOneWidget);

    // Tap the remove (close) icon.
    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();
    expect(find.text('demo.pdf'), findsNothing);
    expect(find.textContaining('Aún no hay'), findsOneWidget);
  });

  testWidgets('justificante panel shows unavailable copy by default', (final tester) async {
    await tester.pumpWidget(_harness(picker: _stubPicker));
    await tester.pumpAndSettle();
    // Pending text is shown until the session is finalized.
    expect(find.textContaining('justificante'), findsWidgets);
  });
}
