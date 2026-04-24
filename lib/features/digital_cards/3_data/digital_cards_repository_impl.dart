import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/digital_cards_repository.dart';

/// In-memory mock implementation of [DigitalCardsRepository].
///
/// Returns a deterministic catalogue with one card per federated type,
/// each in a different status so the UI can exercise the full state
/// model (available / notValid / notDownloadable). The fourth status
/// `DigitalCardStatus.notAvailable` is exercised via the per-status
/// widget test (page renders the empty-state widget when the catalogue
/// has no cards at all).
///
/// // TODO(TASK-53): replace with live wiring against the
///   `/carnet-digital/familia-numerosa`, `/carnet-digital/joven` and
///   `/carnet-digital/discapacidad` operations once the payload string
///   contracts are validated by the SESCAM parser team.
final class DigitalCardsRepositoryImpl implements DigitalCardsRepository {
  const DigitalCardsRepositoryImpl();

  @override
  Future<DigitalCardsCatalog> loadCatalog() async {
    final now = DateTime.now();
    return DigitalCardsCatalog(
      cards: <DigitalCard>[
        DigitalCard(
          id: 'familia-numerosa-mock',
          type: DigitalCardType.familiaNumerosa,
          status: DigitalCardStatus.available,
          holderName: 'María García',
          expiryDate: DateTime(now.year + 1, now.month, now.day),
          badge: 'vigente',
        ),
        DigitalCard(
          id: 'joven-mock',
          type: DigitalCardType.joven,
          status: DigitalCardStatus.notValid,
          holderName: 'María García',
          expiryDate: DateTime(now.year - 1, now.month, now.day),
          badge: 'caducado',
        ),
        const DigitalCard(
          id: 'discapacidad-mock',
          type: DigitalCardType.discapacidad,
          status: DigitalCardStatus.notDownloadable,
          holderName: 'María García',
        ),
      ],
      lastUpdatedAt: now,
      state: DigitalCardsCatalogState.loaded,
    );
  }
}
