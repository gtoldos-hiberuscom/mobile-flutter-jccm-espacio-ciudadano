import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/repositories/notification_contact_repository.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/preferences_page.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/providers/notification_contact_providers.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// C5 regression: an unanswerable clause check must surface the page's error
/// state with retry — never the "disabled" authorization card that asserts the
/// citizen has not accepted a consent they may well have accepted.
void main() {
  testWidgets('a failing clause check shows the error state, not a fake "disabled" authorization', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStorageProvider.overrideWithValue(_MemoryAppStorage()),
          jwtClaimsProvider.overrideWith(
            () => _StubJwtClaimsNotifier(
              const JwtClaims(
                exp: 0,
                iat: 0,
                iss: 'issuer',
                aud: [],
                sub: 'subject',
                subAlt: 'PER1',
              ),
            ),
          ),
          checkAcceptedConsentClauseUsecaseProvider.overrideWithValue(
            CheckAcceptedConsentClauseUsecase(
              _FakeConsentRepository(error: const ConsentStatusUnknownException(message: 'gateway down')),
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PreferencesPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(ErrorStateWidget), findsOneWidget);
    expect(find.textContaining('primero debes aceptar'), findsNothing);
  });

  testWidgets('a failing contact request does not block the rest of preferences', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStorageProvider.overrideWithValue(_MemoryAppStorage()),
          jwtClaimsProvider.overrideWith(
            () => _StubJwtClaimsNotifier(
              const JwtClaims(
                exp: 0,
                iat: 0,
                iss: 'issuer',
                aud: [],
                sub: 'subject',
                subAlt: 'PER1',
              ),
            ),
          ),
          checkAcceptedConsentClauseUsecaseProvider.overrideWithValue(
            CheckAcceptedConsentClauseUsecase(_FakeConsentRepository(accepted: false)),
          ),
          notificationContactRepositoryProvider.overrideWithValue(_FailingNotificationContactRepository()),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PreferencesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(PreferencesPage));
    final l10n = AppLocalizations.of(context);
    expect(find.text(l10n.lifeEventsTitle), findsOneWidget);
    expect(find.text(l10n.notificationContactErrorLoading), findsOneWidget);
    expect(find.byType(ErrorStateWidget), findsOneWidget);
  });
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}

final class _FakeConsentRepository implements ConsentRepository {
  _FakeConsentRepository({this.error, this.accepted});

  final Exception? error;
  final bool? accepted;

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) async {
    final pendingError = error;
    if (pendingError != null) {
      throw pendingError;
    }
    return accepted ?? false;
  }

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) => throw UnimplementedError();
  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) => throw UnimplementedError();
}

final class _FailingNotificationContactRepository implements NotificationContactRepository {
  @override
  Future<NotificationContact?> loadContact({required final String citizenId}) => throw Exception('contact backend down');

  @override
  Future<NotificationContact> saveContact({
    required final String citizenId,
    required final String dni,
    required final NotificationContact contact,
  }) => throw UnimplementedError();
}

final class _MemoryAppStorage implements AppStorage {
  final Map<String, Object> _values = {};

  @override
  T? read<T>(final String key) => _values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    _values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _values.clear();
    return true;
  }
}
