import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_agenda_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_consent_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_contact_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_digital_cards_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_gestion_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_my_data_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_personalization_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_recommendations_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_support_routes.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';

/// Backend ficticio del modo demostración: el estado en memoria de la persona
/// ficticia más la tabla de rutas que lo lee y lo muta.
///
/// Vive lo que vive el `Dio` de la sesión demo: `dioProvider` lo construye al
/// entrar y lo suelta al cerrar sesión, así que cada demostración empieza
/// limpia. La única entrada persistida es la semilla de consentimiento (ver
/// [DemoBackend.seeded]).
final class DemoBackend {
  DemoBackend({required final List<DemoRoute> routes, required this.now}) : _router = DemoRouter(routes);

  /// Estado inicial para una sesión demo.
  ///
  /// Mira en [storage] si esta identidad ya aceptó las cláusulas: tras un
  /// reinicio con acceso rápido activado la sesión demo se reanuda del
  /// almacén seguro, y si el backend volviera a nacer sin consentimiento el
  /// `SessionGuard` encontraría «sesión guardada + consentimiento no aceptado»
  /// y la cerraría. Las dos claves las escribe `ConsentRepositoryImpl` sólo
  /// tras una respuesta confirmada, así que son evidencia fiable.
  factory DemoBackend.seeded({required final AppStorage storage, required final DateTime Function() now}) {
    final consent = DemoConsentState(
      now: now,
      seededAccepted: storage.read<bool>('${StorageKeys.consentAcceptedPrefix}${DemoSession.idAgente}') ?? false,
      seededAcceptedClauseIds: _seededAcceptedClauseIds(storage),
    );
    final personalization = DemoPersonalizationState(now: now);
    final contact = DemoContactState();
    return DemoBackend(
      routes: <DemoRoute>[
        ...demoConsentRoutes(consent),
        ...demoPersonalizationRoutes(personalization, consent: consent),
        ...demoRecommendationsRoutes(personalization: personalization, now: now),
        ...demoContactRoutes(contact),
        // Las rutas de salud viven en my_data y las comparte la agenda: la
        // de citas pendientes de primaria sirve a `SaludApi` y a `SescamApi`.
        ...demoMyDataRoutes(now: now),
        ...demoAgendaRoutes(now: now),
        ...demoGestionRoutes(DemoGestionState(now: now)),
        ...demoDigitalCardsRoutes(now: now),
        ...demoSupportRoutes(),
      ],
      now: now,
    );
  }

  /// Ids de cláusula aceptados que `ConsentRepositoryImpl` dejó en caché
  /// (`List<String>` con los `idClausula`). Lo ilegible se ignora.
  static Set<int> _seededAcceptedClauseIds(final AppStorage storage) {
    final cached = storage.read<List<String>>('${StorageKeys.consentAcceptedClausesPrefix}${DemoSession.idAgente}') ?? const <String>[];
    return <int>{
      for (final raw in cached)
        if (int.tryParse(raw) case final int id) id,
    };
  }

  final DemoRouter _router;

  /// Reloj del backend, inyectable para fixtures con fechas relativas.
  final DateTime Function() now;

  List<DemoRoute> get routes => _router.routes;

  DemoResponse handle(final DemoRequest request) => _router.handle(request);
}
