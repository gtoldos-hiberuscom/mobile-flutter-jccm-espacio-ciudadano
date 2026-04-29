import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';

/// Domain contract for the Educación landing.
abstract interface class EducationRepository {
  Future<EducationSnapshot> loadSnapshot();
}
