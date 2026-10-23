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

const _primaria = 'Citas de atención primaria';
const _hospitalaria = 'Citas de atención hospitalaria';
const _cip = 'Código de Identificación Personal (CIP): CIP-1';
const _verificar = 'Verifica tu identidad para continuar';

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

  // Figma 45045:57735: el CIP se muestra una sola vez, en el menú, y no se
  // repite dentro de las consultas.
  testWidgets('el CIP sale en el menú y no dentro de las consultas', (final tester) async {
    await _pumpHealth(tester);
    expect(find.text(_cip), findsOneWidget);

    await tester.tap(find.text(_primaria));
    await tester.pumpAndSettle();
    expect(find.byType(MyDataPrimaryCareAppointmentsPage), findsOneWidget);
    expect(find.text(_cip), findsNothing);
  });

  // Figma 45049:59358: Body/Caption (Inter Regular 12/18, sin tracking) en
  // ColorBrand/Primary/Base. `captionRegular` se llama igual pero es negrita.
  testWidgets('el CIP usa Body/Caption en primario', (final tester) async {
    await _pumpHealth(tester);

    final style = tester.widget<Text>(find.text(_cip)).style!;
    expect(style.fontSize, 12);
    expect(style.fontWeight, FontWeight.w400);
    expect(style.height, 18 / 12);
    expect(style.letterSpacing, 0);
    expect(style.color, AppColors.primary);
  });

  testWidgets('con nivel bajo, hospitalaria avisa con candado de que pedirá verificar la identidad', (final tester) async {
    await _pumpHealth(tester, authNLevel: 'low');

    expect(find.text(_verificar), findsOneWidget);
    expect(find.byIcon(AppIcons.lock), findsOneWidget);
  });

  testWidgets('con nivel suficiente, hospitalaria no avisa de nada', (final tester) async {
    await _pumpHealth(tester);

    expect(find.text(_verificar), findsNothing);
    expect(find.byIcon(AppIcons.lock), findsNothing);
  });

  testWidgets('un usuario normal con el scope técnico de representación ve sus datos de Salud', (final tester) async {
    await _pumpHealth(tester, scope: 'openid profile clave_representado');

    expect(find.text(_cip), findsOneWidget);
    expect(find.text(_primaria), findsOneWidget);
    expect(find.text('Con la identificación que se ha usado para entrar no es posible ver esta información. Si dispones de otra forma de identificarte, puedes probar de nuevo.'), findsNothing);
  });

  testWidgets('un representante abre Salud en Mis datos, no en Información y servicios', (final tester) async {
    await _pumpHealth(tester, representedAgentId: 'PER-REPRESENTADO');

    expect(find.text('Con la identificación que se ha usado para entrar no es posible ver esta información. Si dispones de otra forma de identificarte, puedes probar de nuevo.'), findsOneWidget);
    expect(find.text('Trámites que te pueden interesar'), findsNothing);
  });

  testWidgets('sin autorización las dos salen deshabilitadas, sin CIP, y no navegan', (final tester) async {
    await _pumpHealth(tester, hasAuthorization: false);

    expect(find.byType(MyDataDisabledNavigationCard), findsNWidgets(2));
    expect(find.byType(AppNavigationCard), findsNothing);
    // Sin autorización no se puede consultar al SESCAM.
    expect(find.text(_cip), findsNothing);

    await tester.tap(find.text(_primaria));
    await tester.pumpAndSettle();

    expect(find.byType(MyDataHealthPage), findsOneWidget);
    expect(find.byType(MyDataPrimaryCareAppointmentsPage), findsNothing);
  });
}

Future<GoRouter> _pumpHealth(
  final WidgetTester tester, {
  final bool hasAuthorization = true,
  final String authNLevel = 'substantial',
  final String? scope,
  final String? representedAgentId,
}) async {
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
        jwtClaimsProvider.overrideWith(() => _StubClaims(authNLevel, scope: scope, representedAgentId: representedAgentId)),
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
  _StubClaims(this.authNLevel, {this.scope, this.representedAgentId});

  final String authNLevel;
  final String? scope;
  final String? representedAgentId;

  @override
  JwtClaims? build() => JwtClaims(
    exp: 0,
    iat: 0,
    iss: 'issuer',
    aud: [],
    sub: 'subject',
    subAlt: 'PER1',
    idAgente: 'PER1',
    authNLevelRaw: authNLevel,
    scope: scope,
    representedAgentId: representedAgentId,
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
