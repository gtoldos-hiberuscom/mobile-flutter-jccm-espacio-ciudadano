import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/3_data/digital_cards_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'digital_cards_catalog_notifier.g.dart';

/// Owns the digital cards catalogue screen state (STORY-48).
///
/// On `build()` it asks the repository for a catalogue snapshot; the UI
/// renders loading/loaded/empty/error from the resulting
/// [DigitalCardsCatalog]. Refresh forces a new fetch.
@riverpod
class DigitalCardsCatalogNotifier extends _$DigitalCardsCatalogNotifier {
  @override
  Future<DigitalCardsCatalog> build() async {
    final repo = ref.watch(digitalCardsRepositoryProvider);
    return repo.loadCatalog();
  }

  /// Forces a fresh fetch of the catalogue.
  Future<void> refresh() async {
    state = const AsyncValue<DigitalCardsCatalog>.loading();
    state = await AsyncValue.guard<DigitalCardsCatalog>(
      () => ref.read(digitalCardsRepositoryProvider).loadCatalog(),
    );
  }
}
