import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';

void main() {
  group('GestionAportarDocumentacionNotifier', () {
    AportacionArchivo archivo(final String name, {final int bytes = 1024}) => AportacionArchivo(
      path: '/tmp/$name',
      nombre: name,
      tamanioBytes: bytes,
    );

    test('adds up to 5 files successfully', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(gestionAportarDocumentacionProvider.notifier);

      final result = notifier.addArchivos([
        archivo('a.pdf'),
        archivo('b.docx'),
        archivo('c.zip'),
        archivo('d.xls'),
        archivo('e.xlsx'),
      ]);

      expect(result, isA<AddArchivosAdded>());
      expect(container.read(gestionAportarDocumentacionProvider), hasLength(5));
    });

    test('rejects a 6th file beyond the max of 5', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(gestionAportarDocumentacionProvider.notifier)..addArchivos([archivo('a.pdf'), archivo('b.pdf'), archivo('c.pdf'), archivo('d.pdf'), archivo('e.pdf')]);
      final result = notifier.addArchivos([archivo('f.pdf')]);

      expect(result, isA<AddArchivosRejectedTooMany>());
      expect(container.read(gestionAportarDocumentacionProvider), hasLength(5));
    });

    test('rejects a file larger than 20MB', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(gestionAportarDocumentacionProvider.notifier);

      final result = notifier.addArchivos([archivo('big.pdf', bytes: maxTamanioBytesAportacion + 1)]);

      expect(result, isA<AddArchivosRejectedTooLarge>());
      expect(container.read(gestionAportarDocumentacionProvider), isEmpty);
    });

    test('rejects a file with a disallowed extension', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(gestionAportarDocumentacionProvider.notifier);

      final result = notifier.addArchivos([archivo('script.exe')]);

      expect(result, isA<AddArchivosRejectedInvalidType>());
      expect(container.read(gestionAportarDocumentacionProvider), isEmpty);
    });

    test('rejects a duplicate path', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(gestionAportarDocumentacionProvider.notifier)..addArchivos([archivo('a.pdf')]);
      final result = notifier.addArchivos([archivo('a.pdf')]);

      expect(result, isA<AddArchivosRejectedDuplicate>());
      expect(container.read(gestionAportarDocumentacionProvider), hasLength(1));
    });

    test('removeArchivo removes the matching file by path', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(gestionAportarDocumentacionProvider.notifier)
        ..addArchivos([archivo('a.pdf'), archivo('b.pdf')])
        ..removeArchivo('/tmp/a.pdf');

      final remaining = container.read(gestionAportarDocumentacionProvider);
      expect(remaining, hasLength(1));
      expect(remaining.single.nombre, 'b.pdf');
    });
  });
}
