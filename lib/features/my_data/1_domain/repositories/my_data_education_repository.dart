import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/non_university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/university_title.dart';

/// Repository contract for education data.
///
/// `citizenId` es el segmento de la ruta `/ciudadanos/{id}/...` y
/// `documentNumber` el documento consultado, que viaja en el cuerpo. Coinciden
/// contra la fachada, pero no contra el gateway, donde la ruta lleva `sub_alt`.
abstract interface class MyDataEducationRepository {
  /// Fetches university titles for the given document number.
  ///
  /// Returns a list of [UniversityTitle] objects.
  /// Throws on network or API errors.
  Future<List<UniversityTitle>> loadUniversityTitles({
    required final String citizenId,
    required final String documentNumber,
  });

  /// Fetches non-university titles for the given document number.
  ///
  /// Returns a list of [NonUniversityTitle] objects.
  /// Throws on network or API errors.
  Future<List<NonUniversityTitle>> loadNonUniversityTitles({
    required final String citizenId,
    required final String documentNumber,
  });
}
