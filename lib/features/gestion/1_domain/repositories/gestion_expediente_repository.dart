import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';

abstract interface class GestionExpedienteRepository {
  /// [citizenId] es el identificador del ciudadano autenticado para el path
  /// `/ciudadanos/{sid}/...` (sub_alt contra el gateway); [documentNumber] es
  /// el documento real (NIF/NIE/CIF) que viaja en el cuerpo SOAP.
  Future<List<Expediente>> loadExpedientes({
    required final String citizenId,
    required final String documentNumber,
  });

  Future<Expediente> loadExpedienteDetail({
    required final String citizenId,
    required final String documentNumber,
    required final String numexp,
    final String tipodoc = 'NIF',
  });

  Future<Expediente> loadExpedienteByRegistro({
    required final String citizenId,
    required final String documentNumber,
    required final String numRegistro,
    final String tipodoc = 'NIF',
  });
}
