import 'package:jccm_espacio_ciudadano/features/my_data/3_data/document_type.dart';

/// Cuerpo `BaseRequestIntermediacion`, común a bienestar social y a las ofertas
/// de empleo inscritas.
///
/// `tipo`, `idaut` y `proc` son constantes de la consulta iniciada por el propio
/// ciudadano, según los ejemplos del contrato del gateway; la fachada las
/// resolvía internamente y por eso no se enviaban antes. Los campos de
/// funcionario se omiten porque aquí nunca hay uno detrás.
Map<String, Object?> intermediacionRequest(final String documentNumber) => {
  'tipo': 'A',
  'idaut': 'ESP-CIUDADANO',
  'proc': 'JCCMEC',
  'tipodoc': documentTypeOf(documentNumber),
  'docu': documentNumber,
};
