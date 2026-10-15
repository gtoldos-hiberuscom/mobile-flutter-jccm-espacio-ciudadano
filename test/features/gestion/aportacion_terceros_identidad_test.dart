import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/app/app_lifecycle_provider.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/representante.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_documento_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_expediente_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_aportacion_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_documento_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/tercero_identificacion.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// JCCMEC-219: aportar a un expediente de terceros. El backend no conoce el
/// tipo `DNI` (403 / «numero de DNI incorrecto») y el representante tiene que
/// ir con el documento efectivo y normalizado del usuario autenticado.
void main() {
  testWidgets('la búsqueda de terceros con DNI seleccionado envía ptipodoc NIF', (final tester) async {
    final repository = _RecordingExpedienteRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          citizenEndpointIdsProvider.overrideWithValue((numDocumento: '12345678Z', idAgente: 'agente-1')),
          gestionExpedienteRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionAportacionPage(),
        ),
      ),
    );

    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), '99999999R');
    await tester.enterText(campos.at(1), '1120973/2026');
    await tester.tap(find.text('Buscar Expediente'));
    await tester.pumpAndSettle();

    expect(repository.tiposEnviados, ['NIF']);
  });

  test('al aportar como tercero, el representante va con el documento normalizado', () async {
    final tempDir = Directory.systemTemp.createTempSync('aportacion_tercero');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    const tercero = TerceroIdentificacion(tipodoc: 'NIF', documentNumber: '99999999R');
    const ExpedienteDetailKey key = (numexp: 'EXP-1', tercero: tercero);
    final repository = _RecordingDocumentoRepository();
    final container = ProviderContainer(
      overrides: [
        connectivityRawStreamProvider.overrideWith((final ref) => Stream.value([ConnectivityResult.wifi])),
        appResumedFromBackgroundProvider.overrideWithValue(const Stream<void>.empty()),
        citizenEndpointIdsProvider.overrideWithValue((numDocumento: '12345678Z', idAgente: 'agente-1')),
        jwtClaimsProvider.overrideWith(
          () => _StubJwtClaimsNotifier(
            const JwtClaims(exp: 0, iat: 0, iss: '', aud: [], sub: 'sub', personIdentifier: 'ES/ES/12345678Z', givenName: 'Ana'),
          ),
        ),
        gestionDocumentoRepositoryProvider.overrideWithValue(repository),
        expedienteDetailProvider.overrideWith(
          (final ref, final key) async => Expediente(numexp: key.numexp, titulo: 'Expediente', consejeria: 'JCCM', tipoproc: '020'),
        ),
      ],
    );
    addTearDown(container.dispose);
    final provider = gestionAportarDocumentacionProvider(key);
    container.listen(provider, (_, _) {});

    final fichero = File('${tempDir.path}/a.pdf')..writeAsBytesSync(List.filled(32, 1));
    container.read(provider.notifier).addArchivos([AportacionArchivo(path: fichero.path, nombre: 'a.pdf', tamanioBytes: 32)]);
    final inicio = await repository.inicio.future.timeout(const Duration(seconds: 5));

    expect(inicio.documentNumber, '99999999R');
    expect(inicio.representante?.nifcif, '12345678Z');
    expect(inicio.representante?.nombre, 'Ana');
  });
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}

final class _RecordingExpedienteRepository implements GestionExpedienteRepository {
  final tiposEnviados = <String>[];

  @override
  Future<Expediente> loadExpedienteByRegistro({
    required final String citizenId,
    required final String documentNumber,
    required final String numRegistro,
    final String tipodoc = 'NIF',
  }) async {
    tiposEnviados.add(tipodoc);
    throw StateError('No hay publicaciones para los parametros introducidos');
  }

  @override
  Future<Expediente> loadExpedienteDetail({
    required final String citizenId,
    required final String documentNumber,
    required final String numexp,
    final String tipodoc = 'NIF',
  }) async {
    tiposEnviados.add(tipodoc);
    throw StateError('No hay publicaciones para los parametros introducidos');
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}

final class _RecordingDocumentoRepository implements GestionDocumentoRepository {
  final inicio = Completer<({String documentNumber, Representante? representante})>();

  @override
  Future<InicioProcedimientoResultado> iniciarProcedimiento({
    required final String citizenId,
    required final String idUnico,
    required final String documentNumber,
    required final Expediente expediente,
    final Representante? representante,
    final CancelToken? cancelToken,
  }) async {
    if (!inicio.isCompleted) {
      inicio.complete((documentNumber: documentNumber, representante: representante));
    }
    return InicioProcedimientoResultado(
      idunico: idUnico,
      estado: 'OK',
      asuid: '',
      descrip: '',
      uniorg: '',
      numdoc: documentNumber,
      nombre: '',
      apellido1: '',
      apellido2: '',
    );
  }

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
  }) async => 'hash-$nombreFichero';

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}
