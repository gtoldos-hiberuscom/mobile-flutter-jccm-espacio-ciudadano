import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/dependency_care_status.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/disability_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/large_family_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/parking_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/thermal_spa_award.dart';

/// Consultas de bienestar social por intermediación.
///
/// `citizenId` es el segmento de la ruta `/ciudadanos/{id}/...` y `documentNumber`
/// el documento sobre el que se consulta, que viaja en el cuerpo. Coinciden
/// contra la fachada en familia numerosa, pero no en el resto ni contra el
/// gateway, donde la ruta lleva `sub_alt`.
abstract interface class MyDataSocialWelfareRepository {
  Future<LargeFamilyTitle?> loadLargeFamilyTitle({
    required final String citizenId,
    required final String documentNumber,
  });

  Future<DisabilityTitle?> loadDisabilityTitle({
    required final String citizenId,
    required final String documentNumber,
  });

  Future<ThermalSpaAward?> loadThermalSpaAward({
    required final String citizenId,
    required final String documentNumber,
  });

  Future<DependencyCareStatus?> loadDependencyCareStatus({
    required final String citizenId,
    required final String documentNumber,
  });

  Future<ParkingCard?> loadParkingCard({
    required final String citizenId,
    required final String documentNumber,
  });
}
