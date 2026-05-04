import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_title.dart';
import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_repository.dart';
import 'package:jccm_espacio_ciudadano/features/education/3_data/api/educacion_api_wrapper.dart';

final class EducationRepositoryImpl implements EducationRepository {
  const EducationRepositoryImpl({
    required final EducacionApiWrapper apiWrapper,
    required final SecureStorage secureStorage,
  }) : _apiWrapper = apiWrapper,
       _secureStorage = secureStorage;

  final EducacionApiWrapper _apiWrapper;
  final SecureStorage _secureStorage;

  @override
  Future<EducationSnapshot> loadSnapshot() async {
    final numDocumento = await _secureStorage.read(StorageKeys.idAgente) ?? '';

    //   // Get the access token from secure storage
    // final accessToken = await _secureStorage.read(StorageKeys.accessToken) ?? '';

    // // Fetch the authenticated user to get their document number
    // final authUser = await _authRepository.fetchUserInfo(accessToken: accessToken);
    // final numDocumento = authUser.idAgente;

    final uoFuture = _apiWrapper.getTitulosUniversitarios(
      numDocumento,
      DTEDUTUOREQ((final b) => b..docu = numDocumento),
    );
    final nuFuture = _apiWrapper.getTitulosNoUniversitarios(
      numDocumento,
      DTEDUTNUREQ((final b) => b..docu = numDocumento),
    );

    final uoResult = await uoFuture;
    final nuResult = await nuFuture;

    return EducationSnapshot(
      universityTitles: _mapUniversityResult(uoResult),
      nonUniversityTitles: _mapNonUniversityResult(nuResult),
    );
  }

  EducationSection<List<EducationTitle>> _mapUniversityResult(
    final Result<DTEDUTUORES> result,
  ) {
    if (result is Failure<DTEDUTUORES>) {
      return EducationSection.error();
    }
    final elementos = (result as Success<DTEDUTUORES>).value.elemento;
    if (elementos == null || elementos.isEmpty) {
      return EducationSection.empty();
    }
    return EducationSection.loaded(_mapElementos(elementos, prefix: 'u'));
  }

  EducationSection<List<EducationTitle>> _mapNonUniversityResult(
    final Result<DTEDUTNURES> result,
  ) {
    if (result is Failure<DTEDUTNURES>) {
      return EducationSection.error();
    }
    final elementos = (result as Success<DTEDUTNURES>).value.elemento;
    if (elementos == null || elementos.isEmpty) {
      return EducationSection.empty();
    }
    return EducationSection.loaded(_mapElementos(elementos, prefix: 'nu'));
  }

  List<EducationTitle> _mapElementos(
    final Iterable<ELEMENTO> elementos, {
    required final String prefix,
  }) {
    return elementos
        .toList()
        .asMap()
        .entries
        .map(
          (final e) => EducationTitle(
            id: e.value.codtitulacion ?? '$prefix-${e.key}',
            titulacion: e.value.titulacion ?? '',
            centro: e.value.centro ?? '',
            year: _parseYear(e.value.fecexp),
          ),
        )
        .toList();
  }

  static int _parseYear(final String? fecexp) {
    if (fecexp == null || fecexp.length < 4) {
      return 0;
    }
    return int.tryParse(fecexp.substring(0, 4)) ?? 0;
  }
}
