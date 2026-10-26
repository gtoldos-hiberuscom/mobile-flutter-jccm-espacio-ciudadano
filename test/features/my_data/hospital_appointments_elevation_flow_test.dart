import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_elevation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_hospital_appointments_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

import '../auth/auth_session_controller_test.dart' show FakeAppStorage;

const _salud = 'pantalla de Salud';
const _inicio = 'pantalla de inicio';
const _acceder = 'Acceder a cl@ve';
const _volver = 'Volver';
const _noVolverAMostrar = 'No volver a mostrar';
const _suppressionKey = '${StorageKeys.identityVerificationNoticeSuppressedPrefix}PER1';

/// Regresión del 14/10: **cerrar Cl@ve con la X volvía a abrir Cl@ve, en bucle.**
///
/// Con «No volver a mostrar» marcado, el bloqueo iba directo a Cl@ve al
/// montarse. Al volver del navegador la pantalla pasa por `loading`, el bloqueo
/// se monta de nuevo y, como la cancelación no dejaba desenlace, no sabía que
/// ya se había intentado: relanzaba Cl@ve. Ahora Cl@ve se intenta una vez por
/// decisión del ciudadano, y cerrarlo devuelve a Salud.
void main() {
  late FakeAppStorage storage;
  late _Clave clave;
  late _FakeElevationNotifier elevation;

  setUp(() {
    storage = FakeAppStorage();
    clave = _Clave();
    elevation = _FakeElevationNotifier(clave);
  });

  testWidgets('cerrar Cl@ve sin identificarse vuelve a Salud', (final tester) async {
    await _pump(tester, storage: storage, elevation: elevation);

    await tester.tap(find.text(_acceder));
    await _settle(tester);
    expect(clave.calls, 1);

    elevation.finish(ElevationOutcome.cancelled);
    await _settle(tester);

    expect(find.text(_salud), findsOneWidget);
    expect(clave.calls, 1);
  });

  testWidgets('con «No volver a mostrar», cerrar Cl@ve tampoco lo relanza aunque el bloqueo se monte de nuevo', (final tester) async {
    storage.values[_suppressionKey] = true;
    final container = await _pump(tester, storage: storage, elevation: elevation);
    // Sin diálogo: va directo a Cl@ve, que es lo que pidió.
    expect(clave.calls, 1);

    // Lo que pasa al volver del navegador: la pantalla recarga y el bloqueo se
    // crea de nuevo **antes** de que llegue el desenlace.
    container.invalidate(jccmDataAuthorizationProvider);
    await _settle(tester);
    elevation.finish(ElevationOutcome.cancelled);
    await _settle(tester);

    expect(find.text(_salud), findsOneWidget);
    expect(clave.calls, 1);
  });

  testWidgets('un desenlace que llega con el bloqueo desmontado lo atiende el siguiente, sin relanzar Cl@ve', (final tester) async {
    storage.values[_suppressionKey] = true;
    clave.pendingOutcome = ElevationOutcome.cancelled;

    await _pump(tester, storage: storage, elevation: elevation);

    expect(find.text(_salud), findsOneWidget);
    expect(clave.calls, 0);
  });

  // La preferencia es sobre el aviso: se guarda también al volver.
  testWidgets('marcar «No volver a mostrar» y pulsar Volver lo guarda, y vuelve a Salud sin ir a Cl@ve', (final tester) async {
    await _pump(tester, storage: storage, elevation: elevation);

    await tester.tap(find.text(_noVolverAMostrar));
    await tester.pump();
    await tester.tap(find.text(_volver));
    await _settle(tester);

    expect(find.text(_salud), findsOneWidget);
    expect(clave.calls, 0);
    expect(storage.values[_suppressionKey], isTrue);
  });

  testWidgets('con la preferencia guardada, la siguiente entrada no muestra el aviso y va a Cl@ve una vez', (final tester) async {
    storage.values[_suppressionKey] = true;
    await _pump(tester, storage: storage, elevation: elevation);

    expect(find.text(_acceder), findsNothing);
    expect(clave.calls, 1);
  });

  testWidgets('el botón atrás del sistema sobre el aviso vuelve a Salud', (final tester) async {
    await _pump(tester, storage: storage, elevation: elevation);
    expect(find.text(_acceder), findsOneWidget);

    await tester.binding.handlePopRoute();
    await _settle(tester);

    expect(find.text(_salud), findsOneWidget);
    expect(find.text(_acceder), findsNothing);
    expect(clave.calls, 0);
  });

  testWidgets('marcar «No volver a mostrar» y acceder sí lo guarda', (final tester) async {
    await _pump(tester, storage: storage, elevation: elevation);

    await tester.tap(find.text(_noVolverAMostrar));
    await tester.pump();
    await tester.tap(find.text(_acceder));
    await _settle(tester);

    expect(storage.values[_suppressionKey], isTrue);
    expect(clave.calls, 1);
  });

  testWidgets('con «No volver a mostrar», un método insuficiente se explica en vez de relanzar Cl@ve', (final tester) async {
    storage.values[_suppressionKey] = true;
    await _pump(tester, storage: storage, elevation: elevation);
    expect(clave.calls, 1);

    elevation.finish(ElevationOutcome.stillInsufficient);
    await _settle(tester);

    expect(find.text(_acceder), findsOneWidget);
    expect(clave.calls, 1);
  });

  /// JCCMEC-278: tras elevar con éxito **el aviso volvía a salir**, y pulsar
  /// «Acceder» solo lo cerraba. El bloqueo seguía montado mientras el listado
  /// se rehacía y trataba `succeeded` como una entrada nueva.
  testWidgets('elevar con éxito muestra el listado sin volver a abrir el aviso', (final tester) async {
    final container = await _pump(tester, storage: storage, elevation: elevation, repository: _EmptyRepository());

    await tester.tap(find.text(_acceder));
    await _settle(tester);
    expect(clave.calls, 1);

    // Como el notifier real: adopta el token nuevo y, después, el desenlace.
    container.read(jwtClaimsProvider.notifier).update(_claims(level: 'substantial'));
    elevation.finish(ElevationOutcome.succeeded);
    await _settle(tester);

    expect(find.text(_acceder), findsNothing);
    expect(find.text('Verificación completada'), findsOneWidget);
    expect(find.text('No tienes citas hospitalarias pendientes.'), findsOneWidget);
    expect(clave.calls, 1);
  });

  // JCCMEC-278: con el certificado de otra persona la sesión pasa a ser suya,
  // como en la web, y entra por el inicio igual que tras un login.
  testWidgets('identificarse con otra persona lleva al inicio y lo explica, sin volver a Cl@ve', (final tester) async {
    await _pump(tester, storage: storage, elevation: elevation);

    await tester.tap(find.text(_acceder));
    await _settle(tester);
    elevation.finish(ElevationOutcome.identitySwitched);
    await _settle(tester);

    expect(find.text(_inicio), findsOneWidget);
    expect(find.text('Te has identificado con otra persona. Se ha cerrado la sesión anterior.'), findsOneWidget);
    expect(find.text(_acceder), findsNothing);
    expect(clave.calls, 1);
  });
}

