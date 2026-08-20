import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/housing_address.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/real_estate_property.dart';

/// Consultas de vivienda: padrón (INE) y catastro.
///
/// `citizenId` es el segmento de la ruta `/ciudadanos/{id}/vivienda/...` y
/// `documentNumber` el documento sobre el que se consulta, que viaja en el
/// cuerpo. Coincidían mientras el documento iba en la ruta; contra el gateway
/// la ruta lleva `sub_alt`.
abstract interface class MyDataHousingRepository {
  Future<HousingAddress?> loadAddress({
    required final String citizenId,
    required final String documentNumber,
  });

  Future<List<RealEstateProperty>> loadRealEstateProperties({
    required final String citizenId,
    required final String documentNumber,
  });
}
