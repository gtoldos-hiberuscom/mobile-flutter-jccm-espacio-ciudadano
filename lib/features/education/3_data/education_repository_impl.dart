import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_title.dart';
import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_repository.dart';

/// Mock implementation of [EducationRepository] for STORY-23.
///
/// TODO(STORY-23): replace with the real Dio-backed implementation
/// hitting `/educacion/titulos-universitarios/{numDocumento}` and
/// `/educacion/titulos-no-universitarios/{numDocumento}`.
final class EducationRepositoryImpl implements EducationRepository {
  const EducationRepositoryImpl();

  @override
  Future<EducationSnapshot> loadSnapshot() async {
    final university = <EducationTitle>[
      const EducationTitle(
        id: 'u-1',
        titulacion: 'Grado en Ingeniería Informática',
        centro: 'Universidad de Castilla-La Mancha',
        year: 2014,
      ),
      const EducationTitle(
        id: 'u-2',
        titulacion: 'Máster en Ciberseguridad',
        centro: 'Universidad de Castilla-La Mancha',
        year: 2016,
      ),
    ];
    final nonUniversity = <EducationTitle>[
      const EducationTitle(
        id: 'nu-1',
        titulacion: 'Bachillerato Científico-Tecnológico',
        centro: 'IES Sefarad — Toledo',
        year: 2009,
      ),
      const EducationTitle(
        id: 'nu-2',
        titulacion: 'Certificado de Profesionalidad — Atención al cliente',
        centro: 'Centro Regional de Formación',
        year: 2018,
      ),
    ];
    return EducationSnapshot(
      universityTitles: EducationSection<List<EducationTitle>>.loaded(
        university,
      ),
      nonUniversityTitles: EducationSection<List<EducationTitle>>.loaded(
        nonUniversity,
      ),
    );
  }
}
