import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/family_numerosa_title.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/social_welfare_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/1_domain/social_welfare_repository.dart';

/// Mock implementation of [SocialWelfareRepository] for STORY-25.
///
/// TODO(STORY-25): replace with the real Dio-backed implementation
/// hitting `/ccaa/familia-numerosa/{numDocumento}`.
final class SocialWelfareRepositoryImpl implements SocialWelfareRepository {
  const SocialWelfareRepositoryImpl();

  @override
  Future<SocialWelfareSnapshot> loadSnapshot() async => SocialWelfareSnapshot(
    familyNumerosa: SocialWelfareSection<FamilyNumerosaTitle>.loaded(
      FamilyNumerosaTitle(
        numero: 'CLM-FN-2024-0123',
        categoria: 'general',
        fechaCaducidad: DateTime(2029, 12, 31),
        beneficiarios: <FamilyNumerosaBeneficiary>[
          FamilyNumerosaBeneficiary(
            relacion: 'titular',
            fechaNacimiento: DateTime(1985, 6, 12),
          ),
          FamilyNumerosaBeneficiary(
            relacion: 'conyuge',
            fechaNacimiento: DateTime(1986, 9, 4),
          ),
          FamilyNumerosaBeneficiary(
            relacion: 'hijo',
            fechaNacimiento: DateTime(2014, 1, 22),
          ),
          FamilyNumerosaBeneficiary(
            relacion: 'hijo',
            fechaNacimiento: DateTime(2017, 8, 30),
          ),
          FamilyNumerosaBeneficiary(
            relacion: 'hijo',
            fechaNacimiento: DateTime(2021, 3, 15),
          ),
        ],
      ),
    ),
  );
}
