import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/routing/session_guard.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_repository_provider.dart';

final _guardProvider = Provider<SessionGuard>(SessionGuard.new);

void main() {
  late _FakeSecureStorage storage;
  late _FakeConsentRepository consentRepository;
  late _FakeAppStorage appStorage;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_UnusedAuthRepository()),
        secureStorageProvider.overrideWithValue(storage),
        appStorageProvider.overrideWithValue(appStorage),
        consentRepositoryProvider.overrideWithValue(consentRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  void startSession(
    final ProviderContainer container, {
    final String? representedAgentId,
  }) {
    container
        .read(authSessionControllerProvider)
        .startInMemory(
          TokenResponse(
            'access',
            'refresh',
            DateTime.now().add(const Duration(minutes: 5)),
            null,
            null,
            null,
            null,
          ),
          claims: JwtClaims(
            exp: 9999999999,
            iat: 0,
            iss: 'test',
            aud: ['app'],
            sub: 'sub-1',
            subAlt: 'PER1',
            representedAgentId: representedAgentId,
          ),
        );
  }

  setUp(() {
    storage = _FakeSecureStorage();
    consentRepository = _FakeConsentRepository();
    // El acceso rápido activado: es la condición para que la sesión se guarde,
    // que es justo lo que comprueban estos tests.
    appStorage = _FakeAppStorage()..values['${StorageKeys.biometricQuickAccessEnabledPrefix}PER1'] = true;
  });

  group('SessionGuard representative restrictions', () {
    test('redirects restricted sections without calling their backend', () async {
      final container = buildContainer();
      startSession(container, representedAgentId: 'PJU0349051');

      for (final path in [
        Routes.myDataEducationUniversityTitles,
      ]) {
        expect(
          await container.read(_guardProvider).redirectPath(path),
          Routes.representativeUnavailable,
          reason: path,
        );
      }
    });

    test('allows the supported representative sections', () async {
      final container = buildContainer();
      startSession(container, representedAgentId: 'PJU0349051');

      for (final path in [
        Routes.home,
        Routes.myData,
        Routes.myDataHealth,
        Routes.myDataEducation,
        Routes.myDataSocialWelfare,
        Routes.myDataEmployment,
        Routes.myDataVehicles,
        Routes.myDataEducationNonUniversityTitles,
        Routes.myDataSocialWelfareFamily,
        Routes.myDataEmploymentOffers,
        Routes.myDataHousing,
        Routes.myDataHousingRealEstate,
        Routes.myDataHousingAddress,
        Routes.digitalCards,
        Routes.gestionExpedientes,
        Routes.gestionNotificaciones,
        Routes.recommendations,
        Routes.agenda,
        Routes.representativeUnavailable,
      ]) {
        expect(await container.read(_guardProvider).redirectPath(path), isNull, reason: path);
      }
    });
  });

  group('SessionGuard consent gate', () {
    test('REGRESSION: a backend failure during the consent check fails open and keeps the persisted session', () async {
      // This is the UAT incident: a 403/timeout on GET clausulas used to be
      // read as "consent not accepted", wiping the Keychain and bricking login.
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      consentRepository.consentError = const ConsentStatusUnknownException(message: 'gateway down', statusCode: 503);
      final container = buildContainer();
      startSession(container);

      final redirect = await container.read(_guardProvider).redirectPath(Routes.home);

      expect(redirect, isNull, reason: 'navigation must proceed while the gate cannot be evaluated');
      expect(storage.store[StorageKeys.accessToken], 'persisted-access', reason: 'the session must never be cleared over an outage');
    });

    test('genuinely missing consent with a persisted session clears it and bounces to landing', () async {
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      consentRepository.hasAccepted = false;
      final container = buildContainer();
      startSession(container);

      final redirect = await container.read(_guardProvider).redirectPath(Routes.home);

      expect(redirect, Routes.landing);
      expect(storage.store[StorageKeys.accessToken], isNull);
      expect(
        container.read(landingProvider).sessionExpired,
        isFalse,
        reason: 'esta expulsión es por consentimiento revocado, no por una sesión irrenovable',
      );
    });

    test('genuinely missing consent with an in-memory session funnels into the legal gate', () async {
      consentRepository.hasAccepted = false;
      final container = buildContainer();
      startSession(container);

      final redirect = await container.read(_guardProvider).redirectPath(Routes.home);

      expect(redirect, Routes.legalPrivacy);
    });

    test('accepted consent allows navigation', () async {
      consentRepository.hasAccepted = true;
      final container = buildContainer();
      startSession(container);

      final redirect = await container.read(_guardProvider).redirectPath(Routes.home);

      expect(redirect, isNull);
    });

    test('REGRESSION: confirming consent persists the in-memory session so it survives closing the app', () async {
      // Until this existed the only caller of persistCurrentSession() was the
      // consent notifier's acceptance branch, so a returning citizen — who
      // never re-accepts anything — kept the session in memory only and was
      // sent back to Cl@ve on every cold start, even holding a valid token.
      consentRepository.hasAccepted = true;
      final container = buildContainer();
      startSession(container);

      await container.read(_guardProvider).redirectPath(Routes.home);

      expect(storage.store[StorageKeys.accessToken], 'access');
      expect(storage.store[StorageKeys.refreshToken], 'refresh');
    });

    test('an unconfirmed consent never writes the session to disk', () async {
      consentRepository.hasAccepted = false;
      final container = buildContainer();
      startSession(container);

      await container.read(_guardProvider).redirectPath(Routes.home);

      expect(
        storage.store[StorageKeys.accessToken],
        isNull,
        reason: 'persistence is gated on consent: nothing is stored for a citizen who has not accepted the clause',
      );
    });

    test('an already persisted session is not rewritten on every navigation', () async {
      consentRepository.hasAccepted = true;
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      final container = buildContainer();
      startSession(container);

      await container.read(_guardProvider).redirectPath(Routes.home);

      expect(storage.store[StorageKeys.accessToken], 'persisted-access');
    });
  });

  group('SessionGuard session refresh tri-state (C6)', () {
    test('a transient refresh failure fails open and keeps the persisted session', () async {
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      storage.store[StorageKeys.refreshToken] = 'persisted-refresh';
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(const _FailingAuthRepository(AuthException.unexpected())),
          secureStorageProvider.overrideWithValue(storage),
          appStorageProvider.overrideWithValue(appStorage),
          consentRepositoryProvider.overrideWithValue(consentRepository),
        ],
      );
      addTearDown(container.dispose);
      container
          .read(authSessionControllerProvider)
          .startInMemory(
            TokenResponse(
              'access',
              'persisted-refresh',
              DateTime.now().subtract(const Duration(minutes: 1)),
              null,
              null,
              null,
              null,
            ),
            claims: const JwtClaims(exp: 0, iat: 0, iss: 'test', aud: ['app'], sub: 'sub-1', subAlt: 'PER1'),
          );

      final redirect = await container.read(_guardProvider).redirectPath(Routes.home);

      expect(redirect, isNull, reason: 'a network blip must not eject the user to the landing');
      expect(storage.store[StorageKeys.accessToken], 'persisted-access');
    });

    test('una expulsión por sesión irrenovable avisa al ciudadano', () async {
      // Sin esto el guard le devolvía a la landing sin decir nada, y desde su
      // punto de vista la app simplemente le echaba.
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      storage.store[StorageKeys.refreshToken] = 'persisted-refresh';
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(const _FailingAuthRepository(AuthException.remoteFailure(message: 'invalid_grant'))),
          secureStorageProvider.overrideWithValue(storage),
          appStorageProvider.overrideWithValue(appStorage),
          consentRepositoryProvider.overrideWithValue(consentRepository),
        ],
      );
      addTearDown(container.dispose);
      container
          .read(authSessionControllerProvider)
          .startInMemory(
            TokenResponse('access', 'persisted-refresh', DateTime.now().subtract(const Duration(minutes: 1)), null, null, null, null),
            claims: const JwtClaims(exp: 0, iat: 0, iss: 'test', aud: ['app'], sub: 'sub-1', subAlt: 'PER1'),
          );

      final redirect = await container.read(_guardProvider).redirectPath(Routes.home);

      expect(redirect, Routes.landing);
      expect(container.read(landingProvider).sessionExpired, isTrue);
    });

    test('a definitive rejection bounces to the landing with the session cleared', () async {
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      storage.store[StorageKeys.refreshToken] = 'persisted-refresh';
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(const _FailingAuthRepository(AuthException.remoteFailure(message: 'invalid_grant'))),
          secureStorageProvider.overrideWithValue(storage),
          appStorageProvider.overrideWithValue(appStorage),
          consentRepositoryProvider.overrideWithValue(consentRepository),
        ],
      );
      addTearDown(container.dispose);
      container
          .read(authSessionControllerProvider)
          .startInMemory(
            TokenResponse(
              'access',
              'persisted-refresh',
              DateTime.now().subtract(const Duration(minutes: 1)),
              null,
              null,
              null,
              null,
            ),
            claims: const JwtClaims(exp: 0, iat: 0, iss: 'test', aud: ['app'], sub: 'sub-1', subAlt: 'PER1'),
          );

      final redirect = await container.read(_guardProvider).redirectPath(Routes.home);

      expect(redirect, Routes.landing);
      expect(storage.store[StorageKeys.accessToken], isNull);
    });
  });

  group('SessionGuard optional clause gate', () {
    test('a backend failure during the optional clause check fails open', () async {
      consentRepository
        ..hasAccepted = true
        ..clauseError = const ConsentStatusUnknownException(message: 'gateway down');
      final container = buildContainer();
      startSession(container);

      final redirect = await container.read(_guardProvider).redirectPath(Routes.myDataEmploymentOffers);

      expect(redirect, isNull);
    });

    test('a genuinely unaccepted optional clause redirects to the preferences consent editor', () async {
      consentRepository
        ..hasAccepted = true
        ..clauseAccepted = false;
      final container = buildContainer();
      startSession(container);

      final redirect = await container.read(_guardProvider).redirectPath(Routes.myDataEmploymentOffers);

      expect(
        redirect,
        Uri(
          path: Routes.consent,
          queryParameters: {
            'mode': 'preferences',
            'returnTo': Routes.myDataEmploymentOffers,
          },
        ).toString(),
      );
    });
  });
}

