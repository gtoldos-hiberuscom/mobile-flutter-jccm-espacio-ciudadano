import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_seeker_status.dart';
import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/employment/1_domain/employment_landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/employment/1_domain/employment_repository.dart';
import 'package:jccm_espacio_ciudadano/features/employment/3_data/employment_repository_provider.dart';

class _FakeEmploymentRepository implements EmploymentRepository {
  _FakeEmploymentRepository(this._snapshot);
  final EmploymentSnapshot _snapshot;
  @override
  Future<EmploymentSnapshot> loadSnapshot() async => _snapshot;
}

void main() {
  group('EmploymentLandingNotifier', () {
    final snapshot = EmploymentSnapshot(
      seekerStatus: EmploymentSection<EmploymentSeekerStatus>.loaded(
        EmploymentSeekerStatus(
          estado: 'inscrito',
          fechaInscripcion: DateTime(2025, 11, 12),
          fechaContinuidad: DateTime(2026, 4, 12),
        ),
      ),
    );

    ProviderContainer container() => ProviderContainer(
          overrides: [
            employmentRepositoryProvider.overrideWith(
              (final ref) => _FakeEmploymentRepository(snapshot),
            ),
          ],
        );

    test('initial build exposes the mock snapshot shape', () async {
      final c = container();
      addTearDown(c.dispose);
      final state = await c.read(employmentLandingProvider.future);
      expect(state.seekerStatus.status, EmploymentSectionStatus.loaded);
      expect(state.seekerStatus.value!.estado, 'inscrito');
    });

    test('refresh re-runs the repository call', () async {
      final c = container();
      addTearDown(c.dispose);
      await c.read(employmentLandingProvider.future);
      await c.read(employmentLandingProvider.notifier).refresh();
      final state = c.read(employmentLandingProvider).requireValue;
      expect(state.seekerStatus.value!.estado, 'inscrito');
    });
  });
}
