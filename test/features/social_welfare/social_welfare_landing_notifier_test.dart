import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/family_numerosa_title.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/social_welfare_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/1_domain/social_welfare_landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/1_domain/social_welfare_repository.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/3_data/social_welfare_repository_provider.dart';

class _FakeSocialWelfareRepository implements SocialWelfareRepository {
  _FakeSocialWelfareRepository(this._snapshot);
  final SocialWelfareSnapshot _snapshot;
  @override
  Future<SocialWelfareSnapshot> loadSnapshot() async => _snapshot;
}

void main() {
  group('SocialWelfareLandingNotifier', () {
    final snapshot = SocialWelfareSnapshot(
      familyNumerosa: SocialWelfareSection<FamilyNumerosaTitle>.loaded(
        FamilyNumerosaTitle(
          numero: 'CLM-FN-2024-0001',
          categoria: 'general',
          fechaCaducidad: DateTime(2029, 12, 31),
          beneficiarios: const <FamilyNumerosaBeneficiary>[],
        ),
      ),
    );

    ProviderContainer container() => ProviderContainer(
          overrides: [
            socialWelfareRepositoryProvider.overrideWith(
              (final ref) => _FakeSocialWelfareRepository(snapshot),
            ),
          ],
        );

    test('initial build exposes the mock snapshot shape', () async {
      final c = container();
      addTearDown(c.dispose);
      final state = await c.read(socialWelfareLandingProvider.future);
      expect(state.familyNumerosa.status, SocialWelfareSectionStatus.loaded);
      expect(state.familyNumerosa.value!.categoria, 'general');
      expect(state.familyNumerosa.value!.numero, 'CLM-FN-2024-0001');
    });

    test('refresh re-runs the repository call', () async {
      final c = container();
      addTearDown(c.dispose);
      await c.read(socialWelfareLandingProvider.future);
      await c.read(socialWelfareLandingProvider.notifier).refresh();
      final state = c.read(socialWelfareLandingProvider).requireValue;
      expect(state.familyNumerosa.value!.numero, 'CLM-FN-2024-0001');
    });
  });
}
