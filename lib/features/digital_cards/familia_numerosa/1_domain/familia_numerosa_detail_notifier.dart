/// Familia numerosa carnet (EPIC-7 / STORY-49) — domain.
///
/// Plain Riverpod `AsyncNotifier` (no codegen) — mirrors the precedent
/// set by other domain notifiers in the codebase that need to coexist
/// with externally-overridden providers in tests without regenerating
/// `*.g.dart` artifacts.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/1_domain/familia_numerosa_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/3_data/familia_numerosa_repository_provider.dart';

/// Owns the carnet detail screen state (STORY-49).
///
/// On `build()` it delegates to [FamiliaNumerosaRepository.loadCard];
/// the `FamiliaNumerosaUnavailable` exception bubbles through
/// `AsyncValue.error` so the page can downgrade to the explicit
/// unavailable surface.
final familiaNumerosaDetailNotifierProvider =
    AsyncNotifierProvider<FamiliaNumerosaDetailNotifier, FamiliaNumerosaCard>(
  FamiliaNumerosaDetailNotifier.new,
);

class FamiliaNumerosaDetailNotifier extends AsyncNotifier<FamiliaNumerosaCard> {
  @override
  Future<FamiliaNumerosaCard> build() {
    return ref.read(familiaNumerosaRepositoryProvider).loadCard();
  }

  /// Forces a fresh fetch of the carnet metadata.
  Future<void> refresh() async {
    state = const AsyncValue<FamiliaNumerosaCard>.loading();
    state = await AsyncValue.guard<FamiliaNumerosaCard>(
      () => ref.read(familiaNumerosaRepositoryProvider).loadCard(),
    );
  }
}
