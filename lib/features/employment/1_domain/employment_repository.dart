import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_snapshot.dart';

/// Domain contract for the Empleo landing (STORY-24).
///
// TODO(STORY-24): Sprint-3 implementation returns mocked data. Real
/// wiring against `/sepe/demandante-empleo-fecha-actual/{numDocumento}`
/// is owned by a follow-up story.
abstract interface class EmploymentRepository {
  Future<EmploymentSnapshot> loadSnapshot();
}
