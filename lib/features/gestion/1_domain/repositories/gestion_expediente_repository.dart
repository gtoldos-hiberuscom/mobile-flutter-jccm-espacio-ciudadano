import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';

abstract interface class GestionExpedienteRepository {
  Future<List<Expediente>> loadExpedientes({required final String documentNumber});

  Future<Expediente> loadExpedienteDetail({
    required final String documentNumber,
    required final String numexp,
  });
}
