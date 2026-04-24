import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/cip_summary.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/cip_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/cip_summary_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/cip_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/cip_repository_provider.dart';

class _SequencedRepo implements CipRepository {
  _SequencedRepo(this._snapshots);
  final List<CipSummary> _snapshots;
  int _idx = 0;
  @override
  Future<CipSummary> loadCip() async {
    final snap = _snapshots[_idx.clamp(0, _snapshots.length - 1)];
    _idx++;
    return snap;
  }
}

void main() {
  group('CipSummaryNotifier', () {
    test('default stub repository transitions loading → loaded with the '
        'deterministic CLM01234567 payload', () async {
      final container = ProviderContainer(
        overrides: [
          cipRepositoryProvider.overrideWith(
            (final ref) => CipRepositoryImpl(clock: () => DateTime(2026, 5, 4)),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Reading the future starts in `loading` and resolves to `data`.
      expect(container.read(cipSummaryProvider).isLoading, isTrue);
      final value = await container.read(cipSummaryProvider.future);
      expect(value.loadState, CipLoadState.loaded);
      expect(value.cipCode, 'CLM01234567');
      expect(value.titular, 'María Ejemplo');
      expect(value.lastUpdatedAt, DateTime(2026, 5, 4));
    });

    test('parse-error path is propagated as CipLoadState.parseError', () async {
      final parseError = CipSummary(
        id: 'cip-parse-error',
        cipCode: '',
        lastUpdatedAt: DateTime(2026, 5, 4),
        loadState: CipLoadState.parseError,
        parseErrorReason: 'unknown_shape',
      );
      final container = ProviderContainer(
        overrides: [
          cipRepositoryProvider.overrideWith((final ref) => _SequencedRepo([parseError])),
        ],
      );
      addTearDown(container.dispose);

      final value = await container.read(cipSummaryProvider.future);
      expect(value.loadState, CipLoadState.parseError);
      expect(value.parseErrorReason, 'unknown_shape');
      // Notifier stays in AsyncValue.data, not error.
      expect(container.read(cipSummaryProvider).hasError, isFalse);
    });

    test('refresh re-invokes the repository', () async {
      var calls = 0;
      final repo = _CountingRepo(onLoad: () => calls++);
      final container = ProviderContainer(
        overrides: [
          cipRepositoryProvider.overrideWith((final ref) => repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(cipSummaryProvider.future);
      expect(calls, 1);
      await container.read(cipSummaryProvider.notifier).refresh();
      expect(calls, 2);
    });
  });
}

class _CountingRepo implements CipRepository {
  _CountingRepo({required this.onLoad});
  final void Function() onLoad;
  @override
  Future<CipSummary> loadCip() async {
    onLoad();
    return CipSummary(
      id: 'cip-x',
      cipCode: 'X',
      lastUpdatedAt: DateTime(2026, 5, 4),
      loadState: CipLoadState.loaded,
    );
  }
}
