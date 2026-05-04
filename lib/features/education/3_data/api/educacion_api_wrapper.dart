import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_wrapper.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';

final class EducacionApiWrapper extends GeneratedApiWrapper {
  const EducacionApiWrapper(this._api);

  final EducacionApi _api;

  Future<Result<DTEDUTUORES>> getTitulosUniversitarios(
    final String numDocumento,
    final DTEDUTUOREQ body,
  ) => safeCall(
    () => _api.getTitulosUniversitarios(
      numDocumento: numDocumento,
      dTEDUTUOREQBody: body,
    ),
  );

  Future<Result<DTEDUTNURES>> getTitulosNoUniversitarios(
    final String numDocumento,
    final DTEDUTNUREQ body,
  ) => safeCall(
    () => _api.getTitulosNoUniversitarios(
      numDocumento: numDocumento,
      dTEDUTNUREQBody: body,
    ),
  );
}
