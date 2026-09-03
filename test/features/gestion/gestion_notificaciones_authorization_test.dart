import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/consent_revocation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_notificaciones_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';

void main() {
  late _RejectingNotificacionesRepository notificaciones;
  late _ClausesConsentRepository consent;
  late _RecordingRevocationNotifier revocation;

  ProviderContainer buildContainer() {
    revocation = _RecordingRevocationNotifier();
    final container = ProviderContainer(
      // Riverpod reintenta con espera creciente los providers que fallan; en
      // producción los desenlaces de autorización se excluyen en el propio
      // provider, y aquí se desactiva del todo para que el test no espere.
      retry: (final _, final _) => null,
      overrides: [
        ciudadanosEndpointIdProvider.overrideWithValue('f5b3ec2b'),
        citizenEndpointIdsProvider.overrideWithValue((numDocumento: 'f5b3ec2b', idAgente: 'f5b3ec2b')),
        gestionNotificacionesRepositoryProvider.overrideWithValue(notificaciones),
        consentRepositoryProvider.overrideWithValue(consent),
        consentRevocationProvider.overrideWith(() => revocation),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Mantiene vivo el provider `autoDispose` mientras se espera su future: sin
  /// un oyente, la resolución de la autorización introduce un hueco asíncrono
  /// suficiente para que Riverpod lo tire antes de emitir.
  Future<T> readAlive<T>(final ProviderContainer container, final FutureProvider<T> provider) {
    final subscription = container.listen(provider, (final _, final _) {}, onError: (final _, final _) {});
    addTearDown(subscription.close);
    return container.read(provider.future);
  }

  setUp(() {
    notificaciones = _RejectingNotificacionesRepository();
    consent = _ClausesConsentRepository();
    _revocationSignals = 0;
  });

  test('cláusula obligatoria retirada: la pantalla recibe ConsentRevoked y se cierra la sesión', () async {
    consent.clauses = [const Clause(id: requiredConsentClauseId, label: 'Protección de datos', isSelected: false)];
    final container = buildContainer();

    await expectLater(
      readAlive(container, gestionNotificacionesProvider(null)),
      throwsA(isA<ConsentRevoked>()),
    );
    expect(_revocationSignals, 1);
  });

  test('cláusula obligatoria aceptada: el rechazo no era de consentimiento y no se cierra la sesión', () async {
    consent.clauses = [const Clause(id: requiredConsentClauseId, label: 'Protección de datos', isSelected: true)];
    final container = buildContainer();

    await expectLater(
      readAlive(container, gestionNotificacionesProvider(NotificacionEstado.pendiente)),
      throwsA(isA<AuthorizationUnknown>()),
    );
    expect(_revocationSignals, isZero);
  });

  test('si el servicio de cláusulas no responde, no se cierra la sesión', () async {
    consent.error = const ConsentStatusUnknownException(message: 'Clausulas endpoint unavailable', statusCode: 500);
    final container = buildContainer();

    await expectLater(
      readAlive(container, gestionNotificacionesProvider(null)),
      throwsA(isA<AuthorizationUnknown>()),
    );
    expect(_revocationSignals, isZero);
    // Guardarraíl: el gateway emite el mismo sobre cuando no puede leer
    // preferencias, así que un fallo de la relectura jamás expulsa al usuario.
  });

  test('el detalle también resuelve el rechazo en vez de propagar el sobre', () async {
    consent.clauses = [const Clause(id: requiredConsentClauseId, label: 'Protección de datos', isSelected: false)];
    final container = buildContainer();

    await expectLater(
      readAlive(container, gestionNotificacionDetalleProvider((id: 7924, estado: null, sistemaOrigen: null))),
      throwsA(isA<ConsentRevoked>()),
    );
    expect(_revocationSignals, 1);
  });

  test('relee las cláusulas una sola vez aunque "Todo" barra cuatro estados', () async {
    consent.clauses = [const Clause(id: requiredConsentClauseId, label: 'Protección de datos', isSelected: false)];
    final container = buildContainer();

    await expectLater(
      readAlive(container, gestionNotificacionesProvider(null)),
      throwsA(isA<ConsentRevoked>()),
    );
    // El barrido de los cuatro estados vive dentro del repositorio, así que la
    // resolución ocurre una vez por carga de pantalla, no una por estado.
    expect(consent.refreshCalls, hasLength(1));
  });
}

final class _RejectingNotificacionesRepository implements GestionNotificacionesRepository {
  @override
  Future<List<Notificacion>> loadNotificaciones({required final String citizenId, final NotificacionEstado? estado, final CancelToken? cancelToken}) async {
    throw const AuthorizationRequiredException(statusCode: 403, path: 'notificaciones');
  }

  @override
  Future<NotificacionDetalle> loadNotificacion({
    required final String citizenId,
    required final int notificacionId,
    final NotificacionEstado? fallbackEstado,
    final String? sistemaOrigen,
  }) async {
    throw const AuthorizationRequiredException(statusCode: 403, path: 'notificaciones/7924');
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}

final class _ClausesConsentRepository implements ConsentRepository {
  List<Clause> clauses = const [];
  Exception? error;
  final List<String> refreshCalls = [];

  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) async {
    refreshCalls.add(idAgente);
    final pending = error;
    if (pending != null) {
      throw pending;
    }
    return clauses;
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}

/// El contador vive fuera del notifier: su API pública es `state` y nada más.
int _revocationSignals = 0;

final class _RecordingRevocationNotifier extends ConsentRevocationNotifier {
  @override
  Future<void> signalRevoked() async {
    _revocationSignals++;
    state = true;
  }
}
