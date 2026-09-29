import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_hospital_appointments_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _pendientes = 'Citas pendientes';
const _pasadas = 'Citas pasadas';
const _sinPendientes = 'No tienes citas hospitalarias pendientes.';
const _sinPasadas = 'No tienes citas hospitalarias pasadas.';
const _servicioCaido =
    'El servicio de consulta de tus citas sanitarias no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';
const _nivelInsuficiente =
    'Para consultar tus citas hospitalarias necesitas un nivel de seguridad más alto. Vuelve a identificarte con certificado digital o DNI electrónico.';
const _nivelSinVerificar =
    'No hemos podido comprobar tu nivel de seguridad, así que no podemos mostrar tus citas hospitalarias. Vuelve a identificarte o inténtalo más tarde.';

void main() {
  testWidgets('abre en pendientes y pinta el CIP y los campos de la cita', (final tester) async {
    await _pump(
      tester,
      pending: [
        HospitalAppointment(
          dateTime: DateTime(2026, 2, 3, 11, 40),
          service: 'TRAUMATOLOGIA',
          provision: 'CONSULTA SUCESIVA',
          room: 'PLANTA 1',
          center: 'HOSPITAL GENERAL DE TOMELLOSO',
          agendaDescription: 'TRAUMATOLOGIA 6 - DRA. CASTELLANOS',
        ),
      ],
    );

    expect(find.text('CIP: PNRV901264600010'), findsOneWidget);
    // Los siete campos del apartado 6.3, cada uno localizable en pantalla.
    expect(find.text('3'), findsOneWidget); // día
    expect(find.text('martes'), findsOneWidget); // día de la semana
    expect(find.text('11:40'), findsOneWidget); // hora
    expect(find.text('Traumatologia'), findsOneWidget); // servicio
    expect(find.text('Consulta sucesiva'), findsOneWidget); // prestación
    expect(find.textContaining('Sala: Planta 1'), findsOneWidget);
    expect(find.textContaining('Centro: Hospital general de tomelloso'), findsOneWidget);
    expect(find.textContaining('Agenda: Traumatologia 6 - dra. castellanos'), findsOneWidget);
    expect(find.textContaining('Fecha y hora: 03/02/2026, 11:40'), findsOneWidget);
  });

  // El apartado 2.2 exige alternar «sin recargar toda la pantalla». La prueba de
  // que eso ocurre es que el repositorio no se vuelve a llamar.
  testWidgets('ir y volver entre pestañas no vuelve a pedir nada al SESCAM', (final tester) async {
    final repository = _SpyHealthRepository(
      pending: [_cita('TRAUMATOLOGIA')],
      past: [_cita('MEDICINA INTERNA')],
    );
    await _pump(tester, repository: repository);

    expect(repository.callsFor(HealthAppointmentFilter.pending), 1);
    // Las pasadas no se piden hasta que se abre su pestaña.
    expect(repository.callsFor(HealthAppointmentFilter.past), isZero);

    await tester.tap(find.text(_pasadas));
    await tester.pumpAndSettle();
    expect(repository.callsFor(HealthAppointmentFilter.past), 1);

    await tester.tap(find.text(_pendientes));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_pasadas));
    await tester.pumpAndSettle();

    expect(repository.callsFor(HealthAppointmentFilter.pending), 1);
    expect(repository.callsFor(HealthAppointmentFilter.past), 1);
  });

  testWidgets('cada pestaña tiene su propio mensaje de vacío', (final tester) async {
    await _pump(tester);

    expect(find.text(_sinPendientes), findsOneWidget);
    expect(find.text(_sinPasadas), findsNothing);

    await tester.tap(find.text(_pasadas));
    await tester.pumpAndSettle();

    expect(find.text(_sinPasadas), findsOneWidget);
    expect(find.text(_sinPendientes), findsNothing);
  });

  testWidgets('varias citas el mismo día y a la misma hora se ven todas', (final tester) async {
    await _pump(
      tester,
      pending: [
        HospitalAppointment(dateTime: DateTime(2026, 1, 22, 9, 30), service: 'MEDICINA INTERNA', provision: 'CONSULTA ENFERMERIA'),
        HospitalAppointment(dateTime: DateTime(2026, 1, 22, 9, 30), service: 'RADIOLOGIA', provision: 'TC CEREBRO'),
      ],
    );

    expect(find.byType(HospitalAppointmentCard), findsNWidgets(2));
    expect(find.text('Medicina interna'), findsOneWidget);
    expect(find.text('Radiologia'), findsOneWidget);
  });

  testWidgets('los campos opcionales ausentes no dejan filas ni «null» en pantalla', (final tester) async {
    await _pump(
      tester,
      pending: [
        HospitalAppointment(dateTime: DateTime(2026, 2, 3, 11, 40), service: 'TRAUMATOLOGIA', provision: 'CONSULTA SUCESIVA'),
      ],
    );

    expect(find.textContaining('null'), findsNothing);
    expect(find.textContaining('Sala:'), findsNothing);
    expect(find.textContaining('Centro:'), findsNothing);
    expect(find.textContaining('Agenda:'), findsNothing);
    // La fecha y hora sí, que no es opcional.
    expect(find.textContaining('Fecha y hora:'), findsOneWidget);
  });

  testWidgets('un fallo del SESCAM se muestra con reintento, no como lista vacía', (final tester) async {
    await _pump(tester, pendingError: Exception('SESCAM caído'));

    expect(find.text(_servicioCaido), findsOneWidget);
    expect(find.text(_sinPendientes), findsNothing);
  });

  // Se inyecta el error en el provider en vez de en el repositorio: la
  // resolución del clausulado pasa por la cadena de consentimiento, que ya
  // tiene sus propios tests. Aquí lo que se comprueba es el reparto que hace la
  // pantalla, y que no lo confunde con un fallo de servicio.
  testWidgets('la falta de clausulado se explica en vez de mostrar un error de servicio', (final tester) async {
    await _pump(tester, providerError: const MyDataAuthorizationRequired());

    expect(find.text(_servicioCaido), findsNothing);
    expect(find.text(_sinPendientes), findsNothing);
    expect(find.text(_nivelInsuficiente), findsNothing);
  });

  testWidgets('sin autorización previa no se pinta ni el CIP ni las pestañas', (final tester) async {
    await _pump(tester, hasAuthorization: false);

    expect(find.text(_pendientes), findsNothing);
    expect(find.textContaining('CIP:'), findsNothing);
  });

  // Apartados 4 y 5. Lo que importa es que NO se presente como un fallo de
  // servicio, que es donde caía antes de darle su propia rama.
  testWidgets('con nivel bajo se explica el nivel y no se pide nada al SESCAM', (final tester) async {
    final repository = _SpyHealthRepository(pending: [_cita('TRAUMATOLOGIA')]);
    await _pump(tester, authNLevel: 'low', repository: repository);

    expect(find.text(_nivelInsuficiente), findsOneWidget);
    expect(find.text(_servicioCaido), findsNothing);
    expect(repository.callsFor(HealthAppointmentFilter.pending), isZero);
  });

  testWidgets('un nivel que no se sabe leer se distingue del nivel bajo', (final tester) async {
    await _pump(tester, authNLevel: 'enhanced');

    expect(find.text(_nivelSinVerificar), findsOneWidget);
    expect(find.text(_nivelInsuficiente), findsNothing);
  });
}

