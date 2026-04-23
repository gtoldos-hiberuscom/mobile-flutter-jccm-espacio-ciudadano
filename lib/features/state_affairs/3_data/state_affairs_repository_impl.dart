import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/cadastral_property.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/residence_data.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/state_affairs_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/1_domain/state_affairs_repository.dart';

/// Mock implementation of [StateAffairsRepository] for STORY-26.
///
/// Returns a deterministic snapshot that exercises the loaded UI states
/// for residence + properties + vehicles. The vehicles section uses an
/// `error` status to demonstrate the per-section error handling
/// (the DGT feed is the most fragile of the three sources in production).
///
/// TODO(STORY-26): replace with the real Dio-backed implementation
/// hitting `/ine/datos-residencia/{numDocumento}`,
/// `/catastro/datos-catastrales/{numDocumento}` and
/// `/dgt/lista-vehiculos/{numDocumento}`.
final class StateAffairsRepositoryImpl implements StateAffairsRepository {
  const StateAffairsRepositoryImpl();

  @override
  Future<StateAffairsSnapshot> loadSnapshot() async {
    final residence = ResidenceData(
      municipio: 'Toledo',
      provincia: 'Toledo',
      comunidadAutonoma: 'Castilla-La Mancha',
      direccion: 'Calle de la Plata, 12',
      codigoPostal: '45001',
      lastUpdatedAt: DateTime.now().subtract(const Duration(days: 14)),
    );

    final properties = <CadastralProperty>[
      const CadastralProperty(
        id: 'cp-1',
        direccion: 'Calle de la Plata, 12 — Toledo',
        titularidad: 'Pleno dominio',
        superficieM2: 92,
        referenciaCatastral: '1234567VK1234N0001ZZ',
      ),
      const CadastralProperty(
        id: 'cp-2',
        direccion: 'Avenida del Tajo, 45 — Toledo',
        titularidad: 'Nuda propiedad',
        superficieM2: 110,
      ),
      const CadastralProperty(
        id: 'cp-3',
        direccion: 'Calle Mayor, 3 — Talavera de la Reina',
        titularidad: 'Usufructo',
        superficieM2: 76,
      ),
      const CadastralProperty(
        id: 'cp-4',
        direccion: 'Plaza de la Constitución, 1 — Cuenca',
        titularidad: 'Pleno dominio',
        superficieM2: 65,
      ),
      const CadastralProperty(
        id: 'cp-5',
        direccion: 'Camino del Soto, 7 — Albacete',
        titularidad: 'Pleno dominio',
        superficieM2: 88,
      ),
      const CadastralProperty(
        id: 'cp-6',
        direccion: 'Calle Real, 22 — Ciudad Real',
        titularidad: 'Pleno dominio',
        superficieM2: 102,
      ),
    ];

    return StateAffairsSnapshot(
      residence: StateAffairsSection<ResidenceData>.loaded(residence),
      properties: StateAffairsSection<List<CadastralProperty>>.loaded(
        properties,
      ),
      // Mix one error to demonstrate the per-section error UI state.
      vehicles: StateAffairsSection<List<Vehicle>>.error(),
    );
  }
}
