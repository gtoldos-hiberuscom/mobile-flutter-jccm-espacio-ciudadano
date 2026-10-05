import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/app/app_lifecycle_provider.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';

/// Sin `tercero` y sin claims en el contenedor, la apertura de la transacción
/// que dispara `addArchivos` muere antes de tocar la red (no hay documento del
/// ciudadano): estos tests solo ejercitan la validación de la lista, que es
/// síncrona, y las aserciones corren antes de que la cola avance.
const ExpedienteDetailKey _key = (numexp: 'EXP-1', tercero: null);

final _provider = gestionAportarDocumentacionProvider(_key);

void main() {
  group('GestionAportarDocumentacionNotifier', () {
    late ProviderContainer container;
    late GestionAportarDocumentacionNotifier notifier;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          connectivityRawStreamProvider.overrideWith((final ref) => Stream.value([ConnectivityResult.wifi])),
          appResumedFromBackgroundProvider.overrideWithValue(const Stream<void>.empty()),
        ],
      );
      notifier = container.read(_provider.notifier);
    });

    tearDown(() => container.dispose());

    AportacionArchivo archivo(final String nombre, {final int bytes = 1024}) => AportacionArchivo(path: '/tmp/$nombre', nombre: nombre, tamanioBytes: bytes);

    List<AportacionArchivo> archivos() => container.read(_provider).archivos;

    test('adds up to 5 files successfully', () {
      final result = notifier.addArchivos([
        archivo('uno.pdf'),
        archivo('dos.doc'),
        archivo('tres.docx'),
        archivo('cuatro.zip'),
        archivo('cinco.xlsx'),
      ]);

      expect(result, isA<AddArchivosAdded>());
      expect((result as AddArchivosAdded).count, 5);
      expect(archivos(), hasLength(5));
    });

    test('rejects a 6th file beyond the max of 5', () {
      notifier.addArchivos([archivo('uno.pdf'), archivo('dos.pdf'), archivo('tres.pdf'), archivo('cuatro.pdf'), archivo('cinco.pdf')]);

      final result = notifier.addArchivos([archivo('seis.pdf')]);

      expect(result, isA<AddArchivosRejectedTooMany>());
      expect(archivos(), hasLength(5));
    });

    test('el límite de 20 MB es decimal, como muestra iOS', () {
      // 20.900.000 bytes: iOS lo muestra como «21 MB» y cabía en 20 MiB.
      final result = notifier.addArchivos([archivo('veintiuno.pdf', bytes: 20900000)]);

      expect(result, isA<AddArchivosRejectedTooLarge>());
      expect(notifier.addArchivos([archivo('justo.pdf', bytes: 20000000)]), isA<AddArchivosAdded>());
    });

    test('rejects a file larger than 20MB', () {
      final result = notifier.addArchivos([archivo('grande.pdf', bytes: maxTamanioBytesAportacion + 1)]);

      expect(result, isA<AddArchivosRejectedTooLarge>());
      expect((result as AddArchivosRejectedTooLarge).nombres, ['grande.pdf']);
      expect(archivos(), isEmpty);
    });

    test('rejects a file with a disallowed extension', () {
      final result = notifier.addArchivos([archivo('imagen.png')]);

      expect(result, isA<AddArchivosRejectedInvalidType>());
      expect((result as AddArchivosRejectedInvalidType).nombres, ['imagen.png']);
      expect(archivos(), isEmpty);
    });

    test('rejects a duplicate path', () {
      notifier.addArchivos([archivo('uno.pdf')]);

      final result = notifier.addArchivos([archivo('uno.pdf')]);

      expect(result, isA<AddArchivosRejectedDuplicate>());
      expect((result as AddArchivosRejectedDuplicate).nombres, ['uno.pdf']);
      expect(archivos(), hasLength(1));
    });

    test('removeArchivo removes the matching file by path', () {
      notifier
        ..addArchivos([archivo('uno.pdf'), archivo('dos.pdf')])
        ..removeArchivo('/tmp/uno.pdf');

      expect(archivos().map((final a) => a.nombre), ['dos.pdf']);
    });

    test('un hueco liberado permite volver a añadir hasta el tope de 5', () {
      notifier
        ..addArchivos([archivo('uno.pdf'), archivo('dos.pdf'), archivo('tres.pdf'), archivo('cuatro.pdf'), archivo('cinco.pdf')])
        ..removeArchivo('/tmp/uno.pdf');

      expect(notifier.addArchivos([archivo('seis.pdf')]), isA<AddArchivosAdded>());
      expect(archivos(), hasLength(5));
    });

    test('cancelarTodas no lanza sin peticiones en vuelo', () {
      notifier.addArchivos([archivo('uno.pdf')]);

      expect(notifier.cancelarTodas, returnsNormally);
    });
  });
}
