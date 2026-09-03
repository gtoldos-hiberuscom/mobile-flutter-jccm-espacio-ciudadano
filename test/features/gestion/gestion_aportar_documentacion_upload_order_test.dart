import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/representante.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_documento_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_aportar_documentacion_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_documento_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/tercero_identificacion.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  late Directory tempDir;

  // E/S síncrona: `testWidgets` corre con reloj falso y una escritura
  // asíncrona no completaría fuera de `runAsync`.
  setUp(() => tempDir = Directory.systemTemp.createTempSync('aportacion_order'));
  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('sube los ficheros de uno en uno, sin solaparlos', (final tester) async {
    final archivos = [
      for (final nombre in ['a.pdf', 'b.pdf', 'c.pdf'])
        AportacionArchivo(
          path: (File('${tempDir.path}/$nombre')..writeAsBytesSync(List.filled(32, 1))).path,
          nombre: nombre,
          tamanioBytes: 32,
        ),
    ];
    final repository = _RecordingDocumentoRepository();
    final container = ProviderContainer(
      overrides: [
        citizenEndpointIdsProvider.overrideWithValue((numDocumento: 'PER9998003', idAgente: 'PER9998003')),
        gestionDocumentoRepositoryProvider.overrideWithValue(repository),
        expedienteDetailProvider.overrideWith(
          (final ref, final key) async => Expediente(numexp: key.numexp, titulo: 'Expediente', consejeria: 'JCCM', tipoproc: '020'),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionAportarDocumentacionPage(
            numexp: 'EXP-1',
            tercero: TerceroIdentificacion(tipodoc: 'NIF', documentNumber: '99999999R'),
          ),
        ),
      ),
    );
    container.read(gestionAportarDocumentacionProvider.notifier).addArchivos(archivos);
    await tester.pump();

    await tester.runAsync(() async {
      await tester.tap(find.text('Registrar documentos aportados'));
      for (var i = 0; i < 30; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await tester.pump();
      }
    });

    // El plazo de cada subida se dimensiona con el tamaño de ese fichero, así
    // que dos subidas simultáneas compartiendo el enlace lo invalidarían.
    expect(repository.maxSimultaneas, 1);
    expect(repository.subidas, ['a.pdf', 'b.pdf', 'c.pdf']);
  });
}

final class _RecordingDocumentoRepository implements GestionDocumentoRepository {
  final subidas = <String>[];
  int _enVuelo = 0;
  int maxSimultaneas = 0;

  @override
  Future<InicioProcedimientoResultado> iniciarProcedimiento({
    required final String citizenId,
    required final String idUnico,
    required final String documentNumber,
    required final Expediente expediente,
    final Representante? representante,
  }) async => InicioProcedimientoResultado(
    idunico: idUnico,
    estado: 'OK',
    asuid: 'ASU-1',
    descrip: 'descripcion',
    uniorg: 'UNI-1',
    numdoc: documentNumber,
    nombre: 'Nombre',
    apellido1: 'Apellido1',
    apellido2: 'Apellido2',
  );

  @override
  Future<String> subirDocumentoSinFirma({
    required final String citizenId,
    required final String documentNumber,
    required final String idUnico,
    required final String tipoProcedimiento,
    required final String nombreFichero,
    required final Uint8List bytes,
    final CancelToken? cancelToken,
    final void Function(double progreso)? onProgress,
  }) async {
    _enVuelo++;
    maxSimultaneas = _enVuelo > maxSimultaneas ? _enVuelo : maxSimultaneas;
    subidas.add(nombreFichero);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    _enVuelo--;
    return 'hash-$nombreFichero';
  }

  @override
  Future<Uint8List> registrarFicheros({
    required final String citizenId,
    required final String documentNumber,
    required final Expediente expediente,
    required final InicioProcedimientoResultado inicio,
    required final List<({String nombre, String hash, int tamanioBytes})> documentos,
    final Representante? representante,
    final CancelToken? cancelToken,
  }) async => Uint8List.fromList('%PDF-1.4'.codeUnits);

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}
