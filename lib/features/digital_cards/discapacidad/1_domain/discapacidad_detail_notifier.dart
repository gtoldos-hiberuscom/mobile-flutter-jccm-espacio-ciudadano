/// Carnet Discapacidad (EPIC-7 / STORY-51) — domain.
///
/// Plain Riverpod `AsyncNotifier` (no codegen) — mirrors the precedent
/// set by `JovenDetailNotifier` so test overrides do not need to
/// regenerate `*.g.dart` artifacts.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/0_entity/discapacidad_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/3_data/discapacidad_repository_provider.dart';

/// Owns the carnet de discapacidad detail surface state (STORY-51).
///
/// On `build()` it delegates to [DiscapacidadRepository.loadCard]; the
/// `DiscapacidadUnavailable` exception bubbles through `AsyncValue.error`
/// so the page can downgrade to the explicit unavailable surface.
final discapacidadDetailNotifierProvider = AsyncNotifierProvider<DiscapacidadDetailNotifier, DiscapacidadCard>(
  DiscapacidadDetailNotifier.new,
);

class DiscapacidadDetailNotifier extends AsyncNotifier<DiscapacidadCard> {
  @override
  Future<DiscapacidadCard> build() {
    return ref.read(discapacidadRepositoryProvider).loadCard();
  }

  /// Forces a fresh fetch of the carnet metadata.
  Future<void> refresh() async {
    state = const AsyncValue<DiscapacidadCard>.loading();
    state = await AsyncValue.guard<DiscapacidadCard>(
      () => ref.read(discapacidadRepositoryProvider).loadCard(),
    );
  }
}
