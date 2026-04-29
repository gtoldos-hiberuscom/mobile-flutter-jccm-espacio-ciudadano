import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_search_query.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_search_result.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_search_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';

class _StubRepo implements CaseworkRepository {
  _StubRepo({this.byNif, this.throwOn});

  final List<CaseworkItem>? byNif;
  final CaseworkSearchField? throwOn;

  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) async => <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByNif(final String identification) async {
    if (throwOn == CaseworkSearchField.identification) {
      throw StateError('boom');
    }
    return byNif ?? const <CaseworkItem>[];
  }

  @override
  Future<List<CaseworkItem>> searchByExpedienteNumber(
    final String number,
  ) async {
    if (throwOn == CaseworkSearchField.expedienteNumber) {
      throw StateError('boom');
    }
    return const <CaseworkItem>[];
  }

  @override
  Future<List<CaseworkItem>> searchByRegistroNumber(final String number) async {
    if (throwOn == CaseworkSearchField.registroNumber) {
      throw StateError('boom');
    }
    return const <CaseworkItem>[];
  }
}

ProviderContainer _container(final CaseworkRepository repo) {
  final c = ProviderContainer(
    overrides: [
      caseworkRepositoryProvider.overrideWith((final ref) => repo),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

CaseworkItem _item(final String id) => CaseworkItem(
  id: id,
  type: CaseworkTab.expedientes,
  number: 'EXP/2025/$id',
  date: DateTime(2025, 6),
  organism: 'Org',
  subject: 'Subject',
  status: CaseworkItemStatus.enTramite,
);

void main() {
  group('CaseworkSearchNotifier', () {
    test('initial state is idle', () {
      final c = _container(_StubRepo());
      final state = c.read(caseworkSearchProvider);
      expect(state.result.status, CaseworkSearchStatus.idle);
      expect(state.showValidation, isFalse);
    });

    test('submit with empty query surfaces a validation error', () async {
      final c = _container(_StubRepo());
      await c.read(caseworkSearchProvider.notifier).submit();
      final state = c.read(caseworkSearchProvider);
      expect(state.showValidation, isTrue);
      expect(state.validation.generalError, CaseworkSearchValidationError.noInputProvided);
      expect(state.result.status, CaseworkSearchStatus.idle);
    });

    test('valid NIF query transitions idle → results', () async {
      final c = _container(_StubRepo(byNif: <CaseworkItem>[_item('1')]));
      final n = c.read(caseworkSearchProvider.notifier)..updateField(CaseworkSearchField.identification, '12345678Z');
      await n.submit();
      final state = c.read(caseworkSearchProvider);
      expect(state.result.status, CaseworkSearchStatus.results);
      expect(state.result.items, hasLength(1));
      expect(state.result.executedField, CaseworkSearchField.identification);
    });

    test('expediente search yielding zero items maps to noResults', () async {
      final c = _container(_StubRepo());
      final n = c.read(caseworkSearchProvider.notifier)..updateField(CaseworkSearchField.expedienteNumber, 'EXP/2025/00123');
      await n.submit();
      final state = c.read(caseworkSearchProvider);
      expect(state.result.status, CaseworkSearchStatus.noResults);
      expect(state.result.items, isEmpty);
      expect(state.result.executedField, CaseworkSearchField.expedienteNumber);
    });

    test('repository throwing maps to error state', () async {
      final c = _container(
        _StubRepo(throwOn: CaseworkSearchField.registroNumber),
      );
      final n = c.read(caseworkSearchProvider.notifier)..updateField(CaseworkSearchField.registroNumber, 'REG/E/45612');
      await n.submit();
      final state = c.read(caseworkSearchProvider);
      expect(state.result.status, CaseworkSearchStatus.error);
      expect(state.result.executedField, CaseworkSearchField.registroNumber);
    });

    test('reset clears the state back to idle', () async {
      final c = _container(_StubRepo(byNif: <CaseworkItem>[_item('1')]));
      final n = c.read(caseworkSearchProvider.notifier)..updateField(CaseworkSearchField.identification, '12345678Z');
      await n.submit();
      n.reset();
      final state = c.read(caseworkSearchProvider);
      expect(state.result.status, CaseworkSearchStatus.idle);
      expect(state.query.identification, isEmpty);
      expect(state.showValidation, isFalse);
    });
  });

  group('CaseworkRepositoryImpl mock search', () {
    test('searchByNif returns three deterministic items', () async {
      const repo = CaseworkRepositoryImpl();
      final items = await repo.searchByNif('12345678Z');
      expect(items, hasLength(3));
    });

    test('searchByExpedienteNumber returns zero items (no-results state)', () async {
      const repo = CaseworkRepositoryImpl();
      final items = await repo.searchByExpedienteNumber('EXP/2025/00123');
      expect(items, isEmpty);
    });

    test('searchByRegistroNumber throws (error state)', () async {
      const repo = CaseworkRepositoryImpl();
      await expectLater(
        repo.searchByRegistroNumber('REG/E/1'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
