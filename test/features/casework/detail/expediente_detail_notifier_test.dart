import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_estado.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_fichero.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/1_domain/expediente_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/1_domain/expediente_detail_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/3_data/expediente_detail_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/3_data/expediente_detail_repository_provider.dart';

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

ExpedienteDetail _abiertoFixture() => ExpedienteDetail(
      id: 'x1',
      numero: 'EXP/2025/00123',
      asuntoCodigo: 'AS-1',
      asunto: 'Asunto',
      consejeria: 'Consejería',
      oficinaTramitadora: 'Oficina',
      procedimiento: 'Procedimiento',
      fechaInicio: DateTime(2025, 3, 4),
      fechaUltimaActualizacion: DateTime(2025, 4, 2),
      estado: ExpedienteEstado.abierto,
      ficheros: <ExpedienteFichero>[],
    );

ProviderContainer _container(final ExpedienteDetailRepository repo) {
  final c = ProviderContainer(
    overrides: [
      expedienteDetailRepositoryProvider.overrideWith((final ref) => repo),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('ExpedienteDetailNotifier', () {
    test('emits data on successful load', () async {
      final c = _container(_StubRepo(detail: _abiertoFixture()));
      final detail = await c.read(
        expedienteDetailProvider('EXP/2025/00123').future,
      );
      expect(detail.numero, 'EXP/2025/00123');
      expect(detail.estado, ExpedienteEstado.abierto);
    });

    test('surfaces an error when the repository throws', () async {
      final c = _container(_StubRepo(error: StateError('boom')));
      final asyncValue = await c.read(
        expedienteDetailProvider('EXP/0').future,
      ).then<Object?>((final v) => v).onError<Object>(
            (final e, final _) => e,
          );
      expect(asyncValue, isA<StateError>());
    });
  });

  group('ExpedienteDetailRepositoryImpl mock', () {
    test('returns abierto fixture for EXP/2025/00123 with two files', () async {
      const repo = ExpedienteDetailRepositoryImpl();
      final detail = await repo.loadByNumber('EXP/2025/00123');
      expect(detail.estado, ExpedienteEstado.abierto);
      expect(detail.estado.permiteAportacion, isTrue);
      expect(detail.ficheros, hasLength(2));
    });

    test('returns cerrado fixture for EXP/2025/00098 with one file', () async {
      const repo = ExpedienteDetailRepositoryImpl();
      final detail = await repo.loadByNumber('EXP/2025/00098');
      expect(detail.estado, ExpedienteEstado.cerrado);
      expect(detail.estado.permiteAportacion, isFalse);
      expect(detail.ficheros, hasLength(1));
    });

    test('throws StateError for unknown numbers', () async {
      const repo = ExpedienteDetailRepositoryImpl();
      await expectLater(
        repo.loadByNumber('EXP/UNKNOWN'),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('ExpedienteEstado', () {
    test('only abierto allows aportación', () {
      expect(ExpedienteEstado.abierto.permiteAportacion, isTrue);
      expect(ExpedienteEstado.cerrado.permiteAportacion, isFalse);
      expect(ExpedienteEstado.unknown.permiteAportacion, isFalse);
    });
  });
}
