import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';

abstract interface class GestionNotificacionesRepository {
  Future<List<Notificacion>> loadNotificaciones({
    required final String citizenId,
    final String? estado,
  });
}
