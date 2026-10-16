import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_primary_care_appointments_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _pendientes = 'Pendientes';
const _pasadas = 'Pasadas';
// `MyDataNoData` parte el mensaje en dos: el resultado, dentro del aviso, y la
// indicación de dónde corregirlo, debajo.
const _sinCitas = 'No hemos encontrado citas de Atención Primaria asociadas a tus datos en el servicio de consulta del SESCAM.';
const _sinCitasContacto = 'Si la situación no es correcta o no está actualizada, contacta con tu Centro de Salud.';
const _servicioCaido =
    'El servicio de consulta de datos de citas de atención primaria no se encuentra actualmente disponible. Inténtalo de nuevo más tarde.';
const _sinCip = 'En el servicio del SESCAM no existe ningún CIP vinculado a su identidad. Puede que no podamos mostrar esta información ahora. Inténtelo de nuevo más tarde.';

/// Atención primaria sale de la pantalla de Salud, que pasa a ser un menú.
///
/// Hasta ahora **no tenía ni un test de interfaz**, así que estos cubren lo que
/// se ha mudado: es la red que avisa si el traslado cambió algo.
void main() {
  testWidgets('abre en pendientes con sus citas, sin repetir el CIP del menú', (final tester) async {
    await _pump(
      tester,
      pending: [
        HealthAppointment(
          dateTime: DateTime(2026, 2, 3, 11, 40),
          professional: 'DRA. CASTELLANOS',
          description: 'REVISION',
          center: 'CENTRO DE SALUD',
        ),
      ],
    );

    // El CIP vive en el menú de Salud (Figma 45045:57735), no aquí.
    expect(find.textContaining('(CIP)'), findsNothing);
    expect(find.text('Revision'), findsOneWidget);
    expect(find.text('Dra. castellanos'), findsOneWidget);
    expect(find.text(_sinCitas), findsNothing);
  });

  // La pestaña de pasadas es la única paginada: es la única operación del
  // gateway que acepta `pagina`. Lo que se fija es que **acumula** páginas, no
  // que las reemplaza.
  testWidgets('la pestaña de pasadas acumula las páginas que va cargando', (final tester) async {
    final repository = _FakeHealthRepository(
      pending: const [],
      pastPages: [
        [_cita(1, 'PRIMERA'), _cita(2, 'SEGUNDA')],
        [_cita(3, 'TERCERA')],
      ],
    );
    await _pump(tester, repository: repository);

    await tester.tap(find.text(_pasadas));
    await tester.pumpAndSettle();

    expect(find.text('Primera'), findsOneWidget);
    expect(find.text('Tercera'), findsNothing);
    // Con la lista corta no hay scroll que dispare la carga, y por eso el botón
    // tiene que estar: es el único camino, y además el accesible por teclado y
    // lector de pantalla.
    expect(find.text('Cargar más citas'), findsOneWidget);

    await tester.tap(find.text('Cargar más citas'));
    await tester.pumpAndSettle();

    // Acumula: la página nueva no reemplaza a la anterior.
    expect(find.text('Primera'), findsOneWidget);
    expect(find.text('Segunda'), findsOneWidget);
    expect(find.text('Tercera'), findsOneWidget);
    expect(repository.requestedPastPages, [0, 1]);
  });

  testWidgets('sin citas lo dice, en vez de dejar la pantalla vacía', (final tester) async {
    await _pump(tester);

    expect(find.text(_sinCitas), findsOneWidget);
    expect(find.text(_sinCitasContacto), findsOneWidget);
  });

  testWidgets('un fallo del servicio se muestra con reintento', (final tester) async {
    await _pump(tester, pendingError: Exception('SESCAM caído'));

    expect(find.text(_servicioCaido), findsOneWidget);
    expect(find.text(_sinCitas), findsNothing);
  });

  testWidgets('el CIP ausente se explica y no se confunde con un fallo', (final tester) async {
    await _pump(tester, pendingError: const MyDataHealthCipMissing());

    expect(find.text(_sinCip), findsOneWidget);
    expect(find.text(_servicioCaido), findsNothing);
  });

  testWidgets('sin autorización no se pintan las pestañas', (final tester) async {
    await _pump(tester, hasAuthorization: false);

    expect(find.text(_pendientes), findsNothing);
    expect(find.textContaining('CIP:'), findsNothing);
  });
}

HealthAppointment _cita(final int day, final String description) => HealthAppointment(
  dateTime: DateTime(2026, 1, day),
  professional: 'PROFESIONAL',
  description: description,
);

Future<void> _pump(
  final WidgetTester tester, {
  final List<HealthAppointment> pending = const [],
  final Object? pendingError,
  final bool hasAuthorization = true,
  final _FakeHealthRepository? repository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      // La misma política que `bootstrap.dart`: sin ella Riverpod reintenta sola
      // cualquier `Exception` y los estados de error no llegan a pintarse.
      retry: (final _, final _) => null,
      overrides: [
        // El provider de primaria resuelve el identificador desde los claims:
        // sin ellos `requireNumDocumento()` lanza y nunca llega a la lista.
        jwtClaimsProvider.overrideWith(_StubClaims.new),
        myDataHealthRepositoryProvider.overrideWithValue(
          repository ?? _FakeHealthRepository(pending: pending, pendingError: pendingError),
        ),
        jccmDataAuthorizationProvider.overrideWith((final ref) async => hasAuthorization),
        myDataHealthCipProvider.overrideWith((final ref) async => 'PNRV901264600010'),
      ],
      child: const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MyDataPrimaryCareAppointmentsPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

final class _FakeHealthRepository implements MyDataHealthRepository {
  _FakeHealthRepository({required this.pending, this.pastPages = const [], this.pendingError});

  final List<HealthAppointment> pending;

  /// Una lista por página; la que falte vuelve vacía y cierra la paginación.
  final List<List<HealthAppointment>> pastPages;
  final Object? pendingError;

  final List<int> requestedPastPages = <int>[];

  @override
  Future<String?> loadCip({required final String citizenId}) async => 'PNRV901264600010';

  @override
  Future<List<HealthAppointment>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  }) async {
    if (filter == HealthAppointmentFilter.pending) {
      if (pendingError != null) {
        // ignore: only_throw_errors — el error a simular lo elige el test.
        throw pendingError!;
      }
      return pending;
    }
    requestedPastPages.add(page);
    return page < pastPages.length ? pastPages[page] : const [];
  }

  @override
  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  }) => throw UnimplementedError();
}

final class _StubClaims extends JwtClaimsNotifier {
  @override
  JwtClaims? build() => const JwtClaims(
    exp: 0,
    iat: 0,
    iss: 'issuer',
    aud: [],
    sub: 'subject',
    subAlt: 'PER1',
    idAgente: 'PER1',
  );
}
