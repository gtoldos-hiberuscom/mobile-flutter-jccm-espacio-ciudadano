import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_seeker_status.dart';
import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/employment/1_domain/employment_repository.dart';

/// Mock implementation of [EmploymentRepository] for STORY-24.
///
/// TODO(STORY-24): replace with the real Dio-backed implementation
/// hitting `/sepe/demandante-empleo-fecha-actual/{numDocumento}`.
final class EmploymentRepositoryImpl implements EmploymentRepository {
  const EmploymentRepositoryImpl();

  @override
  Future<EmploymentSnapshot> loadSnapshot() async => EmploymentSnapshot(
        seekerStatus: EmploymentSection<EmploymentSeekerStatus>.loaded(
          EmploymentSeekerStatus(
            estado: 'inscrito',
            fechaInscripcion: DateTime(2025, 11, 12),
            fechaContinuidad: DateTime(2026, 4, 12),
          ),
        ),
      );
}