final class _FakeAppStorage implements AppStorage {
  final Map<String, Object> values = {};

  @override
  T? read<T>(final String key) => values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    values.clear();
    return true;
  }
}

final class _FakeSecureStorage implements SecureStorage {
  final Map<String, String> store = {};

  @override
  Future<String?> read(final String key, {final SecureStorageProtection protection = SecureStorageProtection.standard, final BiometricPromptCopy? prompt}) async => store[key];

  @override
  Future<void> write(final String key, final String value, {final SecureStorageProtection protection = SecureStorageProtection.standard, final BiometricPromptCopy? prompt}) async => store[key] = value;

  @override
  Future<void> delete(final String key, {final SecureStorageProtection protection = SecureStorageProtection.standard}) async => store.remove(key);

  @override
  Future<void> clearBiometric() async => store.remove(StorageKeys.refreshToken);

  @override
  Future<void> clear({final bool includeBiometric = true}) async => store.clear();
}

/// Repository whose refresh always fails with the given [AuthException].
final class _FailingAuthRepository implements AuthRepository {
  const _FailingAuthRepository(this.error);

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {}

  final AuthException error;

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final Map<String, String> extraParameters = const <String, String>{},
  }) => throw UnimplementedError();

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw error;

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) => throw UnimplementedError();
}

/// The guard under test never refreshes (the in-memory token is fresh).
final class _UnusedAuthRepository implements AuthRepository {
  final List<String> revokedTokens = [];

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    revokedTokens.add(refreshToken);
  }

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final Map<String, String> extraParameters = const <String, String>{},
  }) => throw UnimplementedError();

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw UnimplementedError();

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) => throw UnimplementedError();
}

final class _FakeConsentRepository implements ConsentRepository {
  bool hasAccepted = true;
  Exception? consentError;
  bool clauseAccepted = true;
  Exception? clauseError;

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) async {
    final pendingError = consentError;
    if (pendingError != null) {
      throw pendingError;
    }
    return hasAccepted;
  }

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) async {
    final pendingError = clauseError;
    if (pendingError != null) {
      throw pendingError;
    }
    return clauseAccepted;
  }

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) => throw UnimplementedError();

  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();
}
