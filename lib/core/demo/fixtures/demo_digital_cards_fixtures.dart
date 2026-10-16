import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_binaries.dart';

/// Carnés digitales de la persona ficticia del modo demostración, con la forma
/// exacta con que la fachada los entrega dentro de `body` (mismas claves y
/// fechas `dd/MM/yyyy`), para que `DigitalCardsRepositoryImpl` los mapee por el
/// mismo camino que los reales, sin ninguna rama especial para la demo.
///
/// Las fechas son relativas al reloj del backend demo: así los carnés están
/// siempre en vigor y una demostración de hoy sigue enseñando carnés vigentes
/// dentro de un año, sin tener que retocar las fixtures.
abstract final class DemoDigitalCardsFixtures {
  const DemoDigitalCardsFixtures._();

  /// Número del Carné Joven, con el formato `NIF-XXXX-XXXX-XXXX-XXXX` del real.
  static const String youthCardNumber = '${DemoSession.personIdentifier}-DEMO-0001-0002-0003';

  /// Número de título de familia numerosa.
  static const String largeFamilyTitleNumber = 'FN-DEMO-0001';

  /// Titular tal y como lo escribe la fachada: en mayúsculas.
  static String get holderName => '${DemoSession.givenName} ${DemoSession.firstSurname} ${DemoSession.secondSurname}'.toUpperCase();

  /// `GET …/carnet-digital/joven`: vigente desde hace un año y hasta dentro de dos.
  static Map<String, Object?> youthCard({required final DateTime now}) => <String, Object?>{
    'Numero': youthCardNumber,
    'Titular': holderName,
    'FechaNacimiento': formatDate(DateTime(now.year - 22, 4, 12)),
    'FechaInicioValidez': formatDate(DateTime(now.year - 1, now.month, now.day)),
    'FechaFinValidez': formatDate(DateTime(now.year + 2, now.month, now.day)),
    'enTramitacion': 'N',
  };

  /// `GET …/carnet-digital/familia-numerosa`: título vigente desde hace dos
  /// años y hasta dentro de tres.
  static Map<String, Object?> largeFamilyCard({required final DateTime now}) => <String, Object?>{
    'numeroTitulo': largeFamilyTitleNumber,
    'categoria': 'General',
    'fechaValidezDesde': formatDate(DateTime(now.year - 2, now.month, now.day)),
    'fechaValidezHasta': formatDate(DateTime(now.year + 3, now.month, now.day)),
  };

  /// `GET …/carnet-digital/discapacidad`: validez definitiva, como el caso
  /// real más habitual. Sin número: este carné no lo tiene.
  static Map<String, Object?> disabilityCard({required final DateTime now}) => <String, Object?>{
    'validezDefinitiva': 'S',
    'fechaEfectos': formatDate(DateTime(now.year - 5, now.month, now.day)),
    'grado': '33',
  };

  /// Cuerpos de descarga: el base64 viaja bajo la clave que el repositorio lee
  /// en primer lugar para cada formato (`pdf`, `qr`, `pkpass`).
  static Map<String, Object?> get youthPdf => <String, Object?>{'pdf': DemoBinaries.pdfBase64};
  static Map<String, Object?> get youthQr => <String, Object?>{'qr': DemoBinaries.qrPngBase64};
  static Map<String, Object?> get pkPass => <String, Object?>{'pkpass': DemoBinaries.pkpassBase64};

  /// `dd/MM/yyyy`, el formato con que la fachada entrega las fechas de los carnés.
  static String formatDate(final DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
