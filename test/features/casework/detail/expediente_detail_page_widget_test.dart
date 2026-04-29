import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_estado.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_fichero.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/1_domain/expediente_detail_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/2_presentation/expediente_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/3_data/expediente_detail_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/justificante_state.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_session.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_validator.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/upload_evidence_section.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/3_data/upload_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _StubRepo implements ExpedienteDetailRepository {
  _StubRepo({this.detail, this.error});
  final ExpedienteDetail? detail;
  final Object? error;
  @override
  Future<ExpedienteDetail> loadByNumber(final String numexp) async {
    final err = error;
    if (err != null) {
      Error.throwWithStackTrace(err, StackTrace.current);
    }
    return detail!;
  }
}

class _StubUploadRepo implements UploadRepository {
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
    const JustificanteState.unavailable('builder-pending-backend'),
  );
}

ExpedienteDetail _detail({required final ExpedienteEstado estado}) => ExpedienteDetail(
  id: 'x1',
  numero: 'EXP/2025/00123',
  asuntoCodigo: 'AS-1',
  asunto: 'Solicitud',
  consejeria: 'Consejería de Bienestar',
  oficinaTramitadora: 'Oficina de Toledo',
  procedimiento: 'Ayudas',
  fechaInicio: DateTime(2025, 3, 4),
  fechaUltimaActualizacion: DateTime(2025, 4, 18),
  estado: estado,
  ficheros: <ExpedienteFichero>[
    ExpedienteFichero(
      id: 'f1',
      nombre: 'documento.pdf',
      mimeType: 'application/pdf',
      sizeBytes: 1024,
      fechaSubida: DateTime(2025, 3, 5),
      descargaRef: 'ref://x',
    ),
  ],
);

Widget _harness({required final ExpedienteDetailRepository repo}) {
  return ProviderScope(
    overrides: [
      expedienteDetailRepositoryProvider.overrideWith((final ref) => repo),
      uploadRepositoryProvider.overrideWith((final ref) => _StubUploadRepo()),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('es'),
      home: ExpedienteDetailPage(expedienteRef: 'EXP/2025/00123'),
    ),
  );
}

void main() {
  testWidgets('abierto detail shows the embedded upload section', (final tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _harness(
        repo: _StubRepo(detail: _detail(estado: ExpedienteEstado.abierto)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Solicitud'), findsOneWidget);
    expect(find.text('Abierto'), findsOneWidget);
    expect(find.byType(UploadEvidenceSection), findsOneWidget);
    expect(find.textContaining('Expediente cerrado'), findsNothing);
  });

  testWidgets('cerrado detail shows the closed banner without upload section', (final tester) async {
    await tester.pumpWidget(
      _harness(
        repo: _StubRepo(detail: _detail(estado: ExpedienteEstado.cerrado)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cerrado'), findsOneWidget);
    expect(find.byType(UploadEvidenceSection), findsNothing);
    expect(find.textContaining('Expediente cerrado'), findsOneWidget);
  });

  testWidgets('error state surfaces an error message and retry control', (final tester) async {
    await tester.pumpWidget(
      _harness(repo: _StubRepo(error: StateError('boom'))),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('No hemos podido cargar el expediente'),
      findsOneWidget,
    );
  });
}