Future<ProviderContainer> _pump(
  final WidgetTester tester, {
  required final FakeAppStorage storage,
  required final _FakeElevationNotifier elevation,
  final MyDataHealthRepository? repository,
}) async {
  // Pantalla de móvil: en la de 800×600 por defecto el botón de Cl@ve del
  // diálogo queda fuera del área que recibe toques.
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: Routes.myDataHealthHospitalAppointments,
    routes: [
      GoRoute(path: Routes.myDataHealth, builder: (final _, final _) => const Scaffold(body: Text(_salud))),
      GoRoute(path: Routes.home, builder: (final _, final _) => const Scaffold(body: Text(_inicio))),
      GoRoute(
        path: Routes.myDataHealthHospitalAppointments,
        builder: (final _, final _) => const MyDataHospitalAppointmentsPage(),
      ),
    ],
  );
  addTearDown(router.dispose);

  final container = ProviderContainer(
    retry: (final _, final _) => null,
    overrides: [
      jwtClaimsProvider.overrideWith(_LowLevelClaims.new),
      appStorageProvider.overrideWithValue(storage),
      elevationProvider.overrideWith(() => elevation),
      myDataHealthRepositoryProvider.overrideWithValue(repository ?? _NoCallsRepository()),
      jccmDataAuthorizationProvider.overrideWith((final ref) async => true),
      myDataHealthCipProvider.overrideWith((final ref) async => 'CIP-1'),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await _settle(tester);
  return container;
}

/// Mientras Cl@ve está abierto la pantalla muestra un indicador que no para de
/// animarse, así que `pumpAndSettle` no llegaría a asentarse nunca.
Future<void> _settle(final WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Lo que el test observa y prepara de Cl@ve. Va aparte del notifier porque un
/// notifier solo expone su `state`.
final class _Clave {
  int calls = 0;

  /// Desenlace ya presente al construirse, como si hubiera llegado con el
  /// bloqueo desmontado.
  ElevationOutcome? pendingOutcome;
}

/// Cl@ve de mentira: cuenta cuántas veces se lanza y deja que el test decida
/// cuándo y cómo vuelve.
final class _FakeElevationNotifier extends ElevationNotifier {
  _FakeElevationNotifier(this._clave);

  final _Clave _clave;

  @override
  ElevationState build() => ElevationState(outcome: _clave.pendingOutcome);

  @override
  Future<void> elevate({required final AuthenticationLevel minimum}) async {
    _clave.calls++;
    state = const ElevationState(isElevating: true);
  }

  void finish(final ElevationOutcome outcome) => state = ElevationState(outcome: outcome);
}

final class _LowLevelClaims extends JwtClaimsNotifier {
  @override
  JwtClaims? build() => _claims(level: 'low');
}

JwtClaims _claims({required final String level}) => JwtClaims(
  exp: 0,
  iat: 0,
  iss: 'issuer',
  aud: const [],
  sub: 'subject',
  subAlt: 'PER1',
  idAgente: 'PER1',
  authNLevelRaw: level,
);

final class _EmptyRepository implements MyDataHealthRepository {
  @override
  Future<String?> loadCip({required final String citizenId}) async => 'CIP-1';

  @override
  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  }) async => const [];

  @override
  Future<List<Never>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  }) => throw UnimplementedError();
}

final class _NoCallsRepository implements MyDataHealthRepository {
  @override
  Future<String?> loadCip({required final String citizenId}) async => 'CIP-1';

  @override
  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  }) => throw StateError('con nivel bajo no se llega a pedir nada');

  @override
  Future<List<Never>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  }) => throw UnimplementedError();
}
