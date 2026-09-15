import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/authorization_guard.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/repositories/digital_cards_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/3_data/digital_cards_repository_impl.dart';

final digitalCardsRepositoryProvider = Provider<DigitalCardsRepository>((final ref) {
  return DigitalCardsRepositoryImpl(dio: ref.watch(dioProvider));
});

final digitalCardsAuthorizationProvider = FutureProvider.autoDispose<bool>((final ref) async {
  final idAgente = ref.watch(citizenEndpointIdsProvider).idAgente;
  if (idAgente == null || idAgente.isEmpty) {
    throw StateError('No se ha encontrado el identificador de la persona usuaria.');
  }

  final result = await ref
      .watch(checkAcceptedConsentClauseUsecaseProvider)
      .execute(
        idAgente: idAgente,
        clauseId: digitalCardsConsentClauseId,
      );
  return switch (result) {
    AcceptedConsentClauseStatus(:final isAccepted) => isAccepted,
    CheckAcceptedConsentClauseFailed(:final message) => throw StateError(message),
  };
});

final digitalCardsProvider = FutureProvider.autoDispose<List<DigitalCard>>((final ref) async {
  final citizenId = ref.watch(ciudadanosEndpointIdProvider).trim();
  if (citizenId.isEmpty) {
    throw StateError('No se ha encontrado el identificador de la persona usuaria.');
  }

  final repository = ref.watch(digitalCardsRepositoryProvider);
  // Los carnets exigen la cláusula obligatoria y la específica de carnets
  // (`documentation/consent_clause_access_matrix.md`). La comprobación
  // proactiva de `digitalCardsAuthorizationProvider` se apoya en la caché
  // positiva de cláusulas, así que no ve una revocación reciente: esta es la
  // corrección reactiva.
  return withAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId, digitalCardsConsentClauseId},
    request: () => repository.loadCards(citizenId: citizenId),
  );
});

final digitalCardQrImageProvider = FutureProvider.autoDispose.family<Uint8List?, DigitalCard>((final ref, final card) async {
  final citizenId = ref.watch(ciudadanosEndpointIdProvider).trim();
  if (citizenId.isEmpty) {
    throw StateError('No se ha encontrado el identificador de la persona usuaria.');
  }

  return ref.watch(digitalCardsRepositoryProvider).loadQrImage(citizenId: citizenId, card: card);
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
  final citizenId = ref.read(ciudadanosEndpointIdProvider).trim();
  if (citizenId.isEmpty) {
    throw StateError('No se ha encontrado el identificador de la persona usuaria.');
  }

  return ref.read(digitalCardsRepositoryProvider).downloadPdf(citizenId: citizenId, card: card);
}

Future<DigitalCardArtifact> downloadDigitalCardsQr(final WidgetRef ref, final DigitalCard card) async {
  final citizenId = ref.read(ciudadanosEndpointIdProvider).trim();
  if (citizenId.isEmpty) {
    throw StateError('No se ha encontrado el identificador de la persona usuaria.');
  }

  return ref.read(digitalCardsRepositoryProvider).downloadQr(citizenId: citizenId, card: card);
}

Future<DigitalCardArtifact> downloadDigitalCardsPkPass(final WidgetRef ref, final DigitalCard card) async {
  final citizenId = ref.read(ciudadanosEndpointIdProvider).trim();
  if (citizenId.isEmpty) {
    throw StateError('No se ha encontrado el identificador de la persona usuaria.');
  }

  return ref.read(digitalCardsRepositoryProvider).downloadPkPass(citizenId: citizenId, card: card);
}
