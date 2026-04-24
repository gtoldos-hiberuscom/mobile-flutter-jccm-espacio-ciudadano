import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/digital_cards_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/3_data/digital_cards_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'digital_cards_repository_provider.g.dart';

/// DI composition for [DigitalCardsRepository] (canon §16).
///
/// Not kept alive on purpose: navigation back into the cards catalogue
/// should re-fetch the snapshot.
@riverpod
DigitalCardsRepository digitalCardsRepository(final Ref ref) => const DigitalCardsRepositoryImpl();
