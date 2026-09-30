import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_lote.dart';

AportacionArchivo _archivo(final String nombre, final AportacionArchivoEstado estado, {final String? hash}) => AportacionArchivo(path: '/tmp/$nombre', nombre: nombre, tamanioBytes: 64, estado: estado, hash: hash);

void main() {
  group('AportacionLote', () {
    test('un lote vacío no se puede registrar', () {
      const lote = AportacionLote();

      expect(lote.todosSubidos, isFalse);
      expect(lote.puedeRegistrar, isFalse);
      expect(lote.haySubidasEnCurso, isFalse);
    });

    test('se puede registrar solo con TODOS los ficheros subidos', () {
      final completo = AportacionLote(
        archivos: [
          _archivo('uno.pdf', AportacionArchivoEstado.completado, hash: 'h1'),
          _archivo('dos.pdf', AportacionArchivoEstado.completado, hash: 'h2'),
        ],
      );

      expect(completo.puedeRegistrar, isTrue);

      // Un fichero en error o sin enviar basta para bloquear el cierre: cada
      // entrada de `documentos` necesita el hash de su subida.
      for (final pendiente in [AportacionArchivoEstado.error, AportacionArchivoEstado.noEnviado, AportacionArchivoEstado.enviando]) {
        final lote = completo.copyWith(
          archivos: [completo.archivos.first, _archivo('dos.pdf', pendiente)],
        );
        expect(lote.puedeRegistrar, isFalse, reason: 'estado $pendiente');
      }
    });

    test('mientras se cierra la transacción no se registra ni se edita la lista', () {
      final lote = AportacionLote(
        archivos: [_archivo('uno.pdf', AportacionArchivoEstado.completado, hash: 'h1')],
        cerrando: true,
      );

      expect(lote.todosSubidos, isTrue);
      expect(lote.puedeRegistrar, isFalse);
      expect(lote.puedeEditarLista, isFalse);
    });

    test('con la cola parada y algún fichero en error se puede reintentar y registrar', () {
      final lote = AportacionLote(
        archivos: [
          _archivo('uno.pdf', AportacionArchivoEstado.completado, hash: 'h1'),
          _archivo('dos.pdf', AportacionArchivoEstado.error),
        ],
      );

      expect(lote.puedeRegistrar, isFalse);
      expect(lote.puedeReintentarYRegistrar, isTrue);

      // Con algo todavía subiendo o por subir, la cola no ha terminado.
      for (final enCola in [AportacionArchivoEstado.enviando, AportacionArchivoEstado.noEnviado]) {
        final conCola = lote.copyWith(archivos: [...lote.archivos, _archivo('tres.pdf', enCola)]);
        expect(conCola.puedeReintentarYRegistrar, isFalse, reason: 'estado $enCola');
      }
      // Sin ningún fallido no hay nada que reintentar.
      expect(AportacionLote(archivos: [lote.archivos.first]).puedeReintentarYRegistrar, isFalse);
      expect(lote.copyWith(cerrando: true).puedeReintentarYRegistrar, isFalse);
    });

    test('mientras se reintenta para registrar no se registra ni se edita la lista', () {
      final lote = AportacionLote(
        archivos: [_archivo('uno.pdf', AportacionArchivoEstado.completado, hash: 'h1')],
        reintentandoParaRegistrar: true,
      );

      expect(lote.puedeRegistrar, isFalse);
      expect(lote.puedeReintentarYRegistrar, isFalse);
      expect(lote.puedeEditarLista, isFalse);
    });

    test('haySubidasEnCurso solo con algún fichero enviando', () {
      final subiendo = AportacionLote(archivos: [_archivo('uno.pdf', AportacionArchivoEstado.enviando)]);
      final parado = AportacionLote(archivos: [_archivo('uno.pdf', AportacionArchivoEstado.error)]);

      expect(subiendo.haySubidasEnCurso, isTrue);
      expect(parado.haySubidasEnCurso, isFalse);
    });

    test('clearError descarta el fallo pendiente y copyWith sin él lo conserva', () {
      const lote = AportacionLote(error: AportacionLoteError(tipo: AportacionLoteErrorTipo.cierre, secuencia: 1));

      expect(lote.copyWith(cerrando: true).error, isNotNull);
      expect(lote.copyWith(clearError: true).error, isNull);
    });

    test('dos lotes con los mismos ficheros son iguales', () {
      final uno = AportacionLote(archivos: [_archivo('uno.pdf', AportacionArchivoEstado.completado, hash: 'h1')]);
      final otro = AportacionLote(archivos: [_archivo('uno.pdf', AportacionArchivoEstado.completado, hash: 'h1')]);

      // `List.==` es identidad: sin comparación elemento a elemento, dos
      // estados idénticos se tomarían por distintos y repintarían de más.
      expect(uno, otro);
      expect(uno.hashCode, otro.hashCode);
    });

    test('el mismo fallo repetido cambia de estado por la secuencia', () {
      const primero = AportacionLoteError(tipo: AportacionLoteErrorTipo.cierre, secuencia: 1);
      const segundo = AportacionLoteError(tipo: AportacionLoteErrorTipo.cierre, secuencia: 2);

      // Reintentar el cierre y volver a fallar tiene que avisar otra vez.
      expect(primero, isNot(segundo));
    });
  });
}
