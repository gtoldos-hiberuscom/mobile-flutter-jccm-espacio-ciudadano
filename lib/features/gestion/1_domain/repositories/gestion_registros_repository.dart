import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';

abstract interface class GestionRegistrosRepository {
  /// [citizenId] es el identificador del ciudadano autenticado para el path
  /// `/ciudadanos/{sid}/...` (sub_alt contra el gateway); [documentNumber] es
  /// el documento real (NIF/NIE/CIF) que viaja en el cuerpo SOAP.
  Future<List<Registro>> loadEntradas({
    required final String citizenId,
    required final String documentNumber,
  });
  Future<List<Registro>> loadSalidas({
    required final String citizenId,
    required final String documentNumber,
  });
}
