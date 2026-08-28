import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';

/// Consultas de empleo (SEPE e intermediación).
///
/// `citizenId` es el segmento de la ruta `/ciudadanos/{id}/empleo/...` y
/// `documentNumber` el documento sobre el que se consulta, que viaja en el
/// cuerpo. Coincidían contra la fachada, donde el documento iba en la ruta;
/// contra el gateway la ruta lleva `sub_alt`.
abstract interface class MyDataEmploymentRepository {
  /// Situación como demandante de empleo a fecha actual.
  ///
  /// El contrato marca el nombre y el primer apellido del titular como
  /// obligatorios. Se aceptan nulos porque el único origen posible es el token
  /// y no hay garantía de que Cl@ve informe esos claims: cuando falten se
  /// omiten del cuerpo, que es exactamente lo que se enviaba antes de migrar.
  Future<EmploymentDemand?> loadDemand({
    required final String citizenId,
    required final String documentNumber,
    final String? givenName,
    final String? firstSurname,
    final String? secondSurname,
  });

  /// Ofertas de empleo en las que el ciudadano está inscrito.
  Future<List<EmploymentOfferRegistration>> loadOfferRegistrations({
    required final String citizenId,
    required final String documentNumber,
  });
}
