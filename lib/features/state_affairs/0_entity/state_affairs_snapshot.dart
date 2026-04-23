import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/cadastral_property.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/residence_data.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/vehicle.dart';

/// Per-section load outcome — the landing renders each block independently
/// so a failure on one feed does not blank the whole page.
enum StateAffairsSectionStatus { loading, loaded, empty, error }

/// Generic wrapper around an optional payload for a single landing block.
final class StateAffairsSection<T> {
  const StateAffairsSection({
    required this.status,
    this.value,
  });

  factory StateAffairsSection.loading() =>
      const StateAffairsSection(status: StateAffairsSectionStatus.loading);

  factory StateAffairsSection.loaded(final T value) =>
      StateAffairsSection<T>(
        status: StateAffairsSectionStatus.loaded,
        value: value,
      );

  factory StateAffairsSection.empty() =>
      const StateAffairsSection(status: StateAffairsSectionStatus.empty);

  factory StateAffairsSection.error() =>
      const StateAffairsSection(status: StateAffairsSectionStatus.error);

  final StateAffairsSectionStatus status;
  final T? value;
}

/// Aggregated payload for the Estado y otros temas de interés landing
/// (STORY-26). Pure Dart — no Flutter / Dio / Riverpod.
final class StateAffairsSnapshot {
  const StateAffairsSnapshot({
    required this.residence,
    required this.properties,
    required this.vehicles,
  });

  factory StateAffairsSnapshot.loading() => StateAffairsSnapshot(
        residence: StateAffairsSection<ResidenceData>.loading(),
        properties: StateAffairsSection<List<CadastralProperty>>.loading(),
        vehicles: StateAffairsSection<List<Vehicle>>.loading(),
      );

  final StateAffairsSection<ResidenceData> residence;
  final StateAffairsSection<List<CadastralProperty>> properties;
  final StateAffairsSection<List<Vehicle>> vehicles;
}
