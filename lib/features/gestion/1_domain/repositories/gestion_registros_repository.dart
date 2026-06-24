import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';

abstract interface class GestionRegistrosRepository {
  Future<List<Registro>> loadEntradas({required final String documentNumber});
  Future<List<Registro>> loadSalidas({required final String documentNumber});
}
