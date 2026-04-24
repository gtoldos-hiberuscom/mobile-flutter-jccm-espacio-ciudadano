import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';

/// Domain contract for the Educación landing (STORY-23).
///
// TODO(STORY-23): Sprint-3 implementation returns mocked data. Real
/// wiring against `/educacion/titulos-universitarios/{numDocumento}` and
/// `/educacion/titulos-no-universitarios/{numDocumento}` is owned by a
/// follow-up story.
abstract interface class EducationRepository {
  Future<EducationSnapshot> loadSnapshot();
}
