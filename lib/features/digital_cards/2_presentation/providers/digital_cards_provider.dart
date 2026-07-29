import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/repositories/digital_cards_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/3_data/digital_cards_repository_impl.dart';

final digitalCardsRepositoryProvider = Provider<DigitalCardsRepository>((final ref) {
  return DigitalCardsRepositoryImpl(dio: ref.watch(dioProvider));
});

final digitalCardsAuthorizationProvider = FutureProvider.autoDispose<bool>((final ref) async {
  final idAgente = ref.watch(jwtClaimsProvider)?.idAgente?.trim();
  if (idAgente == null || idAgente.isEmpty) {
    throw StateError('No se ha encontrado el identificador de la persona usuaria.');
  }

  final result = await ref
      .watch(checkAcceptedConsentClauseUsecaseProvider)
      .execute(
        idAgente: idAgente,
        clauseId: jccmDataConsentClauseId,
      );
  return switch (result) {
    AcceptedConsentClauseStatus(:final isAccepted) => isAccepted,
    CheckAcceptedConsentClauseFailed(:final message) => throw StateError(message),
  };
});

final digitalCardsProvider = FutureProvider.autoDispose<List<DigitalCard>>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref.watch(digitalCardsRepositoryProvider).loadCards(documentNumber: documentNumber);
});

final digitalCardQrImageProvider = FutureProvider.autoDispose.family<Uint8List?, DigitalCard>((final ref, final card) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref.watch(digitalCardsRepositoryProvider).loadQrImage(documentNumber: documentNumber, card: card);
});

final digitalCardsDownloadingProvider = NotifierProvider.autoDispose<DigitalCardsDownloadingNotifier, String?>(
  DigitalCardsDownloadingNotifier.new,
);

final class DigitalCardsDownloadingNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  bool tryStartDownload(final String format) {
    if (state != null) {
      return false;
    }
    state = format;
    return true;
  }

  void finishDownload() {
    state = null;
  }
}

Future<DigitalCardArtifact> downloadDigitalCardsPdf(final WidgetRef ref, final DigitalCard card) async {
  final documentNumber = _documentNumber(ref.read(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref.read(digitalCardsRepositoryProvider).downloadPdf(documentNumber: documentNumber, card: card);
}

Future<DigitalCardArtifact> downloadDigitalCardsQr(final WidgetRef ref, final DigitalCard card) async {
  final documentNumber = _documentNumber(ref.read(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref.read(digitalCardsRepositoryProvider).downloadQr(documentNumber: documentNumber, card: card);
}

Future<DigitalCardArtifact> downloadDigitalCardsPkPass(final WidgetRef ref, final DigitalCard card) async {
  final documentNumber = _documentNumber(ref.read(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref.read(digitalCardsRepositoryProvider).downloadPkPass(documentNumber: documentNumber, card: card);
}

String? _documentNumber(final JwtClaims? claims) {
  final candidates = [
    claims?.personIdentifier,
    claims?.preferredUsername,
    claims?.sub,
  ];
  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}
