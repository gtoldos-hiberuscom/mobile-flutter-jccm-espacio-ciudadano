import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_about_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// La entrada a la demostración vive en «Saber más»: el botón está en la barra
/// inferior y abre la hoja de confirmación.
void main() {
  Future<void> pumpPage(final WidgetTester tester) async {
    // En vertical, como en el móvil: `AppStickybar` sólo pone los botones en
    // fila en apaisado, y el viewport por defecto de los tests (800×600) lo es.
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_UnusedAuthRepository()),
          secureStorageProvider.overrideWithValue(_EmptySecureStorage()),
          appStorageProvider.overrideWithValue(_EmptyAppStorage()),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LandingAboutPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('la barra inferior ofrece «Acceder a demostración» bajo el acceso con Cl@ve', (final tester) async {
    await pumpPage(tester);

    final access = find.text('Acceder a mi Espacio ciudadano');
    final demo = find.text('Acceder a demostración');
    expect(access, findsOneWidget);
    expect(demo, findsOneWidget);
    expect(tester.getTopLeft(demo).dy, greaterThan(tester.getTopLeft(access).dy), reason: 'la demo va debajo del CTA principal');
  });

  testWidgets('pulsarlo abre la hoja de confirmación con el campo de código', (final tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Acceder a demostración'));
    await tester.pumpAndSettle();

    expect(find.text('Modo demostración'), findsOneWidget);
    expect(find.textContaining(RegExp('código de acceso', caseSensitive: false)), findsOneWidget);
  });
}

final class _UnusedAuthRepository implements AuthRepository {
  @override
  Future<TokenResponse> login({final List<String> scopes = authDefaultScopes, final String? loginHint, final Map<String, String> extraParameters = const {}}) => throw UnimplementedError();

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw UnimplementedError();

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {}

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) async {}
}

final class _EmptySecureStorage implements SecureStorage {
  @override
  Future<String?> read(final String key) async => null;

  @override
  Future<void> write(final String key, final String value) async {}

  @override
  Future<void> delete(final String key) async {}

  @override
  Future<void> clear() async {}
}

final class _EmptyAppStorage implements AppStorage {
  @override
  T? read<T>(final String key) => null;

  @override
  Future<bool> write(final String key, final Object value) async => true;

  @override
  Future<bool> remove(final String key) async => true;

  @override
  Future<bool> clear() async => true;
}
