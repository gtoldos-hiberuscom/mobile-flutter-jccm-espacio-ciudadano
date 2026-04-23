import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/cadastral_property.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/residence_data.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/state_affairs_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/1_domain/state_affairs_landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/1_domain/state_affairs_repository.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/3_data/state_affairs_repository_provider.dart';

class _FakeStateAffairsRepository implements StateAffairsRepository {
  _FakeStateAffairsRepository(this._snapshot);

  final StateAffairsSnapshot _snapshot;

  @override
  Future<StateAffairsSnapshot> loadSnapshot() async => _snapshot;
}

void main() {
  group('StateAffairsLandingNotifier', () {
    final residence = ResidenceData(
      municipio: 'Toledo',
      provincia: 'Toledo',
      comunidadAutonoma: 'Castilla-La Mancha',
      lastUpdatedAt: DateTime(2026, 5),
    );

    final snapshot = StateAffairsSnapshot(
      residence: StateAffairsSection<ResidenceData>.loaded(residence),
      properties: StateAffairsSection<List<CadastralProperty>>.loaded(
        const <CadastralProperty>[
          CadastralProperty(
            id: 'cp-1',
            direccion: 'Calle Mayor 1',
            titularidad: 'Pleno dominio',
            superficieM2: 80,
          ),
        ],
      ),
      vehicles: StateAffairsSection<List<Vehicle>>.error(),
    );

    ProviderContainer container() => ProviderContainer(
          overrides: [
            stateAffairsRepositoryProvider.overrideWith(
              (final ref) => _FakeStateAffairsRepository(snapshot),
            ),
          ],
        );

    test('initial build exposes the mock snapshot shape', () async {
      final c = container();
      addTearDown(c.dispose);
      final state =
          await c.read(stateAffairsLandingProvider.future);
      expect(state.residence.status, StateAffairsSectionStatus.loaded);
      expect(state.residence.value!.municipio, 'Toledo');
      expect(state.properties.status, StateAffairsSectionStatus.loaded);
      expect(state.properties.value!.length, 1);
      expect(state.vehicles.status, StateAffairsSectionStatus.error);
    });

    test('refresh re-runs the repository call', () async {
      final c = container();
      addTearDown(c.dispose);
      await c.read(stateAffairsLandingProvider.future);
      await c
          .read(stateAffairsLandingProvider.notifier)
          .refresh();
      final state =
          c.read(stateAffairsLandingProvider).requireValue;
      expect(state.residence.value!.municipio, 'Toledo');
    });
  });
}
