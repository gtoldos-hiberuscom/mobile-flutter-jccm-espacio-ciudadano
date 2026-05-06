import 'package:dio/src/response.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_title.dart';
import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_repository.dart';

final class EducationRepositoryImpl implements EducationRepository {
  const EducationRepositoryImpl({
    required final EducacionApi apiWrapper,
    required final String numDocumento,
  }) : _apiWrapper = apiWrapper,
       _numDocumento = numDocumento;

  final EducacionApi _apiWrapper;
  final String _numDocumento;

  @override
  Future<EducationSnapshot> loadSnapshot() async {
    final numDocumento = _numDocumento;
    final uoFuture = _apiWrapper.getTitulosUniversitarios(
      numDocumento: numDocumento,
      dTEDUTUOREQBody: DTEDUTUOREQ(
        (final b) => b..docu = numDocumento,
      ),
    );
    // final nuFuture = _apiWrapper.getTitulosNoUniversitarios(
    //   numDocumento,
    //   DTEDUTNUREQ((final b) => b..docu = numDocumento),
    // );

    final Response<DTEDUTUORES> uoResult = await uoFuture;
    // final nuResult = await nuFuture;

    return EducationSnapshot(
      universityTitles: _mapUniversityResult(uoResult),
      nonUniversityTitles: EducationSection.empty(),
    );
  }

  EducationSection<List<EducationTitle>> _mapUniversityResult(final Response<DTEDUTUORES> result) {
    if (result is DTEDUTUORES) {
      return EducationSection.error();
    }
    final elementos = (result as DTEDUTUORES).elemento;
    if (elementos == null || elementos.isEmpty) {
      return EducationSection.empty();
    }
    return EducationSection.loaded(_mapElementos(elementos, prefix: 'u'));
  }

  EducationSection<List<EducationTitle>> _mapNonUniversityResult(final Response<DTEDUTNURES> result) {
    if (result is DTEDUTNURES) {
      return EducationSection.error();
    }
    final elementos = (result as DTEDUTNURES).elemento;
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
