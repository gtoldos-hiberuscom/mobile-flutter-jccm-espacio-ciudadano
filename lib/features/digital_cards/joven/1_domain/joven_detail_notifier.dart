/// Carnet Joven (EPIC-7 / STORY-50) — domain.
///
/// Plain Riverpod `AsyncNotifier` (no codegen) — mirrors the precedent
/// set by other domain notifiers in the codebase that need to coexist
/// with externally-overridden providers in tests without regenerating
/// `*.g.dart` artifacts.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/0_entity/joven_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/1_domain/joven_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/3_data/joven_repository_provider.dart';

/// Owns the Carnet Joven detail surface state (STORY-50).
///
/// On `build()` it delegates to [JovenRepository.loadCard]; the
/// `JovenUnavailable` exception bubbles through `AsyncValue.error` so
/// the page (and the modal variant) can downgrade to the explicit
/// unavailable surface.
final jovenDetailNotifierProvider =
    AsyncNotifierProvider<JovenDetailNotifier, JovenCard>(
  JovenDetailNotifier.new,
);

class JovenDetailNotifier extends AsyncNotifier<JovenCard> {
  @override
  Future<JovenCard> build() {
    return ref.read(jovenRepositoryProvider).loadCard();
  }

  /// Forces a fresh fetch of the carnet metadata.
  Future<void> refresh() async {
    state = const AsyncValue<JovenCard>.loading();
    state = await AsyncValue.guard<JovenCard>(
      () => ref.read(jovenRepositoryProvider).loadCard(),
    );
  }
}
