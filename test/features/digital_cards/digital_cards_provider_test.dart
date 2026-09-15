import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/repositories/digital_cards_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/providers/digital_cards_provider.dart';

void main() {
  test('checks authorization with sub_alt', () async {
    final repository = _RecordingConsentRepository();
    final container = ProviderContainer(
      overrides: [
        jwtClaimsProvider.overrideWith(
          () => _StubJwtClaimsNotifier(
            const JwtClaims(
              exp: 0,
              iat: 0,
              iss: 'issuer',
              aud: [],
              sub: 'subject',
              idAgente: 'PER9998003',
              subAlt: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
            ),
          ),
        ),
        checkAcceptedConsentClauseUsecaseProvider.overrideWithValue(
          CheckAcceptedConsentClauseUsecase(repository),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(await container.read(digitalCardsAuthorizationProvider.future), isTrue);
    expect(repository.lastIdAgente, 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6');
    expect(repository.lastClauseId, digitalCardsConsentClauseId);
  });

  test('loads cards with sub_alt', () async {
    final repository = _RecordingDigitalCardsRepository();
    final container = ProviderContainer(
      overrides: [
        jwtClaimsProvider.overrideWith(
          () => _StubJwtClaimsNotifier(
            const JwtClaims(
              exp: 0,
              iat: 0,
              iss: 'issuer',
              aud: [],
              sub: 'subject',
              personIdentifier: '99999999R',
              idAgente: 'PER9998003',
              subAlt: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
            ),
          ),
        ),
        digitalCardsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    expect(await container.read(digitalCardsProvider.future), isEmpty);
    expect(repository.lastCitizenId, 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6');
  });
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}

final class _RecordingConsentRepository implements ConsentRepository {
  String? lastIdAgente;
  int? lastClauseId;

  @override
  Future<bool> hasAcceptedClause({required final String idAgente, required final int clauseId}) async {
    lastIdAgente = idAgente;
    lastClauseId = clauseId;
    return true;
  }

  @override
  Future<bool> hasAcceptedConsent({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<void> markConsentAccepted({required final String idAgente, required final List<Clause> clauses}) => throw UnimplementedError();

  @override
  Future<void> resetConsentClauses({required final String idAgente}) => throw UnimplementedError();

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) => throw UnimplementedError();

  @override
  Future<List<Clause>> refreshClauses({required final String idAgente}) => throw UnimplementedError();
}

final class _RecordingDigitalCardsRepository implements DigitalCardsRepository {
  String? lastCitizenId;

  @override
  Future<List<DigitalCard>> loadCards({required final String citizenId}) async {
    lastCitizenId = citizenId;
    return const [];
  }

  @override
  Future<DigitalCardArtifact> downloadPdf({required final String citizenId, required final DigitalCard card}) => throw UnimplementedError();

  @override
  Future<DigitalCardArtifact> downloadPkPass({required final String citizenId, required final DigitalCard card}) => throw UnimplementedError();

  @override
  Future<DigitalCardArtifact> downloadQr({required final String citizenId, required final DigitalCard card}) => throw UnimplementedError();

  @override
  Future<Uint8List?> loadQrImage({required final String citizenId, required final DigitalCard card}) => throw UnimplementedError();
}
