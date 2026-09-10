import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/routing/session_guard.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_repository_provider.dart';

final _guardProvider = Provider<SessionGuard>(SessionGuard.new);

void main() {
  late _FakeSecureStorage storage;
  late _FakeConsentRepository consentRepository;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_UnusedAuthRepository()),
        secureStorageProvider.overrideWithValue(storage),
        consentRepositoryProvider.overrideWithValue(consentRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  void startSession(final ProviderContainer container) {
    container.read(authSessionControllerProvider).startInMemory(
      TokenResponse(
        'access',
        'refresh',
        DateTime.now().add(const Duration(minutes: 5)),
        null,
        null,
        null,
        null,
      ),
      claims: const JwtClaims(
        exp: 9999999999,
        iat: 0,
        iss: 'test',
        aud: ['app'],
        sub: 'sub-1',
        subAlt: 'PER1',
      ),
    );
  }

  setUp(() {
    storage = _FakeSecureStorage();
    consentRepository = _FakeConsentRepository();
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

final class _FakeSecureStorage implements SecureStorage {
  final Map<String, String> store = {};

  @override
  Future<String?> read(final String key) async => store[key];

  @override
  Future<void> write(final String key, final String value) async => store[key] = value;

  @override
  Future<void> delete(final String key) async => store.remove(key);

  @override
  Future<void> clear() async => store.clear();
}

/// The guard under test never refreshes (the in-memory token is fresh).
final class _UnusedAuthRepository implements AuthRepository {
  @override
  Future<TokenResponse> login({final List<String> scopes = authDefaultScopes, final String? loginHint, final bool ephemeralSession = true}) => throw UnimplementedError();

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw UnimplementedError();

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri, final bool ephemeralSession = true}) => throw UnimplementedError();
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