HospitalAppointment _cita(final String service) => HospitalAppointment(
  dateTime: DateTime(2026, 2, 3, 11, 40),
  service: service,
  provision: 'CONSULTA SUCESIVA',
);

Future<void> _pump(
  final WidgetTester tester, {
  final List<HospitalAppointment> pending = const [],
  final List<HospitalAppointment> past = const [],
  final Object? pendingError,
  final bool hasAuthorization = true,
  final String authNLevel = 'substantial',
  final Object? providerError,
  final _SpyHealthRepository? repository,
}) async {
  final spy = repository ?? _SpyHealthRepository(pending: pending, past: past, pendingError: pendingError);

  await tester.pumpWidget(
    ProviderScope(
      // La misma política que `bootstrap.dart`: sin ella Riverpod reintenta sola
      // cualquier `Exception` y los estados de error no llegan a pintarse.
      retry: (final _, final _) => null,
      overrides: [
        // El gate de nivel corre antes de la petición, así que sin claims con
        // nivel suficiente la pantalla no llega ni a pedir las citas.
        jwtClaimsProvider.overrideWith(
          () => _StubJwtClaimsNotifier(
            JwtClaims(
              exp: 0,
              iat: 0,
              iss: 'issuer',
              aud: const [],
              sub: 'subject',
              subAlt: 'PER1',
              idAgente: 'PER1',
              authNLevelRaw: authNLevel,
            ),
          ),
        ),
        myDataHealthRepositoryProvider.overrideWithValue(spy),
        jccmDataAuthorizationProvider.overrideWith((final ref) async => hasAuthorization),
        myDataHealthCipProvider.overrideWith((final ref) async => 'PNRV901264600010'),
        if (providerError != null)
          myDataHospitalAppointmentsProvider.overrideWith(
            // ignore: only_throw_errors — el error a inyectar lo elige el test.
            (final ref, final filter) async => throw providerError,
          ),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MyDataHospitalAppointmentsPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

final class _SpyHealthRepository implements MyDataHealthRepository {
  _SpyHealthRepository({
    this.pending = const [],
    this.past = const [],
    this.pendingError,
  });

  final List<HospitalAppointment> pending;
  final List<HospitalAppointment> past;
  final Object? pendingError;

  final Map<HealthAppointmentFilter, int> _calls = <HealthAppointmentFilter, int>{};

  int callsFor(final HealthAppointmentFilter filter) => _calls[filter] ?? 0;

  @override
  Future<String?> loadCip({required final String citizenId}) async => 'PNRV901264600010';

  @override
  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  }) async {
    _calls[filter] = callsFor(filter) + 1;
    if (filter == HealthAppointmentFilter.pending && pendingError != null) {
      // ignore: only_throw_errors — el error a simular lo elige el test.
      throw pendingError!;
    }
    return filter == HealthAppointmentFilter.pending ? pending : past;
  }

  @override
  Future<List<Never>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  }) => throw UnimplementedError();
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}
