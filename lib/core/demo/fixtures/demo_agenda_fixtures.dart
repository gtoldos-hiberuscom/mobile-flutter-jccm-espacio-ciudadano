import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_health_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_my_data_fixtures.dart';

/// Eventos de la agenda general del ciudadano para el modo demostración.
///
/// La agenda real agrega lo que publican otros sistemas, así que los eventos
/// se construyen desde los mismos datos que el resto de fixtures: la primera
/// cita de primaria aparece también aquí —como hace el servicio real, con el
/// detalle dentro del `mensaje` en HTML— para que `AgendaRepositoryImpl` la
/// deduplique por franja y se quede con la de SESCAM, y la caducidad de la
/// tarjeta de estacionamiento coincide con la vigencia que devuelve bienestar
/// social.
abstract final class DemoAgendaFixtures {
  const DemoAgendaFixtures._();

  /// `GET {id}/eventos/TODOS` → `body.eventos[]`.
  ///
  /// [includeHospital] añade la cita hospitalaria pendiente: el backend solo
  /// la publica cuando la sesión tiene nivel suficiente, y la app explica su
  /// ausencia con el aviso «Citas hospitalarias ocultas».
  static Map<String, Object?> eventos(final DateTime now, {final bool includeHospital = false}) {
    final primaryCare = DemoHealthFixtures.primaryCarePendingDates(now).first;
    final hospital = DemoHealthFixtures.hospitalPendingDate(now);
    final notification = DateTime(now.year, now.month, now.day + 5, 23, 30);
    final parkingCard = DemoMyDataFixtures.parkingCardValidUntil(now);
    return {
      'eventos': [
        {
          'fechaVencimiento': demoIsoDateTime(primaryCare),
          'titulo': 'Cita de Atención Primaria',
          'tipoEvento': 'CITA',
          'area': 'SESCAM',
          'mensaje': '<p>Tiene una cita de atención primaria el próximo ${demoShortDate(primaryCare)}</p> <p>Hora:${demoTime(primaryCare)}</p> <p>Profesional:${DemoHealthFixtures.primaryCareProfessional}</p> <p>Tipo de cita:DEMANDA</p> <p>Modo de cita:Presencial</p>',
        },
        if (includeHospital)
          {
            'fechaVencimiento': demoIsoDateTime(hospital),
            'titulo': 'Cita de Atención Hospitalaria',
            'tipoEvento': 'CITA',
            'area': 'SESCAM',
            'mensaje': '<p>Tiene una cita de atención hospitalaria el próximo ${demoShortDate(hospital)}</p> <p>Hora:${demoTime(hospital)}</p> <p>Servicio:${DemoHealthFixtures.hospitalPendingService}</p> <p>Sala:${DemoHealthFixtures.hospitalPendingRoom}</p> <p>Centro:${DemoHealthFixtures.hospitalCenter}</p>',
          },
        {
          'fechaVencimiento': demoIsoDateTime(notification),
          'titulo': 'Caducidad de notificación',
          'tipoEvento': 'EVENTO',
          'area': 'NOTIFICA',
          'mensaje': '<p>Tiene una notificación próxima a caducar:</p> <p>Organismo emisor: Consejería de Bienestar Social</p> <p>Asunto: Resolución de revisión del grado de dependencia</p>',
        },
        {
          'fechaVencimiento': demoIsoDateTime(parkingCard),
          'titulo': 'Caducidad de la tarjeta de estacionamiento',
          'tipoEvento': 'EVENTO',
          'area': 'BIENESTAR_SOCIAL',
          'mensaje': '<p>La tarjeta de estacionamiento para personas con movilidad reducida caduca el próximo ${demoShortDate(parkingCard)}</p>',
        },
      ],
    };
  }

  /// `GET {id}/eventos/refrescar` → `RefrescarAgendaDTO`. La app no muestra
  /// los contadores: recarga los eventos después.
  static const Map<String, Object?> refrescar = {'notificacionesOk': 3, 'notificacionesError': 0};
}
