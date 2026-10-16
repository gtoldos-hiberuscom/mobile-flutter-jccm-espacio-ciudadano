import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_my_data_fixtures.dart';

/// Datos ficticios de salud (SESCAM) para el modo demostración.
///
/// Las citas se calculan desde `now`: las pendientes caen siempre en el
/// futuro y las pasadas en el pasado, cualquiera que sea el día de la demo.
/// Son las formas que parsea `MyDataHealthRepositoryImpl` y, en el caso de
/// primaria pendientes, también `AgendaRepositoryImpl` a través de
/// `SescamApi`: `body.listaCitas` con los datos del centro al nivel de `body`.
abstract final class DemoHealthFixtures {
  const DemoHealthFixtures._();

  /// CIP con la forma del SESCAM: cuatro letras y doce dígitos.
  static const String cip = 'EJDE850612000012';

  /// `GET {id}/salud/cip`.
  static const Map<String, Object?> cipBody = {'cip': cip};

  static const String primaryCareCenter = 'C.S. BUENAVISTA';

  /// Profesional de la primera cita pendiente. Público porque la agenda
  /// general lo publica dentro del mensaje de su evento, igual que el real.
  static const String primaryCareProfessional = 'MANCHA ALCARRIA SAGRA';

  static const String _nurse = 'JARA MONTES CAMPANA';

  /// Fechas de las dos citas pendientes de primaria, ascendentes. Públicas
  /// porque la agenda general publica la primera también como evento, para que
  /// la deduplicación por franja de `AgendaRepositoryImpl` tenga trabajo.
  static List<DateTime> primaryCarePendingDates(final DateTime now) => [
    DateTime(now.year, now.month, now.day + 6, 9, 40),
    DateTime(now.year, now.month, now.day + 20, 8, 15),
  ];

  /// `GET {id}/salud/primaria-citas-pendientes`.
  static Map<String, Object?> primaryCarePending(final DateTime now) {
    final dates = primaryCarePendingDates(now);
    return {
      ..._primaryCareCenterData,
      'listaCitas': [
        _primaryCare(dates[0], professional: primaryCareProfessional, type: 'DEMANDA', modality: 'Presencial'),
        _primaryCare(dates[1], professional: _nurse, type: 'ANALITICA', modality: 'Presencial'),
      ],
    };
  }

  /// `GET {id}/salud/primaria-citas-pasadas?pagina=N`.
  ///
  /// Paginado desde 0 como hace el gateway (`PastPrimaryCareAppointmentsNotifier`
  /// empieza en `page: 0`). Todo cabe en la primera página; las siguientes
  /// vienen vacías, que es la única señal de fin que da el backend y la que
  /// corta el scroll infinito.
  static Map<String, Object?> primaryCarePast(final DateTime now, {required final int page}) {
    if (page > 0) {
      return {..._primaryCareCenterData, 'listaCitas': <Object?>[]};
    }
    return {
      ..._primaryCareCenterData,
      'listaCitas': [
        _primaryCare(DateTime(now.year, now.month, now.day - 12, 12), professional: primaryCareProfessional, type: 'DEMANDA', modality: 'Presencial'),
        _primaryCare(DateTime(now.year, now.month, now.day - 45, 9, 30), professional: primaryCareProfessional, type: 'TELECONSULTA DEMANDA', modality: 'Telefónica'),
        _primaryCare(DateTime(now.year, now.month, now.day - 80, 10, 10), professional: _nurse, type: 'ANALITICA', modality: 'Presencial'),
      ],
    };
  }

  /// `GET {id}/salud/hospitalaria-citas-pendientes`: `body` es un array de
  /// `CitaHospitalariaDetalleSescam`.
  static List<Object?> hospitalPending(final DateTime now) => [
    _hospital(DateTime(now.year, now.month, now.day + 33, 8, 30), id: '90000001', service: 'TRAUMATOLOGIA', provision: 'CONSULTA SUCESIVA', room: 'CONSULTA 12 - PLANTA 1', agendaCode: 'TRAU-D', agenda: 'TRAUMATOLOGIA 4 - CONSULTAS EXTERNAS', status: 'PENDIENTE'),
  ];

  /// `GET {id}/salud/hospitalaria-citas-pasadas`: dos citas en meses
  /// distintos, para que el listado agrupado por mes tenga más de un grupo.
  static List<Object?> hospitalPast(final DateTime now) => [
    _hospital(DateTime(now.year, now.month, now.day - 60, 10), id: '90000002', service: 'OFTALMOLOGIA', provision: 'PRIMERA CONSULTA', room: 'CONSULTA 3 - PLANTA BAJA', agendaCode: 'OFTA-A', agenda: 'OFTALMOLOGIA 1 - CONSULTAS EXTERNAS', status: 'REALIZADA'),
    _hospital(DateTime(now.year, now.month, now.day - 125, 9, 15), id: '90000003', service: 'TRAUMATOLOGIA', provision: 'PRIMERA CONSULTA', room: 'CONSULTA 12 - PLANTA 1', agendaCode: 'TRAU-D', agenda: 'TRAUMATOLOGIA 4 - CONSULTAS EXTERNAS', status: 'REALIZADA'),
  ];

  /// Datos del centro, que el contrato de primaria informa una sola vez al
  /// nivel de `body` y el repositorio fusiona en cada cita.
  static const Map<String, Object?> _primaryCareCenterData = {
    'nombreCentro': primaryCareCenter,
    'dirCentro': 'AVDA. DE LA DEMOSTRACIÓN, 1 (Toledo)',
    'municipioCentro': 'TOLEDO',
  };

  static Map<String, Object?> _primaryCare(final DateTime date, {required final String professional, required final String type, required final String modality}) => {
    'fecha': demoShortDate(date),
    'hora': demoTime(date),
    'nomModoVisita': modality,
    'nomProfesionalRealizador': professional,
    'nomTvisita': type,
  };

  static Map<String, Object?> _hospital(
    final DateTime date, {
    required final String id,
    required final String service,
    required final String provision,
    required final String room,
    required final String agendaCode,
    required final String agenda,
    required final String status,
  }) => {
    'id': id,
    'nhc': '00000042',
    'servicio': service,
    'prestacion': provision,
    'sala': room,
    'estadoCita': status,
    'centro': {'nombre': 'HOSPITAL UNIVERSITARIO DE TOLEDO'},
    'agenda': {'codigo': agendaCode, 'descripcion': agenda},
    'fecha': demoShortDate(date),
    'hora': demoTime(date),
  };
}
