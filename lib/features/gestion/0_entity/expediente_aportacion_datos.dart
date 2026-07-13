import 'package:meta/meta.dart';

/// Campos "en bruto" del expediente exigidos por `DTProcedimiento`
/// (`inicproc`/`registrarfichero`), distintos de los ya expuestos en
/// `Expediente` para mostrar en pantalla (p.ej. `consejeria` mezcla
/// `desconsej`/`consej` con fines de UI, aquí se necesita el código puro).
@immutable
final class ExpedienteAportacionDatos {
  const ExpedienteAportacionDatos({
    this.uniorg,
    this.consej,
    this.bland,
    this.asunto,
    this.desasunto,
    this.source,
    this.nombre,
    this.apellido1,
    this.apellido2,
    this.numdoc,
    this.codpos,
    this.calle,
    this.ncalle,
    this.tlfno,
    this.bezei,
    this.registro,
    this.fechareg,
  });

  /// Código de unidad orgánica (`unidadorganica`).
  final String? uniorg;

  /// Código de consejería (`consejeria`), no la descripción.
  final String? consej;

  /// Código de provincia (`provincia`).
  final String? bland;

  /// Código de asunto SIACI.
  final String? asunto;

  /// Descripción del asunto.
  final String? desasunto;

  /// Sistema tramitador del expediente.
  final String? source;

  final String? nombre;
  final String? apellido1;
  final String? apellido2;
  final String? numdoc;
  final String? codpos;
  final String? calle;
  final String? ncalle;
  final String? tlfno;

  /// Población.
  final String? bezei;

  /// Número de registro de entrada ya existente del expediente (`registro`,
  /// ej. `"123456/2026"`) — usado como `REGISTRO.noregistro` al aportar
  /// documentación a un expediente ya registrado (a diferencia de iniciar un
  /// procedimiento nuevo, donde este campo aún no existe).
  final String? registro;

  /// Fecha de ese registro de entrada (`fechareg`) — usado como
  /// `REGISTRO.fecha`.
  final String? fechareg;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is ExpedienteAportacionDatos && runtimeType == other.runtimeType && uniorg == other.uniorg && consej == other.consej && bland == other.bland && asunto == other.asunto && desasunto == other.desasunto && source == other.source && nombre == other.nombre && apellido1 == other.apellido1 && apellido2 == other.apellido2 && numdoc == other.numdoc && codpos == other.codpos && calle == other.calle && ncalle == other.ncalle && tlfno == other.tlfno && bezei == other.bezei && registro == other.registro && fechareg == other.fechareg;

  @override
  int get hashCode => Object.hash(
    uniorg,
    consej,
    bland,
    asunto,
    desasunto,
    source,
    nombre,
    apellido1,
    apellido2,
    numdoc,
    Object.hash(codpos, calle, ncalle, tlfno, bezei, registro, fechareg),
  );
}
