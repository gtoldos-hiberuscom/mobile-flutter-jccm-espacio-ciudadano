import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/data_consent_repository.dart';

/// Mock implementation of [DataConsentRepository] for STORY-55.
///
/// Returns a deterministic catalog of three `clausulas` (one per
/// [DataConsentType]) with one already accepted and the other two not, so
/// the UI can exercise the loaded / saving / saved transitions without a
/// live backend.
///
/// TODO(future-sprint): replace with the real Dio-backed implementation
/// hitting `/hechos-vitales/clausulas/{idAgente}` (GET catalog),
/// `PATCH /hechos-vitales/clausulas` (persist consents) and
/// `DELETE /hechos-vitales/preferencias/{idAgente}` (revoke). Depends on
/// TASK-21 idAgente closure.
final class DataConsentRepositoryImpl implements DataConsentRepository {
  const DataConsentRepositoryImpl();

  static const List<_SeedConsent> _catalog = <_SeedConsent>[
    _SeedConsent(
      id: 'consent-jccm',
      type: DataConsentType.jccm,
      defaultAccepted: true,
    ),
    _SeedConsent(
      id: 'consent-otras-admin',
      type: DataConsentType.otrasAdmin,
      defaultAccepted: false,
    ),
    _SeedConsent(
      id: 'consent-perfilado',
      type: DataConsentType.perfilado,
      defaultAccepted: false,
    ),
  ];

  /// Per-citizen acceptance map — kept in memory so consecutive reads after
  /// `saveClausulas` / `revokeAll` reflect the latest mutation.
  static final Map<String, Map<String, bool>> _persisted = <String, Map<String, bool>>{};

  static const String _mockVersion = '2026-04-21';

  @override
  Future<DataConsentLoadResult> loadClausulas(
    final String idAgente,
  ) async {
    final acceptance = _persisted.putIfAbsent(
      idAgente,
      () => <String, bool>{
        for (final s in _catalog) s.id: s.defaultAccepted,
      },
    );
    return DataConsentLoadResult(
      items: <DataConsent>[
        for (final s in _catalog)
          DataConsent(
            id: s.id,
            type: s.type,
            accepted: acceptance[s.id] ?? s.defaultAccepted,
            version: _mockVersion,
          ),
      ],
    );
  }

  @override
  Future<void> saveClausulas(
    final String idAgente,
    final Map<DataConsentType, bool> acceptance,
  ) async {
    _persisted[idAgente] = <String, bool>{
      for (final s in _catalog) s.id: acceptance[s.type] ?? false,
    };
  }

  @override
  Future<void> revokeAll(final String idAgente) async {
    _persisted[idAgente] = <String, bool>{
      for (final s in _catalog) s.id: false,
    };
  }
}

class _SeedConsent {
  const _SeedConsent({
    required this.id,
    required this.type,
    required this.defaultAccepted,
  });

  final String id;
  final DataConsentType type;
  final bool defaultAccepted;
}
