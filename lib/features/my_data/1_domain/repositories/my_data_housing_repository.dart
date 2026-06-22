import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/housing_address.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/real_estate_property.dart';

abstract interface class MyDataHousingRepository {
  Future<HousingAddress?> loadAddress({
    required final String documentNumber,
  });

  Future<List<RealEstateProperty>> loadRealEstateProperties({
    required final String documentNumber,
  });
}
