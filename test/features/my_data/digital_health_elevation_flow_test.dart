import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_elevation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_health_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

import '../auth/auth_session_controller_test.dart' show FakeAppStorage;

const _servicios = 'Información y servicios';
const _miSaludDigital = 'Mi Salud Digital';
const _acceder = 'Acceder a cl@ve';
const _volver = 'Volver';
const _noVolverAMostrar = 'No volver a mostrar';
const _salirDeLaApp = 'Vas a salir de la aplicación';
const _metodoInsuficiente = 'El método de identificación utilizado no alcanza el nivel de acceso requerido. Pulse «Continuar» e identifíquese con certificado digital o DNI electrónico.';
const _suppressionKey = '${StorageKeys.identityVerificationNoticeSuppressedPrefix}PER1';
const _urlLauncherChannel = MethodChannel('plugins.flutter.io/url_launcher');

/// JCCMEC-275: Mi Salud Digital entra por Cerbero pidiendo nivel sustancial.
///
/// Con una sesión de nivel bajo, Cerbero vuelve a pasar por Cl@ve sin forzar el
/// desafío y Cl@ve identifica sola con el último certificado del navegador:
/// en PRE, un ciudadano de Cl@ve Permanente entraba en la salud de otro. Por
/// eso la app eleva antes, con el mismo aviso y la misma elevación que las
/// citas hospitalarias.
void main() {
  late FakeAppStorage storage;
  late _Clave clave;
  late _FakeElevationNotifier elevation;
  late List<String> launched;

  setUp(() {
    storage = FakeAppStorage();
    clave = _Clave();
    elevation = _FakeElevationNotifier(clave);
    launched = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_urlLauncherChannel, (final call) async {
      if (call.method == 'launch') {
        launched.add((call.arguments as Map<Object?, Object?>)['url']! as String);
      }
      return true;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_urlLauncherChannel, null);
  });

  testWidgets('con nivel sustancial no pide verificar: solo el aviso de salir de la app', (final tester) async {
    await _pump(tester, storage: storage, elevation: elevation, authNLevel: 'substantial');

    await _tapDigitalHealth(tester);
    await tester.pumpAndSettle();

    expect(find.text(_salirDeLaApp), findsOneWidget);
    expect(find.text(_acceder), findsNothing);
    expect(clave.calls, 0);
  });

  testWidgets('con nivel bajo avisa, eleva y, si basta, abre Mi Salud Digital sin otro aviso', (final tester) async {
    clave.nextOutcome = ElevationOutcome.succeeded;
    await _pump(tester, storage: storage, elevation: elevation);

    await _tapDigitalHealth(tester);
    await tester.pumpAndSettle();
    expect(find.text(_acceder), findsOneWidget);

    await tester.tap(find.text(_acceder));
    await tester.pumpAndSettle();

    expect(clave.calls, 1);
    expect(find.text(_salirDeLaApp), findsNothing);
    expect(Uri.parse(launched.single).queryParameters['scope'], 'openid substantial');
  });

  testWidgets('Volver no va a Cl@ve ni abre nada', (final tester) async {
    await _pump(tester, storage: storage, elevation: elevation);

    await _tapDigitalHealth(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(_volver));
    await tester.pumpAndSettle();

    expect(clave.calls, 0);
    expect(launched, isEmpty);
  });

  testWidgets('marcar «No volver a mostrar» lo guarda, y la siguiente vez va directo a Cl@ve', (final tester) async {
    clave.nextOutcome = ElevationOutcome.cancelled;
    await _pump(tester, storage: storage, elevation: elevation);

    await _tapDigitalHealth(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text(_noVolverAMostrar));
    await tester.pump();
    await tester.tap(find.text(_acceder));
    await tester.pumpAndSettle();
    expect(storage.values[_suppressionKey], isTrue);
    expect(clave.calls, 1);

    await _tapDigitalHealth(tester);
    await tester.pumpAndSettle();

    expect(find.text(_acceder), findsNothing);
    expect(clave.calls, 2);
  });

  testWidgets('cerrar Cl@ve sin identificarse no relanza Cl@ve ni abre nada', (final tester) async {
    storage.values[_suppressionKey] = true;
    clave.nextOutcome = ElevationOutcome.cancelled;
    await _pump(tester, storage: storage, elevation: elevation);

    await _tapDigitalHealth(tester);
    await tester.pumpAndSettle();

    expect(clave.calls, 1);
    expect(find.text(_acceder), findsNothing);
    expect(launched, isEmpty);
  });

  testWidgets('con «No volver a mostrar», un método insuficiente se explica en vez de abrir el enlace', (final tester) async {
    storage.values[_suppressionKey] = true;
    clave.nextOutcome = ElevationOutcome.stillInsufficient;
    await _pump(tester, storage: storage, elevation: elevation);

    await _tapDigitalHealth(tester);
    await tester.pumpAndSettle();

    expect(find.text(_metodoInsuficiente), findsOneWidget);
    expect(clave.calls, 1);
    expect(launched, isEmpty);
  });
}

Future<void> _pump(
  final WidgetTester tester, {
  required final FakeAppStorage storage,
  required final _FakeElevationNotifier elevation,
  final String authNLevel = 'low',
}) async {
  // Pantalla de móvil: en la de 800×600 por defecto el botón de Cl@ve del
  // diálogo queda fuera del área que recibe toques.
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: Routes.myDataHealth,
    routes: [
      GoRoute(path: Routes.myDataHealth, builder: (final _, final _) => const MyDataHealthPage()),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      retry: (final _, final _) => null,
      overrides: [
        appConfigProvider.overrideWithValue(const AppConfig.fromMap({'APP_FLAVOR': 'preproduction'})),
        jwtClaimsProvider.overrideWith(() => _StubClaims(authNLevel)),
        appStorageProvider.overrideWithValue(storage),
        elevationProvider.overrideWith(() => elevation),
        jccmDataAuthorizationProvider.overrideWith((final ref) async => true),
        myDataHealthCipProvider.overrideWith((final ref) async => 'CIP-1'),
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
  await tester.tap(find.text(_servicios));
  await tester.pumpAndSettle();
}

Future<void> _tapDigitalHealth(final WidgetTester tester) async {
  await tester.ensureVisible(find.text(_miSaludDigital));
  await tester.pumpAndSettle();
  await tester.tap(find.text(_miSaludDigital));
}

/// Lo que el test observa y prepara de Cl@ve. Va aparte del notifier porque un
/// notifier solo expone su `state`.
final class _Clave {
  int calls = 0;
  ElevationOutcome? nextOutcome;
}

/// Cl@ve de mentira: cuenta cuántas veces se lanza y vuelve con el desenlace
/// que haya preparado el test.
final class _FakeElevationNotifier extends ElevationNotifier {
  _FakeElevationNotifier(this._clave);

  final _Clave _clave;

  @override
  Future<void> elevate({required final AuthenticationLevel minimum}) async {
    _clave.calls++;
    state = ElevationState(outcome: _clave.nextOutcome);
  }
}

final class _StubClaims extends JwtClaimsNotifier {
  _StubClaims(this.authNLevel);

  final String authNLevel;

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
  );
}
