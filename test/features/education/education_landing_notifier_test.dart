import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_title.dart';
import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_repository.dart';
import 'package:jccm_espacio_ciudadano/features/education/3_data/education_repository_provider.dart';

class _FakeEducationRepository implements EducationRepository {
  _FakeEducationRepository(this._snapshot);
  final EducationSnapshot _snapshot;
  @override
  Future<EducationSnapshot> loadSnapshot() async => _snapshot;
}

void main() {
  group('EducationLandingNotifier', () {
    final snapshot = EducationSnapshot(
      universityTitles: EducationSection<List<EducationTitle>>.loaded(
        const <EducationTitle>[
          EducationTitle(
            id: 'u-1',
            titulacion: 'Grado en Informática',
            centro: 'UCLM',
            year: 2014,
          ),
        ],
      ),
      nonUniversityTitles: EducationSection<List<EducationTitle>>.loaded(
        const <EducationTitle>[
          EducationTitle(
            id: 'nu-1',
            titulacion: 'Bachillerato',
            centro: 'IES Sefarad',
            year: 2009,
          ),
        ],
      ),
    );

    ProviderContainer container() => ProviderContainer(
      overrides: [
        educationRepositoryProvider.overrideWith(
          (final ref) => _FakeEducationRepository(snapshot),
        ),
      ],
    );

    test('initial build exposes the mock snapshot shape', () async {
      final c = container();
      addTearDown(c.dispose);
      final state = await c.read(educationLandingProvider.future);
      expect(state.universityTitles.status, EducationSectionStatus.loaded);
      expect(state.universityTitles.value!.first.titulacion, 'Grado en Informática');
      expect(state.nonUniversityTitles.status, EducationSectionStatus.loaded);
      expect(state.nonUniversityTitles.value!.length, 1);
    });

    test('refresh re-runs the repository call', () async {
      final c = container();
      addTearDown(c.dispose);
      await c.read(educationLandingProvider.future);
      await c.read(educationLandingProvider.notifier).refresh();
      final state = c.read(educationLandingProvider).requireValue;
      expect(state.universityTitles.value!.length, 1);
    });
  });
}
