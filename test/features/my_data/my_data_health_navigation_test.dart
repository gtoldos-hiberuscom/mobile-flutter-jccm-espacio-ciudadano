import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_health_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_hospital_appointments_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_primary_care_appointments_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_disabled_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _primaria = 'Atención primaria';
const _hospitalaria = 'Atención hospitalaria';

/// Salud es un **menú** de dos opciones al mismo nivel, como Bienestar Social y
/// Educación. Antes primaria se mostraba dentro de Salud y hospitalaria se
/// enlazaba, que eran dos cosas del mismo rango en planos distintos.
void main() {
  testWidgets('la tarjeta de primaria abre su pantalla, y el back vuelve a Salud', (final tester) async {
    final router = await _pumpHealth(tester);

    await tester.tap(find.text(_primaria));
    await tester.pumpAndSettle();
    expect(find.byType(MyDataPrimaryCareAppointmentsPage), findsOneWidget);

    router.go(Routes.myDataHealth);
    await tester.pumpAndSettle();
    expect(find.byType(MyDataHealthPage), findsOneWidget);
  });

  testWidgets('la tarjeta de hospitalaria abre su pantalla', (final tester) async {
    await _pumpHealth(tester);

    await tester.tap(find.text(_hospitalaria));
    await tester.pumpAndSettle();

    expect(find.byType(MyDataHospitalAppointmentsPage), findsOneWidget);
  });

  testWidgets('sin autorización las dos salen deshabilitadas y no navegan', (final tester) async {
    await _pumpHealth(tester, hasAuthorization: false);

    expect(find.byType(MyDataDisabledNavigationCard), findsNWidgets(2));
    expect(find.byType(AppNavigationCard), findsNothing);

    await tester.tap(find.text(_primaria));
    await tester.pumpAndSettle();

    expect(find.byType(MyDataHealthPage), findsOneWidget);
    expect(find.byType(MyDataPrimaryCareAppointmentsPage), findsNothing);
  });
}

Future<GoRouter> _pumpHealth(final WidgetTester tester, {final bool hasAuthorization = true}) async {
  final router = GoRouter(
    initialLocation: Routes.myDataHealth,
    routes: [
      GoRoute(path: Routes.myDataHealth, builder: (final _, final _) => const MyDataHealthPage()),
      GoRoute(
        path: Routes.myDataHealthPrimaryCareAppointments,
        builder: (final _, final _) => const MyDataPrimaryCareAppointmentsPage(),
      ),
      GoRoute(
        path: Routes.myDataHealthHospitalAppointments,
        builder: (final _, final _) => const MyDataHospitalAppointmentsPage(),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      retry: (final _, final _) => null,
      overrides: [
        jccmDataAuthorizationProvider.overrideWith((final ref) async => hasAuthorization),
        myDataHealthCipProvider.overrideWith((final ref) async => 'CIP-1'),
        myDataHealthRepositoryProvider.overrideWithValue(_EmptyHealthRepository()),
        // Hospitalaria gatea por nivel; sin claims no llegaría a pintarse.
        jwtClaimsProvider.overrideWith(_StubClaims.new),
      ],
      child: MaterialApp.router(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
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
    authNLevelRaw: 'substantial',
  );
}

final class _EmptyHealthRepository implements MyDataHealthRepository {
  @override
  Future<String?> loadCip({required final String citizenId}) async => 'CIP-1';

  @override
  Future<List<HealthAppointment>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  }) async => const [];

  @override
  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  }) async => const [];
}
