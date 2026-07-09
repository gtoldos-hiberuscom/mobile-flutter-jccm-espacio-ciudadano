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

    test('beginUpload marks the file as enviando with progreso 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(gestionAportarDocumentacionProvider.notifier)..addArchivos([archivo('a.pdf')]);

      final token = notifier.beginUpload('/tmp/a.pdf');

      final result = container.read(gestionAportarDocumentacionProvider).single;
      expect(result.estado, AportacionArchivoEstado.enviando);
      expect(result.progreso, 0);
      expect(token.isCancelled, isFalse);
    });

    test('updateProgreso only affects the matching file', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(gestionAportarDocumentacionProvider.notifier)
        ..addArchivos([archivo('a.pdf'), archivo('b.pdf')])
        ..beginUpload('/tmp/a.pdf')
        ..beginUpload('/tmp/b.pdf')
        ..updateProgreso('/tmp/a.pdf', 0.5);

      final result = container.read(gestionAportarDocumentacionProvider);
      expect(result.firstWhere((final a) => a.nombre == 'a.pdf').progreso, 0.5);
      expect(result.firstWhere((final a) => a.nombre == 'b.pdf').progreso, 0);
    });

    test('marcarCompletado sets estado completado, clears progreso and stores the hash', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(gestionAportarDocumentacionProvider.notifier)
        ..addArchivos([archivo('a.pdf')])
        ..beginUpload('/tmp/a.pdf')
        ..updateProgreso('/tmp/a.pdf', 0.7)
        ..marcarCompletado('/tmp/a.pdf', 'abc123');

      final result = container.read(gestionAportarDocumentacionProvider).single;
      expect(result.estado, AportacionArchivoEstado.completado);
      expect(result.progreso, isNull);
      expect(result.hash, 'abc123');
    });

    test('marcarError sets estado error and clears progreso', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(gestionAportarDocumentacionProvider.notifier)
        ..addArchivos([archivo('a.pdf')])
        ..beginUpload('/tmp/a.pdf')
        ..marcarError('/tmp/a.pdf');

      final result = container.read(gestionAportarDocumentacionProvider).single;
      expect(result.estado, AportacionArchivoEstado.error);
      expect(result.progreso, isNull);
    });

    test('cancelarSubida cancels the token and reverts to noEnviado', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(gestionAportarDocumentacionProvider.notifier)..addArchivos([archivo('a.pdf')]);
      final token = notifier.beginUpload('/tmp/a.pdf');

      notifier.cancelarSubida('/tmp/a.pdf');

      expect(token.isCancelled, isTrue);
      final result = container.read(gestionAportarDocumentacionProvider).single;
      expect(result.estado, AportacionArchivoEstado.noEnviado);
      expect(result.progreso, isNull);
    });

    test('cancelarTodas cancels every active token', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(gestionAportarDocumentacionProvider.notifier)..addArchivos([archivo('a.pdf'), archivo('b.pdf')]);
      final tokenA = notifier.beginUpload('/tmp/a.pdf');
      final tokenB = notifier.beginUpload('/tmp/b.pdf');

      notifier.cancelarTodas();

      expect(tokenA.isCancelled, isTrue);
      expect(tokenB.isCancelled, isTrue);
    });

    test('marcarErrorTodos reverts every file to error and clears hash/progreso', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(gestionAportarDocumentacionProvider.notifier)
        ..addArchivos([archivo('a.pdf'), archivo('b.pdf')])
        ..beginUpload('/tmp/a.pdf')
        ..marcarCompletado('/tmp/a.pdf', 'hash-a')
        ..beginUpload('/tmp/b.pdf')
        ..marcarCompletado('/tmp/b.pdf', 'hash-b')
        ..marcarErrorTodos();

      final result = container.read(gestionAportarDocumentacionProvider);
      expect(result, everyElement(isA<AportacionArchivo>().having((final a) => a.estado, 'estado', AportacionArchivoEstado.error)));
      expect(result, everyElement(isA<AportacionArchivo>().having((final a) => a.hash, 'hash', isNull)));
    });
  });
}
